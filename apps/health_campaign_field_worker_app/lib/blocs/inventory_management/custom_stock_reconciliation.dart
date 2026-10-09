// GENERATED using mason_cli
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_management/blocs/stock_reconciliation.dart';
import 'package:inventory_management/models/entities/stock.dart';
import 'package:inventory_management/models/entities/stock_reconciliation.dart';
import 'package:inventory_management/models/entities/transaction_reason.dart';
import 'package:inventory_management/models/entities/transaction_type.dart';
import 'package:inventory_management/utils/typedefs.dart';
import 'package:inventory_management/utils/utils.dart';
import 'package:registration_delivery/models/entities/task.dart';
import 'package:registration_delivery/utils/typedefs.dart';
import 'package:registration_delivery/utils/utils.dart';

import '../../utils/extensions/extensions.dart';
import '../../utils/stock_in_hand_utils.dart';

part 'custom_stock_reconciliation.freezed.dart';

typedef StockReconciliationEmitter = Emitter<StockReconciliationState>;

// Bloc for handling stock reconciliation related events and states
class CustomStockReconciliationBloc
    extends Bloc<StockReconciliationEvent, StockReconciliationState> {
  final StockDataRepository stockRepository;
  final StockReconciliationDataRepository stockReconciliationRepository;
  final TaskDataRepository taskRepository;

  CustomStockReconciliationBloc(
    super.initialState, {
    required this.stockReconciliationRepository,
    required this.stockRepository,
    required this.taskRepository,
  }) {
    on(_handleSelectFacility);
    on(_handleSelectProduct);
    on(_handleCalculate);
    on(_handleCreate);
  }

  // Event handler for selecting a facility
  FutureOr<void> _handleSelectFacility(
    StockReconciliationSelectFacilityEvent event,
    StockReconciliationEmitter emit,
  ) async {
    // Emitting the state with the selected facility
    emit(state.copyWith(facilityModel: event.facilityModel));
    add(const StockReconciliationCalculateEvent());
  }

  // Event handler for selecting a product
  FutureOr<void> _handleSelectProduct(
    StockReconciliationSelectProductEvent event,
    StockReconciliationEmitter emit,
  ) async {
    // Emitting the state with the selected product
    emit(state.copyWith(productVariantId: event.productVariantId));
    add(StockReconciliationCalculateEvent(
      isDistributor: event.isDistributor,
    ));
  }

  // Event handler for calculating stock reconciliation
  FutureOr<void> _handleCalculate(
    StockReconciliationCalculateEvent event,
    StockReconciliationEmitter emit,
  ) async {
    // Emitting the loading state
    emit(state.copyWith(loading: true, stockModels: []));

    final productVariantId = state.productVariantId;
    final facilityId = state.facilityModel?.id;

    if ((productVariantId == null) ||
        (!event.isDistributor && facilityId == null)) return;

    // Reconciliation figures must only reflect the active cycle's activity,
    // so stock fetched here is additionally scoped to it (unlike the
    // cumulative stock-in-hand balance, which intentionally spans cycles).
    final currentCycle = RegistrationDeliverySingleton()
        .projectType
        ?.cycles
        ?.firstWhereOrNull(
          (cycle) =>
              cycle.startDate < DateTime.now().millisecondsSinceEpoch &&
              cycle.endDate > DateTime.now().millisecondsSinceEpoch,
        );

    bool isInCurrentCycle(StockModel stock) {
      if (currentCycle == null) return true;
      final createdTime = stock.clientAuditDetails?.createdTime ?? 0;
      return createdTime >= currentCycle.startDate &&
          createdTime <= currentCycle.endDate;
    }

    // Fetching the stock reconciliation details
    final receivedStocks = (await stockRepository.search(
      StockSearchModel(
          productVariantId: productVariantId,
          receiverId: [facilityId!],
          transactionType: [TransactionType.received.toValue()]),
    ))
        .where((element) =>
            element.auditDetails != null &&
            element.auditDetails?.createdBy ==
                InventorySingleton().loggedInUserUuid &&
            isInCurrentCycle(element))
        .toList();
    final sentStocks = (await stockRepository.search(
      StockSearchModel(
          productVariantId: productVariantId,
          senderId: facilityId,
          transactionType: [TransactionType.dispatched.toValue()]),
    ))
        .where((element) =>
            element.auditDetails != null &&
            element.auditDetails?.createdBy ==
                InventorySingleton().loggedInUserUuid &&
            isInCurrentCycle(element))
        .toList();

    // Stock used (administered doses, including redoses) only factors into
    // the CDD/distributor formula, so it's only fetched for that role.
    final tasksCreatedByUser = event.isDistributor
        ? (await taskRepository.search(TaskSearchModel()))
            .where((element) =>
                element.auditDetails != null &&
                element.auditDetails?.createdBy ==
                    InventorySingleton().loggedInUserUuid)
            .toList()
        : <TaskModel>[];

    // Emitting the state with the fetched stock reconciliation details
    emit(state.copyWith(
      loading: false,
      stockModels: [...receivedStocks, ...sentStocks],
      tasksCreatedByUser: tasksCreatedByUser,
    ));
  }

  // Event handler for creating a stock reconciliation
  FutureOr<void> _handleCreate(
    StockReconciliationCreateEvent event,
    StockReconciliationEmitter emit,
  ) async {
    // Emitting the loading state
    emit(state.copyWith(loading: true));
    // Saving the stock reconciliation details
    stockReconciliationRepository.create(
      event.stockReconciliationModel.copyWith(
        tenantId: InventorySingleton().tenantId,
        referenceId: state.projectId,
        referenceIdType: 'PROJECT',
        additionalFields: StockReconciliationAdditionalFields(
          version: 1,
          fields: [
            AdditionalField('received', state.stockReceived),
            AdditionalField('issued', state.stockIssued),
            AdditionalField('returned', state.stockReturned),
            AdditionalField('lost', state.stockLost),
            AdditionalField('damaged', state.stockDamaged),
            AdditionalField('used', state.stockUsed),
            AdditionalField('inHand', state.stockInHand),
          ],
        ),
        rowVersion: 1,
      ),
    );
    // Emitting the state with the persisted stock reconciliation details
    emit(
      state.copyWith(
        loading: false,
        persisted: true,
      ),
    );
  }
}

