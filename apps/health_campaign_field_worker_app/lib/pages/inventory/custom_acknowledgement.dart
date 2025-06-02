import 'package:auto_route/auto_route.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import '../../utils/i18_key_constants.dart' as i18_local;
import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import 'package:inventory_management/widgets/localized.dart';

@RoutePage()
class CustomInventoryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool isDataRecordSuccess;
  final String? label;
  final String? description;
  final Map<String, dynamic>? descriptionTableData;
  

  const CustomInventoryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.isDataRecordSuccess = false,
    this.label,
    this.description,
    this.descriptionTableData,
    

  });

  @override
  State<CustomInventoryAcknowledgementPage> createState() =>
      CustomAcknowledgementPageState();
}

class CustomAcknowledgementPageState
    extends LocalizedState<CustomInventoryAcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String descriptionText;
    
  
    return Scaffold(
      body: PanelCard(
        title: widget.label ??
            localizations.translate(
              i18_local.acknowledgementSuccess.updatedacknowledgementLabelText
            ),

        type: PanelType.success,
        description: localizations.translate(
              widget.description ?? i18.acknowledgementSuccess.acknowledgementDescriptionText,
            ),


        /// TODO: need to update this as listview card
        // additionWidgets: widget.isDataRecordSuccess
        //     ? DigitTableCard(
        //         element: widget.descriptionTableData ?? {},
        //       )
        //     : null,
        actions: [
          DigitButton(
              label: localizations
                  .translate(i18.acknowledgementSuccess.actionLabelText),
              onPressed: () {
                context.router.maybePop();
              },
              type: DigitButtonType.primary,
              size: DigitButtonSize.large),
        ],
        // action: () {
        //   context.router.maybePop();
        // },
        // enableBackToSearch: widget.isDataRecordSuccess ? false : true,
        // actionLabel:
        //     localizations.translate(i18.acknowledgementSuccess.actionLabelText),
      ),
      bottomNavigationBar: Offstage(
        offstage: !widget.isDataRecordSuccess,
        // Show the bottom navigation bar if `isDataRecordSuccess` is true
        child: SizedBox(
          height: 150,
          child: DigitCard(
            margin: const EdgeInsets.fromLTRB(0, spacer2, 0, 0),
            children: [
              DigitButton(
                size: DigitButtonSize.large,
                type: DigitButtonType.secondary,
                label: localizations
                    .translate(i18.acknowledgementSuccess.goToHome),
                onPressed: () {
                  context.router.popUntilRoot();
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DigitButton(
                size: DigitButtonSize.large,
                type: DigitButtonType.primary,
                onPressed: () {
                  context.router.popUntilRoot();
                },
                label: localizations
                    .translate(i18.acknowledgementSuccess.downloadmoredata),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
