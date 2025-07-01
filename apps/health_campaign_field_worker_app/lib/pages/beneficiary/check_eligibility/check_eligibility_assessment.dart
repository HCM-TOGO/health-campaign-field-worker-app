import 'dart:math';

import 'package:digit_components/digit_components.dart';
import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_components/widgets/digit_sync_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:health_campaign_field_worker_app/widgets/custom_back_navigation.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:intl/intl.dart';
import 'package:registration_delivery/models/entities/status.dart';
import 'package:survey_form/survey_form.dart';
import 'package:registration_delivery/blocs/delivery_intervention/deliver_intervention.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';
import 'package:digit_data_model/data_model.dart';
// import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/models/entities/task.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
// import '../../../blocs/service/service.dart' as service;
import '../../../models/entities/additional_fields_type.dart';
import '../../../models/entities/roles_type.dart';
import '../../../router/app_router.dart';
import '../../../utils/app_enums.dart';
import '../../../utils/environment_config.dart';
import '../../../utils/i18_key_constants.dart' as i18_local;
import '../../../utils/utils.dart';
import '../../../widgets/header/back_navigation_help_header.dart';
import '../../../widgets/localized.dart';
import '../../../models/entities/assessment_checklist/status.dart'
    as status_local;
import 'package:digit_ui_components/services/location_bloc.dart' as location;
import '../../../models/entities/additional_fields_type.dart'
    as additional_fields_local;

@RoutePage()
class EligibilityChecklistViewPage extends LocalizedStatefulWidget {
  final String? referralClientRefId;
  final IndividualModel? individual;
  final String? projectBeneficiaryClientReferenceId;
  final EligibilityAssessmentType eligibilityAssessmentType;

  const EligibilityChecklistViewPage({
    super.key,
    this.referralClientRefId,
    this.individual,
    this.projectBeneficiaryClientReferenceId,
    required this.eligibilityAssessmentType,
    super.appLocalizations,
  });

  @override
  State<EligibilityChecklistViewPage> createState() =>
      _EligibilityChecklistViewPage();
}

