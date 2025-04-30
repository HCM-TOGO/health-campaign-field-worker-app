import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
// import 'package:digit_components/utils/date_utils.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
import 'package:registration_delivery/blocs/delivery_intervention/deliver_intervention.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';
import 'package:registration_delivery/models/entities/additional_fields_type.dart';
import 'package:registration_delivery/models/entities/household.dart';
import 'package:registration_delivery/models/entities/task.dart';

import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/utils/utils.dart';
import '../../router/app_router.dart';
import '../../widgets/action_card/action_card.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:digit_ui_components/utils/date_utils.dart';
import '../../widgets/member_card.dart';

@RoutePage()
class CustomHouseholdOverviewPage extends LocalizedStatefulWidget {
  const CustomHouseholdOverviewPage({super.key, super.appLocalizations});

  @override
  State<CustomHouseholdOverviewPage> createState() =>
      _CustomHouseholdOverviewPageState();
}

class _CustomHouseholdOverviewPageState
    extends LocalizedState<CustomHouseholdOverviewPage> {
  @override
  void initState() {
    final bloc = context.read<HouseholdOverviewBloc>();
    bloc.add(
      HouseholdOverviewReloadEvent(
        projectId: RegistrationDeliverySingleton().projectId!,
        projectBeneficiaryType:
            RegistrationDeliverySingleton().beneficiaryType!,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final beneficiaryType = RegistrationDeliverySingleton().beneficiaryType!;
    final deliverState = context.read<DeliverInterventionBloc>().state;

    return PopScope(
      onPopInvoked: (didPop) async {
        context
            .read<SearchBlocWrapper>()
            .searchHouseholdsBloc
            .add(const SearchHouseholdsClearEvent());
        context.router.maybePop();
      },
      child: BlocBuilder<HouseholdOverviewBloc, HouseholdOverviewState>(
        builder: (ctx, state) {
          return Scaffold(
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ScrollableContent(
                    header: const BackNavigationHelpHeaderWidget(),
                    enableFixedButton: true,
                    footer: Offstage(
                      offstage: beneficiaryType == BeneficiaryType.individual,
                      child: BlocBuilder<DeliverInterventionBloc,
                          DeliverInterventionState>(
                        builder: (ctx, deliverInterventionState) => DigitCard(
                            margin:
                                const EdgeInsets.fromLTRB(0, kPadding, 0, 0),
                            padding: const EdgeInsets.fromLTRB(
                                kPadding, 0, kPadding, 0),
                            child: isSuccessfulOrInEligible(
                                        state, deliverInterventionState) ||
                                    isIneligibleHouseStructure(state)
                                ? const Offstage()
                                : DigitElevatedButton(
                                    onPressed: (state.householdMemberWrapper
                                                        .projectBeneficiaries ??
                                                    [])
                                                .isEmpty ||
                                            state.householdMemberWrapper.tasks
                                                    ?.last.status ==
                                                Status.closeHousehold.toValue()
                                        ? null
                                        : () async {
                                            final bloc = ctx
                                                .read<HouseholdOverviewBloc>();

                                            final projectId =
                                                RegistrationDeliverySingleton()
                                                    .projectId!;

                                            bloc.add(
                                              HouseholdOverviewReloadEvent(
                                                projectId: projectId,
                                                projectBeneficiaryType:
                                                    beneficiaryType,
                                              ),
                                            );

                                            // await context.router.push(
                                            //     BeneficiaryChecklistRoute());

                                            await context.router
                                                .push(BeneficiaryWrapperRoute(
                                              wrapper:
                                                  state.householdMemberWrapper,
                                            ));
                                          },
                                    child: Center(
                                      child: Text(
                                        localizations.translate(
                                          i18.householdOverView
                                              .householdOverViewActionText,
                                        ),
                                      ),
                                    ),
                                  )),
                      ),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: DigitCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if ((state.householdMemberWrapper
                                          .projectBeneficiaries ??
                                      [])
                                  .isNotEmpty)
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: kPadding - 8,
                                          right: kPadding - 8,
                                        ),
                                        child: Text(
                                          localizations.translate(i18
                                              .householdOverView
                                              .householdOverViewLabel),
                                          style: theme.textTheme.displayMedium,
                                        ),
                                      ),
                                      if (!isSuccessfulOrInEligible(
                                          state, deliverState))
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: DigitIconButton(
                                            onPressed: () {
                                              final projectId =
                                                  RegistrationDeliverySingleton()
                                                      .projectId!;

                                              final bloc = context.read<
                                                  HouseholdOverviewBloc>();
                                              bloc.add(
                                                HouseholdOverviewReloadEvent(
                                                  projectId: projectId,
                                                  projectBeneficiaryType:
                                                      beneficiaryType,
                                                ),
                                              );
                                              DigitActionDialog.show(
                                                context,
                                                widget: ActionCard(
                                                  items: [
                                                    ActionCardModel(
                                                      icon: Icons.edit,
                                                      label: localizations
                                                          .translate(
                                                        i18.householdOverView
                                                            .householdOverViewEditLabel,
                                                      ),
                                                      action: () async {
                                                        Navigator.of(
                                                          context,
                                                          rootNavigator: true,
                                                        ).pop();

                                                        HouseholdMemberWrapper
                                                            wrapper = state
                                                                .householdMemberWrapper;

                                                        final timestamp = wrapper
                                                            .headOfHousehold
                                                            ?.clientAuditDetails
                                                            ?.createdTime;
                                                        final date = DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                          timestamp ??
                                                              DateTime.now()
                                                                  .millisecondsSinceEpoch,
                                                        );

                                                        final address = wrapper
                                                            .household?.address;

                                                        if (address == null)
                                                          return;

                                                        final projectBeneficiary = state
                                                            .householdMemberWrapper
                                                            .projectBeneficiaries
                                                            ?.firstWhereOrNull(
                                                          (element) =>
                                                              element
                                                                  .beneficiaryClientReferenceId ==
                                                              wrapper.household
                                                                  ?.clientReferenceId,
                                                        );

                                                        await context
                                                            .router.root
                                                            .push(
                                                          BeneficiaryRegistrationWrapperRoute(
                                                            initialState:
                                                                BeneficiaryRegistrationEditHouseholdState(
                                                              addressModel:
                                                                  address,
                                                              individualModel: state
                                                                      .householdMemberWrapper
                                                                      .members ??
                                                                  [],
                                                              householdModel: state
                                                                  .householdMemberWrapper
                                                                  .household!,
                                                              registrationDate:
                                                                  date,
                                                              projectBeneficiaryModel:
                                                                  projectBeneficiary,
                                                            ),
                                                            children: [
                                                              HouseholdLocationRoute(),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            iconText: localizations.translate(
                                              i18.householdOverView
                                                  .householdOverViewEditIconText,
                                            ),
                                            icon: Icons.edit,
                                          ),
                                        ),
                                    ]),
                              // BlocBuilder<DeliverInterventionBloc,
                              //     DeliverInterventionState>(
                              //   builder: (ctx, deliverInterventionState) =>
                              //       Offstage(
                              //     offstage: beneficiaryType ==
                              //         BeneficiaryType.individual,
                              //     child: Align(
                              //       alignment: Alignment.centerLeft,
                              //       child: DigitIconButton(
                              //         icon: getStatusAttributes(state,
                              //             deliverInterventionState)['icon'],
                              //         iconText: localizations.translate(
                              //           getStatusAttributes(state,
                              //                   deliverInterventionState)[
                              //               'textLabel'],
                              //         ), // [TODO: map task status accordingly based on projectBeneficiaries and tasks]
                              //         iconTextColor: getStatusAttributes(state,
                              //             deliverInterventionState)['color'],
                              //         iconColor: getStatusAttributes(state,
                              //             deliverInterventionState)['color'],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: kPadding,
                                  right: kPadding,
                                ),
                                child: BlocBuilder<DeliverInterventionBloc,
                                        DeliverInterventionState>(
                                    builder: (ctx, deliverInterventionState) {
                                  return Column(
                                    children: [
                                      DigitTableCard(
                                        element: {
                                          localizations.translate(i18
                                                  .householdOverView
                                                  .householdOverViewHouseholdHeadNameLabel):
                                              state
                                                      .householdMemberWrapper
                                                      .headOfHousehold
                                                      ?.name
                                                      ?.givenName ??
                                                  localizations.translate(
                                                      i18.common.coreCommonNA),
                                          localizations.translate(
                                            i18.householdLocation
                                                .administrationAreaFormLabel,
                                          ): localizations.translate(
                                              RegistrationDeliverySingleton()
                                                  .boundary!
                                                  .code!),
                                          localizations.translate(
                                            i18.deliverIntervention
                                                .memberCountText,
                                          ): state.householdMemberWrapper
                                              .household?.memberCount,
                                          localizations.translate(i18
                                              .beneficiaryDetails
                                              .status): localizations.translate(
                                            getStatusAttributes(state,
                                                    deliverInterventionState)[
                                                'textLabel'],
                                          )
                                        },
                                      ),
                                      if ((state.householdMemberWrapper
                                                  .projectBeneficiaries ??
                                              [])
                                          .isEmpty)
                                        DigitElevatedButton(
                                            onPressed: () async {
                                              Logger().d("This is the button");

                                              context.router.root.push(
                                                  EligibilityChecklistViewRoute());
                                              // HouseholdMemberWrapper wrapper =
                                              //     state.householdMemberWrapper;

                                              // final timestamp = wrapper
                                              //     .headOfHousehold
                                              //     ?.clientAuditDetails
                                              //     ?.createdTime;
                                              // final date = DateTime
                                              //     .fromMillisecondsSinceEpoch(
                                              //   timestamp ??
                                              //       DateTime.now()
                                              //           .millisecondsSinceEpoch,
                                              // );

                                              // final address =
                                              //     wrapper.household?.address;

                                              // if (address == null) return;

                                              // final projectBeneficiary = state
                                              //     .householdMemberWrapper
                                              //     .projectBeneficiaries
                                              //     ?.firstWhereOrNull(
                                              //   (element) =>
                                              //       element
                                              //           .beneficiaryClientReferenceId ==
                                              //       wrapper.household
                                              //           ?.clientReferenceId,
                                              // );

                                              // await context.router.root.push(
                                              //   BeneficiaryRegistrationWrapperRoute(
                                              //     initialState:
                                              //         BeneficiaryRegistrationEditHouseholdState(
                                              //       addressModel: address,
                                              //       individualModel: state
                                              //               .householdMemberWrapper
                                              //               .members ??
                                              //           [],
                                              //       householdModel: state
                                              //           .householdMemberWrapper
                                              //           .household!,
                                              //       registrationDate: date,
                                              //       projectBeneficiaryModel:
                                              //           projectBeneficiary,
                                              //     ),
                                              //     children: [
                                              //       HouseholdLocationRoute(),
                                              //     ],
                                              //   ),
                                              // );
                                            },
                                            child: Center(
                                              child: Text(
                                                "SMC Eligibility",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ))
                                    ],
                                  );
                                }),
                              ),
                              Column(
                                children:
                                    (state.householdMemberWrapper.members ?? [])
                                        .map(
                                  (e) {
                                    final isHead = state
                                            .householdMemberWrapper
                                            .headOfHousehold
                                            ?.clientReferenceId ==
                                        e.clientReferenceId;
                                    final projectBeneficiaryId = state
                                        .householdMemberWrapper
                                        .projectBeneficiaries
                                        ?.firstWhereOrNull((b) =>
                                            b.beneficiaryClientReferenceId ==
                                            e.clientReferenceId)
                                        ?.clientReferenceId;

                                    final projectBeneficiary = state
                                        .householdMemberWrapper
                                        .projectBeneficiaries
                                        ?.where(
                                          (element) =>
                                              element
                                                  .beneficiaryClientReferenceId ==
                                              (RegistrationDeliverySingleton()
                                                          .beneficiaryType ==
                                                      BeneficiaryType.individual
                                                  ? e.clientReferenceId
                                                  : state
                                                      .householdMemberWrapper
                                                      .household
                                                      ?.clientReferenceId),
                                        )
                                        .toList();

                                    final taskData = (projectBeneficiary ?? [])
                                            .isNotEmpty
                                        ? state.householdMemberWrapper.tasks
                                            ?.where((element) =>
                                                element
                                                    .projectBeneficiaryClientReferenceId ==
                                                projectBeneficiary
                                                    ?.first.clientReferenceId)
                                            .toList()
                                        : null;
                                    final referralData = (projectBeneficiary ??
                                                [])
                                            .isNotEmpty
                                        ? state.householdMemberWrapper.referrals
                                            ?.where((element) =>
                                                element
                                                    .projectBeneficiaryClientReferenceId ==
                                                projectBeneficiary
                                                    ?.first.clientReferenceId)
                                            .toList()
                                        : null;
                                    final sideEffectData = taskData != null &&
                                            taskData.isNotEmpty
                                        ? state
                                            .householdMemberWrapper.sideEffects
                                            ?.where((element) =>
                                                element.taskClientReferenceId ==
                                                taskData.last.clientReferenceId)
                                            .toList()
                                        : null;
                                    final ageInYears = e.dateOfBirth != null
                                        ? DigitDateUtils.calculateAge(
                                            DigitDateUtils
                                                    .getFormattedDateToDateTime(
                                                  e.dateOfBirth!,
                                                ) ??
                                                DateTime.now(),
                                          ).years
                                        : 0;
                                    final ageInMonths = e.dateOfBirth != null
                                        ? DigitDateUtils.calculateAge(
                                            DigitDateUtils
                                                    .getFormattedDateToDateTime(
                                                  e.dateOfBirth!,
                                                ) ??
                                                DateTime.now(),
                                          ).months
                                        : 0;
                                    final currentCycle =
                                        RegistrationDeliverySingleton()
                                            .projectType
                                            ?.cycles
                                            ?.firstWhereOrNull(
                                              (e) =>
                                                  (e.startDate) <
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch &&
                                                  (e.endDate) >
                                                      DateTime.now()
                                                          .millisecondsSinceEpoch,
                                            );

                                    final isBeneficiaryRefused =
                                        checkIfBeneficiaryRefused(
                                      taskData,
                                    );
                                    final isBeneficiaryReferred =
                                        checkIfBeneficiaryReferred(
                                      referralData,
                                      currentCycle,
                                    );

                                    return CustomMemberCard(
                                      isHead: isHead,
                                      individual: e,
                                      projectBeneficiaries:
                                          projectBeneficiary ?? [],
                                      tasks: taskData,
                                      sideEffects: sideEffectData,
                                      editMemberAction: () async {
                                        final bloc =
                                            ctx.read<HouseholdOverviewBloc>();

                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();

                                        final address = e.address;
                                        if (address == null ||
                                            address.isEmpty) {
                                          return;
                                        }

                                        final projectId =
                                            RegistrationDeliverySingleton()
                                                .projectId!;
                                        bloc.add(
                                          HouseholdOverviewReloadEvent(
                                            projectId: projectId,
                                            projectBeneficiaryType:
                                                beneficiaryType,
                                          ),
                                        );

                                        await context.router.root.push(
                                          BeneficiaryRegistrationWrapperRoute(
                                            initialState:
                                                BeneficiaryRegistrationEditIndividualState(
                                              individualModel: e,
                                              householdModel: state
                                                  .householdMemberWrapper
                                                  .household!,
                                              addressModel: address.first,
                                              projectBeneficiaryModel: state
                                                  .householdMemberWrapper
                                                  .projectBeneficiaries
                                                  ?.firstWhereOrNull(
                                                (element) =>
                                                    element
                                                        .beneficiaryClientReferenceId ==
                                                    (RegistrationDeliverySingleton()
                                                                .beneficiaryType ==
                                                            BeneficiaryType
                                                                .individual
                                                        ? e.clientReferenceId
                                                        : state
                                                            .householdMemberWrapper
                                                            .household
                                                            ?.clientReferenceId),
                                              ),
                                            ),
                                            children: [
                                              CustomIndividualDetailsRoute(
                                                isHeadOfHousehold: isHead,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      isNotEligible: RegistrationDeliverySingleton()
                                                  .projectType
                                                  ?.cycles !=
                                              null
                                          ? !checkEligibilityForAgeAndSideEffect(
                                              DigitDOBAgeConvertor(
                                                years: ageInYears,
                                                months: ageInMonths,
                                              ),
                                              RegistrationDeliverySingleton()
                                                  .projectType,
                                              (taskData ?? []).isNotEmpty
                                                  ? taskData?.last
                                                  : null,
                                              sideEffectData,
                                            )
                                          : false,
                                      name: e.name?.givenName ?? ' - - ',
                                      years: (e.dateOfBirth == null
                                              ? null
                                              : DigitDateUtils.calculateAge(
                                                  DigitDateUtils
                                                          .getFormattedDateToDateTime(
                                                        e.dateOfBirth!,
                                                      ) ??
                                                      DateTime.now(),
                                                ).years) ??
                                          0,
                                      months: (e.dateOfBirth == null
                                              ? null
                                              : DigitDateUtils.calculateAge(
                                                  DigitDateUtils
                                                          .getFormattedDateToDateTime(
                                                        e.dateOfBirth!,
                                                      ) ??
                                                      DateTime.now(),
                                                ).months) ??
                                          0,
                                      gender: e.gender?.name,
                                      isBeneficiaryRefused:
                                          isBeneficiaryRefused &&
                                              !checkStatus(
                                                taskData,
                                                currentCycle,
                                              ),
                                      isBeneficiaryReferred:
                                          isBeneficiaryReferred,
                                      isDelivered: taskData == null
                                          ? false
                                          : taskData.isNotEmpty &&
                                                  !checkStatus(
                                                    taskData,
                                                    currentCycle,
                                                  )
                                              ? true
                                              : false,
                                      localizations: localizations,
                                      projectBeneficiaryClientReferenceId:
                                          projectBeneficiaryId,
                                    );
                                  },
                                ).toList(),
                              ),
                              const SizedBox(
                                height: kPadding,
                              ),
                              Center(
                                child: DigitIconButton(
                                  onPressed: () => addIndividual(
                                    context,
                                    state.householdMemberWrapper.household!,
                                  ),
                                  iconText: localizations.translate(
                                    i18.householdOverView
                                        .householdOverViewAddActionText,
                                  ),
                                  icon: Icons.add_circle,
                                ),
                              ),
                              const SizedBox(
                                height: kPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  addIndividual(BuildContext context, HouseholdModel household) async {
    final bloc = context.read<HouseholdOverviewBloc>();

    final address = household.address;

    if (address == null) return;
    bloc.add(
      HouseholdOverviewReloadEvent(
        projectId: RegistrationDeliverySingleton().projectId!,
        projectBeneficiaryType:
            RegistrationDeliverySingleton().beneficiaryType!,
      ),
    );
    await context.router.push(
      BeneficiaryRegistrationWrapperRoute(
        initialState: BeneficiaryRegistrationAddMemberState(
          addressModel: address,
          householdModel: household,
        ),
        children: [
          IndividualDetailsRoute(),
        ],
      ),
    );
  }

  bool isSuccessfulOrInEligible(HouseholdOverviewState state,
      DeliverInterventionState deliverInterventionState) {
    if (deliverInterventionState.tasks == null ||
        (deliverInterventionState.tasks?.isEmpty ?? true)) {
      return false;
    }
    final lastTask = deliverInterventionState.tasks?.last;
    final status = lastTask?.status;

    if (status == Status.administeredSuccess.toValue()) {
      return true;
    }

    if (status == Status.administeredFailed.toValue()) {
      final reasonField = lastTask?.additionalFields?.fields.firstWhereOrNull(
          (field) =>
              field.key == AdditionalFieldsType.reasonOfRefusal.toValue());

      return reasonField?.value == "INCOMPATIBLE";
    }

    return false;
  }

  bool isIneligibleHouseStructure(HouseholdOverviewState state) {
    final selectedHouseStructureTypes = state
            .householdMemberWrapper.household?.additionalFields?.fields
            .firstWhereOrNull((element) =>
                element.key ==
                AdditionalFieldsType.houseStructureTypes.toValue())
            ?.value
            ?.toString() ??
        '';
    if (selectedHouseStructureTypes.contains("METAL") ||
        selectedHouseStructureTypes.contains("GLASS") ||
        selectedHouseStructureTypes.contains("PAPER") ||
        selectedHouseStructureTypes.contains("PLASTIC") ||
        selectedHouseStructureTypes.contains("UNDER_CONSTRUCTION")) {
      return true;
    }
    return false;
  }

  getStatusAttributes(HouseholdOverviewState state,
      DeliverInterventionState deliverInterventionState) {
    var textLabel =
        i18.householdOverView.householdOverViewNotRegisteredIconLabel;
    var color = DigitTheme.instance.colorScheme.error;
    var icon = Icons.info_rounded;

    if ((state.householdMemberWrapper.projectBeneficiaries ?? []).isNotEmpty) {
      textLabel = state.householdMemberWrapper.tasks?.isNotEmpty ?? false
          ? getTaskStatus(state.householdMemberWrapper.tasks ?? []).toValue()
          : Status.registered.toValue();

      color = state.householdMemberWrapper.tasks?.isNotEmpty ?? false
          ? (state.householdMemberWrapper.tasks?.last.status ==
                  Status.administeredSuccess.toValue()
              ? DigitTheme.instance.colorScheme.onSurfaceVariant
              : DigitTheme.instance.colorScheme.error)
          : DigitTheme.instance.colorScheme.onSurfaceVariant;

      icon = state.householdMemberWrapper.tasks?.isNotEmpty ?? false
          ? (state.householdMemberWrapper.tasks?.last.status ==
                  Status.administeredSuccess.toValue()
              ? Icons.check_circle
              : Icons.info_rounded)
          : Icons.check_circle;
    } else {
      textLabel = i18.householdOverView.householdOverViewNotRegisteredIconLabel;
      color = DigitTheme.instance.colorScheme.error;
      icon = Icons.info_rounded;
    }

    return {'textLabel': textLabel, 'color': color, 'icon': icon};
  }

  Status getTaskStatusEnum(Iterable<TaskModel> tasks) {
    final statusMap = {
      Status.delivered.toValue(): Status.delivered,
      Status.visited.toValue(): Status.visited,
      Status.notVisited.toValue(): Status.notVisited,
      Status.beneficiaryRefused.toValue(): Status.beneficiaryRefused,
      Status.beneficiaryReferred.toValue(): Status.beneficiaryReferred,
      Status.administeredSuccess.toValue(): Status.administeredSuccess,
      Status.administeredFailed.toValue(): Status.administeredFailed,
      Status.inComplete.toValue(): Status.inComplete,
      Status.toAdminister.toValue(): Status.toAdminister,
      Status.closeHousehold.toValue(): Status.closeHousehold,
    };

    for (var task in tasks) {
      final mappedStatus = statusMap[task.status];
      if (mappedStatus != null) {
        return mappedStatus;
      }
    }

    return Status.registered;
  }
}
