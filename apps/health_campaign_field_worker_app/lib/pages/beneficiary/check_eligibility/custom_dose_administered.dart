import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/models/RadioButtonModel.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/table_cell.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:digit_ui_components/widgets/molecules/digit_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/blocs/app_localization.dart';
import 'package:registration_delivery/utils/extensions/extensions.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:health_campaign_field_worker_app/utils/i18_key_constants.dart'
    as i18_local;
import 'package:registration_delivery/blocs/delivery_intervention/deliver_intervention.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/models/entities/additional_fields_type.dart';
import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/models/entities/task.dart';
import 'package:registration_delivery/models/entities/task_resource.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/constants.dart';
import 'package:registration_delivery/utils/utils.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/component_wrapper/product_variant_bloc_wrapper.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/widgets/table_card/table_card.dart';
import '../../../models/entities/additional_fields_type.dart'
    as additional_fields_local;
import '../../../models/entities/identifier_types.dart';
import '../../../router/app_router.dart';
import '../../../utils/app_enums.dart';

@RoutePage()
class CustomDoseAdministeredPage extends LocalizedStatefulWidget {
  final EligibilityAssessmentType eligibilityAssessmentType;
  const CustomDoseAdministeredPage({
    super.key,
    super.appLocalizations,
    required this.eligibilityAssessmentType,
  });

  @override
  State<CustomDoseAdministeredPage> createState() =>
      CustomDoseAdministeredPageState();
}

