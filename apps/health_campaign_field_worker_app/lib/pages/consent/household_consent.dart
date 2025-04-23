import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_radio_button_list.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';
import 'package:registration_delivery/models/entities/household.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import '../../blocs/beneficiary_registration/beneficiary_registration.dart';
import '../../models/data_model.dart';
import '../../router/app_router.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/utils.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

@RoutePage()
class HouseHoldConsentPage extends LocalizedStatefulWidget {
  const HouseHoldConsentPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<HouseHoldConsentPage> createState() => _HouseHoldConsentPageState();
}

class _HouseHoldConsentPageState extends LocalizedState<HouseHoldConsentPage> {
  static const _consent = 'consent';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final router = context.router;

    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => buildForm(context),
        builder: (context, form, child) => BlocBuilder<
            BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          builder: (context, registrationState) {
            return ScrollableContent(
              header: const Column(children: [
                BackNavigationHelpHeaderWidget(),
              ]),
              footer: DigitCard(
                margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return DigitElevatedButton(
                      onPressed: () {
                        form.markAllAsTouched();
                        if (!form.valid) return;

                        registrationState.maybeWhen(
                          orElse: () {
                            return;
                          },
                          create: (
                            addressModel,
                            householdModel,
                            individualModel,
                            registrationDate,
                            searchQuery,
                            loading,
                            isHeadOfHousehold,
                          ) {
                            if (form.control(_consent).value == null) {
                              form.control(_consent).setErrors({'': true});

                              return;
                            }

                            final isConsent =
                                (form.control(_consent).value as KeyValue)
                                            .key ==
                                        0
                                    ? false
                                    : true;
                            if (!isConsent && addressModel != null) {
                              var address = addressModel.copyWith(
                                latitude: locationState.latitude ??
                                    addressModel.latitude,
                                longitude: locationState.longitude ??
                                    addressModel.longitude,
                                locationAccuracy: locationState.accuracy ??
                                    addressModel.locationAccuracy,
                              );
                              final projectTypeId =
                                  context.selectedProjectType == null
                                      ? ""
                                      : context.selectedProjectType!.id;
                              final cycleIndex = context.selectedCycle?.id == 0
                                  ? ""
                                  : "0${context.selectedCycle?.id}";

                              var household = householdModel;
                              household ??= HouseholdModel(
                                tenantId: envConfig.variables.tenantId,
                                clientReferenceId: IdGen.i.identifier,
                                rowVersion: 1,
                                clientAuditDetails: ClientAuditDetails(
                                  createdBy: context.loggedInUserUuid,
                                  createdTime: context.millisecondsSinceEpoch(),
                                  lastModifiedBy: context.loggedInUserUuid,
                                  lastModifiedTime:
                                      context.millisecondsSinceEpoch(),
                                ),
                                auditDetails: AuditDetails(
                                  createdBy: context.loggedInUserUuid,
                                  createdTime: context.millisecondsSinceEpoch(),
                                  lastModifiedBy: context.loggedInUserUuid,
                                  lastModifiedTime:
                                      context.millisecondsSinceEpoch(),
                                ),
                                address: address,
                                latitude: locationState.latitude,
                                longitude: locationState.longitude,
                                additionalFields: HouseholdAdditionalFields(
                                  version: 1,
                                  fields: [
                                    // AdditionalField(
                                    //     Constants.isConsentKey, isConsent),
                                    if (cycleIndex.isNotEmpty)
                                      AdditionalField(
                                        'cycleIndex',
                                        cycleIndex,
                                      ),
                                    if (projectTypeId!.isNotEmpty)
                                      AdditionalField(
                                        'projectTypeId',
                                        projectTypeId,
                                      ),
                                    AdditionalField(
                                      'projectId',
                                      context.projectId,
                                    ),
                                  ],
                                ),
                              );

                              household = household.copyWith(
                                memberCount: 0,
                              );

                              bloc.add(
                                BeneficiaryRegistrationSaveHouseholdConsentEvent(
                                  household: household,
                                  isConsent: isConsent,
                                ),
                              );
                              // clear search on consent being no
                              final searchBloc =
                                  context.read<SearchHouseholdsBloc>();
                              searchBloc.add(
                                const SearchHouseholdsClearEvent(),
                              );
                              context.router
                                  .push(ConsentHouseholdAcknowledgementRoute());
                            } else {
                              context.router.push(HouseHoldDetailsRoute());
                            }
                          },
                          editHousehold: (
                            addressModel,
                            householdModel,
                            individuals,
                            registrationDate,
                            loading,
                          ) {
                            (router.parent() as StackRouter).pop();
                          },
                        );
                      },
                      child: Center(
                        child: Text(
                          registrationState.mapOrNull(
                                editHousehold: (value) => localizations
                                    .translate(i18.common.coreCommonSave),
                              ) ??
                              localizations
                                  .translate(i18.householdDetails.actionLabel),
                        ),
                      ),
                    );
                  },
                ),
              ),
              children: [
                DigitCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.translate(
                          i18.householdDetails.householdConsentLabel,
                        ),
                        style: theme.textTheme.displayMedium,
                      ),
                      DigitRadioButtonList<KeyValue>(
                        labelText: localizations
                            .translate(i18.householdDetails.cardAztTitle),
                        labelStyle: DigitTheme
                            .instance.mobileTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        isRequired: true,
                        errorMessage: localizations.translate(
                          i18.householdDetails.validationForSelection,
                        ),
                        formControlName: _consent,
                        options: [
                          KeyValue(i18.householdDetails.submitYes, 1),
                          KeyValue(i18.householdDetails.submitNo, 0),
                        ],
                        valueMapper: (value) {
                          return localizations.translate(value.label);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  FormGroup buildForm(BuildContext ctx) {
    return fb.group(<String, Object>{
      _consent: FormControl<KeyValue>(value: null),
    });
  }
}
