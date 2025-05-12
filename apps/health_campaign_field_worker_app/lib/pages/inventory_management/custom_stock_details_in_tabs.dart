import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_data_model/models/entities/product_variant.dart';
import 'package:digit_scanner/blocs/scanner.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/input_wrapper.dart';
import 'package:digit_ui_components/widgets/atoms/pop_up_card.dart';
import 'package:digit_ui_components/widgets/molecules/show_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/pages/inventory_management/custom_acknowledgement.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/models/entities/inventory_transport_type.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/utils/utils.dart';
import 'package:inventory_management/widgets/localized.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import '../../blocs/inventory_management/stock_bloc.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18_local;
import '../../utils/constants.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/registration_delivery/registration_delivery_utils.dart';

class DynamicTabsPage extends LocalizedStatefulWidget {
  @override
  LocalizedState<DynamicTabsPage> createState() => _DynamicTabsPageState();
}

class _DynamicTabsPageState extends LocalizedState<DynamicTabsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final Map<String, FormGroup> _forms = {};
  late List<ProductVariantModel> products;
  late String receivedFrom;
  late List<dynamic> _formkeys;
  final Map<String, StockModel> _tabStocks = {};
  String _sharedMRN = '';
  bool _isInitializing = true;

  static const _productVariantKey = 'productVariant';
  static const _secondaryPartyKey = 'secondaryParty';
  static const _transactionReasonKey = 'transactionReason';
  static const _waybillNumberKey = 'waybillNumber';
  static const _waybillQuantityKey = 'waybillQuantity';
  static const _batchNumberKey = 'batchNumberKey';
  static const _vehicleNumberKey = 'vehicleNumber';
  static const _typeOfTransportKey = 'typeOfTransport';
  static const _commentsKey = 'comments';
  static const _expiry = 'expiry';
  static const _deliveryTeamKey = 'deliveryTeam';
  List<InventoryTransportTypes> transportTypes = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Generate unique MRN first
      final mrnNumbers = await UniqueIdGeneration()
          .generateUniqueMaterialNoteNumber(
            loggedInUserId: context.loggedInUserUuid,
            returnCombinedIds: true,
          )
          .timeout(const Duration(seconds: 5));

      if (mrnNumbers.isEmpty) {
        throw Exception('Failed to generate MRN number');
      }

      _sharedMRN = mrnNumbers.first;

      transportTypes = InventorySingleton().transportType;
      context.read<LocationBloc>().add(const LoadLocationEvent());

      final state = context.read<StockBloc>().state;
      if (state is StockSelectedState) {
        products = state.selectedProducts;
        receivedFrom = state.receivedFrom;
        _tabController = TabController(length: products.length, vsync: this);
        _formkeys =
            List.generate(products.length, (_) => GlobalKey<FormState>());

        _initializeForms();
        await _initializeStocks();
      }
    } on TimeoutException {
      _sharedMRN = 'MRN-${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('MRN generation timed out, using fallback');
    } catch (e) {
      _sharedMRN = 'MRN-${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('Error generating MRN: $e');
    } finally {
      setState(() => _isInitializing = false);
    }
  }

  void _initializeForms() {
    final selectedProducts =
        products.map((variant) => variant.sku).whereType<String>().toList();

    _forms.addAll({
      for (final product in selectedProducts)
        product: FormGroup({
          'materialNoteNumber': FormControl<String>(value: _sharedMRN),
          _transactionReasonKey: FormControl<String>(),
          _waybillNumberKey: FormControl<String>(
            validators: [
              Validators.minLength(2),
              Validators.maxLength(200),
              Validators.required
            ],
          ),
          _waybillQuantityKey: FormControl<String>(validators: []),
          _batchNumberKey: FormControl<String>(
            validators: [Validators.required],
          ),
          'expiry': FormControl<String>(validators: [Validators.required]),
          _commentsKey: FormControl<String>(),
        }),
    });
  }

  Future<void> _initializeStocks() async {
    for (final product in products) {
      _tabStocks[product.sku ?? ''] = await _createEmptyStock(product);
    }
  }

  Future<StockModel> _createEmptyStock(ProductVariantModel product) async {
    final productSku = product.sku ?? '';

    return StockModel(
      id: null,
      facilityId: receivedFrom,
      productVariantId: product.id,
      quantity:
          _forms[productSku]?.control(_waybillQuantityKey)?.value?.toString() ??
              '0',
      wayBillNumber:
          _forms[productSku]?.control(_waybillNumberKey)?.value?.toString(),
      transactionReason:
          _forms[productSku]?.control(_transactionReasonKey)?.value?.toString(),
      clientReferenceId: DateTime.now().millisecondsSinceEpoch.toString(),
      additionalFields: StockAdditionalFields(
        version: 1,
        fields: [
          AdditionalField('productName', product.sku),
          AdditionalField('variation', product.variation),
          AdditionalField('materialNoteNumber', _sharedMRN),
          if (_forms[productSku] != null) ...[
            AdditionalField('batchNumber',
                _forms[productSku]!.control(_batchNumberKey).value),
            AdditionalField(
                'expiryDate', _forms[productSku]!.control(_expiry).value),
            AdditionalField(
                'comments', _forms[productSku]!.control(_commentsKey).value),
          ],
        ],
      ),
      referenceId: null,
      referenceIdType: null,
      transactingPartyId: null,
      transactingPartyType: null,
      receiverId: null,
      receiverType: null,
      senderId: null,
      senderType: null,
      nonRecoverableError: false,
      rowVersion: null,
      transactionType: null,
    );
  }

  Widget _buildTabContent(
      BuildContext context, String productName, String receivedFrom) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final isDistributor = context.isDistributor;

    final stockState = context.read<RecordStockBloc>().state;
    bool isWareHouseMgr = InventorySingleton().isWareHouseMgr;
    final form = _forms[productName]!;
    StockRecordEntryType entryType = stockState.entryType;
    bool isLastTab = _tabController.index == _tabController.length - 1;

    return _KeepAliveTabContent(
      child: ReactiveForm(
        formGroup: form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                        const Expanded(child: Text('Resource')),
                        Expanded(child: Text(productName)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(child: Text('Received From')),
                        Expanded(child: Text(receivedFrom)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            DigitCard(
              padding: const EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stock Details',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    if (isWareHouseMgr)
                      ReactiveWrapperField(
                          formControlName: _waybillNumberKey,
                          builder: (field) {
                            return InputField(
                              type: InputType.text,
                              label: localizations.translate(
                                i18.stockDetails.waybillNumberLabel,
                              ),
                              onChange: (val) {
                                field.control.value = val;
                              },
                              isRequired: true,
                            );
                          }),
                    if (isWareHouseMgr &&
                        entryType != StockRecordEntryType.returned)
                      ReactiveWrapperField(
                          formControlName: _batchNumberKey,
                          builder: (field) {
                            return InputField(
                              type: InputType.text,
                              isRequired: true,
                              label: localizations.translate(
                                i18_local.stockDetails.batchNumberLabel,
                              ),
                              onChange: (val) {
                                if (val == '') {
                                  field.control.value = '0';
                                } else {
                                  field.control.value = val;
                                }
                              },
                            );
                          }),
                    ReactiveWrapperField(
                      formControlName: _expiry,
                      builder: (field) {
                        return InputField(
                          type: InputType.date,
                          label: localizations.translate(
                            i18_local.StockDetailsReturnedShowcase().expiry,
                          ),
                          errorMessage: field.errorText,
                          onChange: (val) => field.control.value = val,
                          isRequired: true,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveWrapperField(
                      formControlName: _waybillQuantityKey,
                      builder: (field) {
                        return InputField(
                          type: InputType.text,
                          label: localizations.translate(
                            i18.stockDetails.quantityReceivedLabel,
                          ),
                          errorMessage: field.errorText,
                          onChange: (val) {
                            if (val == '') {
                              field.control.value = '0';
                            } else {
                              field.control.value = val;
                            }
                          },
                          isRequired: true,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ReactiveWrapperField(
                      formControlName: _commentsKey,
                      builder: (field) {
                        return InputField(
                          type: InputType.textArea,
                          label: localizations.translate(
                            i18.stockDetails.commentsLabel,
                          ),
                          errorMessage: field.errorText,
                          onChange: (val) => field.control.value = val,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DigitButton(
                  size: DigitButtonSize.large,
                  type: DigitButtonType.primary,
                  onPressed: () async {
                    if (form.valid) {
                      await _saveCurrentTabData(productName);

                      if (_tabController.index < products.length - 1) {
                        _tabController.animateTo(_tabController.index + 1);
                      } else {
                        await _handleFinalSubmission(context);
                      }
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  label: isLastTab
                      ? localizations.translate(i18.common.coreCommonSubmit)
                      : localizations.translate(i18.common.coreCommonNext),
                ),
                const SizedBox(height: 12),
                // DigitButton(
                //   type: DigitButtonType.secondary,
                //   size: DigitButtonSize.large,
                //   onPressed: () {
                //     // Secondary action if needed
                //   },
                //   label: localizations.translate(
                //     i18.common.coreCommonCancel,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveCurrentTabData(String productName) async {
    final form = _forms[productName]!;
    final currentStock = _tabStocks[productName]!;

    _tabStocks[productName] = currentStock.copyWith(
      quantity: form.control(_waybillQuantityKey).value?.toString(),
      wayBillNumber: form.control(_waybillNumberKey).value?.toString(),
      transactionReason: form.control(_transactionReasonKey).value?.toString(),
      additionalFields: currentStock.additionalFields?.copyWith(
        fields: [
          ...(currentStock.additionalFields?.fields ?? []),
          AdditionalField('batchNumber', form.control(_batchNumberKey).value),
          AdditionalField('expiryDate', form.control(_expiry).value),
          AdditionalField('comments', form.control(_commentsKey).value),
        ],
      ),
    );
  }

  Future<void> _handleFinalSubmission(BuildContext context) async {
    final lastProduct = products.last.sku ?? '';
    await _saveCurrentTabData(lastProduct);

    final submit = await showCustomPopup(
      context: context,
      builder: (popupContext) => Popup(
        title: localizations.translate(i18.stockDetails.dialogTitle),
        onOutsideTap: () {
          Navigator.of(popupContext).pop(false);
        },
        description: localizations.translate(
          i18.stockDetails.dialogContent,
        ),
        type: PopUpType.simple,
        actions: [
          DigitButton(
            label: localizations.translate(
              i18.common.coreCommonSubmit,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomAcknowledgementPage(
                    mrnNumber: _sharedMRN,
                    stockRecords: _tabStocks.values.toList(),
                  ),
                ),
              );
            },
            type: DigitButtonType.primary,
            size: DigitButtonSize.large,
          ),
          DigitButton(
            label: localizations.translate(
              i18.common.coreCommonCancel,
            ),
            onPressed: () {
              Navigator.of(
                popupContext,
                rootNavigator: true,
              ).pop(false);
            },
            type: DigitButtonType.secondary,
            size: DigitButtonSize.large,
          ),
        ],
      ),
    ) as bool;

    if (submit == true) {
      // Loop through all stocks and dispatch individual events
      for (final stockModel in _tabStocks.values) {
        context.read<RecordStockBloc>().add(
              RecordStockSaveStockDetailsEvent(
                stockModel: stockModel,
              ),
            );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedProducts =
        products.map((variant) => variant.sku).whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: selectedProducts
              .map((product) => Tab(text: product.toUpperCase()))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: selectedProducts
            .map((product) => _buildTabContent(context, product, receivedFrom))
            .toList(),
      ),
    );
  }

  void _nextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  String? wastageQuantity(FormGroup form, BuildContext context) {
    final quantity = form.control(_waybillQuantityKey).value;
    final partialBlisters = form.control(_waybillQuantityKey).value;

    if (quantity == null || partialBlisters == null) {
      return null;
    }

    int totalQuantity = 0;
    int totalRemainingQuantityInMl = context.spaq1;

    int totalExpectedUnusedBottles =
        totalRemainingQuantityInMl ~/ Constants.mlPerBottle;

    int totalExpectedPartialQuantityInMl =
        totalRemainingQuantityInMl % Constants.mlPerBottle;

    int totalExpectedPartialBottles =
        totalRemainingQuantityInMl % Constants.mlPerBottle != 0 ? 1 : 0;

    totalQuantity = quantity != null ? int.parse(quantity.toString()) : 0;

    return (((totalExpectedUnusedBottles - totalQuantity) *
                Constants.mlPerBottle) +
            ((totalExpectedPartialBottles >
                    (partialBlisters != null
                        ? int.parse(partialBlisters.toString())
                        : 0))
                ? totalExpectedPartialQuantityInMl
                : 0))
        .toString();
  }

  num _getQuantityCount(Iterable<StockModel> stocks) {
    return stocks.fold<num>(
      0.0,
      (old, e) => (num.tryParse(e.quantity ?? '') ?? 0.0) + old,
    );
  }

  void clearQRCodes() {
    context.read<DigitScannerBloc>().add(const DigitScannerEvent.handleScanner(
          barCode: [],
          qrCode: [],
        ));
  }

  bool _isCurrentTabValid() {
    return _formkeys[_tabController.index].currentState?.validate() ?? false;
  }
}

class _KeepAliveTabContent extends StatefulWidget {
  final Widget child;

  const _KeepAliveTabContent({required this.child});

  @override
  State<_KeepAliveTabContent> createState() => _KeepAliveTabContentState();
}

class _KeepAliveTabContentState extends State<_KeepAliveTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
