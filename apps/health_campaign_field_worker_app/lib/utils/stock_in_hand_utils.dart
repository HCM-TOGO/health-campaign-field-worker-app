import 'package:digit_data_model/data_model.dart';
import 'package:collection/collection.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../models/entities/roles_type.dart';
import 'constants.dart';

class StockInHandResult {
  final double received;
  final double returned;
  final double damaged;
  final double lost;
  final double dispatched;
  final double administered;
  final bool isDistributor;

  const StockInHandResult({
    required this.received,
    required this.returned,
    required this.damaged,
    required this.lost,
    required this.dispatched,
    required this.administered,
    required this.isDistributor,
  });

  double get stockInHand => isDistributor
      ? received - (returned + damaged + lost + dispatched) - administered
      : received + returned - (damaged + lost + dispatched) - administered;
}

/// Single source of truth for resolving which facilities a non-distributor
/// user's stock/administration numbers should be scoped to. Both the stock
/// balance widget and the post-downsync stock recalculation must use this
/// so the two never disagree on the owned-facility set for the same user.
List<FacilityModel> filterFacilitiesByRole({
  required List<FacilityModel> facilities,
  required Set<String> userRoles,
  required String? boundaryType,
}) {
  // HEALTH_FACILITY_SUPERVISOR always operates at HF level, regardless of
  // the boundary of the currently selected project.
  final List<FacilityModel> matched;
  if (userRoles.contains(RolesType.healthFacilitySupervisor.toValue())) {
    matched =
        facilities.where((f) => f.usage == Constants.healthFacility).toList();
  } else if (boundaryType == Constants.countryBoundaryLevel ||
      boundaryType == Constants.stateBoundaryLevel) {
    // WAREHOUSE_MANAGER is reused across HF/District/Region tiers; the
    // boundary of the assigned project is what disambiguates which tier
    // this particular user's facilities belong to.
    matched =
        facilities.where((f) => f.usage == Constants.stateFacility).toList();
  } else if (boundaryType == Constants.lgaBoundaryLevel) {
    matched =
        facilities.where((f) => f.usage == Constants.lgaFacility).toList();
  } else {
    matched =
        facilities.where((f) => f.usage == Constants.healthFacility).toList();
  }

  // A role/usage tag mismatch shouldn't zero out a user's stock view
  // entirely — fall back to the unfiltered (still current-project)
  // facility set rather than dropping the user's facility altogether.
  return matched.isEmpty ? facilities : matched;
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
  double dispatched = 0;

  final ownerIds = stockOwnerIds.where((e) => e.isNotEmpty).toSet();
  if (ownerIds.isEmpty) {
    return StockInHandResult(
      received: 0,
      returned: 0,
      damaged: 0,
      lost: 0,
      dispatched: 0,
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

    final isReturned = _isReturned(stock);
    final isDamaged = _isDamaged(stock);
    final isLost = _isLost(stock);

    if (isReturned) returned += qty;
    if (isDamaged) damaged += qty;
    if (isLost) lost += qty;

    // Stock dispatched (sent) out of the owner's hands reduces stock-in-hand.
    // Returned/damaged/lost are already accounted for above, so exclude them.
    if (ownerIds.contains(stock.senderId) &&
        transactionType == 'DISPATCHED' &&
        !isReturned &&
        !isDamaged &&
        !isLost) {
      dispatched += qty;
    }
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
    dispatched: dispatched,
    administered: administered,
    isDistributor: isDistributor,
  );
}
