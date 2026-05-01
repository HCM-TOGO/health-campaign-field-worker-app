import 'package:digit_data_model/data_model.dart';
import 'package:collection/collection.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:registration_delivery/registration_delivery.dart';

class StockInHandResult {
  final double received;
  final double returned;
  final double damaged;
  final double lost;
  final double administered;
  final bool isDistributor;

  const StockInHandResult({
    required this.received,
    required this.returned,
    required this.damaged,
    required this.lost,
    required this.administered,
    required this.isDistributor,
  });

  double get stockInHand => isDistributor
      ? received - (returned + damaged + lost) - administered
      : received + returned - (damaged + lost) - administered;
}

String _additionalFieldValue(StockModel stock, String key) {
  final fields = stock.additionalFields?.fields;
  if (fields == null) return '';
  for (final field in fields) {
    if (field.key == key) return field.value?.toString().toUpperCase() ?? '';
  }
  return '';
}

bool _isReturned(StockModel stock) {
  final reason = stock.transactionReason?.toUpperCase() ?? '';
  final entryType = _additionalFieldValue(stock, 'stockEntryType');
  return reason == 'RETURNED' || entryType == 'RETURNED';
}

bool _isDamaged(StockModel stock) {
  final reason = stock.transactionReason?.toUpperCase() ?? '';
  final entryType = _additionalFieldValue(stock, 'stockEntryType');
  return reason.contains('DAMAGED') || entryType == 'DAMAGED';
}

bool _isLost(StockModel stock) {
  final reason = stock.transactionReason?.toUpperCase() ?? '';
  final entryType = _additionalFieldValue(stock, 'stockEntryType');
  return reason.contains('LOST') || entryType == 'LOSS';
}

double _qty(String? quantity) => double.tryParse(quantity ?? '0') ?? 0.0;

bool _doseIndexIs01(TaskModel task) {
  final fields = task.additionalFields?.fields;
  if (fields == null || fields.isEmpty) return false;
  final doseIndex = fields.firstWhereOrNull((f) => f.key == 'doseIndex')?.value;
  return doseIndex?.toString() == '01';
}

StockInHandResult calculateStockInHand({
  required List<StockModel> stockEntries,
  required List<TaskModel> tasksCreatedByUser,
  required List<String> stockOwnerIds,
  required String productVariantId,
  required bool isDistributor,
}) {
  double received = 0;
  double returned = 0;
  double damaged = 0;
  double lost = 0;

  final ownerIds = stockOwnerIds.where((e) => e.isNotEmpty).toSet();
  if (ownerIds.isEmpty) {
    return StockInHandResult(
      received: 0,
      returned: 0,
      damaged: 0,
      lost: 0,
      administered: 0,
      isDistributor: isDistributor,
    );
  }

  for (final stock in stockEntries) {
    if (stock.productVariantId != productVariantId) continue;

    final isMine = ownerIds.contains(stock.receiverId) ||
        ownerIds.contains(stock.senderId);
    if (!isMine) continue;

    final qty = _qty(stock.quantity);
    if (qty <= 0) continue;

    final transactionType = stock.transactionType?.toUpperCase() ?? '';
    final transactionReason = stock.transactionReason?.toUpperCase() ?? '';

    if (ownerIds.contains(stock.receiverId) &&
        transactionType == 'RECEIVED' &&
        transactionReason != 'RETURNED') {
      received += qty;
    }

    if (_isReturned(stock)) returned += qty;
    if (_isDamaged(stock)) damaged += qty;
    if (_isLost(stock)) lost += qty;
  }

  double administered = 0;
  for (final task in tasksCreatedByUser) {
    if (!_doseIndexIs01(task)) continue;
    final resources = task.resources;
    if (resources == null || resources.isEmpty) continue;
    for (final res in resources) {
      if (res.productVariantId != productVariantId) continue;
      if (res.isDelivered != true) continue;
      administered += _qty(res.quantity);
    }
  }

  return StockInHandResult(
    received: received,
    returned: returned,
    damaged: damaged,
    lost: lost,
    administered: administered,
    isDistributor: isDistributor,
  );
}
