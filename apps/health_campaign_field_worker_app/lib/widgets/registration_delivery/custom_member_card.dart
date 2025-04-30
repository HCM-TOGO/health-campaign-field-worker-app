import 'package:auto_route/auto_route.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/blocs/app_localization.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/models/entities/project_beneficiary.dart';
import 'package:registration_delivery/models/entities/side_effect.dart';
import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/models/entities/task.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import '../../blocs/localization/app_localization.dart';
import '../../models/entities/identifier_types.dart';
// import '../../utils/registration_delivery/utils_smc.dart';
import 'package:registration_delivery/utils/utils.dart';
import '../../router/app_router.dart';
import '../../utils/registration_delivery/utils_smc.dart';
import '../../utils/utils.dart';
import '../action_card/action_card.dart';

import '../../utils/i18_key_constants.dart' as i18_local;

class CustomMemberCard extends StatelessWidget {
  final String name;
  final String? gender;
  final int? years;
  final int? months;
  final bool isHead;
  final IndividualModel individual;
  final List<ProjectBeneficiaryModel>? projectBeneficiaries;
  final bool isDelivered;

  final VoidCallback setAsHeadAction;
  final VoidCallback editMemberAction;
  final VoidCallback deleteMemberAction;
  final RegistrationDeliveryLocalization localizations;
  final List<TaskModel>? tasks;
  final List<SideEffectModel>? sideEffects;
  final bool isNotEligible;
  final bool isBeneficiaryRefused;
  final bool isBeneficiaryIneligible;
  final bool isBeneficiaryReferred;
  final String? projectBeneficiaryClientReferenceId;

