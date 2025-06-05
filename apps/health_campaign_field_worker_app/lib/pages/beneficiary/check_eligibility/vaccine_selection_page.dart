// import 'dart:math';

import 'dart:ffi';
import 'dart:math';

import 'package:digit_components/widgets/digit_checkbox_tile.dart';
import 'package:digit_components/widgets/digit_dialog.dart';
import 'package:digit_components/widgets/digit_elevated_button.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/blocs/app_initialization/app_initialization.dart';
import 'package:health_campaign_field_worker_app/data/local_store/no_sql/schema/app_configuration.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import '../../../models/entities/roles_type.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:survey_form/survey_form.dart';
import '../../../router/app_router.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/constants.dart';
import '../../../utils/date_utils.dart';
import '../../../utils/environment_config.dart';
import '../../../utils/extensions/extensions.dart';
import '../../../widgets/localized.dart';
import 'package:digit_data_model/data_model.dart';

import '../../../models/entities/additional_fields_type.dart'
    as additional_fields_local;
import '../../../models/entities/assessment_checklist/status.dart'
    as status_local;
import '../../../widgets/custom_back_navigation.dart';
import '../../../widgets/showcase/showcase_wrappers.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import '../../../utils/i18_key_constants.dart' as i18_local;
import 'package:digit_components/widgets/atoms/checkbox_icon.dart';
import 'package:survey_form/utils/i18_key_constants.dart' as i18_survey_form;

@RoutePage()
class VaccineSelectionPage extends LocalizedStatefulWidget {
  final bool isAdministration;
  final EligibilityAssessmentType eligibilityAssessmentType;
  final bool isChecklistAssessmentDone;
  final String? projectBeneficiaryClientReferenceId;
  final IndividualModel? individual;
  final TaskModel task;
  const VaccineSelectionPage({
    super.key,
    super.appLocalizations,
    required this.isAdministration,
    required this.eligibilityAssessmentType,
    required this.isChecklistAssessmentDone,
    this.projectBeneficiaryClientReferenceId,
    this.individual,
    required this.task,
  });

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
  List<Set<String>> selectedVaccines = [];

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
    final dob = context
        .read<HouseholdOverviewBloc>()
        .state
        .selectedIndividual
        ?.dateOfBirth;
    final theme = Theme.of(context);

    // final relatedClientRefId =  context
    //     .read<HouseholdOverviewBloc>()
    //     .state
    //     .selectedIndividual
    //     ?.clientReferenceId;
    // final years = DigitDateUtils.getYears
    final ageInDays = calculateAgeInDaysFromDob(dob!);

