import 'package:digit_data_model/data_model.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_ui_components/models/DropdownModels.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:digit_ui_components/widgets/atoms/digit_dropdown_input.dart'
    as digit_ui;
import 'package:registration_delivery/widgets/localized.dart';

import '../../data/repositories/custom_task.dart';
import '../../models/entities/status.dart';
import '../../utils/constants.dart';
import '../../widgets/digit_ui_component/custom_digit_input_field.dart';
import '../../../utils/utils.dart' as local_utils;

class TaskDetailPage extends LocalizedStatefulWidget {
  final TaskModel taskModel;

  const TaskDetailPage({super.key, required this.taskModel});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends LocalizedState<TaskDetailPage> {
  late Map<String, TextEditingController> _controllers;
  late TaskModel _originalTask;
  late TaskAdditionalFields? _additionalFields;
  late TextEditingController _schemaController;
  late TextEditingController _versionController;
  late Map<String, TextEditingController> _additionalFieldControllers;
  late Map<String, TextEditingController> _resourceControllers;
  late TextEditingController _deleteReasonController;
  late Map<String, TextEditingController> _hiddenIdControllers;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _originalTask = widget.taskModel;
    _additionalFields = widget.taskModel.additionalFields;

    // Initialize controllers for basic task fields
    _controllers = {
      'projectId': TextEditingController(text: _originalTask.projectId ?? ''),
      'status': TextEditingController(text: _originalTask.status ?? ''),
      'createdBy': TextEditingController(text: _originalTask.createdBy ?? ''),
      'tenantId': TextEditingController(text: _originalTask.tenantId ?? ''),
      'projectBeneficiaryId': TextEditingController(
          text: _originalTask.projectBeneficiaryId?.toString() ?? ''),
      'projectBeneficiaryClientReferenceId': TextEditingController(
          text: _originalTask.projectBeneficiaryClientReferenceId ?? ''),
      'rowVersion': TextEditingController(
          text: _originalTask.rowVersion?.toString() ?? ''),
      'isDeleted': TextEditingController(
          text: _originalTask.isDeleted?.toString() ?? ''),
      'createdDate': TextEditingController(
          text: _originalTask.createdDate?.toString() ?? ''),
    };

    // Initialize hidden ID controllers
    _hiddenIdControllers = {
      'id': TextEditingController(text: _originalTask.id?.toString() ?? ''),
      'clientReferenceId':
          TextEditingController(text: _originalTask.clientReferenceId),
    };

    // Initialize resource controllers
    _resourceControllers = {};
    if (_originalTask.resources != null &&
        _originalTask.resources!.isNotEmpty) {
      for (int i = 0; i < _originalTask.resources!.length; i++) {
        final resource = _originalTask.resources![i];
        _resourceControllers['resource_${i}_id'] =
            TextEditingController(text: resource.id.toString());
        _resourceControllers['resource_${i}_clientReferenceId'] =
            TextEditingController(text: resource.clientReferenceId);
        _resourceControllers['resource_${i}_taskclientReferenceId'] =
            TextEditingController(text: resource.taskclientReferenceId);
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
        _resourceControllers['resource_${i}_rowVersion'] =
            TextEditingController(text: resource.rowVersion.toString());
      }
    }

    // Initialize delete reason controller
    _deleteReasonController = TextEditingController();

    // Additional field controllers
    _schemaController =
        TextEditingController(text: _additionalFields?.schema ?? '');
    _versionController = TextEditingController(
        text: _additionalFields?.version.toString() ?? '');

    final fieldsList = _additionalFields?.fields ?? [];

    _additionalFieldControllers = {
      for (final field in fieldsList)
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
    for (final c in _hiddenIdControllers.values) {
      c.dispose();
    }
    _schemaController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _showSaveDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text(
            'Are you sure you want to update this task?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Go Back'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
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

      // Update additional fields
      final updatedFields = _additionalFieldControllers.entries
          .map((e) => AdditionalField(e.key, e.value.text))
          .toList();

      final newAdditionalFields = TaskAdditionalFields(
        schema: _schemaController.text.isNotEmpty
            ? _schemaController.text
            : _additionalFields?.schema ?? '',
        version: int.tryParse(_versionController.text) ??
            _additionalFields?.version ??
            1,
        fields: updatedFields,
      );

      // Build updated TaskResource list from controllers
      final updatedResources = <TaskResourceModel>[];
      final totalResources = _originalTask.resources?.length ?? 0;

      for (int i = 0; i < totalResources; i++) {
        final resource = _originalTask.resources![i];

        updatedResources.add(
          resource.copyWith(
            productVariantId:
                _resourceControllers['resource_${i}_productVariantId']?.text ??
                    resource.productVariantId ??
                    '',
            deliveryComment:
                _resourceControllers['resource_${i}_deliveryComment']?.text ??
                    resource.deliveryComment,
            // isDelivered: _resourceControllers['resource_${i}_isDelivered']
            //         ?.text
            //         .toLowerCase() ==
            //     'true',
            clientAuditDetails: resource.clientAuditDetails?.copyWith(
                  lastModifiedBy:
                      RegistrationDeliverySingleton().loggedInUserUuid,
                  lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                ) ??
                ClientAuditDetails(
                  createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
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
                  createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
                  createdTime: DateTime.now().millisecondsSinceEpoch,
                  lastModifiedBy:
                      RegistrationDeliverySingleton().loggedInUserUuid!,
                  lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
                ),
          ),
        );
      }

      final updatedClientAuditDetails = _originalTask.clientAuditDetails
              ?.copyWith(
            lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
            lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
          ) ??
          ClientAuditDetails(
            lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
            lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
            createdBy: _originalTask.clientAuditDetails?.createdBy ?? '',
            createdTime: _originalTask.clientAuditDetails?.createdTime ?? 0,
          );

      final updatedAuditDetails = _originalTask.auditDetails?.copyWith(
            lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
            lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
          ) ??
          AuditDetails(
            createdBy: _originalTask.auditDetails?.createdBy ?? '',
            createdTime: _originalTask.auditDetails?.createdTime ?? 0,
            lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
            lastModifiedTime: DateTime.now().millisecondsSinceEpoch,
          );

      // Create updated task model
      final updatedTask = _originalTask.copyWith(
        status: _controllers['status']?.text.isNotEmpty == true
            ? _controllers['status']!.text
            : _originalTask.status,
        additionalFields: newAdditionalFields,
        resources: updatedResources,
        clientAuditDetails: updatedClientAuditDetails,
        auditDetails: updatedAuditDetails,
      );

      // Save using repository
      await taskDataRepository.update(updatedTask);

      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving changes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you want to delete the administration data?'),
              const SizedBox(height: 16),
              TextField(
                controller: _deleteReasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason *',
                  hintText: 'Please provide a reason for deletion',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_deleteReasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide a reason for deletion'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
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

      // Get existing additional fields
      final existingFields = _additionalFields?.fields ?? [];

      // Add delete reason to additional fields
      final deleteReasonField =
          AdditionalField('deleteReason', _deleteReasonController.text.trim());
      final updatedFields = [...existingFields, deleteReasonField];

      final newAdditionalFields = TaskAdditionalFields(
        schema: _additionalFields?.schema ?? 'Task',
        version: _additionalFields?.version ?? 1,
        fields: updatedFields,
      );

      // final updatedResources = <TaskResourceModel>[];
      // final totalResources = _originalTask.resources?.length ?? 0;

      // for (int i = 0; i < totalResources; i++) {
      //   final resource = _originalTask.resources![i];
      //   updatedResources.add(resource.copyWith(isDeleted: true));
      // }

      // Create updated task model with delete reason in additional fields
      final updatedTask = _originalTask.copyWith(
        additionalFields: newAdditionalFields,
        // resources: updatedResources,
      );

      // Delete using repository
      await taskDataRepository.delete(updatedTask);

      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: Text(
          'Task #${_originalTask.id ?? _originalTask.clientReferenceId}',
          style: textTheme.headingL.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          DigitIconButton(
            icon: Icons.delete,
            onPressed: _saving ? null : _showDeleteDialog,
            iconColor: Colors.red,
          ),
          DigitIconButton(
            icon: Icons.save,
            onPressed: _saving ? null : _showSaveDialog,
          ),
        ],
      ),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resources Section (Priority)
                  if (_originalTask.resources != null &&
                      _originalTask.resources!.isNotEmpty)
                    _buildResourcesSection(),

                  const SizedBox(height: 16),

                  // Additional Details Section
                  if (_additionalFields != null)
                    _buildAdditionalDetailsSection(),

                  const SizedBox(height: 16),

                  // Task Information Section
                  _buildTaskInformationSection(),

                  const SizedBox(height: 16),

                  // Hidden ID Fields (for data population)
                  _buildHiddenIdFields(),

                  const SizedBox(height: 32),
                ],
              ),
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
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resources',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(_originalTask.resources!.length, (index) {
              return _buildResourceCard(index);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(int index) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    ProjectTypeModel? projectTypeModel = RegistrationDeliverySingleton()
        .selectedProject
        ?.additionalDetails
        ?.projectType;

    // Get all DeliveryProductVariants from project type
    List<DeliveryProductVariant>? productVariants = projectTypeModel?.resources
        ?.map(
            (r) => DeliveryProductVariant(productVariantId: r.productVariantId))
        .toList();

    // Get the currently selected variant value from the controller
    String? selectedVariantId =
        _resourceControllers['resource_${index}_productVariantId']?.text ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resource Header
          Text(
            'Resource ${index + 1}',
            style: textTheme.headingM.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Product Variant Dropdown
          if (productVariants != null && productVariants.isNotEmpty)
            LabeledField(
              label: 'Product Variant ID *',
              labelStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              child: digit_ui.DigitDropdown(
                isDisabled: false,
                readOnly: false,
                selectedOption: DropdownItem(
                  code: selectedVariantId,
                  name: getFormattedSku(getSku(selectedVariantId) ?? ''),
                ),
                items: productVariants
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
            )
          else
            Text(
              'No Product Variants available',
              style: textTheme.bodyS.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

          const SizedBox(height: 8),

          // Task ID
          CustomDigitTextField(
            label: 'Task ID',
            controller: _resourceControllers['resource_${index}_taskId'],
            readOnly: true,
          ),
          const SizedBox(height: 8),

          // Quantity + Is Delivered
          Row(
            children: [
              Expanded(
                child: CustomDigitTextField(
                  label: 'Quantity',
                  controller:
                      _resourceControllers['resource_${index}_quantity'],
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomDigitTextField(
                  label: 'Is Delivered',
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
            label: 'Delivery Comment',
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
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Additional Details',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDigitTextField(
              label: 'Schema',
              controller: _schemaController,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            CustomDigitTextField(
              label: 'Version',
              controller: _versionController,
              readOnly: true,
            ),
            const SizedBox(height: 12),
            ..._additionalFieldControllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomDigitTextField(
                  label: _formatFieldLabel(entry.key),
                  controller: entry.value,
                  readOnly: false,
                ),
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
        .map((s) => DropdownItem(code: s.toValue(), name: s.toValue()))
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
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Task Information',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomDigitTextField(
              label: 'Project ID',
              controller: _controllers['projectId'],
              readOnly: true,
            ),
            const SizedBox(height: 8),
            LabeledField(
              label: 'Status *',
              labelStyle: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              child: digit_ui.DigitDropdown(
                isDisabled: false,
                readOnly: false,
                selectedOption: DropdownItem(
                  code: selectedStatus,
                  name: selectedStatus.isNotEmpty
                      ? selectedStatus
                      : 'Select Status',
                ),
                items: statusOptions,
                onSelect: (selected) {
                  if (selected != null) {
                    _controllers['status']?.text = selected.code;
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Created By',
                    controller: _controllers['createdBy'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Tenant ID',
                    controller: _controllers['tenantId'],
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Project Beneficiary ID',
                    controller: _controllers['projectBeneficiaryId'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Row Version',
                    controller: _controllers['rowVersion'],
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomDigitTextField(
              label: 'Project Beneficiary Client Reference ID',
              controller: _controllers['projectBeneficiaryClientReferenceId'],
              readOnly: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Is Deleted',
                    controller: _controllers['isDeleted'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Created Date',
                    controller: _controllers['createdDate'],
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
                  color: theme.colorScheme.error,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'System Fields (Hidden)',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.error,
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
                    label: 'ID',
                    controller: _hiddenIdControllers['id'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: CustomDigitTextField(
                    label: 'Client Reference ID',
                    controller: _hiddenIdControllers['clientReferenceId'],
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

  String? getSku(String variantId) {
    if (variantId == Constants.spaq1VariantId) {
      return Constants.spaq1;
    } else if (variantId == Constants.spaq2VariantId) {
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
