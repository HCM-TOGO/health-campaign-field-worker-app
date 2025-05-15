import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/data/repositories/local/inventory_management/custom_stock.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/transaction_reason.dart';
import 'package:inventory_management/models/entities/transaction_type.dart';
import 'package:inventory_management/widgets/back_navigation_help_header.dart';
import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import '../../utils/utils.dart';
import '../../widgets/action_card/all_transactions_card.dart';
import 'view_record_lga.dart';

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
    final stockState = context.read<RecordStockBloc>().state;
  }

  List<StockModel> stockList = [];

  Future<void> loadLocalStockData() async {
    final repository =
        context.read<LocalRepository<StockModel, StockSearchModel>>()
            as CustomStockLocalRepository;
    String? warehouseId = widget.warehouseId;

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

  void _navigateToDetails(StockModel stock) {
    final mrnNumber = stock.additionalFields?.fields
            .firstWhere(
              (field) => field.key == 'materialNoteNumber',
              orElse: () => AdditionalField('materialNoteNumber', ''),
            )
            .value
            ?.toString() ??
        'N/A';

    // Filter stocks with the same MRN number
    final List<StockModel> sameMrnStocks = stockList.where((s) {
      final currentMrn = s.additionalFields?.fields
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
          stockRecords: [stock],
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ScrollableContent(
          header: const Column(
            children: [
              BackNavigationHelpHeaderWidget(showHelp: false),
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
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: BlocBuilder<StockBloc, StockState>(
                          builder: (context, state) {
                            return ListView.builder(
                              itemCount: filteredStock.length,
                              itemBuilder: (context, index) {
                                final stock = filteredStock[index];

                                return GestureDetector(
                                  onTap: () => _navigateToDetails(stock),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TransactionsCard(
                                      minNumber: stock.additionalFields?.fields
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
                                      cddCode: stock.additionalFields?.fields
                                              .firstWhere(
                                                (field) =>
                                                    field.key == 'productName',
                                                orElse: () => AdditionalField(
                                                    'productName', 'N/A'),
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
    );
  }
}
