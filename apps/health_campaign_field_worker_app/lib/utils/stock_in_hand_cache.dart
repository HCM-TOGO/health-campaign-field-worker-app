class StockInHandCache {
  StockInHandCache._();

  static final StockInHandCache instance = StockInHandCache._();

  final Map<String, Map<String, double>> _byOwnerId = {};
  String? _currentOwnerId;

  String? get currentOwnerId => _currentOwnerId;

  void setCurrentOwnerId(String ownerId) {
    _currentOwnerId = ownerId;
  }

  void setBalances({
    required String ownerId,
    required Map<String, double> balancesByVariantId,
  }) {
    _byOwnerId[ownerId] = Map<String, double>.from(balancesByVariantId);
  }

  Map<String, double> getBalances(String ownerId) {
    return Map<String, double>.from(_byOwnerId[ownerId] ?? const {});
  }

  Map<String, double> get currentBalances {
    final ownerId = _currentOwnerId;
    if (ownerId == null) return const {};
    return getBalances(ownerId);
  }
}

