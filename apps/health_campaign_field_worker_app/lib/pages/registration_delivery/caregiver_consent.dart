import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/models/entities/household_type.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/models/RadioButtonModel.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/selection_card.dart';
import 'package:digit_ui_components/widgets/atoms/text_block.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/utils/utils.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/widgets/showcase/config/showcase_constants.dart';
import 'package:registration_delivery/widgets/showcase/showcase_button.dart';

import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18_local;

enum CaregiverConsentEnum {
  yes,
  no,
}

@RoutePage()
class CaregiverConsentPage extends LocalizedStatefulWidget {
  const CaregiverConsentPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CaregiverConsentPage> createState() => CaregiverConsentPageState();
}

class CaregiverConsentPageState extends LocalizedState<CaregiverConsentPage> {
  CaregiverConsentEnum selectedConsent = CaregiverConsentEnum.yes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final router = context.router;
    final bool isCommunity = RegistrationDeliverySingleton().householdType ==
        HouseholdType.community;

    return Scaffold(
      body: BlocBuilder<BeneficiaryRegistrationBloc,
          BeneficiaryRegistrationState>(builder: (context, registrationState) {
        return ScrollableContent(
          enableFixedDigitButton: true,
          header: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: spacer2),
                child: BackNavigationHelpHeaderWidget(
                  showcaseButton: ShowcaseButton(
                    isCommunity: isCommunity,
                  ),
                ),
              ),
            ],
          ),
          footer:
              DigitCard(margin: const EdgeInsets.only(top: spacer2), children: [
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locationState) {
                return DigitButton(
                  label: localizations.translate(
                    i18.householdLocation.actionLabel,
                  ),
                  type: DigitButtonType.primary,
                  size: DigitButtonSize.large,
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    if (selectedConsent == CaregiverConsentEnum.yes) {
                      router.push(CustomHouseHoldDetailsRoute());
                    } else {
                      router.push(CustomHouseHoldDetailsRoute());
                    }
                  },
                );
              },
            ),
          ]),
          slivers: [
            SliverToBoxAdapter(
              child:
                  DigitCard(margin: const EdgeInsets.all(spacer2), children: [
                DigitTextBlock(
                  padding: EdgeInsets.zero,
                  heading: localizations.translate(
                      i18_local.caregiverConsent.caregiverConsentLabelText),
                  headingStyle: textTheme.headingXl
                      .copyWith(color: theme.colorTheme.primary.primary2),
                  description: localizations.translate(
                    i18_local.caregiverConsent.caregiverConsentDescriptionText,
                  ),
                ),
                FormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    builder: (context) {
                      return RadioList(
                        radioDigitButtons: [
                          RadioButtonModel(
                            code: CaregiverConsentEnum.yes.name,
                            name: localizations.translate(
                              i18_local.common.coreCommonYes,
                            ),
                          ),
                          RadioButtonModel(
                            code: CaregiverConsentEnum.no.name,
                            name: localizations.translate(
                              i18_local.common.coreCommonNo,
                            ),
                          ),
                        ],
                        groupValue: CaregiverConsentEnum.yes.name,
                        onChanged: (value) {
                          if (value.code == CaregiverConsentEnum.yes.name) {
                            selectedConsent = CaregiverConsentEnum.yes;
                          } else {
                            selectedConsent = CaregiverConsentEnum.yes;
                          }
                        },
                      );
                    })
              ]),
            ),
          ],
        );
      }),
    );
  }
}
