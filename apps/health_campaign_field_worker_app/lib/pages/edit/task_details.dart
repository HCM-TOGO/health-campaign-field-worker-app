import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/models/DropdownModels.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/theme/spacers.dart';
import 'package:digit_ui_components/digit_components.dart' hide LabeledField;
import 'package:digit_ui_components/utils/date_utils.dart';
import 'package:digit_ui_components/widgets/atoms/digit_dropdown_input.dart'
    as digit_ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../../models/entities/additional_fields_type.dart'
    as additional_fields_local;
import '../../../models/entities/assessment_checklist/status.dart';
import '../../../utils/utils.dart' as local_utils;
import '../../blocs/localization/app_localization.dart';
import '../../data/repositories/custom_task.dart';
import '../../models/entities/additional_fields_type.dart';
import '../../models/entities/identifier_types.dart';
import '../../utils/app_enums.dart';
import '../../utils/constants.dart';
import '../../utils/environment_config.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../widgets/digit_ui_component/custom_digit_input_field.dart';
import '../../widgets/localized.dart';

@RoutePage()
class TaskDetailPage extends LocalizedStatefulWidget {
  final TaskModel taskModel;
  final IndividualModel? individualModel;

  const TaskDetailPage(
      {super.key, required this.taskModel, this.individualModel});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends LocalizedState<TaskDetailPage> {
  late Map<String, TextEditingController> _controllers;
  late TaskModel _originalTask;
  late IndividualModel? _individual;
  late TaskAdditionalFields? _additionalFields;
  late TextEditingController _schemaController;
  late TextEditingController _versionController;
  late Map<String, TextEditingController> _additionalFieldControllers;
  late Map<String, TextEditingController> _resourceControllers;
  late TextEditingController _deleteReasonController;
  late TextEditingController _updateReasonController;
  late Map<String, TextEditingController> _hiddenIdControllers;

  bool _saving = false;
  late bool showResources;

  static const _hiddenAdditionalFieldKeys = {
    'dateOfAdministration',
    'dateOfVerification',
  };

  static const _editableAdditionalFieldKeys = {'name', 'age'};

  static const _genderFieldKey = 'gender';

  static const _datePickerAdditionalFieldKeys = {'dateOfDelivery'};

  List<String> allowedStatuses = [
    Status.delivered.toValue(),
    Status.administeredSuccess.toValue(),
    Status.beneficiaryReferred.toValue(),
    Status.beneficiaryRefused.toValue(),
    Status.beneficiaryInEligible.toValue(),
    Status.notAdministered.toValue(),
  ];

  ProjectTypeModel? projectTypeModel = RegistrationDeliverySingleton()
      .selectedProject
      ?.additionalDetails
      ?.projectType;

  // Get all DeliveryProductVariants from project type
  List<DeliveryProductVariant>? productVariants;

  @override
  void initState() {
    super.initState();
    _originalTask = widget.taskModel;
    _individual = widget.individualModel;
    _additionalFields = widget.taskModel.additionalFields;

    if (_originalTask.status != Status.delivered.toValue()) {
      allowedStatuses.remove(Status.delivered.toValue());
    }

    productVariants = projectTypeModel?.resources
        ?.map(
            (r) => DeliveryProductVariant(productVariantId: r.productVariantId))
        .toList();

    showResources = _originalTask.resources != null &&
        (_originalTask.status == Status.administeredSuccess.toValue() ||
            _originalTask.status == Status.delivered.toValue());

    // Initialize controllers for basic task fields
    _controllers = {
      'status': TextEditingController(text: _originalTask.status ?? ''),
      'createdBy': TextEditingController(text: _originalTask.createdBy ?? ''),
      'isDeleted': TextEditingController(
          text: _originalTask.isDeleted?.toString() ?? ''),
      'createdDate': TextEditingController(
          text: _originalTask.createdDate?.toString() ?? ''),
    };

    // Initialize hidden ID controllers
    _hiddenIdControllers = {
      'id': TextEditingController(text: _originalTask.id?.toString() ?? ''),
    };

    // Initialize resource controllers
    _resourceControllers = {};
    if (_originalTask.resources != null &&
        _originalTask.resources!.isNotEmpty) {
      for (int i = 0; i < _originalTask.resources!.length; i++) {
        final resource = _originalTask.resources![i];
        _resourceControllers['resource_${i}_id'] =
            TextEditingController(text: resource.id.toString());
        _resourceControllers['resource_${i}_productVariantId'] =
            TextEditingController(text: resource.productVariantId.toString());
        _resourceControllers['resource_${i}_taskId'] =
            TextEditingController(text: resource.taskId.toString());
        _resourceControllers['resource_${i}_deliveryComment'] =
            TextEditingController(text: resource.deliveryComment);
        _resourceControllers['resource_${i}_quantity'] =
            TextEditingController(text: resource.quantity.toString());
        _resourceControllers['resource_${i}_isDelivered'] =
            TextEditingController(text: resource.isDelivered.toString());
      }
    } else {
      _resourceControllers['resource_${0}_productVariantId'] =
          TextEditingController(text: '');
    }

    // Initialize delete reason controller
    _deleteReasonController = TextEditingController();

    // Initialize update reason controller
    _updateReasonController = TextEditingController();

    // Additional field controllers
    _schemaController =
        TextEditingController(text: _additionalFields?.schema ?? '');
    _versionController = TextEditingController(
        text: _additionalFields?.version.toString() ?? '');

    final fieldsList = _additionalFields?.fields ?? [];

    _additionalFieldControllers = {
      for (final field in fieldsList)
        if (!_hiddenAdditionalFieldKeys.contains(field.key))
          field.key: TextEditingController(text: field.value?.toString() ?? '')
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final c in _additionalFieldControllers.values) {
      c.dispose();
    }
    for (final c in _resourceControllers.values) {
      c.dispose();
    }
    _deleteReasonController.dispose();
    _updateReasonController.dispose();
    for (final c in _hiddenIdControllers.values) {
      c.dispose();
    }
    _schemaController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _showSaveDialog() async {
    final theme = Theme.of(context);

    if (_controllers['status']?.text == null ||
        _controllers['status']?.text.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.translate(i18.editTasks.statusRequiredError),
          ),
          backgroundColor: theme.colorTheme.alert.error,
        ),
      );
      return;
    }