// Freezed union class for stock reconciliation events
@freezed
class StockReconciliationEvent with _$StockReconciliationEvent {
  // Event for selecting a facility
  const factory StockReconciliationEvent.selectFacility(
    FacilityModel facilityModel, {
    @Default(false) bool isDistributor,
  }) = StockReconciliationSelectFacilityEvent;

  // Event for selecting a product
  const factory StockReconciliationEvent.selectProduct(
    String? productVariantId, {
    @Default(false) bool isDistributor,
  }) = StockReconciliationSelectProductEvent;

  // Event for calculating stock reconciliation
  const factory StockReconciliationEvent.calculate({
    @Default(false) bool isDistributor,
  }) = StockReconciliationCalculateEvent;

  // Event for creating a stock reconciliation
  const factory StockReconciliationEvent.create(
    StockReconciliationModel stockReconciliationModel,
  ) = StockReconciliationCreateEvent;
}

// Freezed union class for stock reconciliation states
@freezed
class StockReconciliationState with _$StockReconciliationState {
  // State for stock reconciliation
  StockReconciliationState._();

  factory StockReconciliationState({
    @Default(false) bool loading,
    @Default(false) bool persisted,
    required String projectId,
    required DateTime dateOfReconciliation,
    FacilityModel? facilityModel,
    String? productVariantId,
    @Default([]) List<StockModel> stockModels,
    @Default([]) List<TaskModel> tasksCreatedByUser,
    StockReconciliationModel? stockReconciliationModel,
  }) = _StockReconciliationState;

  // Getter for received stock
  num get stockReceived => _getQuantityCount(
        stockModels.where((e) =>
            e.transactionType == TransactionType.received.toValue() &&
            e.transactionReason == TransactionReason.received.toValue()),
      );

  // Getter for issued stock
  num get stockIssued => _getQuantityCount(
        stockModels.where((e) =>
            e.transactionType == TransactionType.dispatched.toValue() &&
            e.transactionReason == null),
      );

  // Getter for returned stock
  num get stockReturned => _getQuantityCount(
        stockModels.where((e) =>
            e.transactionType == TransactionType.received.toValue() &&
            e.transactionReason == TransactionReason.returned.toValue()),
      );

  // Getter for lost stock
  num get stockLost => _getQuantityCount(
        stockModels.where((e) =>
            e.transactionType == TransactionType.dispatched.toValue() &&
            (e.transactionReason == TransactionReason.lostInTransit.toValue() ||
                e.transactionReason ==
                    TransactionReason.lostInStorage.toValue())),
      );

  // Getter for damaged stock
  num get stockDamaged => _getQuantityCount(
        stockModels.where((e) =>
            e.transactionType == TransactionType.dispatched.toValue() &&
            (e.transactionReason ==
                    TransactionReason.damagedInTransit.toValue() ||
                e.transactionReason ==
                    TransactionReason.damagedInStorage.toValue())),
      );

  // Getter for used stock: children who received the SPAQ plus children who
  // vomited and received a redose. CDD/distributor only — reuses the same
  // administered-dose calculation `StockBalanceCard` relies on, so this
  // figure never disagrees with the stock-in-hand balance shown there.
  num get stockUsed {
    final variantId = productVariantId;
    final ownerId = facilityModel?.id;
    if (variantId == null || ownerId == null || ownerId.isEmpty) return 0;

    final currentCycle = RegistrationDeliverySingleton()
        .projectType
        ?.cycles
        ?.firstWhereOrNull(
          (cycle) =>
              cycle.startDate < DateTime.now().millisecondsSinceEpoch &&
              cycle.endDate > DateTime.now().millisecondsSinceEpoch,
        );

    return calculateStockInHand(
      stockEntries: stockModels,
      tasksCreatedByUser: tasksCreatedByUser,
      stockOwnerIds: [ownerId],
      productVariantId: variantId,
      isDistributor: true,
      currentCycle: currentCycle,
    ).administered;
  }

  // Getter for in-hand stock
  num get stockInHand {
    final isDistributor = (InventorySingleton().isDistributor ?? false) &&
        // ignore: avoid_dynamic_calls
        !(InventorySingleton().isWareHouseMgr ?? false);

    return isDistributor
        ? stockReceived -
            (stockIssued +
                stockReturned +
                stockLost +
                stockDamaged +
                stockUsed)
        : (stockReceived + stockReturned) -
            (stockIssued + stockDamaged + stockLost);
  }

  // Method for calculating quantity count
  num _getQuantityCount(Iterable<StockModel> stocks) {
    return stocks.fold<num>(
      0.0,
      (old, e) => (num.tryParse(e.quantity ?? '') ?? 0.0) + old,
    );
  }
}
