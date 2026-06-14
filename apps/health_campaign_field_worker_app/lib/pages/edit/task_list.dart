import 'dart:async';

import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/digit_search_bar.dart';
import 'package:digit_ui_components/widgets/atoms/switch.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../data/repositories/custom_task.dart';
import '../../models/entities/additional_fields_type.dart';
import '../../models/entities/identifier_types.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/upper_case.dart';
import '../../widgets/header/back_navigation_help_header.dart';
import '../../widgets/localized.dart';

@RoutePage()
class TaskListPage extends LocalizedStatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends LocalizedState<TaskListPage> {
  late Future<List<TaskModel>> _tasksFuture;
  final Map<String, IndividualModel?> _individualsByTask = {};
  final TextEditingController searchController = TextEditingController();
  bool _isSearchEnabled = false;
  String _searchQuery = '';
  List<TaskModel> _allTasks = [];
  List<TaskModel> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _tasksFuture = _fetchTasksWithIndividual();
    _subscribeToTaskChanges();
  }

  Future<List<TaskModel>> _fetchTasksWithIndividual() async {
    final taskDataRepository =
        context.read<LocalRepository<TaskModel, TaskSearchModel>>()
            as CustomTaskLocalRepository;

    List<TaskModel> tasks = await taskDataRepository.search(TaskSearchModel(
      createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
    ));

    tasks = tasks.where((task) {
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

    for (final task in tasks) {
      final individual = await _fetchIndividualForTask(task);
      _individualsByTask[task.id ?? task.projectBeneficiaryClientReferenceId!] =
          individual;
    }

    _allTasks = tasks;
    _filteredTasks = tasks;
    return tasks;
  }

  void _subscribeToTaskChanges() {
    final taskDataRepository =
        context.read<LocalRepository<TaskModel, TaskSearchModel>>()
            as CustomTaskLocalRepository;

    taskDataRepository.listenToChanges(
      query: TaskSearchModel(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
      ),
      listener: (data) {
        _onTasksChanged(data);
      },
    );
  }

  Future<void> _onTasksChanged(List<TaskModel> data) async {
    List<TaskModel> tasks = data.where((task) {
      if (task.isDeleted == true) return false;
      if (task.clientAuditDetails?.createdBy !=
          RegistrationDeliverySingleton().loggedInUserUuid) {
        return false;
      }

      final doseIndexField = task.additionalFields?.fields.firstWhereOrNull(
        (field) => field.key == AdditionalFieldsType.doseIndex.toValue(),
      );

      return doseIndexField == null || doseIndexField.value == "01";
    }).toList();

    final Map<String, IndividualModel?> newIndividualsByTask = {};
    await Future.wait(tasks.map((task) async {
      final ind = await _fetchIndividualForTask(task);
      newIndividualsByTask[
          task.id ?? task.projectBeneficiaryClientReferenceId!] = ind;
    }));

    if (!mounted) return;
    setState(() {
      _individualsByTask
        ..clear()
        ..addAll(newIndividualsByTask);
      _allTasks = tasks;
      // Re-apply current search filter
      if (_isSearchEnabled && _searchQuery.isNotEmpty) {
        _filterTasksByBeneficiaryId(_searchQuery);
      } else {
        _filteredTasks = tasks;
      }
    });
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
      debugPrint('Error fetching individual: $e');
    }
    return null;
  }

  void _filterTasksByBeneficiaryId(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _filteredTasks = _allTasks;
      } else if (_searchQuery.length == 14 &&
          isBeneficiaryIdValid(_searchQuery)) {
        _filteredTasks = _allTasks.where((task) {
          final individual = _individualsByTask[
              task.id ?? task.projectBeneficiaryClientReferenceId!];
          final beneficiaryId =
              individual?.identifiers?.first.identifierId ?? '';
          return beneficiaryId.toLowerCase() == _searchQuery.toLowerCase();
        }).toList();
      } else {
        _filteredTasks = _allTasks;
      }
    });
  }

  void _toggleSearch(bool value) {
    setState(() {
      _isSearchEnabled = value;
      _searchQuery = '';
      _filteredTasks = _allTasks;
    });
  }

  bool isBeneficiaryIdValid(String value) {
    final pattern = RegExp(r'^[A-Za-z0-9]{4}-[A-Za-z0-9]{4}-[A-Za-z0-9]{4}$');
    return pattern.hasMatch(value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      backgroundColor: theme.colorTheme.generic.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const BackNavigationHelpHeaderWidget(showHelp: false),
          Padding(
            padding: const EdgeInsets.fromLTRB(spacer4, spacer2, spacer4, spacer2),
            child: Text(
              localizations.translate(i18.editTasks.editTasksTitle),
              style: textTheme.headingXl.copyWith(
                color: theme.colorTheme.primary.primary2,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorTheme.primary.primary2,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(spacer4),
                      child: Text(
                        'Error loading tasks: ${snapshot.error}',
                        style: textTheme.bodyL.copyWith(
                          color: theme.colorTheme.alert.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final tasks = _filteredTasks;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: spacer4),
                      child: Row(
                        children: [
                          DigitSwitch(
                            mainAxisAlignment: MainAxisAlignment.start,
                            label: localizations
                                .translate(i18.editTasks.enableSearchLabel),
                            value: _isSearchEnabled,
                            onChanged: (value) {
                              _toggleSearch(value);
                              if (!value) {
                                searchController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    if (_isSearchEnabled)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          spacer4,
                          spacer2,
                          spacer4,
                          spacer2,
                        ),
                        child: DigitSearchBar(
                          inputFormatters: [UpperCaseTextFormatter()],
                          controller: searchController,
                          icon: Icon(
                            Icons.search,
                            color: theme.colorTheme.primary.primary2,
                          ),
                          hintText: localizations.translate(
                            i18.editTasks.searchByBeneficiaryIdLabel,
                          ),
                          textCapitalization: TextCapitalization.characters,
                          onChanged: _filterTasksByBeneficiaryId,
                        ),
                      ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (tasks.isEmpty) {
                            if (_isSearchEnabled &&
                                _searchQuery.isNotEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(spacer4),
                                  child: Text(
                                    '${localizations.translate(i18.editTasks.noMatchFound)} "$_searchQuery"',
                                    style: textTheme.bodyL.copyWith(
                                      color: theme.colorTheme.text.secondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(spacer4),
                                child: Text(
                                  localizations.translate(
                                    i18.editTasks.noTasksFound,
                                  ),
                                  style: textTheme.bodyL.copyWith(
                                    color: theme.colorTheme.text.secondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              spacer4,
                              0,
                              spacer4,
                              spacer4,
                            ),
                            itemCount: tasks.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: spacer2),
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              final individual = _individualsByTask[task.id ??
                                  task.projectBeneficiaryClientReferenceId!];

                              return DigitCard(
                                margin: EdgeInsets.zero,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                onPressed: () {
                                  context.router
                                      .push(
                                        TaskDetailRoute(
                                          taskModel: task,
                                          individualModel: _individualsByTask[
                                              task.id ??
                                                  task.projectBeneficiaryClientReferenceId!],
                                        ),
                                      )
                                      .then((_) => setState(() =>
                                          _tasksFuture =
                                              _fetchTasksWithIndividual()));
                                },
                                children: [
                                  Text(
                                    (() {
                                      final fields =
                                          task.additionalFields?.fields ??
                                              const [];
                                      String? cycleIndex;
                                      String? doseIndex;
                                      for (final f in fields) {
                                        if (f.key == 'cycleIndex' &&
                                            (f.value?.toString().isNotEmpty ??
                                                false)) {
                                          cycleIndex = f.value.toString();
                                        }
                                        if (f.key == 'doseIndex' &&
                                            (f.value?.toString().isNotEmpty ??
                                                false)) {
                                          doseIndex = f.value.toString();
                                        }
                                      }
                                      String suffix;
                                      if (cycleIndex != null ||
                                          doseIndex != null) {
                                        final sep = (cycleIndex != null &&
                                                doseIndex != null)
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
                                  if (individual != null) ...{
                                    if (individual.name?.givenName != null ||
                                        individual.name?.familyName !=
                                            null) ...[
                                      const SizedBox(height: spacer1),
                                      Text(
                                        '${localizations.translate(i18.editTasks.nameLabel)}: ${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}'
                                            .trim(),
                                        style: textTheme.bodyL.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorTheme.text.secondary,
                                        ),
                                      ),
                                    ],
                                    if (individual.identifiers != null &&
                                        individual.identifiers!.isNotEmpty &&
                                        individual.identifiers?.first
                                                .identifierType ==
                                            IdentifierTypes.uniqueBeneficiaryID
                                                .toValue()) ...[
                                      const SizedBox(height: spacer1),
                                      Text(
                                        '${localizations.translate(i18.editTasks.beneficiaryIdLabel)}: ${_individualsByTask[task.id ?? task.projectBeneficiaryClientReferenceId!]?.identifiers?.first.identifierId}',
                                        style: textTheme.bodyL.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorTheme.text.secondary,
                                        ),
                                      ),
                                    ],
                                  },
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
                                          task.status,
                                        ),
                                        _buildTaskField(
                                          context,
                                          i18.editTasks.createdByLabel,
                                          task.createdBy,
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
                                      localizations.translate(
                                        i18.editTasks.tapToViewOrEdit,
                                      ),
                                      style: textTheme.bodyS.copyWith(
                                        color: theme.colorTheme.primary.primary1,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
    if (value == null) return null;

    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Container(
      margin: const EdgeInsets.only(right: spacer4),
      padding: const EdgeInsets.symmetric(horizontal: spacer3, vertical: spacer2),
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
            value,
            style: textTheme.bodyS.copyWith(
              color: theme.colorTheme.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
