import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import '../../../router/app_router.dart';
import '../../../utils/i18_key_constants.dart' as i18;
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
        body: DigitAcknowledgement.success(
          action: () {
            final parent = context.router.parent() as StackRouter;
            // Pop twice to navigate back to the previous screen
            parent
              ..pop()
              ..pop();
          },
          secondaryAction: () {
            final wrapper = context
                .read<HouseholdOverviewBloc>()
                .state
                .householdMemberWrapper;

            context.router.popAndPush(
              BeneficiaryWrapperRoute(wrapper: wrapper),
            );
          },
          enableViewHousehold: widget.enableViewHousehold ?? false,
          secondaryLabel: localizations.translate(
            i18.householdDetails.viewHouseHoldDetailsAction,
          ),
          actionLabel: localizations
              .translate(i18.acknowledgementSuccess.actionLabelText),
          description: localizations.translate(
            i18.acknowledgementSuccess.acknowledgementDescriptionText,
          ),
          label: localizations
              .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
        ),
      ),
    );
  }
}
