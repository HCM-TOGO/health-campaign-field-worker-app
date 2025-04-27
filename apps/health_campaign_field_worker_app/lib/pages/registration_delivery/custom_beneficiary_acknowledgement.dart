import 'package:auto_route/auto_route.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import '../../widgets/digit_ui_component/custom_panel_card.dart';

@RoutePage()
class CustomBeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;
  final String beneficiaryId;

  const CustomBeneficiaryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    required this.beneficiaryId,
    this.enableViewHousehold,
  });

  @override
  State<CustomBeneficiaryAcknowledgementPage> createState() =>
      CustomBeneficiaryAcknowledgementPageState();
}

class CustomBeneficiaryAcknowledgementPageState
    extends LocalizedState<CustomBeneficiaryAcknowledgementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(spacer2),
        child: CustomPanelCard(
          type: PanelType.success,
          title: localizations
              .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
          subTitle: {
            'id': 'Beneficiary Id',
            'value': widget.beneficiaryId,
          },
          actions: [
            DigitButton(
                label: localizations.translate(
                  i18.householdDetails.viewHouseHoldDetailsAction,
                ),
                onPressed: () {
                  final bloc = context.read<SearchBlocWrapper>();

                  context.router.popAndPush(
                    BeneficiaryWrapperRoute(
                      wrapper: bloc.state.householdMembers.first,
                    ),
                  );
                },
                type: DigitButtonType.primary,
                size: DigitButtonSize.large),
            DigitButton(
                label: localizations
                    .translate(i18.acknowledgementSuccess.actionLabelText),
                onPressed: () => context.router.maybePop(),
                type: DigitButtonType.secondary,
                size: DigitButtonSize.large),
          ],
          description: localizations.translate(
            i18.acknowledgementSuccess.acknowledgementDescriptionText,
          ),
        ),
      ),
    );
  }
}
