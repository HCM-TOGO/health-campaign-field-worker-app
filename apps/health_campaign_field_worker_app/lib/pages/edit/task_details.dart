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
  late Map<String, TextEditingController> _addressControllers;
  late Map<String, TextEditingController> _auditControllers;
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

    // Initialize address controllers
    _addressControllers = {};
    if (_originalTask.address != null) {
      final address = _originalTask.address!;
      _addressControllers['address_id'] = 
          TextEditingController(text: address.id.toString());
      _addressControllers['address_relatedClientReferenceId'] = 
          TextEditingController(text: address.relatedClientReferenceId);
      _addressControllers['address_tenantId'] = 
          TextEditingController(text: address.tenantId);
      _addressControllers['address_doorNo'] = 
          TextEditingController(text: address.doorNo);
      _addressControllers['address_latitude'] = 
          TextEditingController(text: address.latitude.toString());
      _addressControllers['address_longitude'] = 
          TextEditingController(text: address.longitude.toString());
      _addressControllers['address_landmark'] = 
          TextEditingController(text: address.landmark);
      _addressControllers['address_locationAccuracy'] = 
          TextEditingController(text: address.locationAccuracy.toString());
      _addressControllers['address_addressLine1'] = 
          TextEditingController(text: address.addressLine1);
      _addressControllers['address_addressLine2'] = 
          TextEditingController(text: address.addressLine2);
      _addressControllers['address_city'] = 
          TextEditingController(text: address.city);
      _addressControllers['address_pincode'] = 
          TextEditingController(text: address.pincode);
      _addressControllers['address_type'] = 
          TextEditingController(text: address.type.toString());
      _addressControllers['address_locality_code'] = 
          TextEditingController(text: address.locality?.code ?? '');
      _addressControllers['address_locality_name'] = 
          TextEditingController(text: address.locality?.name ?? '');
      _addressControllers['address_rowVersion'] = 
          TextEditingController(text: address.rowVersion.toString());
    }

    // Initialize audit controllers
    _auditControllers = {};
    if (_originalTask.auditDetails != null) {
      final audit = _originalTask.auditDetails!;
      _auditControllers['audit_createdBy'] = 
          TextEditingController(text: audit.createdBy);
      _auditControllers['audit_createdTime'] = 
          TextEditingController(text: audit.createdTime.toString());
      _auditControllers['audit_lastModifiedBy'] = 
          TextEditingController(text: audit.lastModifiedBy);
      _auditControllers['audit_lastModifiedTime'] = 
          TextEditingController(text: audit.lastModifiedTime.toString());
    }
    if (_originalTask.clientAuditDetails != null) {
      final clientAudit = _originalTask.clientAuditDetails!;
      _auditControllers['clientAudit_createdBy'] = 
          TextEditingController(text: clientAudit.createdBy);
      _auditControllers['clientAudit_createdTime'] = 
          TextEditingController(text: clientAudit.createdTime.toString());
      _auditControllers['clientAudit_lastModifiedBy'] = 
          TextEditingController(text: clientAudit.lastModifiedBy);
      _auditControllers['clientAudit_lastModifiedTime'] = 
          TextEditingController(text: clientAudit.lastModifiedTime.toString());
    }

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
    for (final c in _addressControllers.values) {
      c.dispose();
    }
    for (final c in _auditControllers.values) {
      c.dispose();
    }
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
                  
                  // Address Section
                  if (_originalTask.address != null)
                    _buildAddressSection(),
                  
                  const SizedBox(height: 16),
                  
                  // Audit Details Section
                  if (_originalTask.auditDetails != null || _originalTask.clientAuditDetails != null)
                    _buildAuditDetailsSection(),
                  
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

  Widget _buildAddressSection() {
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
                  Icons.location_on,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Address Information',
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
                    label: 'Door No',
                    controller: _addressControllers['address_doorNo'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'City',
                    controller: _addressControllers['address_city'],
                    readOnly: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomDigitTextField(
              label: 'Address Line 1',
              controller: _addressControllers['address_addressLine1'],
              readOnly: true,
            ),
            const SizedBox(height: 12),
            CustomDigitTextField(
              label: 'Address Line 2',
              controller: _addressControllers['address_addressLine2'],
              readOnly: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Landmark',
                    controller: _addressControllers['address_landmark'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Pincode',
                    controller: _addressControllers['address_pincode'],
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
                    label: 'Latitude',
                    controller: _addressControllers['address_latitude'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Longitude',
                    controller: _addressControllers['address_longitude'],
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
                    label: 'Locality Code',
                    controller: _addressControllers['address_locality_code'],
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDigitTextField(
                    label: 'Locality Name',
                    controller: _addressControllers['address_locality_name'],
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

  Widget _buildAuditDetailsSection() {
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
                  Icons.history,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Audit Details',
                  style: textTheme.headingL.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_originalTask.auditDetails != null) ...[
              Text(
                'Server Audit',
                style: textTheme.headingM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Created By',
                      controller: _auditControllers['audit_createdBy'],
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Created Time',
                      controller: _auditControllers['audit_createdTime'],
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
                      label: 'Last Modified By',
                      controller: _auditControllers['audit_lastModifiedBy'],
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Last Modified Time',
                      controller: _auditControllers['audit_lastModifiedTime'],
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (_originalTask.clientAuditDetails != null) ...[
              Text(
                'Client Audit',
                style: textTheme.headingM.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Created By',
                      controller: _auditControllers['clientAudit_createdBy'],
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Created Time',
                      controller: _auditControllers['clientAudit_createdTime'],
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
                      label: 'Last Modified By',
                      controller: _auditControllers['clientAudit_lastModifiedBy'],
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomDigitTextField(
                      label: 'Last Modified Time',
                      controller: _auditControllers['clientAudit_lastModifiedTime'],
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ],
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
