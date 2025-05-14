import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/data/repositories/local/inventory_management/custom_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/transaction_reason.dart';
import 'package:inventory_management/models/entities/transaction_type.dart';
// import 'package:logger/logger.dart';

import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import '../../utils/utils.dart';
import 'view_stock_records.dart'; // Import your view stock page

@RoutePage()
class ViewAllTransactionsScreen extends StatefulWidget {
  final String? warehouseId;
  const ViewAllTransactionsScreen({super.key, required this.warehouseId});

  @override
  State<ViewAllTransactionsScreen> createState() =>
      _ViewAllTransactionsScreenState();
}

class _ViewAllTransactionsScreenState extends State<ViewAllTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    loadLocalStockData();
  }

  List<StockModel> stockList = [];

  Future<void> loadLocalStockData() async {
    final repository =
        context.read<LocalRepository<StockModel, StockSearchModel>>()
            as CustomStockLocalRepository;
    String? warehouseId = widget.warehouseId;
    if (warehouseId != null) {
      warehouseId = warehouseId.replaceAll('FAC_', '');
    }
    dynamic result;
    // check for valid user
    if (isLGAUser() || isHFUser(context)) {
      result = await repository.search(StockSearchModel(
          transactionType: [TransactionType.dispatched.toValue()],
          transactionReason: [],
          receiverId: warehouseId == null ? [] : [warehouseId]));
    } else {
      result = await repository.search(StockSearchModel(
          transactionType: [TransactionType.received.toValue()],
          transactionReason: [TransactionReason.received.toValue()],
          senderId: warehouseId));
    }

    setState(() {
      stockList = result;
    });

    print("Stock List: $stockList");
  }

  List<StockModel> groupStockByMrn(List<StockModel> stocks) {
    final List<StockModel> filtered = [];
    for (final stock in stocks) {
      final mrn = stock.additionalFields?.fields
              .firstWhere(
                (f) => f.key == 'materialNoteNumber',
                orElse: () => AdditionalField('materialNoteNumber', ''),
              )
              .value
              ?.toString() ??
          'UNKNOWN';
      if (mrn != "") {
        filtered.add(stock);
      }
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    List<StockModel> filteredStock = groupStockByMrn(stockList);
    if (filteredStock.isEmpty) {
      return const Center(child: Text('No transactions available.'));
    }

    return Scaffold(
      body: BlocBuilder<StockBloc, StockState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: filteredStock.length,
            itemBuilder: (context, index) {
              final firstStock = filteredStock[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewStockRecordsPage(
                          mrnNumber: firstStock.additionalFields?.fields
                                  .firstWhere(
                                    (field) =>
                                        field.key == 'materialNoteNumber',
                                    orElse: () => AdditionalField(
                                        'materialNoteNumber', ''),
                                  )
                                  .value
                                  ?.toString() ??
                              'N/A',
                          stockRecords: [firstStock],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with MRN and Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MRN: ${firstStock.additionalFields?.fields.firstWhere(
                                    (field) =>
                                        field.key == 'materialNoteNumber',
                                    orElse: () => AdditionalField(
                                        'materialNoteNumber', ''),
                                  ).value?.toString() ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Date: ${firstStock.dateOfEntryTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'From: ${firstStock.senderId ?? firstStock.facilityId ?? 'N/A'}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),

                        const Divider(),
                        const Text(
                          'Commodities Received:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                firstStock.additionalFields?.fields
                                        .firstWhere(
                                          (field) => field.key == 'productName',
                                          orElse: () => AdditionalField(
                                              'productName', 'N/A'),
                                        )
                                        .value
                                        ?.toString() ??
                                    'N/A',
                              ),
                              Text(
                                'Qty: ${firstStock.quantity ?? 'N/A'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Text(
                          'Waybill: ${firstStock.wayBillNumber ?? 'N/A'}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