class CustomDoseAdministeredPageState
    extends LocalizedState<CustomDoseAdministeredPage> {
  bool doseAdministered = false;
  bool formSubmitted = false;

  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  final clickedStatus = ValueNotifier<bool>(false);

  @override
  void dispose() {
    clickedStatus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = RegistrationDeliveryLocalization.of(context);
    final overViewBloc = context.read<HouseholdOverviewBloc>().state;
    final textTheme = theme.digitTextTheme(context);
    // Define a list of TableHeader objects for the header of a table
    final headerListResource = [
      DigitTableColumn(
        header: localizations.translate(i18.beneficiaryDetails.beneficiaryDose),
        cellValue: 'dose',
        width: MediaQuery.of(context).size.width / 2.18,
      ),
      DigitTableColumn(
        header: localizations
            .translate(i18.beneficiaryDetails.beneficiaryResources),
        cellValue: 'resources',
        width: MediaQuery.of(context).size.width / 2.18,
      ),
    ];

    return ProductVariantBlocWrapper(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: BlocBuilder<LocationBloc, LocationState>(
            builder: (context, locationState) {
              return ScrollableContent(
                enableFixedDigitButton: true,
                header: const Column(children: [
                  BackNavigationHelpHeaderWidget(
                    showBackNavigation: false,
                    showHelp: false,
                  ),
                ]),
                footer: DigitCard(
                    margin: const EdgeInsets.only(top: spacer2),
                    children: [
                      ValueListenableBuilder(
                        valueListenable: clickedStatus,
                        builder: (context, bool isClicked, _) {
                          return DigitButton(
                            label: localizations
                                .translate(i18.common.coreCommonNext),
                            type: DigitButtonType.primary,
                            size: DigitButtonSize.large,
                            mainAxisSize: MainAxisSize.max,
                            isDisabled: isClicked,
                            onPressed: () {
                              final doseAdministered = true;
                              final lat = locationState.latitude;
                              final long = locationState.longitude;
                              clickedStatus.value = true;
                              final bloc =
                                  context.read<DeliverInterventionBloc>().state;
                              final event =
                                  context.read<DeliverInterventionBloc>();

                              if (doseAdministered == true && context.mounted) {
                                // Iterate through future deliveries

                                for (var e in bloc.futureDeliveries!) {
                                  int doseIndex = e.id;
                                  final clientReferenceId = IdGen.i.identifier;
                                  final address = bloc.oldTask?.address;
                                  // Create and dispatch a DeliverInterventionSubmitEvent with a new TaskModel
                                  event.add(DeliverInterventionSubmitEvent(
                                    task: TaskModel(
                                      projectId: RegistrationDeliverySingleton()
                                          .projectId,
                                      address: address?.copyWith(
                                        relatedClientReferenceId:
                                            clientReferenceId,
                                        id: null,
                                      ),
                                      status: Status.delivered.toValue(),
                                      clientReferenceId: clientReferenceId,
                                      projectBeneficiaryClientReferenceId: bloc
                                          .oldTask
                                          ?.projectBeneficiaryClientReferenceId,
                                      tenantId: RegistrationDeliverySingleton()
                                          .tenantId,
                                      rowVersion: 1,
                                      auditDetails: AuditDetails(
                                        createdBy:
                                            RegistrationDeliverySingleton()
                                                .loggedInUserUuid!,
                                        createdTime:
                                            context.millisecondsSinceEpoch(),
                                      ),
                                      clientAuditDetails: ClientAuditDetails(
                                        createdBy:
                                            RegistrationDeliverySingleton()
                                                .loggedInUserUuid!,
                                        createdTime:
                                            context.millisecondsSinceEpoch(),
                                      ),
                                      resources: fetchProductVariant(
                                              e,
                                              overViewBloc.selectedIndividual,
                                              overViewBloc
                                                  .householdMemberWrapper
                                                  .household)
                                          ?.productVariants
                                          ?.map((variant) => TaskResourceModel(
                                                clientReferenceId:
                                                    IdGen.i.identifier,
                                                tenantId:
                                                    RegistrationDeliverySingleton()
                                                        .tenantId,
                                                taskclientReferenceId:
                                                    clientReferenceId,
                                                quantity:
                                                    variant.quantity.toString(),
                                                productVariantId:
                                                    variant.productVariantId,
                                                isDelivered: true,
                                                auditDetails: AuditDetails(
                                                  createdBy:
                                                      RegistrationDeliverySingleton()
                                                          .loggedInUserUuid!,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                                clientAuditDetails:
                                                    ClientAuditDetails(
                                                  createdBy:
                                                      RegistrationDeliverySingleton()
                                                          .loggedInUserUuid!,
                                                  createdTime: context
                                                      .millisecondsSinceEpoch(),
                                                ),
                                              ))
                                          .toList(),
                                      additionalFields: TaskAdditionalFields(
                                        version: 1,
                                        fields: [
                                          AdditionalField(
                                            AdditionalFieldsType.dateOfDelivery
                                                .toValue(),
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          ),
                                          AdditionalField(
                                            AdditionalFieldsType
                                                .dateOfAdministration
                                                .toValue(),
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          ),
                                          AdditionalField(
                                            AdditionalFieldsType
                                                .dateOfVerification
                                                .toValue(),
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                          ),
                                          AdditionalField(
                                            AdditionalFieldsType.cycleIndex
                                                .toValue(),
                                            "0${bloc.cycle}",
                                          ),
                                          AdditionalField(
                                            AdditionalFieldsType.doseIndex
                                                .toValue(),
                                            "0$doseIndex",
                                          ),
                                          AdditionalField(
                                            AdditionalFieldsType
                                                .deliveryStrategy
                                                .toValue(),
                                            e.deliveryStrategy,
                                          ),
                                          if (lat != null)
                                            AdditionalField(
                                              AdditionalFieldsType.latitude
                                                  .toValue(),
                                              lat,
                                            ),
                                          if (long != null)
                                            AdditionalField(
                                              AdditionalFieldsType.longitude
                                                  .toValue(),
                                              long,
                                            ),
                                          AdditionalField(
                                            additional_fields_local
                                                .AdditionalFieldsType
                                                .deliveryType
                                                .toValue(),
                                            widget.eligibilityAssessmentType ==
                                                    EligibilityAssessmentType
                                                        .smc
                                                ? EligibilityAssessmentStatus
                                                    .smcDone.name
                                                : EligibilityAssessmentStatus
                                                    .vasDone.name,
                                          ),
                                        ],
                                      ),
                                    ),
                                    isEditing: false,
                                    boundaryModel:
                                        RegistrationDeliverySingleton()
                                            .boundary!,
                                  ));
                                }

                                final reloadState =
                                    context.read<HouseholdOverviewBloc>();

                                Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () {
                                    reloadState
                                        .add(HouseholdOverviewReloadEvent(
                                      projectId: RegistrationDeliverySingleton()
                                          .projectId!,
                                      projectBeneficiaryType:
                                          RegistrationDeliverySingleton()
                                              .beneficiaryType!,
                                    ));
                                  },
                                ).then((value) => context.router.popAndPush(
                                      CustomHouseholdAcknowledgementRoute(
                                        enableViewHousehold: true,
                                        eligibilityAssessmentType:
                                            widget.eligibilityAssessmentType,
                                      ),
                                    ));
                              }
                            },
                          );
                        },
                      ),
                    ]),
                children: [
                  BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
                    builder: (context, state) {
                      String name =
                          state.selectedIndividual?.name?.givenName ?? "";
                      String beneficiaryId = state
                              .selectedIndividual?.identifiers
                              ?.lastWhereOrNull((e) =>
                                  e.identifierType ==
                                  IdentifierTypes.uniqueBeneficiaryID.toValue())
                              ?.identifierId ??
                          "";
                      return DigitCard(
                          margin: const EdgeInsets.only(
                              top: spacer2, bottom: spacer2),
                          children: [
                            Text(
                              localizations.translate(
                                i18.deliverIntervention.wasTheDoseAdministered,
                              ),
                              style: textTheme.headingXl,
                            ),
                            Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    localizations.translate(
                                      i18_local.deliverIntervention
                                          .doseCompletionChecksText1,
                                    ),
                                  ),
                                  leading: const Text("1."),
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 24,
                                  minVerticalPadding: 0,
                                ),
                                ListTile(
                                  title: Text.rich(
                                    TextSpan(
                                      text:
                                          '${localizations.translate(i18_local.deliverIntervention.doseCompletionChecksText2)} ',
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: beneficiaryId,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 245, 56, 42),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${localizations.translate(i18_local.deliverIntervention.doseCompletionChecksText3)} ',
                                        ),
                                        TextSpan(
                                          text: name,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 245, 56, 42),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              ' (${localizations.translate(i18_local.deliverIntervention.doseCompletionChecksText4)})',
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: const Text("2."),
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 24,
                                  minVerticalPadding: 0,
                                ),
                                ListTile(
                                  title: Text(
                                    localizations.translate(
                                      i18_local.deliverIntervention
                                          .doseCompletionChecksText5,
                                    ),
                                  ),
                                  leading: const Text("3."),
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 24,
                                  minVerticalPadding: 0,
                                ),
                                ListTile(
                                  title: Text(
                                    localizations.translate(
                                      i18_local.deliverIntervention
                                          .doseCompletionChecksText6,
                                    ),
                                  ),
                                  leading: const Text("4."),
                                  horizontalTitleGap: 0,
                                  minLeadingWidth: 24,
                                  minVerticalPadding: 0,
                                ),
                              ],
                            ),
                          ]);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
