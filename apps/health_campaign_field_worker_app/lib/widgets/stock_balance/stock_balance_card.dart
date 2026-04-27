import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/inventory_management.dart';
import 'package:isar/isar.dart';
import 'package:registration_delivery/registration_delivery.dart';

import '../../blocs/app_initialization/app_initialization.dart';
import '../../data/repositories/local/inventory_management/custom_stock.dart';
import '../../models/entities/roles_type.dart';
import '../../utils/i18_key_constants.dart' as i18;
import '../../utils/stock_in_hand_cache.dart';
import '../../utils/stock_in_hand_utils.dart';
import '../../utils/utils.dart';
import '../localized.dart';

class StockBalanceCard extends LocalizedStatefulWidget {
  const StockBalanceCard({super.key, super.appLocalizations});

  @override
  State<StockBalanceCard> createState() => _StockBalanceCardState();
}

class _StockBalanceCardState extends LocalizedState<StockBalanceCard> {
  List<FacilityModel> _facilities = [];
  FacilityModel? _selectedFacility;
  List<ProductVariantModel> _productVariants = [];
  Map<String, double> _balancesByVariantId = {};
  bool _isLoading = true;

  final double _minThreshold = 100;
  final double _maxThreshold = 500;

  StreamSubscription<List<OpLog>>? _stockOpLogSub;
  StreamSubscription<List<OpLog>>? _taskOpLogSub;

  bool get _isDistributor => context.loggedInUserRoles.any(
        (role) =>
            role.code == RolesType.distributor.toValue() ||
            role.code == RolesType.communityDistributor.toValue(),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
    _setupWatchers();
  }

