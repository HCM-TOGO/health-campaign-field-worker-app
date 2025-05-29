import 'dart:math';

import 'package:digit_components/widgets/digit_checkbox_tile.dart';
import 'package:digit_components/widgets/digit_dialog.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/registration_delivery.dart';
import '../../../models/entities/roles_type.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:survey_form/survey_form.dart';
import '../../../router/app_router.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/constants.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/extensions/extensions.dart';
import '../../../widgets/localized.dart';
import 'package:digit_data_model/data_model.dart';

import '../../../widgets/custom_back_navigation.dart';
import '../../../widgets/showcase/showcase_wrappers.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:digit_components/widgets/atoms/checkbox_icon.dart';

@RoutePage()
class VaccineSelectionPage extends LocalizedStatefulWidget {
  const VaccineSelectionPage(
      {super.key, super.appLocalizations});

  @override
  State<VaccineSelectionPage> createState() => _VaccineSelectionPageState();
}

class _VaccineSelectionPageState extends LocalizedState<VaccineSelectionPage> {
  String isStateChanged = '';
  var submitTriggered = false;
  List<TextEditingController> controller = [];
  List<TextEditingController> additionalController = [];
  List<AttributesModel>? initialAttributes;
  ServiceDefinitionModel? selectedServiceDefinition;
  bool isControllersInitialized = false;
  List<int> visibleChecklistIndexes = [];
  GlobalKey<FormState> checklistFormKey = GlobalKey<FormState>();
  Map<String?, String> responses = {};
  bool triggerLocalization = false;

