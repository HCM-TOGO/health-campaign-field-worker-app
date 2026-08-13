import 'package:digit_data_model/data_model.dart';
import 'package:inventory_management/inventory_management.dart';
import 'package:isar/isar.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../models/entities/assessment_checklist/status.dart';
import 'constants.dart';

/// Breakdown of a CDD (distributor) user's pending-sync records by the
/// metrics relevant to them, in place of a single aggregate count.
class CddSyncSummary {
  final int childrenRegistered;
  final int tasksAdministered;
  final int spaq1Received;
  final int spaq2Received;

  const CddSyncSummary({
    this.childrenRegistered = 0,
    this.tasksAdministered = 0,
    this.spaq1Received = 0,
    this.spaq2Received = 0,
  });
}

/// Computes [CddSyncSummary] from the same pending-sync OpLog rows the
/// generic sync count (`SyncBloc`/`SyncServiceMapper.getSyncCount`) is
/// derived from: rows created by [createdBy] that are either not synced up
/// yet, or synced up but not yet synced down.
CddSyncSummary getCddSyncSummary(Isar isar, String createdBy) {
  final pendingOpLogs = [
    ...isar.opLogs
        .filter()
        .createdByEqualTo(createdBy)
        .syncedUpEqualTo(false)
        .findAllSync(),
    ...isar.opLogs
        .filter()
        .createdByEqualTo(createdBy)
        .syncedUpEqualTo(true)
        .syncedDownEqualTo(false)
        .findAllSync(),
  ];

  var childrenRegistered = 0;
  var tasksAdministered = 0;
  var spaq1ReceivedQty = 0.0;
  var spaq2ReceivedQty = 0.0;

  for (final opLog in _latestPerEntity(pendingOpLogs)) {
    switch (opLog.entityType) {
      case DataModelType.householdMember:
        final member = opLog.getEntity<HouseholdMemberModel>();
        // Household head is registered as the household's contact, not a
        // beneficiary child, so it is excluded from this count.
        if (member is HouseholdMemberModel && !member.isHeadOfHousehold) {
          childrenRegistered++;
        }
        break;
      case DataModelType.task:
        final task = opLog.getEntity<TaskModel>();
        if (task is TaskModel &&
            task.status == Status.administeredSuccess.toValue()) {
          tasksAdministered++;
        }
        break;
      case DataModelType.stock:
        final stock = opLog.getEntity<StockModel>();
        if (stock is StockModel && _isReceived(stock)) {
          final qty = double.tryParse(stock.quantity ?? '') ?? 0;
          if (_isSpaq1(stock.productVariantId)) {
            spaq1ReceivedQty += qty;
          } else if (_isSpaq2(stock.productVariantId)) {
            spaq2ReceivedQty += qty;
          }
        }
        break;
      default:
        break;
    }
  }

  return CddSyncSummary(
    childrenRegistered: childrenRegistered,
    tasksAdministered: tasksAdministered,
    spaq1Received: spaq1ReceivedQty.round(),
    spaq2Received: spaq2ReceivedQty.round(),
  );
}

/// A single entity (household member, task, stock entry) can accumulate
/// multiple pending OpLog rows across its edit history — e.g. a task's
/// administration status toggled more than once before syncing — so only
/// the most recently written row per `clientReferenceId` reflects the
/// entity's current state; counting every row overcounts.
Iterable<OpLog> _latestPerEntity(List<OpLog> opLogs) {
  final latestByClientReferenceId = <String, OpLog>{};

  for (final opLog in opLogs) {
    final clientReferenceId = opLog.clientReferenceId;
    if (clientReferenceId == null) continue;

    final current = latestByClientReferenceId[clientReferenceId];
    if (current == null || opLog.createdAt.isAfter(current.createdAt)) {
      latestByClientReferenceId[clientReferenceId] = opLog;
    }
  }

  return latestByClientReferenceId.values;
}

bool _isSpaq1(String? productVariantId) =>
    productVariantId == Constants.spaq1VariantId ||
    productVariantId == Constants.spaq1VariantIdProd;

bool _isSpaq2(String? productVariantId) =>
    productVariantId == Constants.spaq2VariantId ||
    productVariantId == Constants.spaq2VariantIdProd;

/// Matches the same transactionType/transactionReason gating
/// [calculateStockInHand] (in stock_in_hand_utils.dart) uses for its
/// `received` bucket, so this count and the stock-in-hand balance never
/// disagree on what "received" means.
bool _isReceived(StockModel stock) {
  return stock.transactionType?.toUpperCase() ==
          TransactionType.received.toValue() &&
      stock.transactionReason?.toUpperCase() != 'RETURNED';
}
