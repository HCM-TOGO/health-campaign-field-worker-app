import 'package:digit_ui_components/widgets/atoms/input_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:health_campaign_field_worker_app/blocs/localization/app_localization.dart';
import 'package:inventory_management/widgets/localized.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:inventory_management/utils/i18_key_constants.dart' as i18;

class DynamicTabsPage extends LocalizedStatefulWidget {
  final Map<String, dynamic> data;

  const DynamicTabsPage({Key? key, required this.data}) : super(key: key);

  @override
  LocalizedState<DynamicTabsPage> createState() => _DynamicTabsPageState();
}

class _DynamicTabsPageState extends LocalizedState<DynamicTabsPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final Map<String, FormGroup> _forms;

  @override
  void initState() {
    super.initState();

    final selectedProducts = List<String>.from(widget.data['selectedProducts']);
    _tabController =
        TabController(length: selectedProducts.length, vsync: this);

    _forms = {
      for (final product in selectedProducts)
        product: FormGroup({
          'waybill': FormControl<String>(validators: [Validators.required]),
          'batch': FormControl<String>(validators: [Validators.required]),
          'expiry': FormControl<String>(validators: [Validators.required]),
          'quantity': FormControl<String>(validators: [Validators.required]),
          'comments': FormControl<String>(),
        }),
    };
  }

  Widget _buildTabContent(String productName) {
    final form = _forms[productName]!;
    final receivedFrom = widget.data['receivedFrom'];
    final selectedProducts = List<String>.from(widget.data['selectedProducts']);

    return ReactiveForm(
      formGroup: form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// Card 1: Stock Receipt Details
          DigitCard(
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stock Receipt Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

          /// Card 2: Stock Details
          DigitCard(
            padding: const EdgeInsets.all(16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stock Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  /// Waybill Number
                  ReactiveWrapperField(
                    formControlName: 'waybill',
                    builder: (field) {
                      return InputField(
                        type: InputType.text,
                        label: 'Waybill Number',
                        errorMessage: field.errorText,
                        onChange: (val) => field.control.value = val,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Batch Number
                  ReactiveWrapperField(
                    formControlName: 'batch',
                    builder: (field) {
                      return InputField(
                        type: InputType.text,
                        label: 'Batch Number',
                        errorMessage: field.errorText,
                        onChange: (val) => field.control.value = val,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Expiry Date
                  ReactiveWrapperField(
                    formControlName: 'expiry',
                    builder: (field) {
                      return InputField(
                        type: InputType.text,
                        label: 'Expiry Date',
                        errorMessage: field.errorText,
                        onChange: (val) => field.control.value = val,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Quantity
                  ReactiveWrapperField(
                    formControlName: 'quantity',
                    builder: (field) {
                      return InputField(
                        type: InputType.text,
                        label: 'Quantity of $productName received',
                        errorMessage: field.errorText,
                        onChange: (val) => field.control.value = val,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Comments
                  ReactiveWrapperField(
                    formControlName: 'comments',
                    builder: (field) {
                      return InputField(
                        type: InputType.textArea,
                        label: 'Comments',
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

          /// Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DigitButton(
                size: DigitButtonSize.large,
                type: DigitButtonType.primary,
                onPressed: () {
                  if (form.valid) {
                    if (_tabController.index < selectedProducts.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    } else {
                      // Final Submit
                      // Collect data from all forms
                      final allData = {
                        for (final entry in _forms.entries)
                          entry.key: entry.value.rawValue,
                      };
                      debugPrint('Submitting: $allData');
                    }
                  } else {
                    form.markAllAsTouched();
                  }
                },
                label: localizations.translate(
                  i18.common.coreCommonSubmit,
                ),
                // children: [
                //   Text(_tabController.index ==
                //           widget.model.selectedProducts.length - 1
                //       ? 'Submit'
                //       : 'Next'),
                // ],
              ),
              const SizedBox(height: 12),
              DigitButton(
                type: DigitButtonType.secondary,
                size: DigitButtonSize.large,
                onPressed: () {
                  // Your secondary button logic
                },
                label: localizations.translate(
                  i18.common.coreCommonSubmit,
                ),
                // children: [const Text('Secondary Action')],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProducts = List<String>.from(widget.data['selectedProducts']);

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
            .map((product) => _buildTabContent(product))
            .toList(),
      ),
    );
  }
}
