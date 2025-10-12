import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../data/repositories/custom_task.dart';
import '../../models/entities/identifier_types.dart';
import 'task_details.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late Future<List<TaskModel>> _tasksFuture;
  final Map<String, IndividualModel?> _individualsByTask =
      {}; // Store related individuals

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasksWithIndividual();
  }

  Future<List<TaskModel>> _fetchTasksWithIndividual() async {
    final taskDataRepository =
        context.read<LocalRepository<TaskModel, TaskSearchModel>>()
            as CustomTaskLocalRepository;

    List<TaskModel> tasks = await taskDataRepository.search(TaskSearchModel(
      createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
    ));

    tasks = tasks
        .where((task) =>
            task.isDeleted != true &&
            task.clientAuditDetails?.createdBy ==
                RegistrationDeliverySingleton().loggedInUserUuid)
        .toList();

    // For each task, fetch the related Individual (if exists)
    for (final task in tasks) {
      final individual = await _fetchIndividualForTask(task);
      _individualsByTask[task.id ?? task.projectBeneficiaryClientReferenceId!] =
          individual;
    }

    return tasks;
  }

  Future<IndividualModel?> _fetchIndividualForTask(TaskModel task) async {
    if (task.projectBeneficiaryClientReferenceId == null ||
        task.projectBeneficiaryClientReferenceId!.isEmpty) {
      return null;
    }

    final projectBeneficiaryRepository = context.read<
        LocalRepository<ProjectBeneficiaryModel,
            ProjectBeneficiarySearchModel>>();

    final individualRepository =
        context.read<LocalRepository<IndividualModel, IndividualSearchModel>>();

    try {
      final beneficiaries = await projectBeneficiaryRepository.search(
        ProjectBeneficiarySearchModel(
          isDeleted: false,
          clientReferenceId: [task.projectBeneficiaryClientReferenceId!],
        ),
      );

      if (beneficiaries.isNotEmpty) {
        final beneficiary = beneficiaries.first;
        if (beneficiary.beneficiaryClientReferenceId != null) {
          final individuals = await individualRepository.search(
            IndividualSearchModel(
              clientReferenceId: [beneficiary.beneficiaryClientReferenceId!],
              isDeleted: false,
            ),
          );
          if (individuals.isNotEmpty) {
            return individuals.first;
          }
        }
      }
    } catch (e) {
      // Handle errors if necessary
      debugPrint('Error fetching individual: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Task Entries')),
      body: FutureBuilder<List<TaskModel>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              IndividualModel? individual = _individualsByTask[
                  task.id ?? task.projectBeneficiaryClientReferenceId!];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailPage(
                          taskModel: task,
                          individualModel: _individualsByTask[task.id ??
                              task.projectBeneficiaryClientReferenceId!],
                        ),
                      ),
                    ).then((_) => setState(
                        () => _tasksFuture = _fetchTasksWithIndividual()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task #${task.id ?? task.clientReferenceId}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (individual != null) ...{
                          if (individual.name?.givenName != null ||
                              individual.name?.familyName != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Name: ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
                                  .trim(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                          if (individual.identifiers != null &&
                              individual.identifiers!.isNotEmpty &&
                              individual.identifiers?.first.identifierType ==
                                  IdentifierTypes.uniqueBeneficiaryID
                                      .toValue()) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Beneficiary ID: ${_individualsByTask[task.id ?? task.projectBeneficiaryClientReferenceId!]?.identifiers?.first.identifierId}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        },
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTaskField('ID', task.id?.toString()),
                              _buildTaskField(
                                  'Client Ref ID', task.clientReferenceId),
                              _buildTaskField('Project ID', task.projectId),
                              _buildTaskField('Status', task.status),
                              _buildTaskField('Created By', task.createdBy),
                              _buildTaskField('Tenant ID', task.tenantId),
                            ]
                                .where((widget) => widget != null)
                                .cast<Widget>()
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Tap to View/Edit',
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
          );
        },
      ),
    );
  }

  Widget? _buildTaskField(String label, String? value) {
    if (value == null) return null;

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
            label,
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
