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
// import 'package:logger/logger.dart';
import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import '../../utils/utils.dart';
import '../../widgets/action_card/all_transactions_card.dart';
import 'view_stock_records.dart';

import 'package:inventory_management/utils/i18_key_constants.dart'
    as i18; // Import your view stock page

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
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    List<StockModel> filteredStock = groupStockByMrn(stockList);
    if (filteredStock.isEmpty) {
      return const Center(child: Text('No transactions available.'));
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ScrollableContent(
            header: const Column(
              children: [
                BackNavigationHelpHeaderWidget(showHelp: true),
              ],
            ),
            footer: SizedBox(
              child: DigitCard(
                margin: const EdgeInsets.fromLTRB(0, spacer2, 0, 0),
                children: [
                  DigitButton(
                    type: DigitButtonType.primary,
                    mainAxisSize: MainAxisSize.max,
                    size: DigitButtonSize.large,
                    label: "Next",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            children: [
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
                        Text("Select the MRN number",
                            style: textTheme.headingL),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: BlocBuilder<StockBloc, StockState>(
                            builder: (context, state) {
                              return ListView.builder(
                                itemCount: filteredStock.length,
                                itemBuilder: (context, index) {
                                  final firstStock = filteredStock[index];

                                  return TransactionsCard(
                                      minNumber:
                                          firstStock.additionalFields?.fields
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
                                      cddCode: firstStock
                                              .additionalFields?.fields
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
                                          'Date: ${firstStock.dateOfEntryTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                      items: [],
                                      data: {},
                                      waybillNumber:
                                          ' ${firstStock.wayBillNumber ?? 'N/A'}');

                                  // return Card(
                                  //   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  //   elevation: 2,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (context) => ViewStockRecordsPage(
                                  //             mrnNumber: firstStock.additionalFields?.fields
                                  //                     .firstWhere(
                                  //                       (field) =>
                                  //                           field.key == 'materialNoteNumber',
                                  //                       orElse: () => AdditionalField(
                                  //                           'materialNoteNumber', ''),
                                  //                     )
                                  //                     .value
                                  //                     ?.toString() ??
                                  //                 'N/A',
                                  //             stockRecords: [firstStock],
                                  //           ),
                                  //         ),
                                  //       );
                                  //     },
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(16.0),
                                  //       child: Column(
                                  //         crossAxisAlignment: CrossAxisAlignment.start,
                                  //         children: [
                                  //           // Header with MRN and Date
                                  //           Row(
                                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //             children: [
                                  //               Text(
                                  //                 'MRN: ${firstStock.additionalFields?.fields.firstWhere(
                                  //                       (field) =>
                                  //                           field.key == 'materialNoteNumber',
                                  //                       orElse: () => AdditionalField(
                                  //                           'materialNoteNumber', ''),
                                  //                     ).value?.toString() ?? 'N/A'}',
                                  //                 style: const TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                   fontSize: 16,
                                  //                 ),
                                  //               ),
                                  //               Text(
                                  //                 'Date: ${firstStock.dateOfEntryTime?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                  //                 style: const TextStyle(color: Colors.grey),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //           const SizedBox(height: 8),
                                  //           Text(
                                  //             'From: ${firstStock.senderId ?? firstStock.facilityId ?? 'N/A'}',
                                  //             style: const TextStyle(color: Colors.grey),
                                  //           ),
                                  //           const SizedBox(height: 12),

                                  //           const Divider(),
                                  //           const Text(
                                  //             'Commodities Received:',
                                  //             style: TextStyle(fontWeight: FontWeight.bold),
                                  //           ),
                                  //           const SizedBox(height: 8),
                                  //           Padding(
                                  //             padding: const EdgeInsets.symmetric(vertical: 4),
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   firstStock.additionalFields?.fields
                                  //                           .firstWhere(
                                  //                             (field) => field.key == 'productName',
                                  //                             orElse: () => AdditionalField(
                                  //                                 'productName', 'N/A'),
                                  //                           )
                                  //                           .value
                                  //                           ?.toString() ??
                                  //                       'N/A',
                                  //                 ),
                                  //                 Text(
                                  //                   'Qty: ${firstStock.quantity ?? 'N/A'}',
                                  //                   style: const TextStyle(
                                  //                       fontWeight: FontWeight.bold),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           const Divider(),
                                  //           Text(
                                  //             'Waybill: ${firstStock.wayBillNumber ?? 'N/A'}',
                                  //             style: const TextStyle(fontStyle: FontStyle.italic),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    )),
              )
            ]),
      ),
    );
  }
}
