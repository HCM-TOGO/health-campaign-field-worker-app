import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/atoms/input_wrapper.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/localized.dart';

import '../../router/app_router.dart';

@RoutePage()
class ViewStockRecordsLGAPage extends LocalizedStatefulWidget {
  final String mrnNumber;
  final List<StockModel> stockRecords;

  const ViewStockRecordsLGAPage({
    super.key,
    super.appLocalizations,
    required this.mrnNumber,
    required this.stockRecords,
  });

  @override
  State<ViewStockRecordsLGAPage> createState() =>
      _ViewStockRecordsLGAPageState();
}

class _ViewStockRecordsLGAPageState
    extends LocalizedState<ViewStockRecordsLGAPage> {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textAreaController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    _textAreaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission() async {
    // Save the additional fields to each stock record
    final updatedStocks = widget.stockRecords.map((stock) {
      final additionalFields = stock.additionalFields?.fields ?? [];

      // Add or update the additional fields
      final newFields = [
        ...additionalFields.where((field) =>
            field.key != 'additionalField' && field.key != 'additionalNotes'),
        if (_textFieldController.text.isNotEmpty)
          AdditionalField('additionalField', _textFieldController.text),
        if (_textAreaController.text.isNotEmpty)
          AdditionalField('additionalNotes', _textAreaController.text),
      ];

      return stock.copyWith(
        additionalFields: stock.additionalFields?.copyWith(
          fields: newFields,
        ),
      );
    }).toList();

    // Save each stock record
    for (final stock in updatedStocks) {
      context.read<RecordStockBloc>().add(
            RecordStockSaveStockDetailsEvent(
              stockModel: stock,
            ),
          );
    }

    // Navigate to acknowledgement page
    context.router.push(
      CustomAcknowledgementRoute(
        mrnNumber: widget.mrnNumber,
        stockRecords: updatedStocks,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Records - ${widget.mrnNumber}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // MRN Card
            DigitCard(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stock Receipt Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('MRN Number')),
                        Expanded(child: Text(widget.mrnNumber)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Text('Received From')),
                        Expanded(
                            child: Text(
                                widget.stockRecords.first.facilityId ?? '')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List all products
            ...widget.stockRecords.map((stock) {
              final productName = stock.additionalFields?.fields
                      .firstWhere(
                        (field) => field.key == 'productName',
                        orElse: () => AdditionalField('productName', ''),
                      )
                      .value
                      ?.toString() ??
                  '';

              return Column(
                children: [
                  DigitCard(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Waybill Number
                          InputField(
                            type: InputType.text,
                            label: 'Waybill Number',
                            initialValue: stock.wayBillNumber ?? '',
                            isDisabled: true,
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          // Batch Number
                          InputField(
                            type: InputType.text,
                            label: 'Batch Number',
                            initialValue: stock.additionalFields?.fields
                                    .firstWhere(
                                      (field) => field.key == 'batchNumber',
                                      orElse: () =>
                                          AdditionalField('batchNumber', ''),
                                    )
                                    .value
                                    ?.toString() ??
                                '',
                            isDisabled: true,
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          // Quantity
                          InputField(
                            type: InputType.text,
                            label: 'Quantity',
                            initialValue: stock.quantity ?? '',
                            isDisabled: true,
                            readOnly: true,
                          ),
                          const SizedBox(height: 12),
                          // Comments
                          InputField(
                            type: InputType.textArea,
                            label: 'Comments',
                            initialValue: stock.additionalFields?.fields
                                    .firstWhere(
                                      (field) => field.key == 'comments',
                                      orElse: () =>
                                          AdditionalField('comments', ''),
                                    )
                                    .value
                                    ?.toString() ??
                                '',
                            isDisabled: true,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),

            // Additional editable fields
            const SizedBox(height: 20),
            DigitCard(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Information',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    // Text field
                    InputField(
                      type: InputType.text,
                      label: 'Additional Field',
                      controller: _textFieldController,
                    ),
                    const SizedBox(height: 12),
                    // Text area
                    InputField(
                      type: InputType.textArea,
                      label: 'Additional Notes',
                      controller: _textAreaController,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            DigitButton(
              label: localizations.translate(i18.common.coreCommonSubmit),
              onPressed: _handleSubmission,
              type: DigitButtonType.primary,
              size: DigitButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }
}
