import '../services/entra_auth_service.dart';

class SSOProviderSignInResult {
  final String idToken;
  final String accessToken;

  const SSOProviderSignInResult({
    required this.idToken,
    required this.accessToken,
  });
}

abstract class SSOProviderAuthService {
  String get providerKey;

  Future<SSOProviderSignInResult?> signIn();
}

class MicrosoftSSOProviderAuthService implements SSOProviderAuthService {
  final EntraAuthService _entraAuthService;

  const MicrosoftSSOProviderAuthService(this._entraAuthService);

  @override
  String get providerKey => 'microsoft';

  @override
  Future<SSOProviderSignInResult?> signIn() async {
    final entraResult = await _entraAuthService.signInWithMicrosoft();
    if (entraResult == null) return null;

    final idToken = entraResult['idToken'];
    final accessToken = entraResult['accessToken'];

    if (idToken is! String || accessToken is! String) {
      return null;
    }

    return SSOProviderSignInResult(
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
