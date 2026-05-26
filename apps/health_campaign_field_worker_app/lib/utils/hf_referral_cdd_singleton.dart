class CddUser {
  final String name;
  final String username;

  const CddUser({required this.name, required this.username});
}

class HFReferralCddSingleton {
  static final HFReferralCddSingleton _singleton =
      HFReferralCddSingleton._internal();

  factory HFReferralCddSingleton() => _singleton;

  HFReferralCddSingleton._internal();

  List<CddUser> _cddUsers = [];

  void setCddUsers(List<CddUser> users) {
    _cddUsers = users;
  }

  List<CddUser> get cddUsers => _cddUsers;
}