    return BlocBuilder<AppInitializationBloc, AppInitializationState>(
        builder: (context, appInitState) {
      List<VaccineData> vaccineDataList = [];
      if (appInitState is AppInitialized) {
        vaccineDataList = appInitState.appConfiguration.vaccinationData ?? [];
      }

      final Map<String, int> vaccineAgeMap = {
        for (final v in vaccineDataList) v.code: v.ageInDays
      };

      final Map<String, String> vaccineCodeToName = {
        for (final v in vaccineDataList) v.code: v.name
      };
      return PopScope(
          canPop: true,
          child: Scaffold(body: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locationState) {
            return BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
              builder: (context, householdOverviewState) {
                double? latitude = locationState.latitude;
                double? longitude = locationState.longitude;
                String vaccineSelection = "ZERO_DOSE_ASSESSMENT";
                return BlocBuilder<ServiceDefinitionBloc,
                    ServiceDefinitionState>(
                  builder: (context, state) {
                    state.mapOrNull(
                      serviceDefinitionFetch: (value) {
                        // todo: verify the checklist name
                        selectedServiceDefinition = value.serviceDefinitionList
                            .where(
                                (element) => element.code.toString().contains(
                                      '${context.selectedProject.name}.$vaccineSelection.${context.isCommunityDistributor ? RolesType.communityDistributor.toValue() : RolesType.healthFacilitySupervisor.toValue()}',
                                    ))
                            .toList()
                            .firstOrNull;
                        initialAttributes =
                            selectedServiceDefinition?.attributes!;
                        //     .where((e) =>
                        //         e.code != null &&
                        //         e.dataType == 'MultiValueList')
                        //     .toList();
                        if (!isControllersInitialized) {
                          initialAttributes?.forEach((e) {
                            controller.add(TextEditingController());
                            selectedVaccines.add({});
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
                              showHelp: true,
                            )
                          ]),
                          enableFixedDigitButton: true,
                          footer: DigitCard(
                            margin:
                                const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
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
                                          final referenceId =
                                              IdGen.i.identifier;
                                          List<ServiceAttributesModel>
                                              attributes = [];
                                          for (int i = 0;
                                              i < controller.length;
                                              i++) {
                                            final attribute = initialAttributes;

                                            attributes
                                                .add(ServiceAttributesModel(
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
                                              value: attribute?[i].dataType ==
                                                      'MultiValueList'
                                                  ? controller[i]
                                                          .text
                                                          .toString()
                                                          .isNotEmpty
                                                      ? controller[i]
                                                          .text
                                                          .toString()
                                                      : i18_survey_form
                                                          .surveyForm
                                                          .notSelectedKey
                                                  : attribute?[i].dataType !=
                                                          'SingleValueList'
                                                      ? controller[i]
                                                              .text
                                                              .toString()
                                                              .trim()
                                                              .isNotEmpty
                                                          ? controller[i]
                                                              .text
                                                              .toString()
                                                          : (attribute?[i]
                                                                      .dataType !=
                                                                  'Number'
                                                              ? i18_survey_form
                                                                  .surveyForm
                                                                  .notSelectedKey
                                                              : '0')
                                                      : visibleChecklistIndexes
                                                              .contains(i)
                                                          ? controller[i]
                                                              .text
                                                              .toString()
                                                          : i18_survey_form
                                                              .surveyForm
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
                                                    accountId:
                                                        context.projectId,
                                                    auditDetails: AuditDetails(
                                                      createdBy: context
                                                          .loggedInUserUuid,
                                                      createdTime: DateTime
                                                              .now()
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

                                    if (widget.isChecklistAssessmentDone ==
                                        true) {
                                      final householdMember = context
                                          .read<HouseholdOverviewBloc>()
                                          .state
                                          .householdMemberWrapper;
                                      final deliverState = context
                                          .read<DeliverInterventionBloc>()
                                          .state;

                                      final oldTask =
                                          deliverState.oldTask ?? widget.task;
                                      final oldFields =
                                          oldTask.additionalFields?.fields ??
                                              [];

                                      final updatedFields = [
                                        ...oldFields,
                                        AdditionalField(
                                          'zeroDoseStatus',
                                          ZeroDoseStatus.done.name,
                                        ),
                                      ];

                                      final updatedTask = oldTask.copyWith(
                                        additionalFields: TaskAdditionalFields(
                                          version: 1,
                                          fields: updatedFields,
                                        ),
                                      );

                                      context
                                          .read<DeliverInterventionBloc>()
                                          .add(
                                            DeliverInterventionSubmitEvent(
                                              task: updatedTask,
                                              isEditing: (deliverState.tasks ??
                                                          [])
                                                      .isNotEmpty &&
                                                  RegistrationDeliverySingleton()
                                                          .beneficiaryType ==
                                                      BeneficiaryType.household,
                                              boundaryModel:
                                                  RegistrationDeliverySingleton()
                                                      .boundary!,
                                            ),
                                          );

                                      ProjectTypeModel? projectTypeModel =
                                          widget.eligibilityAssessmentType ==
                                                  EligibilityAssessmentType.smc
                                              ? RegistrationDeliverySingleton()
                                                  .selectedProject
                                                  ?.additionalDetails
                                                  ?.projectType
                                              : RegistrationDeliverySingleton()
                                                  .selectedProject
                                                  ?.additionalDetails
                                                  ?.additionalProjectType;

                                      if (deliverState.futureDeliveries !=
                                              null &&
                                          deliverState
                                              .futureDeliveries!.isNotEmpty &&
                                          projectTypeModel
                                                  ?.cycles?.isNotEmpty ==
                                              true) {
                                        router.popUntilRouteWithName(
                                            BeneficiaryWrapperRoute.name);
                                        if (widget.isAdministration == true) {
                                          router.push(
                                            CustomSplashAcknowledgementRoute(
                                                enableBackToSearch: false,
                                                eligibilityAssessmentType: widget
                                                    .eligibilityAssessmentType),
                                          );
                                        } else {
                                          router.push(
                                            CustomHouseholdAcknowledgementRoute(
                                                enableViewHousehold: true,
                                                eligibilityAssessmentType: widget
                                                    .eligibilityAssessmentType),
                                          );
                                        }
                                      } else {
                                        final reloadState = context
                                            .read<HouseholdOverviewBloc>();

                                        reloadState.add(
                                          HouseholdOverviewReloadEvent(
                                            projectId:
                                                RegistrationDeliverySingleton()
                                                    .projectId!,
                                            projectBeneficiaryType:
                                                RegistrationDeliverySingleton()
                                                    .beneficiaryType!,
                                          ),
                                        );
                                        router.popAndPush(
                                          CustomHouseholdAcknowledgementRoute(
                                            enableViewHousehold: true,
                                            eligibilityAssessmentType: widget
                                                .eligibilityAssessmentType,
                                          ),
                                        );
                                      }
                                    } else {
                                      final clientReferenceId =
                                          IdGen.i.identifier;
                                      List<String?> ineligibilityReasons = [];
                                      ineligibilityReasons
                                          .add("CHILD_AGE_LESS_THAN_3_MONTHS");
                                      context
                                          .read<DeliverInterventionBloc>()
                                          .add(
                                            DeliverInterventionSubmitEvent(
                                              task: TaskModel(
                                                projectBeneficiaryClientReferenceId:
                                                    widget
                                                        .projectBeneficiaryClientReferenceId,
                                                clientReferenceId:
                                                    clientReferenceId,
                                                tenantId: envConfig
                                                    .variables.tenantId,
                                                rowVersion: 1,
                                                auditDetails: AuditDetails(
                                                  createdBy:
                                                      context.loggedInUserUuid,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                                projectId: context.projectId,
                                                status: status_local.Status
                                                    .beneficiaryInEligible
                                                    .toValue(),
                                                clientAuditDetails:
                                                    ClientAuditDetails(
                                                  createdBy:
                                                      context.loggedInUserUuid,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                  lastModifiedBy:
                                                      context.loggedInUserUuid,
                                                  lastModifiedTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                                additionalFields:
                                                    TaskAdditionalFields(
                                                  version: 1,
                                                  fields: [
                                                    // AdditionalField(
                                                    //   'taskStatus',
                                                    //   status_local.Status
                                                    //       .beneficiaryInEligible
                                                    //       .toValue(),
                                                    // ),
                                                    AdditionalField(
                                                      'ineligibleReasons',
                                                      ineligibilityReasons
                                                          .join(","),
                                                    ),
                                                    AdditionalField(
                                                      additional_fields_local
                                                          .AdditionalFieldsType
                                                          .deliveryType
                                                          .toValue(),
                                                      EligibilityAssessmentStatus
                                                          .smcDone.name,
                                                    ),
                                                    AdditionalField(
                                                      'zeroDoseStatus',
                                                      ZeroDoseStatus.done.name,
                                                    ),
                                                    AdditionalField(
                                                        'ageBelow3Months',
                                                        true.toString()),
                                                  ],
                                                ),
                                                address: widget
                                                    .individual?.address?.first
                                                    .copyWith(
                                                  relatedClientReferenceId:
                                                      clientReferenceId,
                                                  id: null,
                                                ),
                                              ),
                                              isEditing: false,
                                              boundaryModel: context.boundary,
                                              navigateToSummary: false,
                                              householdMemberWrapper: context
                                                  .read<HouseholdOverviewBloc>()
                                                  .state
                                                  .householdMemberWrapper,
                                            ),
                                          );
                                      final searchBloc =
                                          context.read<SearchHouseholdsBloc>();
                                      searchBloc.add(
                                        const SearchHouseholdsClearEvent(),
                                      );
                                      if (widget.isAdministration == true) {
                                        router.push(
                                          CustomSplashAcknowledgementRoute(
                                              enableBackToSearch: false,
                                              eligibilityAssessmentType: widget
                                                  .eligibilityAssessmentType),
                                        );
                                      } else {
                                        router.push(
                                          CustomHouseholdAcknowledgementRoute(
                                              enableViewHousehold: true,
                                              eligibilityAssessmentType: widget
                                                  .eligibilityAssessmentType),
                                        );
                                      }
                                    }
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
                                padding: const EdgeInsets.all(spacer5),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: spacer5, vertical: spacer3),
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          localizations.translate(
                                            i18_local.deliverIntervention
                                                .vaccinsSelectionLabel,
                                          ),
                                          style: theme.textTheme.headlineLarge,
                                        ),
                                        const SizedBox(height: spacer5),
                                        ...initialAttributes!.map((e) {
                                          int index = (initialAttributes ?? [])
                                              .indexOf(e);

                                          return Column(children: [
                                            if (e.dataType ==
                                                'MultiValueList') ...[
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${localizations.translate(
                                                        '${selectedServiceDefinition?.code}.${e.code}',
                                                      )} ',
                                                      style: theme.textTheme
                                                          .headlineSmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: spacer4),
                                              BlocBuilder<ServiceBloc,
                                                  ServiceState>(
                                                builder: (context, state) {
                                                  // ...inside your BlocBuilder<ServiceBloc, ServiceState>...
                                                  return buildTwoColumnCheckboxes(
                                                    values: e.values!,
                                                    index: index,
                                                    vaccineCodeToName:
                                                        vaccineCodeToName,
                                                    vaccineAgeMap:
                                                        vaccineAgeMap,
                                                    ageInDays: ageInDays,
                                                    controller:
                                                        controller[index],
                                                    onChanged: (code, value) {
                                                      setState(() {
                                                        if (value) {
                                                          selectedVaccines[
                                                                  index]
                                                              .add(code);
                                                        } else {
                                                          selectedVaccines[
                                                                  index]
                                                              .remove(code);
                                                        }
                                                        // If you still need to update the controller for submission:
                                                        controller[index].text =
                                                            selectedVaccines[
                                                                    index]
                                                                .join('.');
                                                      });
                                                    },
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
    });
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
        onTap:
            isDisabled ? null : () => onChanged?.call(!value), // 3. Disable tap
        child: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: kPadding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              value
                  ? const CheckboxIcon(
                      value: true, // 3. Disabled color
                    )
                  : const CheckboxIcon(),
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

Widget buildTwoColumnCheckboxes({
  required List<String> values,
  required int index,
  required Map<String, String> vaccineCodeToName,
  required Map<String, int> vaccineAgeMap,
  required int ageInDays,
  required TextEditingController controller,
  required void Function(String code, bool value) onChanged,
}) {
  // Filter out 'NOT_SELECTED'
  final filtered = values.where((e) => e != 'NOT_SELECTED').toList();
  final mid = (filtered.length / 2).ceil();
  final firstCol = filtered.sublist(0, mid);
  final secondCol = filtered.sublist(mid);

  Widget buildCol(List<String> col) => Column(
        children: col
            .map((code) => CustomDigitCheckboxTile(
                  label: vaccineCodeToName.containsKey(code)
                      ? vaccineCodeToName[code] ?? code
                      : code,
                  isDisabled: vaccineAgeMap.containsKey(code)
                      ? vaccineAgeMap[code]! >= ageInDays
                      : true,
                  value: controller.text.split('.').contains(code),
                  onChanged: (value) => onChanged(code, value),
                ))
            .toList(),
      );

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: buildCol(firstCol)),
      const SizedBox(width: 16),
      Expanded(child: buildCol(secondCol)),
    ],
  );
}

int calculateAgeInDaysFromDob(String dobString) {
  final dob = DigitDateUtils.getFormattedDateToDateTime(dobString);
  if (dob == null) return 0;
  final now = DateTime.now();
  return now.difference(dob).inDays;
}