  @override
  void dispose() {
    _stockOpLogSub?.cancel();
    _taskOpLogSub?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final projectFacilityRepo = context
        .read<LocalRepository<ProjectFacilityModel, ProjectFacilitySearchModel>>();
    final facilityRepo =
        context.read<LocalRepository<FacilityModel, FacilitySearchModel>>();
    final projectResourceRepo = context
        .read<LocalRepository<ProjectResourceModel, ProjectResourceSearchModel>>();
    final productVariantRepo = context
        .read<LocalRepository<ProductVariantModel, ProductVariantSearchModel>>();

    final projectFacilities = await projectFacilityRepo.search(
      ProjectFacilitySearchModel(projectId: [context.projectId]),
    );

    final currentFacilities = projectFacilities.where((pf) {
      final facilityLevel = pf.additionalFields?.fields
          ?.where((f) => f.key == 'facilityLevel')
          .firstOrNull
          ?.value;
      return facilityLevel == null || facilityLevel == 'current';
    }).toList();

    final facilityIds =
        currentFacilities.map((pf) => pf.facilityId).whereType<String>().toList();

    final facilities = facilityIds.isEmpty
        ? <FacilityModel>[]
        : await facilityRepo.search(FacilitySearchModel(id: facilityIds));

    final projectResources = await projectResourceRepo.search(
      ProjectResourceSearchModel(projectId: [context.projectId]),
    );

    final productVariantIds = projectResources
        .map((pr) => pr.resource.productVariantId)
        .whereType<String>()
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();

    final variants = productVariantIds.isEmpty
        ? <ProductVariantModel>[]
        : await productVariantRepo.search(ProductVariantSearchModel(id: productVariantIds));

    if (!mounted) return;

    final previousFacilityId = _selectedFacility?.id;
    final selected = facilities.isEmpty
        ? null
        : (previousFacilityId != null
            ? facilities.firstWhere(
                (f) => f.id == previousFacilityId,
                orElse: () => facilities.first,
              )
            : facilities.first);

    setState(() {
      _facilities = facilities;
      _selectedFacility = selected;
      _productVariants = variants;
    });

    await _refreshBalances();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _setupWatchers() {
    _stockOpLogSub?.cancel();
    _taskOpLogSub?.cancel();

    final isar = context.read<Isar>();
    final userId = context.loggedInUserUuid;

    _stockOpLogSub = isar.opLogs
        .filter()
        .createdByEqualTo(userId)
        .entityTypeEqualTo(DataModelType.stock)
        .watch()
        .listen((_) => _refreshBalances());

    _taskOpLogSub = isar.opLogs
        .filter()
        .createdByEqualTo(userId)
        .entityTypeEqualTo(DataModelType.task)
        .watch()
        .listen((_) => _refreshBalances());
  }

  String? get _effectiveOwnerId {
    if (_isDistributor) return context.loggedInUserUuid;
    return _selectedFacility?.id;
  }

  Future<void> _refreshBalances() async {
    if (!mounted) return;
    final ownerId = _effectiveOwnerId;
    if (ownerId == null || _productVariants.isEmpty) {
      if (mounted) setState(() => _balancesByVariantId = {});
      return;
    }

    final stockRepo =
        context.read<LocalRepository<StockModel, StockSearchModel>>()
            as CustomStockLocalRepository;
    final taskRepo = context.read<LocalRepository<TaskModel, TaskSearchModel>>();

    final receivedStocks = await stockRepo.search(
      StockSearchModel(receiverId: [ownerId]),
      context.loggedInUserUuid,
    );
    final sentStocks = await stockRepo.search(
      StockSearchModel(senderId: ownerId),
      context.loggedInUserUuid,
    );

    final allStocksMap = <String, StockModel>{};
    for (final s in receivedStocks) {
      allStocksMap[s.clientReferenceId] = s;
    }
    for (final s in sentStocks) {
      allStocksMap[s.clientReferenceId] = s;
    }

    final tasksCreatedByUser = await taskRepo.search(
      TaskSearchModel(createdBy: context.loggedInUserUuid),
    );

    final allStocks = allStocksMap.values.toList();
    final balances = <String, double>{};

    for (final pv in _productVariants) {
      final res = calculateStockInHand(
        stockEntries: allStocks,
        tasksCreatedByUser: tasksCreatedByUser,
        stockOwnerIds: [ownerId],
        productVariantId: pv.id,
      );
      balances[pv.id] = max(res.stockInHand, 0);
    }

    if (mounted) {
      StockInHandCache.instance.setCurrentOwnerId(ownerId);
      StockInHandCache.instance.setBalances(
        ownerId: ownerId,
        balancesByVariantId: balances,
      );
      setState(() => _balancesByVariantId = balances);
    }
  }

  Color _getColorForBalance(double balance) {
    if (balance < _minThreshold) return Colors.red;
    if (balance > _maxThreshold) return const Color(0xFF0B6623);
    return Colors.blue;
  }

  String _displayName(ProductVariantModel pv) {
    final variation = pv.variation?.trim();
    if (variation != null && variation.isNotEmpty) return variation;
    final sku = pv.sku?.trim();
    if (sku != null && sku.isNotEmpty) return sku;
    return pv.id;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading || _productVariants.isEmpty) {
      return const SizedBox.shrink();
    }

    return DigitCard(
      margin: const EdgeInsets.all(spacer2),
      child: Padding(
        padding: const EdgeInsets.all(spacer2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_facilities.length > 1 && !_isDistributor)
              Padding(
                padding: const EdgeInsets.only(bottom: spacer2),
                child: DigitDropdown(
                  emptyItemText: localizations.translate('NO_FACILITIES_FOUND'),
                  items: _facilities
                      .map(
                        (f) => DropdownItem(
                          name: localizations.translate(f.id),
                          code: f.id,
                        ),
                      )
                      .toList(),
                  selectedOption: _selectedFacility == null
                      ? null
                      : DropdownItem(
                          name: localizations.translate(_selectedFacility!.id),
                          code: _selectedFacility!.id,
                        ),
                  onSelect: (value) async {
                    final selected = _facilities.firstWhere(
                      (f) => f.id == value.code,
                    );
                    setState(() => _selectedFacility = selected);
                    StockInHandCache.instance.setCurrentOwnerId(selected.id);
                    await _refreshBalances();
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: spacer1),
              child: Center(
                child: Text(
                  localizations.translate(i18.home.manageStockLabel),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            ..._productVariants.map((pv) {
              final balance = _balancesByVariantId[pv.id] ?? 0.0;
              final color = _getColorForBalance(balance);
              final progress =
                  _maxThreshold > 0 ? min(balance / _maxThreshold, 1.0) : 0.0;
              final name = _displayName(pv);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: spacer1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: max(progress, 0.0),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 7.0,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(spacer1),
                        left: Radius.circular(spacer1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: spacer1),
                      child: Text(
                        '${balance.toInt()} $name',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