  const CustomMemberCard({
    super.key,
    required this.individual,
    required this.projectBeneficiaries,
    required this.name,
    this.gender,
    required this.years,
    this.isHead = false,
    this.months = 0,
    required this.localizations,
    required this.isDelivered,
    required this.setAsHeadAction,
    required this.editMemberAction,
    required this.deleteMemberAction,
    this.tasks,
    this.isNotEligible = false,
    this.projectBeneficiaryClientReferenceId,
    this.isBeneficiaryRefused = false,
    this.isBeneficiaryIneligible = false,
    this.isBeneficiaryReferred = false,
    this.sideEffects,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final beneficiaryType = context.beneficiaryType;
    final doseStatus = checkStatus(tasks, context.selectedCycle);
    final assessmentPendingStatus = assessmentPending(tasks);
    final redosePendingStatus = assessmentPendingStatus
        ? true
        : redosePending(tasks, context.selectedCycle);

    return Container(
      decoration: BoxDecoration(
        color: DigitTheme.instance.colorScheme.background,
        border: Border.all(
          color: DigitTheme.instance.colorScheme.outline,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      margin: DigitTheme.instance.containerMargin,
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  individual.identifiers != null
                      ? Padding(
                          padding: const EdgeInsets.all(kPadding),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: DigitTheme.instance.colorScheme.primary,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(kPadding),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                kPadding,
                              ),
                              child: Text(
                                individual.identifiers!
                                        .lastWhere(
                                          (e) =>
                                              e.identifierType ==
                                              IdentifierTypes
                                                  .uniqueBeneficiaryID
                                                  .toValue(),
                                        )
                                        .identifierId ??
                                    localizations
                                        .translate(i18.common.noResultsFound),
                                style: theme.textTheme.headlineSmall,
                              ),
                            ),
                          ),
                        )
                      : const Offstage(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: kPadding,
                            top: kPadding,
                          ),
                          child: Text(
                            name,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              (tasks ?? [])
                          .where(
                            (element) =>
                                element.status ==
                                Status.administeredSuccess.toValue(),
                          )
                          .lastOrNull ==
                      null
                  ? Positioned(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: DigitIconButton(
                          onPressed: () => DigitActionDialog.show(
                            context,
                            widget: ActionCard(
                              items: [
                                ActionCardModel(
                                  icon: Icons.edit,
                                  label: localizations.translate(
                                    i18.memberCard.editIndividualDetails,
                                  ),
                                  action: editMemberAction,
                                ),
                              ],
                            ),
                          ),
                          iconText: localizations.translate(
                            i18.memberCard.editDetails,
                          ),
                          icon: Icons.edit,
                        ),
                      ),
                    )
                  : const Offstage(),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: DigitTheme.instance.containerMargin,
                  child: Text(
                    gender != null
                        ? localizations
                            .translate('CORE_COMMON_${gender?.toUpperCase()}')
                        : ' - ',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    " | $years ${localizations.translate(i18.memberCard.deliverDetailsYearText)} $months ${localizations.translate(i18.memberCard.deliverDetailsMonthsText)}",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kPadding / 2,
            ),
            child: Offstage(
              offstage: beneficiaryType != BeneficiaryType.individual,
              child: !isDelivered ||
                      isNotEligible ||
                      isBeneficiaryRefused ||
                      isBeneficiaryIneligible ||
                      isBeneficiaryReferred
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: DigitIconButton(
                        icon: Icons.info_rounded,
                        iconSize: 20,
                        iconText: localizations.translate(
                          isHead
                              ? i18_local.householdOverView
                                  .householdOverViewHouseholderHeadLabel
                              : (isNotEligible || isBeneficiaryIneligible)
                                  ? i18.householdOverView
                                      .householdOverViewNotEligibleIconLabel
                                  : isBeneficiaryReferred
                                      ? i18.householdOverView
                                          .householdOverViewBeneficiaryReferredLabel
                                      : isBeneficiaryRefused
                                          ? Status.beneficiaryRefused.toValue()
                                          : Status.notVisited.toValue(),
                        ),
                        iconTextColor: theme.colorScheme.error,
                        iconColor: theme.colorScheme.error,
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: DigitIconButton(
                        icon: Icons.check_circle,
                        iconText: localizations.translate(
                          i18.householdOverView
                              .householdOverViewDeliveredIconLabel,
                        ),
                        iconSize: 20,
                        iconTextColor:
                            DigitTheme.instance.colorScheme.onSurfaceVariant,
                        iconColor:
                            DigitTheme.instance.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
          ),
          Offstage(
            offstage: beneficiaryType != BeneficiaryType.individual,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: isHead
                  ? const Column(
                      children: [],
                    )
                  : Column(
                      children: [
                        ((isNotEligible ||
                                    isBeneficiaryIneligible ||
                                    isBeneficiaryReferred) &&
                                !doseStatus)
                            ? const Offstage()
                            : !isNotEligible && redosePendingStatus
                                ? DigitElevatedButton(
                                    child: Center(
                                      child: Text(
                                        assessmentPendingStatus
                                            ? localizations.translate(
                                                i18_local.householdOverView
                                                    .householdOverViewAssessmentActionText,
                                              )
                                            : localizations.translate(
                                                i18_local.householdOverView
                                                    .householdOverViewRedoseActionText,
                                              ),
                                        style: textTheme.headingM
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final bloc =
                                          context.read<HouseholdOverviewBloc>();
                                      bloc.add(
                                        HouseholdOverviewEvent
                                            .selectedIndividual(
                                          individualModel: individual,
                                        ),
                                      );

                                      if ((tasks ?? []).isEmpty) {
                                        // TODO: Add eligibility page
                                        context.router.push(
                                          EligibilityChecklistViewRoute(
                                            projectBeneficiaryClientReferenceId:
                                                projectBeneficiaryClientReferenceId,
                                            individual: individual,
                                          ),
                                        );
                                      } else {
                                        var successfulTask = tasks!
                                            .where(
                                              (element) =>
                                                  element.status ==
                                                  Status.administeredSuccess
                                                      .toValue(),
                                            )
                                            .lastOrNull;
                                        if (redosePendingStatus) {
                                          final spaq1 = context.spaq1;

                                          int doseCount = double.parse(
                                            successfulTask!
                                                .resources!.first.quantity!,
                                          ).round();

                                          if (spaq1 >= doseCount) {
                                            context.router.push(
                                              RecordRedoseRoute(
                                                tasks: [successfulTask!],
                                              ),
                                            );
                                          } else {
                                            DigitDialog.show(
                                              context,
                                              options: DigitDialogOptions(
                                                titleText:
                                                    localizations.translate(
                                                  i18.beneficiaryDetails
                                                      .insufficientStockHeading,
                                                ),
                                                titleIcon: Icon(
                                                  Icons.warning,
                                                  color: DigitTheme.instance
                                                      .colorScheme.error,
                                                ),
                                                contentText:
                                                    "${localizations.translate(
                                                  i18.beneficiaryDetails
                                                      .insufficientAZTStockMessageDelivery,
                                                )}=$spaq1${localizations.translate(
                                                  i18.beneficiaryDetails
                                                      .beneficiaryDoseUnit,
                                                )}",
                                                primaryAction:
                                                    DigitDialogActions(
                                                  label: localizations
                                                      .translate(i18_local
                                                          .beneficiaryDetails
                                                          .backToHouseholdDetails),
                                                  action: (ctx) {
                                                    Navigator.of(
                                                      ctx,
                                                      rootNavigator: true,
                                                    ).pop();
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          context.router.push(
                                            BeneficiaryDetailsRoute(),
                                          );
                                        }
                                      }
                                    },
                                  )
                                : const Offstage(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


// class CustomMemberCard extends StatelessWidget {
//   final String name;
//   final String? gender;
//   final int? years;
//   final int? months;
//   final bool isHead;
//   final IndividualModel individual;
//   final List<ProjectBeneficiaryModel>? projectBeneficiaries;
//   final bool isDelivered;

//   final VoidCallback setAsHeadAction;
//   final VoidCallback editMemberAction;
//   final VoidCallback deleteMemberAction;
//   final RegistrationDeliveryLocalization localizations;
//   final List<TaskModel>? tasks;
//   final List<SideEffectModel>? sideEffects;
//   final bool isNotEligible;
//   final bool isBeneficiaryRefused;
//   final bool isBeneficiaryReferred;
//   final bool isBeneficiaryIneligible;
//   final String? projectBeneficiaryClientReferenceId;

//   const CustomMemberCard({
//     super.key,
//     required this.individual,
//     required this.name,
//     this.gender,
//     this.years,
//     this.isHead = false,
//     this.months,
//     required this.localizations,
//     required this.isDelivered,
//     required this.setAsHeadAction,
//     required this.editMemberAction,
//     required this.deleteMemberAction,
//     this.projectBeneficiaries,
//     this.tasks,
//     this.isNotEligible = false,
//     this.projectBeneficiaryClientReferenceId,
//     this.isBeneficiaryRefused = false,
//     this.isBeneficiaryReferred = false,
//     this.isBeneficiaryIneligible = false,
//     this.sideEffects,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final beneficiaryType = RegistrationDeliverySingleton().beneficiaryType;
//     final doseStatus = checkStatus(tasks, context.selectedCycle);
//     final assessmentPendingStatus = assessmentPending(tasks);
//     final redosePendingStatus = assessmentPendingStatus
//         ? true
//         : redosePending(tasks, context.selectedCycle);

//     return Container(
//       decoration: BoxDecoration(
//         color: DigitTheme.instance.colorScheme.background,
//         border: Border.all(
//           color: DigitTheme.instance.colorScheme.outline,
//           width: 1,
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(4.0),
//         ),
//       ),
//       margin: DigitTheme.instance.containerMargin,
//       padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   individual.identifiers != null
//                       ? Padding(
//                           padding: const EdgeInsets.all(kPadding),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: DigitTheme.instance.colorScheme.primary,
//                               ),
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(kPadding),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(
//                                 kPadding,
//                               ),
//                               child: Text(
//                                 individual.identifiers!
//                                         .lastWhere(
//                                           (e) =>
//                                               e.identifierType ==
//                                               IdentifierTypes
//                                                   .uniqueBeneficiaryID
//                                                   .toValue(),
//                                         )
//                                         .identifierId ??
//                                     localizations
//                                         .translate(i18.common.noResultsFound),
//                                 style: theme.textTheme.headlineSmall,
//                               ),
//                             ),
//                           ),
//                         )
//                       : const Offstage(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width / 1.8,
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: kPadding, top: kPadding),
//                           child: Text(
//                             name,
//                             style: theme.textTheme.headlineMedium,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               (tasks ?? [])
//                           .where(
//                             (element) =>
//                                 element.status ==
//                                 Status.administeredSuccess.toValue(),
//                           )
//                           .lastOrNull ==
//                       null
//                   ? Positioned(
//                       child: Align(
//                         alignment: Alignment.topRight,
//                         child: DigitIconButton(
//                           buttonDisabled: (projectBeneficiaries ?? []).isEmpty,
//                           onPressed: (projectBeneficiaries ?? []).isEmpty
//                               ? null
//                               : () => DigitActionDialog.show(
//                                     context,
//                                     widget: ActionCard(
//                                       items: [
//                                         ActionCardModel(
//                                           icon: Icons.edit,
//                                           label: localizations.translate(
//                                             i18.memberCard
//                                                 .editIndividualDetails,
//                                           ),
//                                           action: editMemberAction,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                           iconText: localizations.translate(
//                             i18.memberCard.editDetails,
//                           ),
//                           icon: Icons.edit,
//                         ),
//                       ),
//                     )
//                   : const Offstage()
//             ],
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width / 1.8,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   margin: DigitTheme.instance.containerMargin,
//                   child: Text(
//                     gender != null
//                         ? localizations
//                             .translate('CORE_COMMON_${gender?.toUpperCase()}')
//                         : ' -- ',
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     years != null && months != null
//                         ? " | $years ${localizations.translate(i18.memberCard.deliverDetailsYearText)} $months ${localizations.translate(i18.memberCard.deliverDetailsMonthsText)}"
//                         : "|   --",
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: kPadding / 2,
//             ),
//             child: Offstage(
//               offstage: beneficiaryType != BeneficiaryType.individual,
//               child: !isDelivered ||
//                       isNotEligible ||
//                       isBeneficiaryRefused ||
//                       isBeneficiaryIneligible ||
//                       isBeneficiaryReferred
//                   ? Align(
//                       alignment: Alignment.centerLeft,
//                       child: DigitIconButton(
//                         icon: Icons.info_rounded,
//                         iconSize: 20,
//                         iconText: localizations.translate(
//                           isHead
//                               ? i18_local.householdOverView
//                                   .householdOverViewHouseholderHeadLabel
//                               : (isNotEligible || isBeneficiaryIneligible)
//                                   ? i18.householdOverView
//                                       .householdOverViewNotEligibleIconLabel
//                                   : isBeneficiaryReferred
//                                       ? i18.householdOverView
//                                           .householdOverViewBeneficiaryReferredLabel
//                                       : isBeneficiaryRefused
//                                           ? i18_local.householdOverView
//                                               .householdOverViewBeneficiaryRefusedLabel
//                                           : i18.householdOverView
//                                               .householdOverViewNotDeliveredIconLabel,
//                         ),
//                         iconTextColor: theme.colorScheme.error,
//                         iconColor: theme.colorScheme.error,
//                       ),
//                     )
//                   : Align(
//                       alignment: Alignment.centerLeft,
//                       child: DigitIconButton(
//                         icon: Icons.check_circle,
//                         iconText: localizations.translate(
//                           i18.householdOverView
//                               .householdOverViewDeliveredIconLabel,
//                         ),
//                         iconSize: 20,
//                         iconTextColor:
//                             DigitTheme.instance.colorScheme.onSurfaceVariant,
//                         iconColor:
//                             DigitTheme.instance.colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//             ),
//           ),
//           Offstage(
//             offstage: beneficiaryType != BeneficiaryType.individual ||
//                 isNotEligible ||
//                 isBeneficiaryRefused ||
//                 isBeneficiaryIneligible ||
//                 isBeneficiaryReferred,
//             child: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Column(
//                 children: [
//                   (isNotEligible ||
//                               isBeneficiaryRefused ||
//                               isBeneficiaryIneligible ||
//                               isBeneficiaryReferred) &&
//                           doseStatus
//                       ? const Offstage()
//                       : !isNotEligible && redosePendingStatus
//                           ? DigitElevatedButton(
//                               onPressed: (projectBeneficiaries ?? []).isEmpty
//                                   ? null
//                                   : () {
//                                       final bloc =
//                                           context.read<HouseholdOverviewBloc>();

//                                       bloc.add(
//                                         HouseholdOverviewEvent
//                                             .selectedIndividual(
//                                           individualModel: individual,
//                                         ),
//                                       );
//                                       bloc.add(HouseholdOverviewReloadEvent(
//                                         projectId:
//                                             RegistrationDeliverySingleton()
//                                                 .projectId!,
//                                         projectBeneficiaryType:
//                                             RegistrationDeliverySingleton()
//                                                     .beneficiaryType ??
//                                                 BeneficiaryType.individual,
//                                       ));

//                                       //TODO: Add eligibility page
//                                       // if ((tasks ?? []).isEmpty) {
//                                       //   context.router
//                                       //       .push(EligibilityChecklistViewRoute(
//                                       //     projectBeneficiaryClientReferenceId:
//                                       //         projectBeneficiaryClientReferenceId,
//                                       //     individual: individual,
//                                       //   ));
//                                       // } else {
//                                       //   context.router
//                                       //       .push(BeneficiaryDetailsRoute());
//                                       // }
//                                     },
//                               child: Center(
//                                 child: Text(
//                                   allDosesDelivered(
//                                             tasks,
//                                             context.selectedCycle,
//                                             sideEffects,
//                                             individual,
//                                           ) &&
//                                           !doseStatus
//                                       ? localizations.translate(
//                                           i18.householdOverView
//                                               .viewDeliveryLabel,
//                                         )
//                                       : localizations.translate(
//                                           i18.householdOverView
//                                               .householdOverViewActionText,
//                                         ),
//                                 ),
//                               ),
//                             )
//                           : const Offstage(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
