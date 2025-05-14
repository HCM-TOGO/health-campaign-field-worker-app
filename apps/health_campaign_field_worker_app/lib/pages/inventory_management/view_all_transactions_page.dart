import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/data/repositories/local/inventory_management/custom_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/transaction_reason.dart';
import 'package:inventory_management/models/entities/transaction_type.dart';
import 'package:inventory_management/widgets/back_navigation_help_header.dart';
import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import '../../utils/utils.dart';
import '../../widgets/action_card/all_transactions_card.dart';
import 'view_record_lga.dart';
import 'view_stock_records.dart';

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
  StockModel? selectedStock;

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

  void _handleCardSelection(StockModel stock) {
    setState(() {
      selectedStock = stock;
    });
  }

  void _handleNextButtonPressed() {
    if (selectedStock == null) return;

    final mrnNumber = selectedStock!.additionalFields?.fields
            .firstWhere(
              (field) => field.key == 'materialNoteNumber',
              orElse: () => AdditionalField('materialNoteNumber', ''),
            )
            .value
            ?.toString() ??
        'N/A';

    // Filter stocks with the same MRN number
    final List<StockModel> sameMrnStocks = stockList.where((stock) {
      final currentMrn = stock.additionalFields?.fields
              .firstWhere(
                (field) => field.key == 'materialNoteNumber',
                orElse: () => AdditionalField('materialNoteNumber', ''),
              )
              .value
              ?.toString() ??
          'N/A';
      return currentMrn == mrnNumber;
    }).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewStockRecordsLGAPage(
          mrnNumber: mrnNumber,
          stockRecords: sameMrnStocks,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    List<StockModel> filteredStock = groupStockByMrn(stockList);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ScrollableContent(
                header: const Column(
                  children: [
                    BackNavigationHelpHeaderWidget(showHelp: true),
                  ],
                ),
                children: [
                  if (filteredStock.isEmpty)
                    const Center(child: Text('No transactions available.'))
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(spacer2),
                      ),
                      margin: const EdgeInsets.all(spacer2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16.0),
                            Text("Select the Material Issue number",
                                style: textTheme.headingL),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: BlocBuilder<StockBloc, StockState>(
                                builder: (context, state) {
                                  return ListView.builder(
                                    itemCount: filteredStock.length,
                                    itemBuilder: (context, index) {
                                      final stock = filteredStock[index];
                                      final isSelected = selectedStock == stock;

                                      return GestureDetector(
                                        onTap: () =>
                                            _handleCardSelection(stock),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              width: isSelected ? 2 : 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: TransactionsCard(
                                            minNumber:
                                                stock.additionalFields?.fields
                                                        .firstWhere(
                                                          (field) =>
                                                              field.key ==
                                                              'materialNoteNumber',
                                                          orElse: () =>
                                                              const AdditionalField(
                                                                  'materialNoteNumber',
                                                                  ''),
                                                        )
                                                        .value
                                                        ?.toString() ??
                                                    'N/A',
                                            cddCode:
                                                stock.additionalFields?.fields
                                                        .firstWhere(
                                                          (field) =>
                                                              field.key ==
                                                              'productName',
                                                          orElse: () =>
                                                              AdditionalField(
                                                                  'productName',
                                                                  'N/A'),
                                                        )
                                                        .value
                                                        ?.toString() ??
                                                    'N/A',
                                            date:
                                                'Date: ${stock.dateOfEntryTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                            items: [],
                                            data: {},
                                            waybillNumber:
                                                ' ${stock.wayBillNumber ?? 'N/A'}',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          // Fixed footer with Next button
          DigitCard(
            margin: const EdgeInsets.fromLTRB(spacer2, 0, spacer2, spacer2),
            children: [
              DigitButton(
                  type: DigitButtonType.primary,
                  mainAxisSize: MainAxisSize.max,
                  size: DigitButtonSize.large,
                  label: "Next",
                  onPressed: () {
                    selectedStock != null ? _handleNextButtonPressed : null;
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
