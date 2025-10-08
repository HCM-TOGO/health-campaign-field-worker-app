import 'dart:convert';
import 'package:digit_data_model/data/local_store/sql_store/sql_store.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class TaskDetailPage extends StatefulWidget {
  final LocalSqlDataStore db;
  final Map<String, dynamic> taskData;

  const TaskDetailPage({super.key, required this.db, required this.taskData});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, dynamic> _originalData;
  late Map<String, dynamic> _additionalFields;
  late TextEditingController _schemaController;
  late TextEditingController _versionController;
  late Map<String, TextEditingController> _additionalFieldControllers;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _originalData = Map.of(widget.taskData);

    // Parse additional_fields JSON
    final additional = widget.taskData['additional_fields'];
    Map<String, dynamic> parsed = {};
    if (additional is String) {
      try {
        parsed = jsonDecode(additional);
      } catch (_) {}
    } else if (additional is Map) {
      parsed = Map<String, dynamic>.from(additional);
    }

    _additionalFields = parsed;

    // Normal fields
    _controllers = {
      for (final entry in widget.taskData.entries)
        if (entry.key != 'additional_fields')
          entry.key: TextEditingController(text: entry.value?.toString() ?? '')
    };

    // Additional field controllers
    _schemaController = TextEditingController(
        text: _additionalFields['schema']?.toString() ?? '');
    _versionController = TextEditingController(
        text: _additionalFields['version']?.toString() ?? '');

    final fieldsList =
        (_additionalFields['fields'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    _additionalFieldControllers = {
      for (final field in fieldsList)
        if (field['key'] != null)
          field['key']:
              TextEditingController(text: field['value']?.toString() ?? '')
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
    _schemaController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _saving = true);

    final id = _originalData['id'];
    final updates = <String, dynamic>{};

    // Update normal fields
    _controllers.forEach((key, controller) {
      if (key == 'id') return;
      final newValue = controller.text;
      if (newValue != (_originalData[key]?.toString() ?? '')) {
        updates[key] = newValue;
      }
    });

    // Update additional fields
    final updatedFields = _additionalFieldControllers.entries
        .map((e) => {'key': e.key, 'value': e.value.text})
        .toList();

    final newAdditional = {
      'schema': _schemaController.text,
      'version': int.tryParse(_versionController.text) ??
          _additionalFields['version'] ??
          1,
      'fields': updatedFields,
    };

    if (jsonEncode(newAdditional) != jsonEncode(_additionalFields)) {
      updates['additional_fields'] = jsonEncode(newAdditional);
    }

    if (updates.isNotEmpty) {
      final setClause = updates.keys.map((k) => '$k = ?').join(', ');
      final values = updates.values.toList();
      values.add(id);

      await widget.db.customStatement(
        'UPDATE task SET $setClause WHERE id = ?',
        values,
      );
    }

    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task #${_originalData['id']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saving ? null : _saveChanges,
          ),
        ],
      ),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(2),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Information',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          )),
                      const SizedBox(height: 16),

                      // Regular fields
                      ..._controllers.entries.map((entry) {
                        final key = entry.key;
                        final controller = entry.value;
                        final isReadOnly = key == 'id';
                        return _buildField(
                          label: key,
                          controller: controller,
                          readOnly: isReadOnly,
                          theme: theme,
                        );
                      }),

                      const SizedBox(height: 24),
                      Divider(thickness: 1.5, color: Colors.grey[300]),
                      const SizedBox(height: 16),

                      // Additional Fields Section
                      Text('Additional Fields',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          )),
                      const SizedBox(height: 12),

                      _buildField(
                        label: 'Schema',
                        controller: _schemaController,
                        readOnly: true,
                        theme: theme,
                      ),
                      _buildField(
                        label: 'Version',
                        controller: _versionController,
                        readOnly: true,
                        theme: theme,
                      ),

                      const SizedBox(height: 8),
                      ..._additionalFieldControllers.entries.map((entry) {
                        return _buildField(
                          label: entry.key,
                          controller: entry.value,
                          readOnly: false,
                          theme: theme,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool readOnly,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                )),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: readOnly,
            maxLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey[200] : Colors.grey[50],
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            ),
          ),
        ],
      ),
    );
  }
}