    if (showResources &&
        (_resourceControllers['resource_${0}_productVariantId']?.text == null ||
            _resourceControllers['resource_${0}_productVariantId']
                    ?.text
                    .trim() ==
                '')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations
                .translate(i18.editTasks.productVariantIdRequiredError),
          ),
          backgroundColor: theme.colorTheme.alert.error,
        ),
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        final dialogTheme = Theme.of(dialogContext);
        final dialogTextTheme = dialogTheme.digitTextTheme(dialogContext);
        return AlertDialog(
          backgroundColor: dialogTheme.colorTheme.paper.primary,
          title: Text(
            localizations.translate(i18.editTasks.updateDialogTitle),
            style: dialogTextTheme.headingM.copyWith(
              color: dialogTheme.colorTheme.text.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate(i18.editTasks.updateDialogMessage),
                style: dialogTextTheme.bodyL.copyWith(
                  color: dialogTheme.colorTheme.text.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _updateReasonController,
                decoration: InputDecoration(
                  labelText: localizations.translate(i18.editTasks.reasonLabel),
                  hintText:
                      localizations.translate(i18.editTasks.updateReasonHint),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 200, // visually enforce limit too
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.translate(i18.common.coreCommonCancel)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = _updateReasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations
                            .translate(i18.editTasks.updateReasonRequiredError),
                      ),
                      backgroundColor: theme.colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                if (reason.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations
                            .translate(i18.editTasks.reasonMinLengthError),
                      ),
                      backgroundColor: theme.colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                if (reason.length > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations
                            .translate(i18.editTasks.reasonMaxLengthError),
                      ),
                      backgroundColor: theme.colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dialogTheme.colorTheme.primary.primary2,
                foregroundColor: dialogTheme.colorTheme.paper.primary,
              ),
              child: Text(localizations.translate(i18.common.coreCommonSave)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _saveChanges();
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _saving = true);

    try {
      final taskDataRepository =
          context.read<LocalRepository<TaskModel, TaskSearchModel>>()
              as CustomTaskLocalRepository;

      if (_originalTask.status == Status.administeredSuccess.toValue() ||
          _originalTask.status == Status.delivered.toValue()) {
        List<TaskModel> allAdministrationTasks =
            await _getAllCurrentCycleAdministrationTasks(taskDataRepository);

        bool changeStatus = false;
        if (_originalTask.status != _controllers['status']?.text) {
          changeStatus = true;
        }

        for (var task in allAdministrationTasks) {
          TaskModel updatedTask =
              _getUpdatedTask(task, changeStatus: changeStatus);
          // Save using repository
          await taskDataRepository.update(updatedTask);
        }
      } else {
        TaskModel updatedTask = _getUpdatedTask(_originalTask);
        // Save using repository
        await taskDataRepository.update(updatedTask);
      }

      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(i18.editTasks.updateSuccessMessage),
            ),
            backgroundColor: Theme.of(context).colorTheme.alert.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(i18.editTasks.updateErrorMessage),
            ),
            backgroundColor: Theme.of(context).colorTheme.alert.error,
          ),
        );
        debugPrint('Error saving changes: $e');
      }
    }
  }

  TaskModel _getUpdatedTask(TaskModel task, {bool changeStatus = true}) {
    // Get existing fields
    final existingFields = task.additionalFields?.fields ?? [];

    // Handle editCount logic
    final editCountField = existingFields.firstWhere(
      (f) => f.key == 'editCount',
      orElse: () => const AdditionalField('editCount', '0'),
    );
    final currentEditCount = int.tryParse(editCountField.value ?? '0') ?? 0;
    final newEditCount = currentEditCount + 1;

    // Handle updateReason logic
    final updateReasonField = existingFields.firstWhere(
      (f) => f.key == 'updateReason',
      orElse: () => const AdditionalField('updateReason', ''),
    );
    // ignore: avoid_dynamic_calls
    final oldReason = updateReasonField.value?.trim() ?? '';
    final newReason = _updateReasonController.text.trim();
    // ignore: avoid_dynamic_calls
    final combinedReason = oldReason.isNotEmpty
        ? '$oldReason | Edit #$newEditCount: $newReason'
        : 'Edit #$newEditCount: $newReason';

    // Prepare updated fields
    List<AdditionalField> updatedFields =
        existingFields.map((e) => AdditionalField(e.key, e.value)).toList();

    if (_controllers['status']?.text == Status.beneficiaryRefused.toValue() ||
        _controllers['status']?.text == Status.notAdministered.toValue()) {
      // Exclude deliveryType when status is beneficiaryRefused or notAdministered
      updatedFields = updatedFields
          .where((field) =>
              field.key !=
              additional_fields_local.AdditionalFieldsType.deliveryType
                  .toValue())
          .toList();
    } else {
      // Include deliveryType if it's not already present
      final hasDeliveryType = updatedFields.any((field) =>
          field.key ==
          additional_fields_local.AdditionalFieldsType.deliveryType.toValue());

      if (!hasDeliveryType) {
        updatedFields = [
          ...updatedFields,
          AdditionalField(
            additional_fields_local.AdditionalFieldsType.deliveryType.toValue(),
            EligibilityAssessmentStatus.smcDone.name,
          ),
        ];
      }
    }

    // Apply edits from additional field controllers
    updatedFields = updatedFields.map((field) {
      final controller = _additionalFieldControllers[field.key];
      if (controller != null) {
        return AdditionalField(field.key, controller.text);
      }
      return field;
    }).toList();

    // Remove any existing editCount and updateReason before adding updated ones
    updatedFields = updatedFields
        .where((f) => f.key != 'editCount' && f.key != 'updateReason')
        .toList();

    // Now safely append updated editCount and updateReason
    final List<AdditionalField> finalUpdatedFields = [
      ...updatedFields,
      AdditionalField('editCount', newEditCount.toString()),
      AdditionalField('updateReason', combinedReason),
    ];

    // Build new TaskAdditionalFields
    final newAdditionalFields = TaskAdditionalFields(
      schema: _schemaController.text.isNotEmpty
          ? _schemaController.text
          : task.additionalFields?.schema ?? '',
      version: int.tryParse(_versionController.text) ??
          task.additionalFields?.version ??
          1,
      fields: finalUpdatedFields,
    );

    // Build updated TaskResource list from controllers
    final updatedResources = <TaskResourceModel>[];
    final totalResources = task.resources?.length ?? 0;
    if (showResources) {
      if (totalResources == 0) {
        int qty = productVariants
                ?.where((element) =>
                    element.productVariantId ==
                    _resourceControllers['resource_${0}_productVariantId']
                        ?.text)
                .firstOrNull
                ?.quantity ??
            1;
        updatedResources.add(
          TaskResourceModel(
            taskclientReferenceId:
                _originalTask?.clientReferenceId ?? IdGen.i.identifier,
            clientReferenceId: IdGen.i.identifier,
            productVariantId:
                _resourceControllers['resource_${0}_productVariantId']?.text,
            isDelivered: true,
            taskId: _originalTask.id,
            tenantId: envConfig.variables.tenantId,
            rowVersion: _originalTask.rowVersion ?? 1,
            quantity: qty.toString(),
            clientAuditDetails: ClientAuditDetails(
              createdBy: context.loggedInUserUuid,
              createdTime: context.millisecondsSinceEpoch(),
            ),
            auditDetails: AuditDetails(
              createdBy: context.loggedInUserUuid,
              createdTime: context.millisecondsSinceEpoch(),
            ),
          ),
        );
      } else {
        for (int i = 0; i < totalResources; i++) {
          final resource = task.resources![i];
          updatedResources.add(
            resource.copyWith(
              productVariantId:
                  _resourceControllers['resource_${i}_productVariantId']
                          ?.text ??
                      resource.productVariantId ??
                      '',
              deliveryComment:
                  _resourceControllers['resource_${i}_deliveryComment']?.text ??
                      resource.deliveryComment,
              clientAuditDetails: resource.clientAuditDetails?.copyWith(
                    lastModifiedBy:
                        RegistrationDeliverySingleton().loggedInUserUuid,
                    lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                  ) ??
                  ClientAuditDetails(
                    createdBy:
                        RegistrationDeliverySingleton().loggedInUserUuid!,
                    createdTime: DateTime.now().millisecondsSinceEpoch,
                    lastModifiedBy:
                        RegistrationDeliverySingleton().loggedInUserUuid!,
                    lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                  ),
              auditDetails: resource.auditDetails?.copyWith(
                    lastModifiedBy:
                        RegistrationDeliverySingleton().loggedInUserUuid,
                    lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                  ) ??
                  AuditDetails(
                    createdBy:
                        RegistrationDeliverySingleton().loggedInUserUuid!,
                    createdTime: DateTime.now().millisecondsSinceEpoch,
                    lastModifiedBy:
                        RegistrationDeliverySingleton().loggedInUserUuid!,
                    lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                  ),
            ),
          );
        }
      }
    }

    final updatedClientAuditDetails = task.clientAuditDetails?.copyWith(
          lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
          lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
        ) ??
        ClientAuditDetails(
          lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
          lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
          createdBy: task.clientAuditDetails?.createdBy ?? '',
          createdTime: task.clientAuditDetails?.createdTime ?? 0,
        );

    final updatedAuditDetails = task.auditDetails?.copyWith(
          lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
          lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
        ) ??
        AuditDetails(
          createdBy: task.auditDetails?.createdBy ?? '',
          createdTime: task.auditDetails?.createdTime ?? 0,
          lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
          lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
        );

    final parsedCreatedDate =
        int.tryParse(_controllers['createdDate']?.text.trim() ?? '');

    // Create updated task model
    final updatedTask = task.copyWith(
      status: changeStatus
          ? (_controllers['status']?.text.isNotEmpty == true
              ? _controllers['status']!.text
              : task.status)
          : task.status,
      createdDate: parsedCreatedDate ?? task.createdDate,
      additionalFields: newAdditionalFields,
      resources: updatedResources,
      clientAuditDetails: updatedClientAuditDetails,
      auditDetails: updatedAuditDetails,
    );

    return updatedTask;
  }

  Future<void> _showDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        final dialogTheme = Theme.of(dialogContext);
        final dialogTextTheme = dialogTheme.digitTextTheme(dialogContext);
        return AlertDialog(
          backgroundColor: dialogTheme.colorTheme.paper.primary,
          title: Text(
            localizations.translate(i18.editTasks.deleteDialogTitle),
            style: dialogTextTheme.headingM.copyWith(
              color: dialogTheme.colorTheme.text.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate(i18.editTasks.deleteDialogMessage),
                style: dialogTextTheme.bodyL.copyWith(
                  color: dialogTheme.colorTheme.text.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _deleteReasonController,
                decoration: InputDecoration(
                  labelText: localizations.translate(i18.editTasks.reasonLabel),
                  hintText:
                      localizations.translate(i18.editTasks.deleteReasonHint),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 200,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(localizations.translate(i18.common.coreCommonCancel)),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = _deleteReasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations
                          .translate(i18.editTasks.deleteReasonRequiredError)),
                      backgroundColor: Theme.of(context).colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                if (reason.length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations
                          .translate(i18.editTasks.reasonMinLengthError)),
                      backgroundColor: Theme.of(context).colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                if (reason.length > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations
                          .translate(i18.editTasks.reasonMaxLengthError)),
                      backgroundColor: Theme.of(context).colorTheme.alert.error,
                    ),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: dialogTheme.colorTheme.alert.error,
                foregroundColor: dialogTheme.colorTheme.paper.primary,
              ),
              child: Text(localizations.translate(i18.common.coreCommonDelete)),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _deleteTask();
    }
  }

  Future<void> _deleteTask() async {
    setState(() => _saving = true);

    try {
      final taskDataRepository =
          context.read<LocalRepository<TaskModel, TaskSearchModel>>()
              as CustomTaskLocalRepository;

      if (_originalTask.status == Status.administeredSuccess.toValue() ||
          _originalTask.status == Status.delivered.toValue()) {
        List<TaskModel> allAdministrationTasks =
            await _getAllCurrentCycleAdministrationTasks(taskDataRepository);

        for (var task in allAdministrationTasks) {
          TaskModel updatedTask = _getUpdatedTaskForDelete(task);
          // Delete using repository
          await taskDataRepository.delete(updatedTask);
        }
      } else {
        List<TaskModel> allTasksToDelete =
            await _getAllCurrentCycleRelatedTasks(
                taskDataRepository, _originalTask.status);

        for (var task in allTasksToDelete) {
          TaskModel updatedTask = _getUpdatedTaskForDelete(task);
          // Delete using repository
          await taskDataRepository.delete(updatedTask);
        }
      }

      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(i18.editTasks.deleteSuccessMessage),
            ),
            backgroundColor: Theme.of(context).colorTheme.alert.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations.translate(i18.editTasks.deleteErrorMessage),
            ),
            backgroundColor: Theme.of(context).colorTheme.alert.error,
          ),
        );
        debugPrint('Error deleting task: $e');
      }
    }
  }

  TaskModel _getUpdatedTaskForDelete(TaskModel task) {
    // Get existing additional fields
    final existingFields = task.additionalFields?.fields ?? [];

    // Add delete reason to additional fields
    final deleteReasonField =
        AdditionalField('deleteReason', _deleteReasonController.text.trim());
    final updatedFields = [...existingFields, deleteReasonField];

    final newAdditionalFields = TaskAdditionalFields(
      schema: task.additionalFields?.schema ?? 'Task',
      version: task.additionalFields?.version ?? 1,
      fields: updatedFields,
    );

    final updatedResources = <TaskResourceModel>[];
    final totalResources = task.resources?.length ?? 0;

    for (int i = 0; i < totalResources; i++) {
      final resource = task.resources![i];
      updatedResources.add(resource.copyWith(isDeleted: true));
    }

    // Create updated task model with delete reason in additional fields
    final updatedTask = task.copyWith(
      additionalFields: newAdditionalFields,
      resources: updatedResources,
    );

    return updatedTask;
  }

  Future<List<TaskModel>> _getAllCurrentCycleAdministrationTasks(
      CustomTaskLocalRepository taskDataRepository) async {
    List<TaskModel> allAdministrationTasks =
        await taskDataRepository.search(TaskSearchModel(
      createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
      isDeleted: false,
      projectBeneficiaryClientReferenceId:
          _originalTask.projectBeneficiaryClientReferenceId != null
              ? [_originalTask.projectBeneficiaryClientReferenceId!]
              : [],
    ));

    String currentTaskCycle = _originalTask.additionalFields?.fields
        .where(
            (field) => field.key == AdditionalFieldsType.cycleIndex.toValue())
        .firstOrNull
        ?.value;

    allAdministrationTasks = allAdministrationTasks
        .where((task) =>
            task.isDeleted != true &&
            task.clientAuditDetails?.createdBy ==
                RegistrationDeliverySingleton().loggedInUserUuid &&
            task.projectBeneficiaryClientReferenceId ==
                _originalTask.projectBeneficiaryClientReferenceId &&
            (task.status == Status.administeredSuccess.toValue() ||
                task.status == Status.delivered.toValue()) &&
            (task.additionalFields?.fields
                    .where((field) =>
                        field.key ==
                            AdditionalFieldsType.cycleIndex.toValue() &&
                        field.value == currentTaskCycle)
                    .isNotEmpty ??
                false))
        .toList();

    return allAdministrationTasks;
  }

  Future<List<TaskModel>> _getAllCurrentCycleRelatedTasks(
      CustomTaskLocalRepository taskDataRepository, String? status) async {
    List<TaskModel> allTasks = await taskDataRepository.search(TaskSearchModel(
      createdBy: RegistrationDeliverySingleton().loggedInUserUuid,
      isDeleted: false,
      projectBeneficiaryClientReferenceId:
          _originalTask.projectBeneficiaryClientReferenceId != null
              ? [_originalTask.projectBeneficiaryClientReferenceId!]
              : [],
    ));

    String currentTaskCycle = _originalTask.additionalFields?.fields
        .where(
            (field) => field.key == AdditionalFieldsType.cycleIndex.toValue())
        .firstOrNull
        ?.value;

    allTasks = allTasks
        .where((task) =>
            task.isDeleted != true &&
            task.clientAuditDetails?.createdBy ==
                RegistrationDeliverySingleton().loggedInUserUuid &&
            task.projectBeneficiaryClientReferenceId ==
                _originalTask.projectBeneficiaryClientReferenceId &&
            (task.additionalFields?.fields
                    .where((field) =>
                        field.key ==
                            AdditionalFieldsType.cycleIndex.toValue() &&
                        field.value == currentTaskCycle)
                    .isNotEmpty ??
                false))
        .toList();

    if (status != null) {
      allTasks = allTasks.where((task) => task.status == status).toList();
    }

    return allTasks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      backgroundColor: theme.colorTheme.generic.background,
      appBar: AppBar(
        backgroundColor: theme.colorTheme.primary.primary2,
        foregroundColor: theme.colorTheme.paper.primary,
        iconTheme: IconThemeData(color: theme.colorTheme.paper.primary),
        title: Text(
          (() {
            final fields = _originalTask.additionalFields?.fields ?? const [];
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
                  (cycleIndex != null && doseIndex != null) ? ' -- ' : '';
              suffix = (cycleIndex != null && doseIndex != null)
                  ? '${localizations.translate(i18.beneficiaryDetails.beneficiaryCycle)} $cycleIndex $sep ${localizations.translate(i18.deliverIntervention.dose)} $doseIndex'
                  : ((cycleIndex != null)
                      ? '${localizations.translate(i18.beneficiaryDetails.beneficiaryCycle)} $cycleIndex'
                      : '${localizations.translate(i18.deliverIntervention.dose)} ${doseIndex ?? ''}');
            } else {
              suffix = _originalTask.id ?? _originalTask.clientReferenceId;
            }
            return '${localizations.translate(i18.editTasks.taskLabel)} #$suffix';
          })(),
          style: textTheme.headingL.copyWith(
            color: theme.colorTheme.paper.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          DigitIconButton(
            icon: Icons.delete,
            onPressed: _saving ? null : _showDeleteDialog,
            iconColor: theme.colorTheme.alert.error,
          ),
          DigitIconButton(
            icon: Icons.save,
            onPressed: _saving ? null : _showSaveDialog,
            iconColor: theme.colorTheme.paper.primary,
          ),
        ],
      ),
      body: _saving
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorTheme.primary.primary2,
              ),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(spacer4, spacer2, spacer4, spacer4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableFieldsBanner(),
                  const SizedBox(height: 16),

                  // Beneficiary Details Section
                  if (_individual != null) ...[
                    _buildIndividualDetailsSection(),
                  ],

                  // Resources Section (Priority)
                  if (showResources) ...[
                    _buildResourcesSection(),
                    const SizedBox(height: 16),
                  ],

                  // Task Information Section
                  _buildTaskInformationSection(),

                  const SizedBox(height: 16),

                  // Additional Details Section
                  if (_additionalFields != null) ...[
                    _buildAdditionalDetailsSection(),
                    const SizedBox(height: 16),
                  ],

                  // Hidden ID Fields (for data population)
                  _buildHiddenIdFields(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildIndividualDetailsSection() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    final individual = _individual;
    if (individual == null) return const SizedBox.shrink();

    // Compute details
    final name =
        "${individual.name?.givenName ?? ''} ${individual.name?.familyName ?? ''}"
            .trim();
    final gender = individual.gender?.name ?? 'N/A';
    final age = individual.dateOfBirth != null
        ? DigitDateUtils.calculateAge(
            DigitDateUtils.getFormattedDateToDateTime(
                  individual.dateOfBirth!,
                ) ??
                DateTime.now(),
          )
        : null;
    final beneficiaryId = individual.identifiers != null &&
            individual.identifiers!.isNotEmpty &&
            individual.identifiers?.first.identifierType ==
                IdentifierTypes.uniqueBeneficiaryID.toValue()
        ? individual.identifiers?.first.identifierId ?? 'N/A'
        : 'N/A';

    // Extract from additional fields
    final cycleIndex = _additionalFields?.fields
        .firstWhereOrNull(
            (f) => f.key == AdditionalFieldsType.cycleIndex.toValue())
        ?.value
        ?.toString();
    final doseIndex = _additionalFields?.fields
        .firstWhereOrNull(
            (f) => f.key == AdditionalFieldsType.doseIndex.toValue())
        ?.value
        ?.toString();
    final administrationEpoch = _additionalFields?.fields
        .firstWhereOrNull(
            (f) => f.key == AdditionalFieldsType.dateOfAdministration.toValue())
        ?.value;
    String? administrationDateStr;
    if (administrationEpoch is int) {
      administrationDateStr =
          local_utils.formatDateFromMillis(administrationEpoch);
    } else if (administrationEpoch is String) {
      final parsed = int.tryParse(administrationEpoch);
      if (parsed != null) {
        administrationDateStr = local_utils.formatDateFromMillis(parsed);
      }
    }

    return DigitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: theme.colorTheme.primary.primary2,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations
                      .translate(i18.editTasks.beneficiaryDetailsSectionTitle),
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.primary.primary2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display info
            _buildIndividualInfoRow(
                i18.editTasks.nameLabel, name.isNotEmpty ? name : 'N/A'),
            if (age != null)
              _buildIndividualInfoRow(
                i18.editTasks.ageLabel,
                '${age.years} ${localizations.translate(i18.editTasks.yearsLabel)} ${localizations.translate(i18.editTasks.andLabel)} ${age.months} ${localizations.translate(i18.editTasks.monthsLabel)}',
              ),

            _buildIndividualInfoRow(i18.editTasks.genderLabel, gender),
            _buildIndividualInfoRow(
                i18.editTasks.beneficiaryIdLabel, beneficiaryId),
            if (cycleIndex != null)
              _buildIndividualInfoRow(
                i18.beneficiaryDetails.recordCycle,
                cycleIndex,
              ),
            if (doseIndex != null)
              _buildIndividualInfoRow(
                i18.deliverIntervention.dose,
                doseIndex,
              ),
            if (administrationDateStr != null)
              _buildIndividualInfoRow(
                i18.householdDetails.dateOfAdministrationLabel,
                administrationDateStr,
              ),
          ],
        ),
      ),
    );
  }

  // A helper builder for label-value pairs
  Widget _buildIndividualInfoRow(String label, String value) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '${localizations.translate(label)}:',
              style: textTheme.headingS.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.headingS.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return DigitCard(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  color: theme.colorTheme.primary.primary2,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations.translate(i18.editTasks.resourcesSectionTitle),
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.primary.primary2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_originalTask.resources != null &&
                _originalTask.resources!.isNotEmpty) ...[
              ...List.generate(_originalTask.resources!.length, (index) {
                return _buildResourceCard(index);
              }),
            ] else if (showResources) ...[
              _buildResourceCard(0)
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(int index) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    // Get the currently selected variant value from the controller
    String? selectedVariantId =
        _resourceControllers['resource_${index}_productVariantId']?.text ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorTheme.paper.secondary.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorTheme.generic.divider.withOpacity(0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resource Header
          Text(
            '${localizations.translate(i18.editTasks.resourceLabel)} ${index + 1}',
            style: textTheme.headingM.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorTheme.primary.primary2,
            ),
          ),
          const SizedBox(height: 8),

          // Product Variant Dropdown
          if (productVariants != null && productVariants!.isNotEmpty)
            _wrapEditableField(
              child: LabeledField(
                label: localizations
                    .translate(i18.editTasks.productVariantIdLabel),
                labelStyle: TextStyle(
                  color: theme.colorTheme.text.secondary,
                  fontSize: 16,
                ),
                child: digit_ui.DigitDropdown(
                  isDisabled: false,
                  readOnly: false,
                  selectedOption: DropdownItem(
                    code: selectedVariantId,
                    name: getFormattedSku(getSku(selectedVariantId) ?? ''),
                  ),
                  items: productVariants!
                      .map(
                        (variant) => DropdownItem(
                          code: variant.productVariantId,
                          name: getFormattedSku(
                              getSku(variant.productVariantId) ?? ''),
                        ),
                      )
                      .toList(),
                  onSelect: (selected) {
                    if (selected != null) {
                      selectedVariantId = selected.code;
                      _resourceControllers['resource_${index}_productVariantId']
                          ?.text = selected.code;
                    }
                  },
                ),
              ),
            )
          else
            Text(
              localizations.translate(i18.editTasks.noProductVariantsFound),
              style: textTheme.bodyS.copyWith(
                color: theme.colorTheme.text.secondary,
              ),
            ),

          const SizedBox(height: 8),

          // Task ID
          CustomDigitTextField(
            label: localizations.translate(i18.editTasks.taskIdLabel),
            controller: _resourceControllers['resource_${index}_taskId'],
            readOnly: true,
          ),
          const SizedBox(height: 8),

          // Quantity + Is Delivered
          Row(
            children: [
              Expanded(
                child: CustomDigitTextField(
                  label: localizations.translate(i18.editTasks.quantityLabel),
                  controller:
                      _resourceControllers['resource_${index}_quantity'],
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomDigitTextField(
                  label:
                      localizations.translate(i18.editTasks.isDeliveredLabel),
                  controller:
                      _resourceControllers['resource_${index}_isDelivered'],
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Delivery Comment
          CustomDigitTextField(
            label: localizations.translate(i18.editTasks.deliveryCommentLabel),
            controller:
                _resourceControllers['resource_${index}_deliveryComment'],
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsSection() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return DigitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorTheme.primary.primary2,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations
                      .translate(i18.editTasks.additionalDetailsSectionTitle),
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.primary.primary2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDigitTextField(
              label: localizations.translate(i18.editTasks.schemaLabel),
              controller: _schemaController,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            CustomDigitTextField(
              label: localizations.translate(i18.editTasks.versionLabel),
              controller: _versionController,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            ..._additionalFieldControllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAdditionalFieldWidget(entry.key, entry.value),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInformationSection() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    // Generate dropdown items dynamically from Status enum
    final statusOptions = Status.values
        .where((s) => allowedStatuses.contains(s.toValue()))
        .map(
          (s) => DropdownItem(
            code: s.toValue(),
            name: localizations.translate(s.toValue()),
          ),
        )
        .toList();

    // Get current status value from controller
    final selectedStatus = _controllers['status']?.text ?? '';

    return DigitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: theme.colorTheme.primary.primary2,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations.translate(i18.editTasks.taskInfoSectionTitle),
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.primary.primary2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _wrapEditableField(
              child: LabeledField(
                label: localizations.translate(i18.editTasks.statusLabel),
                labelStyle: TextStyle(
                  color: theme.colorTheme.text.secondary,
                  fontSize: 16,
                ),
                child: digit_ui.DigitDropdown(
                  isDisabled: false,
                  readOnly: false,
                  selectedOption: DropdownItem(
                    code: selectedStatus,
                    name: selectedStatus.isNotEmpty
                        ? localizations.translate(selectedStatus)
                        : localizations
                            .translate(i18.editTasks.selectStatusLabel),
                  ),
                  items: statusOptions,
                  onSelect: (selected) {
                    if (selected != null) {
                      _controllers['status']?.text = selected.code;
                      if (selected.code ==
                              Status.administeredSuccess.toValue() ||
                          selected.code == Status.delivered.toValue()) {
                        setState(() {
                          showResources = true;
                        });
                      } else {
                        setState(() {
                          showResources = false;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Expanded(
            //       child: CustomDigitTextField(
            //         label:
            //             localizations.translate(i18.editTasks.createdByLabel),
            //         controller: _controllers['createdBy'],
            //         readOnly: true,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Expanded(
                //   child: CustomDigitTextField(
                //     label:
                //         localizations.translate(i18.editTasks.isDeletedLabel),
                //     controller: _controllers['isDeleted'],
                //     readOnly: true,
                //   ),
                // ),
                // const SizedBox(width: 8),
                Expanded(
                  child: _buildDatePickerField(
                    label:
                        localizations.translate(i18.editTasks.createdDateLabel),
                    controller: _controllers['createdDate']!,
                    showEditableBadge: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiddenIdFields() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return DigitCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_off,
                  color: theme.colorTheme.alert.error,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  localizations
                      .translate(i18.editTasks.systemFieldsSectionTitle),
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.alert.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomDigitTextField(
                    label: localizations.translate(i18.editTasks.idLabel),
                    controller: _hiddenIdControllers['id'],
                    readOnly: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFieldLabel(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getAdditionalFieldLabel(String key) {
    final String? i18Key = switch (key) {
      'name' => i18.editTasks.nameLabel,
      'age' => i18.editTasks.ageLabel,
      'gender' => i18.editTasks.genderLabel,
      'cycleIndex' || 'cycle' => i18.beneficiaryDetails.recordCycle,
      'doseIndex' => i18.deliverIntervention.dose,
      'dateOfAdministration' => i18.householdDetails.dateOfAdministrationLabel,
      'dateOfEvaluation' => i18.referBeneficiary.dateOfEvaluationLabel,
      'referralComments' => i18.referBeneficiary.referralComments,
      'referredBy' => i18.referBeneficiary.referredByLabel,
      'deliveryComment' => i18.editTasks.deliveryCommentLabel,
      'dateOfDelivery' => i18.editTasks.dateOfDeliveryLabel,
      'deliveryStrategy' => i18.editTasks.deliveryStrategyLabel,
      'deliveryType' => i18.editTasks.deliveryTypeLabel,
      _ => null,
    };

    if (i18Key != null) {
      return localizations.translate(i18Key);
    }

    return localizations.translateWithDefault(
      key,
      fallback: _formatFieldLabel(key),
    );
  }

  bool _isAdditionalFieldEditable(String key) {
    return _editableAdditionalFieldKeys.contains(key) ||
        key == _genderFieldKey ||
        _datePickerAdditionalFieldKeys.contains(key);
  }

  List<String> _allEditableFieldLabels() {
    final labels = <String>[
      localizations.translate(i18.editTasks.statusLabel),
      localizations.translate(i18.editTasks.createdDateLabel),
      _getAdditionalFieldLabel('name'),
      _getAdditionalFieldLabel('age'),
      _getAdditionalFieldLabel('gender'),
      _getAdditionalFieldLabel('dateOfDelivery'),
    ];
    if (showResources) {
      labels.insert(
        1,
        localizations.translate(i18.editTasks.productVariantIdLabel),
      );
    }
    return labels;
  }

  Widget _buildEditableFieldsBanner() {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorTheme.primary.primary2.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorTheme.primary.primary2.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note,
                color: theme.colorTheme.primary.primary2,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  localizations
                      .translate(i18.editTasks.editableFieldsHintTitle),
                  style: textTheme.headingS.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorTheme.primary.primary2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allEditableFieldLabels()
                .map(
                  (label) => Chip(
                    avatar: Icon(
                      Icons.edit,
                      size: 16,
                      color: theme.colorTheme.primary.primary2,
                    ),
                    label: Text(label),
                    labelStyle: textTheme.bodyS.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor:
                        theme.colorTheme.paper.primary.withOpacity(0.9),
                    side: BorderSide(
                      color: theme.colorTheme.primary.primary2.withOpacity(0.4),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _wrapEditableField({required Widget child}) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    final badgeLabel =
        localizations.translate(i18.editTasks.editableFieldBadge);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorTheme.primary.primary2.withOpacity(0.35),
        ),
        color: theme.colorTheme.primary.primary2.withOpacity(0.04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit,
                size: 14,
                color: theme.colorTheme.primary.primary2,
              ),
              const SizedBox(width: 4),
              Text(
                badgeLabel,
                style: textTheme.bodyS.copyWith(
                  color: theme.colorTheme.primary.primary2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  List<String> _genderOptions() {
    return RegistrationDeliverySingleton().genderOptions ??
        const ['MALE', 'FEMALE', 'OTHER'];
  }

  String _normalizeGenderCode(String value) => value.trim().toUpperCase();

  Widget _buildGenderDropdown(TextEditingController controller) {
    final theme = Theme.of(context);
    final options = _genderOptions();
    final selectedCode = _normalizeGenderCode(controller.text);

    return _wrapEditableField(
      child: LabeledField(
        label: localizations.translate(i18.editTasks.genderLabel),
        labelStyle: TextStyle(
          color: theme.colorTheme.text.secondary,
          fontSize: 16,
        ),
        child: digit_ui.DigitDropdown(
          isDisabled: false,
          readOnly: false,
          selectedOption: options
                  .map(
                    (code) => DropdownItem(
                      code: _normalizeGenderCode(code),
                      name: localizations.translate(code),
                    ),
                  )
                  .where((item) => item.code == selectedCode)
                  .firstOrNull ??
              DropdownItem(
                code: selectedCode,
                name: selectedCode.isNotEmpty
                    ? localizations.translate(selectedCode)
                    : localizations.translate(i18.editTasks.genderLabel),
              ),
          items: options
              .map(
                (code) => DropdownItem(
                  code: _normalizeGenderCode(code),
                  name: localizations.translate(code),
                ),
              )
              .toList(),
          onSelect: (selected) {
            if (selected != null) {
              setState(() {
                controller.text = selected.code;
              });
            }
          },
        ),
      ),
    );
  }

  String _datePickerInitialValue(TextEditingController controller) {
    final millis = int.tryParse(controller.text.trim());
    if (millis != null) {
      return local_utils.formatDateFromMillis(millis);
    }
    final date = DigitDateUtils.getFormattedDateToDateTime(controller.text);
    if (date != null) {
      return DateFormat('dd MMM yyyy').format(date);
    }
    return controller.text;
  }

  Widget _buildDatePickerField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    bool showEditableBadge = false,
  }) {
    final field = LabeledField(
      label: label,
      labelStyle: TextStyle(
        color: Theme.of(context).colorTheme.text.secondary,
        fontSize: 16,
      ),
      child: DigitDateFormInput(
        readOnly: readOnly,
        initialValue: _datePickerInitialValue(controller),
        lastDate: DateTime.now(),
        cancelText: localizations.translate(i18.common.coreCommonCancel),
        confirmText: localizations.translate(i18.common.coreCommonOk),
        onChange: (value) {
          if (value.isEmpty) return;
          final date = DigitDateUtils.getFormattedDateToDateTime(value) ??
              DateFormat('dd/MM/yyyy').tryParse(value);
          if (date != null) {
            controller.text = date.millisecondsSinceEpoch.toString();
          }
        },
      ),
    );

    return showEditableBadge ? _wrapEditableField(child: field) : field;
  }

  Widget _buildAdditionalFieldWidget(
    String key,
    TextEditingController controller,
  ) {
    final label = _getAdditionalFieldLabel(key);
    final isEditable = _isAdditionalFieldEditable(key);

    if (key == _genderFieldKey) {
      return _buildGenderDropdown(controller);
    }

    Widget field;

    if (_datePickerAdditionalFieldKeys.contains(key)) {
      field = _buildDatePickerField(
        label: label,
        controller: controller,
      );
    } else {
      field = CustomDigitTextField(
        label: label,
        controller: controller,
        readOnly: !isEditable,
      );
    }

    return isEditable ? _wrapEditableField(child: field) : field;
  }

  String? getSku(String variantId) {
    if (variantId == Constants.spaq1VariantId ||
        variantId == Constants.spaq1VariantIdProd) {
      return Constants.spaq1;
    } else if (variantId == Constants.spaq2VariantId ||
        variantId == Constants.spaq2VariantIdProd) {
      return Constants.spaq2;
    }
    return null; // Fallback to null if no match
  }

  String getFormattedSku(String sku) {
    if (sku == 'Red VAS') {
      return 'VAS - Red Capsule';
    } else if (sku == 'Blue VAS') {
      return 'VAS - Blue Capsule';
    } else if (sku == Constants.spaq1 || sku == Constants.spaq2) {
      return localizations.translate(local_utils.getSpaqName(sku));
    }
    return sku; // Fallback to original if no match
  }
}
