import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import 'view_stock_records.dart'; // Import your view stock page

@RoutePage()
class ViewTransactionsScreen extends StatelessWidget {
  const ViewTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StockBloc, StockState>(
        builder: (context, state) {
          // if (state is StockLoadingState) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          // if (state is StockErrorState) {
          //   return Center(child: Text('Error: ${state.message}'));
          // }

          if (state is! StockLoadedState || state.groupedStocks.isEmpty) {
            return const Center(child: Text('No transactions available.'));
          }

          return ListView.builder(
            itemCount: state.groupedStocks.length,
            itemBuilder: (context, index) {
              final mrnGroup = state.groupedStocks.values.elementAt(index);
              final firstStock = mrnGroup.first;

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
                          stockRecords: mrnGroup,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with MRN and basic info
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

                        // Products list
                        const Divider(),
                        const Text(
                          'Commodities Received:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...mrnGroup
                            .map((stock) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        stock.additionalFields?.fields
                                                .firstWhere(
                                                  (field) =>
                                                      field.key ==
                                                      'productName',
                                                  orElse: () => AdditionalField(
                                                      'productName', 'N/A'),
                                                )
                                                .value
                                                ?.toString() ??
                                            'N/A',
                                      ),
                                      Text(
                                        'Qty: ${stock.quantity ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),

                        // Footer with waybill info
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