  @override
  void initState() {
    context.read<LocationBloc>().add(const LocationEvent.load());
    context.read<ServiceBloc>().add(ServiceSurveyFormEvent(
          value: Random().nextInt(100).toString(),
          submitTriggered: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dob =
        context.read<HouseholdOverviewBloc>().state.selectedIndividual?.dateOfBirth;
    final theme = Theme.of(context);
    // final years = DigitDateUtils.getYears
    final ageInDays = calculateAgeInDaysFromDob(dob!);
    final deliverState = context.read<DeliverInterventionBloc>().state;
    const Map<String, int> vaccineAgeMap = {
      'BCG': 1,
      'VPO-0': 1,
      'Penta-1': 45,
      'VPO-1': 45,
      'Rota-1': 45,
      'PCV13-1': 45,
      'VPO-2': 75,
      'Penta-2': 75,
      'Rota-2': 75,
      'PCV13-2': 75,
      'VPO-3': 105,
      'Penta-3': 105,
      'PCV13-3': 105,
      'VPI-1': 270,
      'RR-1': 270,
      'VAA': 270,
      'VPI-2': 450,
      'RR-2': 450,
      'Men A': 450,
    };

    return PopScope(
        canPop: true,
        child: Scaffold(body: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
          return BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
            builder: (context, householdOverviewState) {
              double? latitude = locationState.latitude;
              double? longitude = locationState.longitude;
              String vaccineSelection = "VACCINE_SELECTION";
              return BlocBuilder<ServiceDefinitionBloc, ServiceDefinitionState>(
                builder: (context, state) {
                  state.mapOrNull(
                    serviceDefinitionFetch: (value) {
                      // todo: verify the checklist name
                      selectedServiceDefinition = value.serviceDefinitionList
                          .where((element) => element.code.toString().contains(
                                '${context.selectedProject.name}.$vaccineSelection.${context.isCommunityDistributor ? RolesType.communityDistributor.toValue() : RolesType.healthFacilitySupervisor.toValue()}',
                              ))
                          .toList()
                          .firstOrNull;
                      initialAttributes = selectedServiceDefinition?.attributes;
                      if (!isControllersInitialized) {
                        initialAttributes?.forEach((e) {
                          controller.add(TextEditingController());
                        });

                        // Set the flag to true after initializing controllers
                        isControllersInitialized = true;
                      }
                    },
                  );

                  return state.maybeMap(
                    orElse: () => Text(state.runtimeType.toString()),
                    serviceDefinitionFetch: (value) {
                      return ScrollableContent(
                        header: const Column(children: [
                          CustomBackNavigationHelpHeaderWidget(
                            showHelp: false,
                          )
                        ]),
                        enableFixedDigitButton: true,
                        footer: DigitCard(
                          margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                          padding: const EdgeInsets.fromLTRB(
                              kPadding, 0, kPadding, 0),
                          children: [
                            DigitElevatedButton(
                              onPressed: () async {
                                submitTriggered = true;
                                final isValid =
                                    checklistFormKey.currentState?.validate();
                                if (!isValid!) {
                                  return;
                                }
                                final itemsAttributes = initialAttributes;
                                triggerLocalization = true;
                                // final router = context.router;

                                final shouldSubmit = await DigitDialog.show(
                                  context,
                                  options: DigitDialogOptions(
                                    titleText: localizations.translate(
                                      i18.deliverIntervention.dialogTitle,
                                    ),
                                    contentText: localizations.translate(
                                      i18.deliverIntervention.dialogContent,
                                    ),
                                    primaryAction: DigitDialogActions(
                                      label: localizations.translate(
                                        i18.common.coreCommonSubmit,
                                      ),
                                      action: (ctx) {
                                        final referenceId = IdGen.i.identifier;
                                        List<ServiceAttributesModel>
                                            attributes = [];
                                        for (int i = 0;
                                            i < controller.length;
                                            i++) {
                                          final attribute = initialAttributes;

                                          attributes.add(ServiceAttributesModel(
                                            auditDetails: AuditDetails(
                                              createdBy:
                                                  context.loggedInUserUuid,
                                              createdTime: context
                                                  .millisecondsSinceEpoch(),
                                            ),
                                            attributeCode:
                                                '${attribute?[i].code}',
                                            dataType: attribute?[i].dataType,
                                            clientReferenceId:
                                                IdGen.i.identifier,
                                            referenceId: referenceId,
                                            value: attribute?[i].dataType !=
                                                    'SingleValueList'
                                                ? controller[i]
                                                        .text
                                                        .toString()
                                                        .trim()
                                                        .isNotEmpty
                                                    ? controller[i]
                                                        .text
                                                        .toString()
                                                    : ''
                                                : visibleChecklistIndexes
                                                        .contains(i)
                                                    ? controller[i]
                                                        .text
                                                        .toString()
                                                    : i18.checklist
                                                        .notSelectedKey,
                                            rowVersion: 1,
                                            tenantId: attribute?[i].tenantId,
                                            additionalFields:
                                                ServiceAttributesAdditionalFields(
                                              version: 1,
                                              // TODO: This needs to be done after adding locationbloc
                                              fields: [
                                                AdditionalField(
                                                  'latitude',
                                                  latitude,
                                                ),
                                                AdditionalField(
                                                  'longitude',
                                                  longitude,
                                                ),
                                              ],
                                            ),
                                          ));
                                        }

                                        context.read<ServiceBloc>().add(
                                              ServiceCreateEvent(
                                                serviceModel: ServiceModel(
                                                  createdAt: DigitDateUtils
                                                      .getDateFromTimestamp(
                                                    DateTime.now()
                                                        .toLocal()
                                                        .millisecondsSinceEpoch,
                                                    dateFormat: Constants
                                                        .checklistViewDateFormat,
                                                  ),
                                                  tenantId:
                                                      selectedServiceDefinition!
                                                          .tenantId,
                                                  clientId: referenceId,
                                                  serviceDefId:
                                                      selectedServiceDefinition
                                                          ?.id,
                                                  attributes: attributes,
                                                  rowVersion: 1,
                                                  accountId: context.projectId,
                                                  auditDetails: AuditDetails(
                                                    createdBy: context
                                                        .loggedInUserUuid,
                                                    createdTime: DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                  ),
                                                  clientAuditDetails:
                                                      ClientAuditDetails(
                                                    createdBy: context
                                                        .loggedInUserUuid,
                                                    createdTime: context
                                                        .millisecondsSinceEpoch(),
                                                    lastModifiedBy: context
                                                        .loggedInUserUuid,
                                                    lastModifiedTime: context
                                                        .millisecondsSinceEpoch(),
                                                  ),
                                                  additionalDetails: {
                                                    "boundaryCode":
                                                        context.boundary.code
                                                  },
                                                ),
                                              ),
                                            );

                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop(true);
                                      },
                                    ),
                                    secondaryAction: DigitDialogActions(
                                      label: localizations.translate(
                                        i18.common.coreCommonGoback,
                                      ),
                                      action: (ctx) {
                                        Navigator.of(ctx, rootNavigator: true)
                                            .pop(false);
                                      },
                                    ),
                                  ),
                                );
                                if (shouldSubmit ?? false) {
                                  final router = context.router;
                                  submitTriggered = true;

                                  context.read<ServiceBloc>().add(
                                        const ServiceSurveyFormEvent(
                                          value: '',
                                          submitTriggered: true,
                                        ),
                                      );
                                  context.router.push(
                                      CustomDoseAdministeredRoute(
                                          eligibilityAssessmentType:
                                              EligibilityAssessmentType.smc));
                                }
                              },
                              child: Text(
                                localizations
                                    .translate(i18.common.coreCommonSubmit),
                              ),
                            )
                          ],
                        ),
                        children: [
                          Form(
                            key: checklistFormKey, //assigning key to form
                            child: DigitCard(
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Vaccins Details", style: theme.textTheme.headlineLarge,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          localizations.translate(
                                            selectedServiceDefinition!.code
                                                .toString(),
                                          ),
                                          style: theme.textTheme.displayMedium,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      ...initialAttributes!.map((
                                        e,
                                      ) {
                                        int index = (initialAttributes ?? [])
                                            .indexOf(e);

                                        return Column(children: [
                                          if (e.dataType == 'MultiValueList' &&
                                              !(e.code ?? '')
                                                  .contains('.')) ...[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${localizations.translate(
                                                        '${selectedServiceDefinition?.code}.${e.code}',
                                                      )} ${e.required == true ? '*' : ''}',
                                                      style: theme.textTheme
                                                          .headlineSmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            BlocBuilder<ServiceBloc,
                                                ServiceState>(
                                              builder: (context, state) {
                                                return Column(
                                                  children: e.values!
                                                      .map((e) =>
                                                          CustomDigitCheckboxTile(
                                                            label: e,
                                                            isDisabled: vaccineAgeMap[e]! <= ageInDays,
                                                            value: controller[
                                                                    index]
                                                                .text
                                                                .split('.')
                                                                .contains(e),
                                                            onChanged: (value) {
                                                              final String ele;
                                                              var val =
                                                                  controller[
                                                                          index]
                                                                      .text
                                                                      .split(
                                                                          '.');
                                                              if (val.contains(
                                                                  e)) {
                                                                val.remove(e);
                                                                ele = val
                                                                    .join(".");
                                                              } else {
                                                                ele =
                                                                    "${controller[index].text}.$e";
                                                              }
                                                              controller[index]
                                                                      .value =
                                                                  TextEditingController
                                                                      .fromValue(
                                                                TextEditingValue(
                                                                  text: ele,
                                                                ),
                                                              ).value;
                                                            },
                                                          ))
                                                      .toList(),
                                                );
                                              },
                                            ),
                                          ]
                                        ]);
                                      }).toList(),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ])
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        })));
  }
}


class CustomDigitCheckboxTile extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool isDisabled; // 1. Add parameter

  const CustomDigitCheckboxTile({
    this.value = false,
    required this.label,
    this.onChanged,
    this.padding,
    this.margin,
    this.isDisabled = false, // 2. Add to constructor
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: InkWell(
        onTap: isDisabled ? null : () => onChanged?.call(!value), // 3. Disable tap
        child: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: kPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              value
                  ? const CheckboxIcon(
                      value: true,// 3. Disabled color
                    )
                  : const CheckboxIcon(
                    ),
              const SizedBox(width: kPadding * 2),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDisabled
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int calculateAgeInDaysFromDob(String dobString) {
  final dob = DigitDateUtils.getFormattedDateToDateTime(dobString);
  if (dob == null) return 0;
  final now = DateTime.now();
  return now.difference(dob).inDays;
}
