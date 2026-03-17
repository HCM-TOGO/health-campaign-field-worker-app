import 'package:dio/dio.dart';

import '../../../models/auth/auth_model.dart';
import '../../../utils/environment_config.dart';

/// Repository for SSO authentication with DIGIT backend
/// Bridges Microsoft Entra ID tokens to DIGIT authentication
class SSOAuthRepository {
  final Dio _client;
  final String oauthLoginPath;

  const SSOAuthRepository(
    this._client, {
    required this.oauthLoginPath,
  });

  /// Exchanges Microsoft Entra ID JWT token for DIGIT JWT tokens
  ///
  /// This method sends the Entra ID idToken as an assertion to the DIGIT backend
  /// which validates it and returns DIGIT-specific authentication tokens.
  ///
  /// Backend expects (form-urlencoded):
  /// - grant_type: jwt_exchange
  /// - scope: read
  /// - userType: EMPLOYEE
  /// - assertion: Entra ID idToken (JWT)
  /// - access_token: Entra ID accessToken (JWT)
  /// - tenantId: Tenant identifier
  /// - Content-Type: application/x-www-form-urlencoded
  /// - Authorization: Basic auth header
  ///
  /// The backend endpoint is configurable via ENV: ENTRA_OAUTH_TOKEN_PATH
  /// Default: /user/oauth/token
  Future<AuthModel> exchangeEntraTokensForDigitAuth({
    required String idToken,
    required String authToken,
    required String tenantId,
  }) async {
    final body = Uri(
      queryParameters: {
        'grant_type': 'jwt_exchange',
        'scope': 'read',
        'userType': 'EMPLOYEE',
        'assertion': idToken,
        'tenantId': tenantId,
      },
    ).query;

    final response = await _client.post(
      oauthLoginPath,
      options: Options(
        headers: {
          'Authorization': 'Basic ZWdvdi11c2VyLWNsaWVudDo=',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
      data: body,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response from DIGIT OAuth endpoint');
    }

    try {
      return AuthModel.fromJson(data);
    } catch (error) {
      throw Exception(
        'Failed to parse DIGIT auth response: $error',
      );
    }
  }
}
