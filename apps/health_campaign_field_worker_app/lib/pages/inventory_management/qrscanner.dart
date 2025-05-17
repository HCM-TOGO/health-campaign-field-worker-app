import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/widgets/localized.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../router/app_router.dart';
import '../../utils/extensions/extensions.dart';

@RoutePage()
class QRScannerPage extends LocalizedStatefulWidget {
  const QRScannerPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends LocalizedState<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;
  String _qrData = '';
  final TextEditingController _qrDataController = TextEditingController();

  @override
  void dispose() {
    cameraController.dispose();
    _qrDataController.dispose();
    super.dispose();
  }

  void _processScannedData(String? code) {
    if (!_isScanning || code == null || code.isEmpty) return;

    setState(() => _isScanning = false);

    try {
      // For emulator testing with simple text
      if (!Platform.isAndroid && !Platform.isIOS) {
        if (code == 'test') {
          code = _generateTestQRData();
        }
      }

      final compressed = base64Url.decode(code);
      final decompressed = utf8.decode(zlib.decode(compressed));
      final decodedJson = jsonDecode(decompressed);

      List<StockModel> stockList = [];
      for (String item in decodedJson) {
        StockModel model = StockModelMapper.fromJson(item);
        if (model.receiverId != context.loggedInUserUuid) {
          _showError('This QR code is not applicable for your account');
          return;
        }
        stockList.add(model);
      }

      if (stockList.isNotEmpty) {
        context.router.push(
          ViewStockRecordsCDDRoute(
            mrnNumber: stockList.first.wayBillNumber ?? "",
            stockRecords: stockList,
          ),
        );
      }
    } catch (e) {
      _showError('Invalid QR code format: ${e.toString()}');
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _isScanning = true);
      });
    }
  }

  String _generateTestQRData() {
    final testData = {
      "additionalFields": {
        "schema": "Stock",
        "version": 1,
        "fields": [
          {"key": "productName", "value": "SPAQ 1"},
          {"key": "variation", "value": "SPAQ 1"},
          {"key": "batchNumber", "value": "BATCH-TEST-001"}
        ]
      },
      "receiverId": context.loggedInUserUuid,
      "wayBillNumber": "WB-TEST-001",
      "quantity": "100"
    };
    return base64Url
        .encode(zlib.encode(utf8.encode(jsonEncode([jsonEncode(testData)]))));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull;
              if (barcode != null && barcode.rawValue != null) {
                _processScannedData(barcode.rawValue);
              }
            },
          ),
        ),
        if (!Platform.isAndroid && !Platform.isIOS)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _processScannedData('test'),
              child: const Text('Test with Sample QR Data'),
            ),
          ),
      ],
    );
  }

  Widget _buildGenerator() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _qrDataController,
              decoration: InputDecoration(
                labelText: 'Enter data for QR code',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _qrDataController.clear(),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('qr_scanner.title')),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              setState(() {
                // _showGenerator = !_showGenerator;
                _qrData = '';
              });
            },
            tooltip: 'Switch to Scanner',
          ),
        ],
      ),
      body: _buildScanner(),
      //   floatingActionButton: _showGenerator
      //       ? null
      //       : FloatingActionButton(
      //           onPressed: () => cameraController.toggleTorch(),
      //           child: const Icon(Icons.flash_on),
      //         ),
    );
  }
}
