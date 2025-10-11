import 'package:digit_data_model/data_model.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../data/repositories/custom_task.dart';
import '../../widgets/digit_ui_component/custom_digit_input_field.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskModel taskModel;

  const TaskDetailPage({super.key, required this.taskModel});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
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
    if (_originalTask.resources != null && _originalTask.resources!.isNotEmpty) {
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

      // Create updated task model
      final updatedTask = _originalTask.copyWith(
        status: _controllers['status']?.text.isNotEmpty == true
            ? _controllers['status']!.text
            : _originalTask.status,
        additionalFields: newAdditionalFields,
      );

      // Save using repository
      await taskDataRepository.update(updatedTask);

      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes: $e')),
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
      final deleteReasonField = AdditionalField('deleteReason', _deleteReasonController.text.trim());
      final updatedFields = [...existingFields, deleteReasonField];

      final newAdditionalFields = TaskAdditionalFields(
        schema: _additionalFields?.schema ?? 'Task',
        version: _additionalFields?.version ?? 1,
        fields: updatedFields,
      );

      // Create updated task model with delete reason in additional fields
      final updatedTask = _originalTask.copyWith(
        additionalFields: newAdditionalFields,
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
          'Task Details #${_originalTask.id ?? _originalTask.clientReferenceId}',
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
            onPressed: _saving ? null : _saveChanges,
          ),
        ],
      ),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resources Section (Priority)
                  if (_originalTask.resources != null && _originalTask.resources!.isNotEmpty)
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
        padding: const EdgeInsets.all(16),
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
          Text(
            'Resource ${index + 1}',
            style: textTheme.headingM.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomDigitTextField(
                  label: 'Product Variant ID',
                  controller: _resourceControllers['resource_${index}_productVariantId'],
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomDigitTextField(
                  label: 'Quantity',
                  controller: _resourceControllers['resource_${index}_quantity'],
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomDigitTextField(
                  label: 'Is Delivered',
                  controller: _resourceControllers['resource_${index}_isDelivered'],
                  readOnly: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomDigitTextField(
                  label: 'Task ID',
                  controller: _resourceControllers['resource_${index}_taskId'],
                  readOnly: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomDigitTextField(
            label: 'Delivery Comment',
            controller: _resourceControllers['resource_${index}_deliveryComment'],
            readOnly: true,
            maxLines: 2,
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
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Project ID',
                    controller: _controllers['projectId'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Status',
                    controller: _controllers['status'],
                    readOnly: false,
                  ),
                ),
              ],
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
                  color: theme.colorScheme.outline,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'System Fields (Hidden)',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'ID',
                    controller: _hiddenIdControllers['id'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
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
}
