import 'package:auto_route/auto_route.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';

import 'package:referral_reconciliation/utils/i18_key_constants.dart' as i18;
import 'package:referral_reconciliation/widgets/localized.dart';
import 'package:health_campaign_field_worker_app/router/app_router.dart';

@RoutePage()
class CustomReferralReconAcknowedgmentPage extends LocalizedStatefulWidget {
  final bool isDataRecordSuccess;
  final String? label;
  final String? description;
  final Map<String, dynamic>? descriptionTableData;
  const CustomReferralReconAcknowedgmentPage({
    super.key,
    super.appLocalizations,
    this.isDataRecordSuccess = false,
    this.label,
    this.description,
    this.descriptionTableData,
  });

  @override
  State<CustomReferralReconAcknowedgmentPage> createState() =>
      _CustomReferralReconAcknowedgmentPageState();
}

class _CustomReferralReconAcknowedgmentPageState
    extends LocalizedState<CustomReferralReconAcknowedgmentPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.router.popUntilRoot();
          context.router.push(CustomSearchReferralReconciliationsRoute());
        }
      },
      child: Scaffold(
        body: PanelCard(
            type: PanelType.success,
            title: widget.label ??
                localizations.translate(
                  i18.acknowledgementSuccess.acknowledgementLabelText,
                ),
            description: widget.description ??
                localizations.translate(
                  i18.acknowledgementSuccess.acknowledgementDescriptionText,
                ),
            actions: [
              DigitButton(
                label: localizations
                    .translate(i18.acknowledgementSuccess.actionLabelText),
                onPressed: () {
                  context.router.popUntilRoot();
                  context.router
                      .push(CustomSearchReferralReconciliationsRoute());
                },
                type: DigitButtonType.primary,
                size: DigitButtonSize.large,
                mainAxisSize: MainAxisSize.max,
              )
            ]),
        bottomNavigationBar: Offstage(
          offstage: !widget.isDataRecordSuccess,
          // Show the bottom navigation bar if `isDataRecordSuccess` is true
          child: SizedBox(
            height: 150,
            child: Column(
              children: [
                DigitButton(
                  size: DigitButtonSize.large,
                  type: DigitButtonType.primary,
                  mainAxisSize: MainAxisSize.max,
                  label: localizations
                      .translate(i18.acknowledgementSuccess.goToHome),
                  onPressed: () {
                    context.router.popUntilRoot();
                    context.router
                        .push(CustomSearchReferralReconciliationsRoute());
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                DigitButton(
                  size: DigitButtonSize.large,
                  type: DigitButtonType.secondary,
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    context.router.popUntilRouteWithName(HomeRoute.name);
                    context.router
                        .push(CustomSearchReferralReconciliationsRoute());
                  },
                  label: localizations
                      .translate(i18.acknowledgementSuccess.downloadmoredata),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
