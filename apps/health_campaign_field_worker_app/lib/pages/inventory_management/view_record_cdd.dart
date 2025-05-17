import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/atoms/input_wrapper.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/transaction_reason.dart';
import 'package:inventory_management/models/entities/transaction_type.dart';
import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import 'package:inventory_management/utils/utils.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:collection/collection.dart';

import '../../blocs/auth/auth.dart';
import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/extensions.dart';

@RoutePage()
class ViewStockRecordsCDDPage extends LocalizedStatefulWidget {
  final String mrnNumber;
  final List<StockModel> stockRecords;

  const ViewStockRecordsCDDPage({
    super.key,
    super.appLocalizations,
    required this.mrnNumber,
    required this.stockRecords,
  });

  @override
  State<ViewStockRecordsCDDPage> createState() =>
      _ViewStockRecordsCDDPageState();
}

class _ViewStockRecordsCDDPageState
    extends LocalizedState<ViewStockRecordsCDDPage>
    with SingleTickerProviderStateMixin {
  late final FormGroup _form;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _form = FormGroup({
      'quantityReceived': FormControl<int>(
        validators: [
          Validators.required,
          Validators.min(1),
        ],
      ),
      'comments': FormControl<String>(),
    });
    _tabController =
        TabController(length: widget.stockRecords.length, vsync: this);
  }

  @override
  void dispose() {
    _form.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmission() async {
    if (_form.valid) {
      context.read<RecordStockBloc>().add(
            RecordStockSaveTransactionDetailsEvent(
              dateOfRecord: DateTime.now(),
              facilityModel: FacilityModel(
                id: context.loggedInUserUuid,
              ),
              primaryId: context.loggedInUserUuid,
              primaryType: "STAFF",
            ),
          );

      final updatedStocks = widget.stockRecords.map((stock) {
        final additionalFields = stock.additionalFields?.fields ?? [];

        final newFields = [
          ...additionalFields.where((field) =>
              field.key != 'quantityReceived' && field.key != 'comments'),
          AdditionalField('quantityReceived',
              _form.control('quantityReceived').value.toString()),
          if (_form.control('comments').value != null)
            AdditionalField('comments', _form.control('comments').value),
          AdditionalField('received', 'true'),
        ];

        return stock.copyWith(
          id: null,
          rowVersion: 1,
          clientReferenceId: IdGen.i.identifier,
          transactionType: TransactionType.received.toValue(),
          transactionReason: TransactionReason.received.toValue(),
          quantity: _form.control('quantityReceived').value.toString(),
          additionalFields: stock.additionalFields?.copyWith(
            fields: newFields,
          ),
          dateOfEntry: DateTime.now().millisecondsSinceEpoch,
          auditDetails: AuditDetails(
            createdBy: InventorySingleton().loggedInUserUuid,
            createdTime: context.millisecondsSinceEpoch(),
            lastModifiedBy: InventorySingleton().loggedInUserUuid,
            lastModifiedTime: context.millisecondsSinceEpoch(),
          ),
          clientAuditDetails: ClientAuditDetails(
            createdBy: InventorySingleton().loggedInUserUuid,
            createdTime: context.millisecondsSinceEpoch(),
            lastModifiedBy: InventorySingleton().loggedInUserUuid,
            lastModifiedTime: context.millisecondsSinceEpoch(),
          ),
        );
      }).toList();

      for (final stock in updatedStocks) {
        context.read<RecordStockBloc>().add(
              RecordStockSaveStockDetailsEvent(
                stockModel: stock,
              ),
            );
        context.read<RecordStockBloc>().add(
              const RecordStockCreateStockEntryEvent(),
            );

        final stockReceived =
            int.parse(_form.control('quantityReceived').value.toString());

        if (int.parse(stock.quantity!) > stockReceived) {
          Toast.showToast(
            context,
            message: localizations.translate("Comments is required"),
            type: ToastType.error,
            position: ToastPosition.aboveOneButtonFooter,
          );
        } else if (int.parse(stock.quantity!) < stockReceived) {
          Toast.showToast(
            context,
            message: localizations.translate("Check the quantity received"),
            type: ToastType.error,
            position: ToastPosition.aboveOneButtonFooter,
          );
        } else {
          if (InventorySingleton().isDistributor) {
            final totalQty =
                int.parse(_form.control('quantityReceived').value.toString());

            int spaq1Count = context.spaq1;
            int spaq2Count = context.spaq2;

            int blueVasCount = context.blueVas;
            int redVasCount = context.redVas;
            String productName = stock.additionalFields?.fields
                .firstWhereOrNull((element) => element.key == "productName")
                ?.value;
            // Custom logic based on productName
            if (productName == Constants.spaq1) {
              spaq1Count = totalQty;
              spaq2Count = 0;
              redVasCount = 0;
              blueVasCount = 0;
            } else if (productName == Constants.spaq2) {
              spaq2Count = totalQty;
              spaq1Count = 0;
              redVasCount = 0;
              blueVasCount = 0;
            } else if (productName == Constants.blueVAS) {
              blueVasCount = totalQty;
              spaq1Count = 0;
              spaq2Count = 0;
              redVasCount = 0;
            } else {
              blueVasCount = 0;
              spaq1Count = 0;
              spaq2Count = 0;
              redVasCount = totalQty;
            }
            context.read<AuthBloc>().add(
                  AuthAddSpaqCountsEvent(
                    spaq1Count: spaq1Count,
                    spaq2Count: spaq2Count,
                    blueVasCount: blueVasCount,
                    redVasCount: redVasCount,
                  ),
                );
          }
        }

        context.router.push(
          CustomAcknowledgementRoute(
              mrnNumber: widget.mrnNumber,
              stockRecords: updatedStocks,
              entryType: StockRecordEntryType.receipt),
        );
      }
    } else {
      _form.markAllAsTouched();
    }
  }

  Widget _buildProductTab(StockModel stock) {
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
                    color: productName == 'SPAQ 1' || productName == 'SPAQ 2'
                        ? Colors.orange
                        : productName == 'Red VAS'
                            ? Colors.red
                            : productName == 'Blue VAS'
                                ? Colors.blue
                                : Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                InputField(
                  type: InputType.text,
                  label: 'Quantity Sent by Warehouse *',
                  initialValue: stock.quantity ?? '',
                  isDisabled: true,
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                ReactiveWrapperField(
                  formControlName: 'quantityReceived',
                  builder: (field) => InputField(
                    type: InputType.text,
                    label: 'Actual Quantity Received *',
                    errorMessage: field.errorText,
                    keyboardType: TextInputType.number,
                    onChange: (value) {
                      if (value != null && value.isNotEmpty) {
                        field.control.value = int.tryParse(value);
                      } else {
                        field.control.value = null;
                      }
                    },
                  ),
                  validationMessages: {
                    'required': (_) => 'Quantity is required',
                    'min': (_) => 'Must be at least 1',
                    'number': (_) => 'Must be a valid number',
                  },
                ),
                const SizedBox(height: 12),
                ReactiveWrapperField(
                  formControlName: 'comments',
                  builder: (field) => InputField(
                    type: InputType.textArea,
                    label: 'Comments',
                    errorMessage: field.errorText,
                    onChange: (value) => field.control.value = value,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final senderIdToShowOnTab = widget.stockRecords.first.senderId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Records - ${widget.mrnNumber}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: widget.stockRecords.map((stock) {
            final productName = stock.additionalFields?.fields
                    .firstWhere(
                      (field) => field.key == 'productName',
                      orElse: () => AdditionalField('productName', ''),
                    )
                    .value
                    ?.toString() ??
                '';
            return Tab(text: productName);
          }).toList(),
        ),
      ),
      body: ReactiveForm(
        formGroup: _form,
        child: Column(
          children: [
            DigitCard(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
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
                          child: Text(localizations
                              .translate('FAC_$senderIdToShowOnTab')),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.stockRecords.map((stock) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildProductTab(stock),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DigitButton(
                label: localizations.translate(i18.common.coreCommonSubmit),
                onPressed: _handleSubmission,
                type: DigitButtonType.primary,
                size: DigitButtonSize.large,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
