import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../models/entities/additional_fields_type.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../router/app_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final individual = widget.individual;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (individual.name?.givenName != null)
              ? '${localizations.translate(i18.editTasks.tasksForLabel)} ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
              : localizations.translate(i18.editTasks.individualTasksTitle),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                localizations
                    .translate(i18.editTasks.noTasksFoundForIndividual),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      await context.router
                          .push(
                            TaskDetailRoute(
                              taskModel: task,
                              individualModel: individual,
                            ),
                          )
                          .then((_) => setState(() => _tasks = _filterTasks()));
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => TaskDetailPage(
                      //       taskModel: task,
                      //       individualModel: individual,
                      //     ),
                      //   ),
                      // );
                      // setState(() {}); // Refresh UI after returning
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                suffix =
                                    '${cycleIndex ?? ''}$sep${doseIndex ?? ''}';
                              } else {
                                suffix = task.clientReferenceId;
                              }
                              return '${localizations.translate(i18.editTasks.taskLabel)} #$suffix';
                            })(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (individual.name?.givenName != null ||
                              individual.name?.familyName != null)
                            Text(
                              '${localizations.translate(i18.editTasks.nameLabel)}: ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
                                  .trim(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          if (individual.identifiers != null &&
                              individual.identifiers!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${localizations.translate(i18.editTasks.beneficiaryIdLabel)}: ${individual.identifiers?.first.identifierId ?? ''}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildTaskField(
                                    i18.editTasks.idLabel, task.id?.toString()),
                                _buildTaskField(i18.editTasks.clientRefIdLabel,
                                    task.clientReferenceId),
                                _buildTaskField(i18.editTasks.projectIdLabel,
                                    task.projectId ?? ''),
                                _buildTaskField(i18.editTasks.statusLabel,
                                    task.status ?? 'N/A'),
                                _buildTaskField(i18.editTasks.createdByLabel,
                                    task.createdBy ?? ''),
                                _buildTaskField(i18.editTasks.tenantIdLabel,
                                    task.tenantId ?? ''),
                              ]
                                  .where((widget) => widget != null)
                                  .cast<Widget>()
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              localizations
                                  .translate(i18.editTasks.tapToViewOrEdit),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget? _buildTaskField(String label, String? value) {
    if (value == null || value.isEmpty) return null;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate(label),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