class _EligibilityChecklistViewPage
    extends LocalizedState<EligibilityChecklistViewPage> {
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
  final String yes = "YES";
  final String positive = "POSITIVE";
  final String no = "NO";
  final String negative = "NEGATIVE";
  final String test_unavailable = "TEST_UNAVAILABLE";
  bool triggerLocalization = false;

  @override
  void initState() {
    context
        .read<location.LocationBloc>()
        .add(const location.LocationEvent.load());
    context.read<ServiceBloc>().add(ServiceSurveyFormEvent(
          value: Random().nextInt(100).toString(),
          submitTriggered: true,
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var ifReferral = false;
    var ifDeliver = false;
    var ifIneligible = false;
    var ifAdministration = false;

    bool isHealthFacilityWorker = context.loggedInUserRoles
        .where((role) => role.code == RolesType.healthFacilityWorker.toValue())
        .toList()
        .isNotEmpty;

    var projectBeneficiaryClientReferenceId =
        widget.projectBeneficiaryClientReferenceId;

    return WillPopScope(
        onWillPop: context.isHealthFacilitySupervisor &&
                widget.referralClientRefId != null
            ? () async => false
            : () async => _onBackPressed(context, ifIneligible),
        child: Scaffold(body:
            BlocBuilder<location.LocationBloc, location.LocationState>(
                builder: (context, locationState) {
          return BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
            builder: (context, householdOverviewState) {
              double? latitude = locationState.latitude;
              double? longitude = locationState.longitude;
              String eligibilityAssessment = widget.eligibilityAssessmentType ==
                      EligibilityAssessmentType.smc
                  ? "ELIGIBLITY_ASSESSMENT"
                  : "ELIGIBLITY_ASSESSMENT_2";
              return BlocBuilder<ServiceDefinitionBloc, ServiceDefinitionState>(
                builder: (context, state) {
                  state.mapOrNull(
                    serviceDefinitionFetch: (value) {
                      // todo: verify the checklist name
                      selectedServiceDefinition = value.serviceDefinitionList
                          .where((element) => element.code.toString().contains(
                                '${context.selectedProject.name}.$eligibilityAssessment.${context.isCommunityDistributor ? RolesType.communityDistributor.toValue() : RolesType.healthFacilitySupervisor.toValue()}',
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
                        header: Column(children: [
                          if (!(context.isHealthFacilitySupervisor &&
                              widget.referralClientRefId != null))
                            const CustomBackNavigationHelpHeaderWidget(
                              showHelp: false,
                            ),
                        ]),
                        enableFixedButton: true,
                        footer: DigitCard(
                          margin: const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                          padding: const EdgeInsets.fromLTRB(
                              kPadding, 0, kPadding, 0),
                          child: DigitElevatedButton(
                            onPressed: () async {
                              submitTriggered = true;
                              final isValid =
                                  checklistFormKey.currentState?.validate();
                              if (!isValid!) {
                                return;
                              }
                              final itemsAttributes = initialAttributes;
                              if (itemsAttributes != null) {
                                for (int i = 0;
                                    i < itemsAttributes.length;
                                    i++) {
                                  if (itemsAttributes[i].required == true &&
                                      ((itemsAttributes[i].dataType ==
                                                  'SingleValueList' &&
                                              visibleChecklistIndexes
                                                  .any((e) => e == i) &&
                                              (controller[i].text == '')) ||
                                          (itemsAttributes[i].dataType !=
                                                  'SingleValueList' &&
                                              visibleChecklistIndexes
                                                  .any((e) => e == i) &&
                                              (controller[i].text == '')))) {
                                    return;
                                  }
                                }
                              }

                              for (int i = 0; i < controller.length; i++) {
                                initialAttributes;
                                var attributeCode =
                                    '${initialAttributes?[i].code}';
                                var value = initialAttributes?[i].dataType !=
                                        'SingleValueList'
                                    ? controller[i]
                                            .text
                                            .toString()
                                            .trim()
                                            .isNotEmpty
                                        ? controller[i].text.toString()
                                        : (initialAttributes?[i].dataType !=
                                                'Number'
                                            ? ''
                                            : '0')
                                    : visibleChecklistIndexes.contains(i)
                                        ? controller[i].text.toString()
                                        : i18_local.checklist.notSelectedKey;
                                responses[attributeCode] = value;
                              }
                              triggerLocalization = true;
                              // final router = context.router;

                              List<String>? referralReasons = [];
                              List<String?> ineligibilityReasons = [];
                              List<bool> checkIfIneligibleFlow = [];

                              ifReferral = widget.eligibilityAssessmentType ==
                                      EligibilityAssessmentType.smc
                                  ? isReferral(responses, referralReasons)
                                  : isVASReferral(responses, referralReasons);
                              ifDeliver = isDelivery(responses);
                              checkIfIneligibleFlow = isIneligible(
                                responses,
                                ineligibilityReasons,
                                ifAdministration,
                              );
                              if (checkIfIneligibleFlow.isNotEmpty &&
                                  checkIfIneligibleFlow.length >= 2) {
                                ifIneligible = checkIfIneligibleFlow[0];
                                ifAdministration = checkIfIneligibleFlow[1];
                              }

                              var descriptionText = ifIneligible
                                  ? localizations.translate(
                                      i18_local.deliverIntervention
                                          .beneficiaryIneligibleDescription,
                                    )
                                  : ifReferral
                                      ? localizations.translate(
                                          i18_local.deliverIntervention
                                              .beneficiaryReferralDescription,
                                        )
                                      : localizations.translate(
                                          i18_local.deliverIntervention
                                              .spaqRedirectionScreenDescription,
                                        );

                              final shouldSubmit = await DigitDialog.show(
                                context,
                                options: DigitDialogOptions(
                                  titleText: (widget
                                                  .eligibilityAssessmentType ==
                                              EligibilityAssessmentType.smc ||
                                          ifIneligible ||
                                          ifReferral)
                                      ? localizations.translate(
                                          i18_local.checklist
                                              .submitButtonDialogLabelText,
                                        )
                                      : localizations.translate(
                                          i18_local.deliverIntervention
                                              .proceedToVASLabel,
                                        ),
                                  content: widget.eligibilityAssessmentType ==
                                          EligibilityAssessmentType.smc
                                      ? Text(localizations
                                          .translate(
                                            i18_local.checklist
                                                .checklistDialogDynamicDescription,
                                          )
                                          .replaceFirst('{}', descriptionText))
                                      : (ifReferral || ifIneligible)
                                          ? getHighlightedText(localizations
                                              .translate(
                                                i18_local.checklist
                                                    .checklistDialogDynamicDescription,
                                              )
                                              .replaceFirst(
                                                  '{}', descriptionText))
                                          : getHighlightedText(
                                              localizations.translate(
                                                i18_local.deliverIntervention
                                                    .proceedToVASDescription,
                                              ),
                                            ),
                                  primaryAction: DigitDialogActions(
                                    label: widget.eligibilityAssessmentType ==
                                            EligibilityAssessmentType.smc
                                        ? localizations.translate(
                                            i18_local.checklist
                                                .checklistDialogPrimaryAction,
                                          )
                                        : localizations.translate(
                                            i18_local.common.coreCommonProceed,
                                          ),
                                    action: (ctx) {
                                      final referenceId = IdGen.i.identifier;
                                      List<ServiceAttributesModel> attributes =
                                          [];
                                      for (int i = 0;
                                          i < controller.length;
                                          i++) {
                                        final attribute = initialAttributes;

                                        attributes.add(ServiceAttributesModel(
                                          auditDetails: AuditDetails(
                                            createdBy: context.loggedInUserUuid,
                                            createdTime: context
                                                .millisecondsSinceEpoch(),
                                          ),
                                          attributeCode:
                                              '${attribute?[i].code}',
                                          dataType: attribute?[i].dataType,
                                          clientReferenceId: IdGen.i.identifier,
                                          referenceId: isHealthFacilityWorker &&
                                                  widget.referralClientRefId !=
                                                      null
                                              ? widget.referralClientRefId
                                              : referenceId,
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
                                                  : i18_local
                                                      .checklist.notSelectedKey,
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
                                                  clientId: isHealthFacilityWorker &&
                                                          widget.referralClientRefId !=
                                                              null
                                                      ? widget
                                                          .referralClientRefId
                                                          .toString()
                                                      : referenceId,
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
                                                  // additionalDetails: {
                                                  //   "boundaryCode":
                                                  //       context.boundary.code
                                                  // },
                                                  additionalFields:
                                                      ServiceAdditionalFields(
                                                    version: 1,
                                                    fields: [
                                                      AdditionalField(
                                                          'boundaryCode',
                                                          context
                                                              .boundary.code),
                                                    ],
                                                  )),
                                            ),
                                          );

                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop(true);
                                    },
                                  ),
                                  secondaryAction:
                                      widget.eligibilityAssessmentType ==
                                              EligibilityAssessmentType.smc
                                          ? DigitDialogActions(
                                              label: localizations.translate(
                                                i18_local.checklist
                                                    .checklistDialogSecondaryAction,
                                              ),
                                              action: (context) {
                                                Navigator.of(
                                                  context,
                                                  rootNavigator: true,
                                                ).pop(false);
                                              },
                                            )
                                          : null,
                                ),
                              );
                              if (shouldSubmit ?? false) {
                                if (context.mounted &&
                                    ((ifDeliver || ifAdministration) ||
                                        ifIneligible ||
                                        ifReferral)) {
                                  final router = context.router;
                                  if (ifIneligible) {
                                    // added the deliversubmitevent here
                                    final clientReferenceId =
                                        IdGen.i.identifier;
                                    final task = TaskModel(
                                      projectBeneficiaryClientReferenceId:
                                          projectBeneficiaryClientReferenceId,
                                      clientReferenceId: clientReferenceId,
                                      tenantId: envConfig.variables.tenantId,
                                      rowVersion: 1,
                                      auditDetails: AuditDetails(
                                        createdBy: context.loggedInUserUuid,
                                        createdTime:
                                            context.millisecondsSinceEpoch(),
                                      ),
                                      projectId: context.projectId,
                                      status: status_local
                                          .Status.beneficiaryInEligible
                                          .toValue(),
                                      clientAuditDetails: ClientAuditDetails(
                                        createdBy: context.loggedInUserUuid,
                                        createdTime:
                                            context.millisecondsSinceEpoch(),
                                        lastModifiedBy:
                                            context.loggedInUserUuid,
                                        lastModifiedTime:
                                            context.millisecondsSinceEpoch(),
                                      ),
                                      additionalFields: TaskAdditionalFields(
                                        version: 1,
                                        fields: [
                                          // AdditionalField(
                                          //   'taskStatus',
                                          //   status_local.Status
                                          //       .beneficiaryInEligible
                                          //       .toValue(),
                                          // ),
                                          AdditionalField(
                                            AdditionalFieldsType.cycleIndex
                                                .toValue(),
                                            "0${context.selectedCycle?.id}",
                                          ),
                                          AdditionalField(
                                            'ineligibleReasons',
                                            ineligibilityReasons.join(","),
                                          ),
                                          AdditionalField(
                                            additional_fields_local
                                                .AdditionalFieldsType
                                                .deliveryType
                                                .toValue(),
                                            (widget.eligibilityAssessmentType ==
                                                    EligibilityAssessmentType
                                                        .smc)
                                                ? EligibilityAssessmentStatus
                                                    .smcDone.name
                                                : EligibilityAssessmentStatus
                                                    .vasDone.name,
                                          ),
                                        ],
                                      ),
                                      address: widget.individual!.address?.first
                                          .copyWith(
                                        relatedClientReferenceId:
                                            clientReferenceId,
                                        id: null,
                                      ),
                                    );

                                    // TODO: Currently, it's been shifted to the zero dose flow
                                    // context.read<DeliverInterventionBloc>().add(
                                    //       DeliverInterventionSubmitEvent(
                                    //           task: task,
                                    //           isEditing: false,
                                    //           boundaryModel: context.boundary,
                                    //           navigateToSummary: false,
                                    //           householdMemberWrapper:
                                    //               householdOverviewState
                                    //                   .householdMemberWrapper),
                                    //     );
                                    // final searchBloc =
                                    //     context.read<SearchHouseholdsBloc>();
                                    // searchBloc.add(
                                    //   const SearchHouseholdsClearEvent(),
                                    // );

                                    router.push(ZeroDoseCheckRoute(
                                      eligibilityAssessmentType:
                                          widget.eligibilityAssessmentType,
                                      isAdministration: false,
                                      task: task,
                                    ));
                                    // router.push(
                                    //   CustomHouseholdAcknowledgementRoute(
                                    //       enableViewHousehold: true,
                                    //       eligibilityAssessmentType:
                                    //           widget.eligibilityAssessmentType),
                                    // );
                                  } else if (ifReferral) {
                                    if (widget.eligibilityAssessmentType ==
                                        EligibilityAssessmentType.smc) {
                                      router
                                          .push(CustomReferBeneficiarySMCRoute(
                                        projectBeneficiaryClientRefId:
                                            projectBeneficiaryClientReferenceId ??
                                                "",
                                        individual: widget.individual!,
                                        referralReasons: referralReasons,
                                      ));
                                    }
                                  } else {
                                    router.push(CustomBeneficiaryDetailsRoute(
                                        eligibilityAssessmentType:
                                            widget.eligibilityAssessmentType));
                                  }
                                }

                                final router = context.router;
                                submitTriggered = true;

                                context.read<ServiceBloc>().add(
                                      const ServiceSurveyFormEvent(
                                        value: '',
                                        submitTriggered: true,
                                      ),
                                    );
                              }
                            },
                            child: Text(
                              localizations
                                  .translate(i18_local.common.coreCommonSubmit),
                            ),
                          ),
                        ),
                        children: [
                          Form(
                            key: checklistFormKey, //assigning key to form
                            child: DigitCard(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                      int index =
                                          (initialAttributes ?? []).indexOf(e);

                                      return Column(children: [
                                        if (e.dataType == 'String' &&
                                            !(e.code ?? '').contains('.')) ...[
                                          DigitTextField(
                                            autoValidation: AutovalidateMode
                                                .onUserInteraction,
                                            isRequired: true,
                                            controller: controller[index],
                                            // inputFormatter: [
                                            //   FilteringTextInputFormatter.allow(RegExp(
                                            //     "[a-zA-Z0-9]",
                                            //   )),
                                            // ],
                                            validator: (value) {
                                              if (((value == null ||
                                                      value == '') &&
                                                  e.required == true)) {
                                                return localizations.translate(
                                                  i18_local.common
                                                      .corecommonRequired,
                                                );
                                              }
                                              if (e.regex != null) {
                                                return (RegExp(e.regex!)
                                                        .hasMatch(value!))
                                                    ? null
                                                    : localizations.translate(
                                                        "${e.code}_REGEX");
                                              }

                                              return null;
                                            },
                                            label: localizations.translate(
                                              '${selectedServiceDefinition?.code}.${e.code}',
                                            ),
                                          ),
                                        ] else if (e.dataType == 'Number' &&
                                            !(e.code ?? '').contains('.')) ...[
                                          DigitTextField(
                                            autoValidation: AutovalidateMode
                                                .onUserInteraction,
                                            textStyle:
                                                theme.textTheme.headlineMedium,
                                            textInputType: TextInputType.number,
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(
                                                  "[0-9]",
                                                ),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (((value == null ||
                                                      value == '') &&
                                                  e.required == true)) {
                                                return localizations.translate(
                                                  i18_local.common
                                                      .corecommonRequired,
                                                );
                                              }
                                              if (e.regex != null) {
                                                return (RegExp(e.regex!)
                                                        .hasMatch(value!))
                                                    ? null
                                                    : localizations.translate(
                                                        "${e.code}_REGEX");
                                              }

                                              return null;
                                            },
                                            controller: controller[index],
                                            label: '${localizations.translate(
                                                  '${selectedServiceDefinition?.code}.${e.code}',
                                                ).trim()} ${e.required == true ? '*' : ''}',
                                          ),
                                        ] else if (e.dataType ==
                                                'MultiValueList' &&
                                            !(e.code ?? '').contains('.')) ...[
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
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
                                                        DigitCheckboxTile(
                                                          label: e,
                                                          value:
                                                              controller[index]
                                                                  .text
                                                                  .split('.')
                                                                  .contains(e),
                                                          onChanged: (value) {
                                                            final String ele;
                                                            var val =
                                                                controller[
                                                                        index]
                                                                    .text
                                                                    .split('.');
                                                            if (val
                                                                .contains(e)) {
                                                              val.remove(e);
                                                              ele =
                                                                  val.join(".");
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
                                        ] else if (e.dataType ==
                                            'SingleValueList') ...[
                                          if (!(e.code ?? '').contains('.'))
                                            DigitCard(
                                              child: _buildChecklist(
                                                e,
                                                index,
                                                selectedServiceDefinition,
                                                context,
                                              ),
                                            ),
                                        ],
                                      ]);
                                    }).toList(),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ]),
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

  Widget _buildChecklist(
    AttributesModel item,
    int index,
    ServiceDefinitionModel? selectedServiceDefinition,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    /* Check the data type of the attribute*/
    if (item.dataType == 'SingleValueList') {
      final childItems = getNextQuestions(
        item.code.toString(),
        initialAttributes ?? [],
      );
      List<int> excludedIndexes = [];

      // Ensure the current index is added to visible indexes and not excluded
      if (!visibleChecklistIndexes.contains(index) &&
          !excludedIndexes.contains(index)) {
        visibleChecklistIndexes.add(index);
      }

      // Determine excluded indexes
      for (int i = 0; i < (initialAttributes ?? []).length; i++) {
        if (!visibleChecklistIndexes.contains(i)) {
          excludedIndexes.add(i);
        }
      }

      return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4.0), // Add padding here
              child: Text(
                '${localizations.translate(
                  '${selectedServiceDefinition?.code}.${item.code}',
                )} ${item.required == true ? '*' : ''}',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          Column(
            children: [
              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  return RadioGroup<String>.builder(
                    groupValue: controller[index].text.trim(),
                    onChanged: (value) {
                      setState(() {
                        for (final matchingChildItem in childItems) {
                          final childIndex =
                              initialAttributes?.indexOf(matchingChildItem);
                          if (childIndex != null) {
                            visibleChecklistIndexes
                                .removeWhere((v) => v == childIndex);
                          }
                        }

                        // Update the current controller's value
                        controller[index].value =
                            TextEditingController.fromValue(
                          TextEditingValue(
                            text: value!,
                          ),
                        ).value;

                        // Remove corresponding controllers based on the removed attributes
                      });
                    },
                    items: item.values != null
                        ? item.values!
                            .where(
                                (e) => e != i18_local.checklist.notSelectedKey)
                            .toList()
                        : [],
                    itemBuilder: (item) => RadioButtonBuilder(
                      item.trim().toUpperCase() == 'TEST_UNAVAILABLE'
                          ? localizations.translate(
                              "${selectedServiceDefinition?.code}.${item.trim().toUpperCase()}")
                          : localizations.translate(
                              'CORE_COMMON_${item.trim().toUpperCase()}'),
                    ),
                  );
                },
              ),
              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  final hasError = (item.required == true &&
                      controller[index].text.isEmpty &&
                      submitTriggered);

                  return Offstage(
                    offstage: !hasError,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizations.translate(
                          i18_local.common.corecommonRequired,
                        ),
                        style: TextStyle(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          if (childItems.isNotEmpty &&
              controller[index].text.trim().isNotEmpty) ...[
            _buildNestedChecklists(
              item.code.toString(),
              index,
              controller[index].text.trim(),
              context,
            ),
          ],
        ],
      );
    } else if (item.dataType == 'String') {
      const pattern = r'^[A-Za-z0-9\s]+$'; // Allows A-Z, a-z, 0-9, and spaces
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DigitTextField(
          onChange: (value) {
            checklistFormKey.currentState?.validate();
          },
          isRequired: item.required ?? true,
          controller: controller[index],
          validator: (value) {
            if (((value == null || value == '') && item.required == true)) {
              return localizations.translate("${item.code}_REQUIRED");
            }
            return (RegExp(item.regex ?? pattern).hasMatch(value!))
                ? null
                : localizations.translate("${item.code}_REGEX");
          },
          label: localizations.translate(
            '${selectedServiceDefinition?.code}.${item.code}',
          ),
        ),
      );
    } else if (item.dataType == 'Number') {
      return DigitTextField(
        autoValidation: AutovalidateMode.onUserInteraction,
        textStyle: theme.textTheme.headlineMedium,
        textInputType: TextInputType.number,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(
            "[0-9]",
          )),
        ],
        validator: (value) {
          if (((value == null || value == '') && item.required == true)) {
            return localizations.translate(
              i18_local.common.corecommonRequired,
            );
          }
          if (item.regex != null) {
            return (RegExp(item.regex!).hasMatch(value!))
                ? null
                : localizations.translate("${item.code}_REGEX");
          }

          return null;
        },
        controller: controller[index],
        label: '${localizations.translate(
              '${selectedServiceDefinition?.code}.${item.code}',
            ).trim()} ${item.required == true ? '*' : ''}',
      );
    } else if (item.dataType == 'MultiValueList') {
      return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    '${localizations.translate(
                      '${selectedServiceDefinition?.code}.${item.code}',
                    )} ${item.required == true ? '*' : ''}',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              return Column(
                children: item.values!
                    .map((e) => DigitCheckboxTile(
                          label: e,
                          value: controller[index].text.split('.').contains(e),
                          onChanged: (value) {
                            final String ele;
                            var val = controller[index].text.split('.');
                            if (val.contains(e)) {
                              val.remove(e);
                              ele = val.join(".");
                            } else {
                              ele = "${controller[index].text}.$e";
                            }
                            controller[index].value =
                                TextEditingController.fromValue(
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
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getHighlightedText(String description) {
    // Find the position of the word "Proceed"
    int startIndex = description.indexOf('Proceed');
    int endIndex = startIndex + 'Proceed'.length;

    if (startIndex == -1) {
      // If "Proceed" is not found, return the original description
      return Text(description);
    }

    // Split the description into parts
    String partBefore = description.substring(0, startIndex);
    String partHighlighted = description.substring(startIndex, endIndex);
    String partAfter = description.substring(endIndex);

    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle normalTextStyle =
        textTheme.titleMedium ?? TextStyle(color: Colors.black);

    // Use RichText to style the word "Proceed"
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: partBefore,
            style: normalTextStyle,
          ),
          TextSpan(
            text: partHighlighted,
            style: normalTextStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: partAfter,
            style: normalTextStyle,
          ),
        ],
      ),
    );
  }

  List<bool> isIneligible(
    Map<String?, String> responses,
    List<String?> ineligibilityReasons,
    bool ifAdministration,
  ) {
    var isIneligible = false;
    var q3Key = "KBEA3";
    var q5Key = "KBEA4";
    var q2Key = "KBEA2";
    var q6Key = "KBEA2.YES.KBEA2A.POSITIVE.KBEA2AA";

    Map<String, String> keyVsReason = {
      q2Key: "FEVER",
      q3Key: "CHILD_ALLERGIC_TO_DRUGS",
      q5Key: "TAKEN_SP_OR_CTX",
      q6Key: "TAKEN_MALARIA_DOSE",
    };

    if (responses.isNotEmpty) {
      if (responses.containsKey(q3Key) && responses[q3Key]!.isNotEmpty) {
        isIneligible = responses[q3Key] == yes ? true : false;
      }
      if (!isIneligible &&
          (responses.containsKey(q5Key) && responses[q5Key]!.isNotEmpty)) {
        isIneligible = responses[q5Key] == yes ? true : false;
      }
      if (responses.containsKey(q2Key) &&
          responses[q2Key]!.isNotEmpty &&
          responses[q2Key] == yes) {
            if (!isIneligible &&
          (responses.containsKey(q6Key) && responses[q6Key]!.isNotEmpty)) {
        ifAdministration = responses[q6Key] == yes ? false : true;
        isIneligible = responses[q6Key] == yes ? true : false;
      }
          }
      if (isIneligible) {
        for (var entry in responses.entries) {
          if (entry.key == q3Key || entry.key == q5Key) {
            entry.value == yes
                ? ineligibilityReasons.add(keyVsReason[entry.key])
                : null;
          }
        }
      }
    }

    return [isIneligible, ifAdministration];
  }

  bool isReferral(
    Map<String?, String> responses,
    List<String?> referralReasons,
  ) {
    var isReferral = false;
    var q1Key = "KBEA1";
    var q2Key = "KBEA2";
    var q3Key = "KBEA2.YES.KBEA2A";
    var q4Key = "KBEA2.YES.KBEA2A.POSITIVE.KBEA2AA";
    Map<String, String> referralKeysVsCode = {
      q1Key: "SICK",
      q2Key: "FEVER",
      q3Key: "MALARIA_CHECK",
      q4Key: "MALARIA_DOSE_CHECK"
    };
    // TODO Configure the reasons ,verify hardcoded strings
    if (responses.isNotEmpty) {
      if (responses.containsKey(q1Key) && responses[q1Key]!.isNotEmpty) {
        isReferral = responses[q1Key] == yes ? true : false;
      }
      if (responses.containsKey(q2Key) &&
          responses[q2Key]!.isNotEmpty &&
          responses[q2Key] == yes) {
        if (!isReferral &&
            (responses.containsKey(q3Key) && responses[q3Key]!.isNotEmpty)) {
          isReferral = (responses[q3Key] == negative ||
                  responses[q3Key] == test_unavailable)
              ? true
              : false;
        }
        if (!isReferral &&
            (responses.containsKey(q4Key) && responses[q4Key]!.isNotEmpty)) {
          isReferral = responses[q4Key] == no ? true : false;
        }
      }
    }
    if (isReferral) {
      for (var entry in referralKeysVsCode.entries) {
        if (responses.containsKey(entry.key) &&
            responses[entry.key]!.isNotEmpty) {
          if ((entry.key == q1Key && responses[q1Key] == yes) ||
              (entry.key == q3Key && responses[q3Key] == negative) ||
              (entry.key == q3Key && responses[q3Key] == test_unavailable) ||
              (entry.key == q4Key && responses[q4Key] == no)) {
            referralReasons.add(entry.value);
          }
        }
      }
    }

    return isReferral;
  }

  bool isVASReferral(
    Map<String?, String> responses,
    List<String?> referralReasons,
  ) {
    var isReferral = false;
    var q1Key = "KBEA5";
    var q2Key = "KBEA6";
    // var q3Key = "KBEA3";
    // var q4Key = "KBEA7";
    Map<String, String> referralKeysVsCode = {
      q1Key: "RESPIRATORY_INFECTION",
      // q2Key: "TAKEN_VITAMIN_A",
      q2Key: "DRUG_SE_PC",
      // qKey: "SIDE_EFFECTS_TO_VITAMIN_A",
    };
    // TODO Configure the reasons ,verify hardcoded strings

    if (responses.isNotEmpty) {
      if (responses.containsKey(q1Key) && responses[q1Key]!.isNotEmpty) {
        isReferral = responses[q1Key] == yes ? true : false;
      }
      if (!isReferral &&
          (responses.containsKey(q2Key) && responses[q2Key]!.isNotEmpty)) {
        isReferral = responses[q2Key] == yes ? true : false;
      }
    }
    if (isReferral) {
      for (var entry in referralKeysVsCode.entries) {
        if (responses.containsKey(entry.key) &&
            responses[entry.key]!.isNotEmpty) {
          if (responses[entry.key] == yes) {
            referralReasons.add(entry.value);
          }
        }
      }
    }

    return isReferral;
  }

  bool isDelivery(Map<String?, String> responses) {
    var isDeliver = true;
    var q1Key = "KBEA7";

    for (var entry in responses.entries) {
      if (entry.key == q1Key) {
        continue;
      }
      if (entry.value == yes) {
        isDeliver = false;
        break;
      }
    }

    return isDeliver;
  }

  // Function to build nested checklists for child attributes
  Widget _buildNestedChecklists(
    String parentCode,
    int parentIndex,
    String parentControllerValue,
    BuildContext context,
  ) {
    // Retrieve child items for the given parent code
    final childItems = getNextQuestions(
      parentCode,
      initialAttributes ?? [],
    );

    return Column(
      children: [
        // Build cards for each matching child attribute
        for (final matchingChildItem in childItems.where((childItem) =>
            childItem.code!.startsWith('$parentCode.$parentControllerValue.')))
          Card(
            margin: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
            color: countDots(matchingChildItem.code ?? '') % 4 == 2
                ? const Color.fromRGBO(238, 238, 238, 1)
                : const DigitColors().white,
            child: _buildChecklist(
              matchingChildItem,
              initialAttributes?.indexOf(matchingChildItem) ??
                  parentIndex, // Pass parentIndex here as we're building at the same level
              selectedServiceDefinition,
              context,
            ),
          ),
      ],
    );
  }

  // Function to get the next questions (child attributes) based on a parent code
  List<AttributesModel> getNextQuestions(
    String parentCode,
    List<AttributesModel> checklistItems,
  ) {
    final childCodePrefix = '$parentCode.';
    final nextCheckLists = checklistItems.where((item) {
      return item.code!.startsWith(childCodePrefix) &&
          item.code?.split('.').length == parentCode.split('.').length + 2;
    }).toList();

    return nextCheckLists;
  }

  int countDots(String inputString) {
    int dotCount = 0;
    for (int i = 0; i < inputString.length; i++) {
      if (inputString[i] == '.') {
        dotCount++;
      }
    }

    return dotCount;
  }

  Future<bool> _onBackPressed(BuildContext context, bool isIneligible) async {
    if (!isIneligible) {
      bool? shouldNavigateBack = await showDialog<bool>(
        context: context,
        builder: (context) => DigitDialog(
          options: DigitDialogOptions(
            titleText: localizations.translate(
              i18_local.checklist.checklistBackDialogLabel,
            ),
            content: Text(localizations.translate(
              i18_local.checklist.checklistBackDialogDescription,
            )),
            primaryAction: DigitDialogActions(
              label: localizations.translate(
                  i18_local.checklist.checklistBackDialogPrimaryAction),
              action: (ctx) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(true);
              },
            ),
            secondaryAction: DigitDialogActions(
              label: localizations.translate(
                  i18_local.checklist.checklistBackDialogSecondaryAction),
              action: (context) {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(false);
              },
            ),
          ),
        ),
      );

      return shouldNavigateBack ?? false;
    }
    return false;
  }
}
