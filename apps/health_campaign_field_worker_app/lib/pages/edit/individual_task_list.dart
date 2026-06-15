import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../data/repositories/custom_task.dart';
import '../../models/entities/additional_fields_type.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

@RoutePage()
class IndividualTaskListPage extends LocalizedStatefulWidget {
  final IndividualModel individual;
  final List<TaskModel> tasks;

  const IndividualTaskListPage({
    super.key,
    required this.individual,
    required this.tasks,
  });

  @override
  State<IndividualTaskListPage> createState() => _IndividualTaskListPageState();
}

class _IndividualTaskListPageState
    extends LocalizedState<IndividualTaskListPage> {
  late List<TaskModel> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _filterTasks();
    _subscribeToTaskChanges();
  }

  List<TaskModel> _filterTasks() {
    return widget.tasks.where((task) {
      if (task.isDeleted == true) return false;
      if (task.clientAuditDetails?.createdBy !=
          RegistrationDeliverySingleton().loggedInUserUuid) {
        return false;
      }

      final doseIndexField = task.additionalFields?.fields.firstWhereOrNull(
        (field) => field.key == AdditionalFieldsType.doseIndex.toValue(),
      );

      // Include if doseIndex not present OR value equals 01
      return doseIndexField == null || doseIndexField.value == "01";
    }).toList();
  }

  void _subscribeToTaskChanges() {
    final taskDataRepository =
        context.read<LocalRepository<TaskModel, TaskSearchModel>>()
            as CustomTaskLocalRepository;

    final allowedBeneficiaryRefs = widget.tasks
        .map((t) => t.projectBeneficiaryClientReferenceId)
        .whereNotNull()
        .toSet();

    taskDataRepository.listenToChanges(
      query: TaskSearchModel(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
      ),
      listener: (data) {
        final filtered = data.where((task) {
          if (task.isDeleted == true) return false;
          if (task.clientAuditDetails?.createdBy !=
              RegistrationDeliverySingleton().loggedInUserUuid) {
            return false;
          }
          if (task.projectBeneficiaryClientReferenceId == null) return false;
          if (!allowedBeneficiaryRefs
              .contains(task.projectBeneficiaryClientReferenceId)) {
            return false;
          }
          final doseIndexField = task.additionalFields?.fields.firstWhereOrNull(
            (field) => field.key == AdditionalFieldsType.doseIndex.toValue(),
          );
          return doseIndexField == null || doseIndexField.value == "01";
        }).toList();

        if (!mounted) return;
        setState(() => _tasks = filtered);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final individual = widget.individual;
    final titleText = (individual.name?.givenName != null)
        ? '${localizations.translate(i18.editTasks.tasksForLabel)} ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
        : localizations.translate(i18.editTasks.individualTasksTitle);

    return Scaffold(
      backgroundColor: theme.colorTheme.generic.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BackNavigationHelpHeaderWidget(showHelp: false),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(spacer4, spacer2, spacer4, spacer2),
            child: Text(
              titleText,
              style: textTheme.headingXl.copyWith(
                color: theme.colorTheme.primary.primary2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(spacer4),
                      child: Text(
                        localizations.translate(
                          i18.editTasks.noTasksFoundForIndividual,
                        ),
                        style: textTheme.bodyL.copyWith(
                          color: theme.colorTheme.text.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(spacer4, 0, spacer4, spacer4),
                    itemCount: _tasks.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: spacer2),
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return DigitCard(
                        margin: EdgeInsets.zero,
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        onPressed: () async {
                          await context.router
                              .push(
                                TaskDetailRoute(
                                  taskModel: task,
                                  individualModel: individual,
                                ),
                              )
                              .then((_) =>
                                  setState(() => _tasks = _filterTasks()));
                        },
                        children: [
                          Text(
                            (() {
                              final fields =
                                  task.additionalFields?.fields ?? const [];
                              String? cycleIndex;
                              String? doseIndex;
                              for (final f in fields) {
                                if (f.key == 'cycleIndex' &&
                                    (f.value?.toString().isNotEmpty ?? false)) {
                                  cycleIndex = f.value.toString();
                                }
                                if (f.key == 'doseIndex' &&
                                    (f.value?.toString().isNotEmpty ?? false)) {
                                  doseIndex = f.value.toString();
                                }
                              }
                              String suffix;
                              if (cycleIndex != null || doseIndex != null) {
                                final sep =
                                    (cycleIndex != null && doseIndex != null)
                                        ? ' -- '
                                        : '';
                                suffix = (cycleIndex != null &&
                                        doseIndex != null)
                                    ? '${localizations.translate(i18.beneficiaryDetails.beneficiaryCycle)} $cycleIndex $sep ${localizations.translate(i18.deliverIntervention.dose)} $doseIndex'
                                    : ((cycleIndex != null)
                                        ? '${localizations.translate(i18.beneficiaryDetails.beneficiaryCycle)} $cycleIndex'
                                        : '${localizations.translate(i18.deliverIntervention.dose)} ${doseIndex ?? ''}');
                              } else {
                                suffix = task.clientReferenceId;
                              }
                              return '${localizations.translate(i18.editTasks.taskLabel)} #$suffix';
                            })(),
                            style: textTheme.headingM.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorTheme.text.primary,
                            ),
                          ),
                          const SizedBox(height: spacer2),
                          if (individual.name?.givenName != null ||
                              individual.name?.familyName != null)
                            Text(
                              '${localizations.translate(i18.editTasks.nameLabel)}: ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
                                  .trim(),
                              style: textTheme.bodyL.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorTheme.text.secondary,
                              ),
                            ),
                          if (individual.identifiers != null &&
                              individual.identifiers!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: spacer1),
                              child: Text(
                                '${localizations.translate(i18.editTasks.beneficiaryIdLabel)}: ${individual.identifiers?.first.identifierId ?? ''}',
                                style: textTheme.bodyL.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorTheme.text.secondary,
                                ),
                              ),
                            ),
                          const SizedBox(height: spacer3),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTaskField(
                                  context,
                                  i18.editTasks.idLabel,
                                  task.id?.toString(),
                                ),
                                _buildTaskField(
                                  context,
                                  i18.editTasks.statusLabel,
                                  task.status ?? 'N/A',
                                ),
                                _buildTaskField(
                                  context,
                                  i18.editTasks.createdByLabel,
                                  task.createdBy ?? '',
                                ),
                              ]
                                  .where((widget) => widget != null)
                                  .cast<Widget>()
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: spacer2),
                            child: Text(
                              localizations
                                  .translate(i18.editTasks.tapToViewOrEdit),
                              style: textTheme.bodyS.copyWith(
                                color: theme.colorTheme.primary.primary1,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget? _buildTaskField(
    BuildContext context,
    String label,
    String? value,
  ) {
    if (value == null || value.isEmpty) return null;

    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Container(
      margin: const EdgeInsets.only(right: spacer4),
      padding:
          const EdgeInsets.symmetric(horizontal: spacer3, vertical: spacer2),
      decoration: BoxDecoration(
        color: theme.colorTheme.paper.secondary,
        borderRadius: BorderRadius.circular(spacer2),
        border: Border.all(color: theme.colorTheme.generic.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate(label),
            style: textTheme.bodyS.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorTheme.text.secondary,
            ),
          ),
          const SizedBox(height: spacer1),
          Text(
            localizations.translate(value),
            style: textTheme.bodyS.copyWith(
              color: theme.colorTheme.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
