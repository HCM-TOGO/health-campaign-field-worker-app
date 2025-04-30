import 'package:digit_components/digit_components.dart';
import 'package:digit_ui_components/enum/app_enums.dart';
import 'package:digit_ui_components/widgets/atoms/digit_button.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
import '../../../utils/logger.dart';
import '../../../widgets/localized.dart';

@RoutePage()
class ConsentHouseholdAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;

  const ConsentHouseholdAcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.enableViewHousehold,
  });

  @override
  State<ConsentHouseholdAcknowledgementPage> createState() =>
      _ConsentHouseholdAcknowledgementPageState();
}

class _ConsentHouseholdAcknowledgementPageState
    extends LocalizedState<ConsentHouseholdAcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocBuilder<BeneficiaryRegistrationBloc,
            BeneficiaryRegistrationState>(
          builder: (context, state) {
            Logger()
                .d("This is the data for household ${state.householdModel}");
            return PanelCard(
              type: PanelType.success,
              title: localizations.translate(
                  i18.acknowledgementSuccess.acknowledgementLabelText),
              actions: [
                DigitButton(
                    label: localizations.translate(
                      i18.householdDetails.viewHouseHoldDetailsAction,
                    ),
                    onPressed: () {
                      //     final wrapper = context
                      //         .read<HouseholdOverviewBloc>()
                      //         .state
                      //         .householdMemberWrapper;

                      //     // context.router.popAndPush(
                      //     //   BeneficiaryWrapperRoute(wrapper: wrapper),
                      //     // );
                      context.router.push(
                        HouseHoldDetailsRoute(),
                      );
                    },
                    type: DigitButtonType.primary,
                    size: DigitButtonSize.large),
                DigitButton(
                    label: localizations
                        .translate(i18.acknowledgementSuccess.actionLabelText),
                    onPressed: () {
                      // final bloc = context.read<SearchBlocWrapper>();

                      // context.router.popAndPush(
                      //   BeneficiaryWrapperRoute(
                      //     wrapper: bloc.state.householdMembers.first,
                      //   ),
                      // );
                    },
                    type: DigitButtonType.secondary,
                    size: DigitButtonSize.large),
              ],
              additionalDetails: [
                const Text(
                  "Household ID",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${state.householdModel?.additionalFields?.fields.firstWhere(
                        (field) => field.key == 'projectTypeId',
                      ).value}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
              description: localizations.translate(
                i18.acknowledgementSuccess.acknowledgementDescriptionText,
              ),
            );
            // return DigitAcknowledgement.success(
            //   action: () {
            //     final parent = context.router.parent() as StackRouter;
            //     // Pop twice to navigate back to the previous screen
            //     parent
            //       ..pop()
            //       ..pop();
            //     // context.router.push(
            //     //   HouseHoldDetailsRoute(),
            //     // );
            //   },
            //   secondaryAction: () {
            //     final wrapper = context
            //         .read<HouseholdOverviewBloc>()
            //         .state
            //         .householdMemberWrapper;

            //     // context.router.popAndPush(
            //     //   BeneficiaryWrapperRoute(wrapper: wrapper),
            //     // );
            //     context.router.push(
            //       HouseHoldDetailsRoute(),
            //     );
            //   },
            //   enableViewHousehold: true,
            //   // secondaryLabel: localizations.translate(
            //   //   i18.householdDetails.viewHouseHoldDetailsAction,
            //   // ),
            //   secondaryLabel: "View Houshold details",
            //   actionLabel: localizations
            //       .translate(i18.acknowledgementSuccess.actionLabelText),
            //   description: localizations.translate(
            //     i18.acknowledgementSuccess.acknowledgementDescriptionText,
            //   ),
            //   label: localizations.translate(
            //       i18.acknowledgementSuccess.acknowledgementLabelText),
            // );
          },
        ),
      ),
    );
  }
}
