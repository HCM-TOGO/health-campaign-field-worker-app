import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:digit_ui_components/utils/app_logger.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/environment_config.dart';

/// Service for Microsoft Entra ID (Azure AD) authentication
/// Implements OAuth 2.0 Authorization Code Flow with PKCE
///
/// Platform Configuration Notes:
/// - Android: Redirect URL scheme configured in android/app/src/main/AndroidManifest.xml:
///   Package name: com.digit.hcm
///   Redirect URI: com.digit.hcm://oauth/callback
///
/// - iOS: Add redirect URL scheme to ios/Runner/Info.plist:
///   <key>CFBundleURLTypes</key>
///   <array>
///     <dict>
///       <key>CFBundleURLSchemes</key>
///       <array>
///         <string>com.digit.hcm</string>
///       </array>
///     </dict>
///   </array>
class EntraAuthService {
  static const FlutterAppAuth _appAuth = FlutterAppAuth();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Storage keys for Entra tokens
  static const String _entraIdTokenKey = 'entra_id_token';
  static const String _entraAccessTokenKey = 'entra_access_token';
  static const String _entraRefreshTokenKey = 'entra_refresh_token';
  static const String _entraTokenExpiryKey = 'entra_token_expiry';
  static const String _codeVerifierKey = 'entra_code_verifier';

  /// Generates a cryptographically random code verifier for PKCE
  String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  /// Generates code challenge from code verifier using SHA256
  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  /// Extracts user claims from ID token
  Map<String, dynamic>? _parseIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) {
        return null;
      }

      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed
      final normalizedPayload = base64.normalize(payload);
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      return json.decode(decodedString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.instance.error(
        title: 'EntraAuthService',
        message: 'Failed to parse ID token: $e',
      );
      return null;
    }
  }

  /// Signs in with Microsoft Entra ID
  /// Returns a map containing idToken, accessToken, and user claims
  Future<Map<String, dynamic>?> signInWithMicrosoft() async {
    try {
      final entraConfig = envConfig.variables.entraConfig;

      // Generate PKCE parameters
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      // Store code verifier securely for token exchange
      await _secureStorage.write(
        key: _codeVerifierKey,
        value: codeVerifier,
      );

      // Build authorization request

//       final authorizationRequest = AuthorizationRequest(
//         entraConfig.clientId,
//         entraConfig.redirectUrl,
//         discoveryUrl: entraConfig.discoveryUrl,
//         scopes: entraConfig.scopes,

//         // Correct way to force account selection in Entra
//         promptValues: ['select_account'],
//       );

// // Perform authorization (returns authorization code)
//       final authorizationResponse =
//           await _appAuth.authorize(authorizationRequest);

      // final authorizationRequest = AuthorizationRequest(
      //   entraConfig.clientId,
      //   entraConfig.redirectUrl,
      //   discoveryUrl: entraConfig.discoveryUrl,
      //   scopes: entraConfig.scopes,
      //   promptValues: ['select_account'],
      // );

      // final authorizationResponse =
      //     await _appAuth.authorize(authorizationRequest);

      // if (authorizationResponse == null ||
      //     authorizationResponse.authorizationCode == null) {
      //   AppLogger.instance.error(
      //     title: 'EntraAuthService',
      //     message: 'Authorization cancelled or failed',
      //   );
      //   return null;
      // }

      // Exchange authorization code for tokens
      // final tokenRequest = TokenRequest(
      //   entraConfig.clientId,
      //   entraConfig.redirectUrl,
      //   authorizationCode: authorizationResponse.authorizationCode,
      //   discoveryUrl: entraConfig.discoveryUrl,
      //   codeVerifier: codeVerifier,
      // );

      // final result = await _appAuth.token(tokenRequest);

      final tokenResponse = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          entraConfig.clientId,
          entraConfig.redirectUrl,
          discoveryUrl: entraConfig.discoveryUrl,
          scopes: ['openid', 'profile', 'offline_access'],
          promptValues: ['select_account'],
        ),
      );

      if (tokenResponse == null) {
        AppLogger.instance.error(
          title: 'EntraAuthService',
          message: 'Token exchange failed',
        );
        return null;
      }

      // Extract tokens
      final idToken = tokenResponse.idToken;
      final accessToken = tokenResponse.accessToken;
      final refreshToken = tokenResponse.refreshToken;
      // Calculate expiry from expiresIn if available, otherwise use default
      final expiresIn = tokenResponse.tokenAdditionalParameters?['expires_in'];
      final tokenExpiry = expiresIn != null
          ? DateTime.now().add(
              Duration(seconds: int.tryParse(expiresIn.toString()) ?? 3600))
          : DateTime.now().add(const Duration(hours: 1));

      if (idToken == null || accessToken == null) {
        // Clean up code verifier on failure
        await _secureStorage.delete(key: _codeVerifierKey);
        AppLogger.instance.error(
          title: 'EntraAuthService',
          message: 'Missing tokens in authorization response',
        );
        return null;
      }

      // Parse user claims from ID token
      final userClaims = _parseIdToken(idToken);
      if (userClaims == null) {
        AppLogger.instance.error(
          title: 'EntraAuthService',
          message: 'Failed to parse user claims from ID token',
        );
        return null;
      }

      // Store tokens securely
      await _secureStorage.write(key: _entraIdTokenKey, value: idToken);
      await _secureStorage.write(
        key: _entraAccessTokenKey,
        value: accessToken,
      );
      if (refreshToken != null) {
        await _secureStorage.write(
          key: _entraRefreshTokenKey,
          value: refreshToken,
        );
      }
      if (tokenExpiry != null) {
        await _secureStorage.write(
          key: _entraTokenExpiryKey,
          value: tokenExpiry.millisecondsSinceEpoch.toString(),
        );
      }

      // Clean up code verifier after successful exchange
      await _secureStorage.delete(key: _codeVerifierKey);

      return {
        'idToken': idToken,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'tokenExpiry': tokenExpiry?.millisecondsSinceEpoch,
        'userClaims': userClaims,
      };
    } catch (e) {
      AppLogger.instance.error(
        title: 'EntraAuthService',
        message: 'Error during Microsoft sign-in: $e',
      );
      rethrow;
    }
  }

  /// Refreshes the access token if needed
  /// Returns true if token was refreshed, false if still valid
  Future<bool> refreshTokenIfNeeded() async {
    try {
      final tokenExpiryStr = await _secureStorage.read(
        key: _entraTokenExpiryKey,
      );
      final refreshToken = await _secureStorage.read(
        key: _entraRefreshTokenKey,
      );

      if (tokenExpiryStr == null || refreshToken == null) {
        return false;
      }

      final tokenExpiry = DateTime.fromMillisecondsSinceEpoch(
        int.parse(tokenExpiryStr),
      );

      // Refresh if token expires in less than 5 minutes
      if (DateTime.now()
          .add(const Duration(minutes: 5))
          .isBefore(tokenExpiry)) {
        return false; // Token still valid
      }

      final entraConfig = envConfig.variables.entraConfig;

      final tokenResponse = await _appAuth.token(
        TokenRequest(
          entraConfig.clientId,
          entraConfig.redirectUrl,
          refreshToken: refreshToken,
          discoveryUrl: entraConfig.discoveryUrl,
        ),
      );

      if (tokenResponse == null ||
          tokenResponse.accessToken == null ||
          tokenResponse.idToken == null) {
        AppLogger.instance.error(
          title: 'EntraAuthService',
          message: 'Failed to refresh token',
        );
        return false;
      }

      // Update stored tokens
      await _secureStorage.write(
        key: _entraIdTokenKey,
        value: tokenResponse.idToken!,
      );
      await _secureStorage.write(
        key: _entraAccessTokenKey,
        value: tokenResponse.accessToken!,
      );
      if (tokenResponse.refreshToken != null) {
        await _secureStorage.write(
          key: _entraRefreshTokenKey,
          value: tokenResponse.refreshToken!,
        );
      }
      // Calculate expiry from expiresIn if available
      final expiresIn = tokenResponse.tokenAdditionalParameters?['expires_in'];
      final newExpiry = expiresIn != null
          ? DateTime.now().add(
              Duration(seconds: int.tryParse(expiresIn.toString()) ?? 3600))
          : DateTime.now().add(const Duration(hours: 1));
      await _secureStorage.write(
        key: _entraTokenExpiryKey,
        value: newExpiry.millisecondsSinceEpoch.toString(),
      );

      return true;
    } catch (e) {
      AppLogger.instance.error(
        title: 'EntraAuthService',
        message: 'Error refreshing token: $e',
      );
      return false;
    }
  }

  /// Gets the current Entra ID token
  Future<String?> getIdToken() async {
    return await _secureStorage.read(key: _entraIdTokenKey);
  }

  /// Gets the current Entra access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _entraAccessTokenKey);
  }

  /// Signs out from Microsoft Entra ID
  /// Clears all stored Entra tokens
  /// Returns true if sign out was successful, false if there was an error
  /// Tokens are always cleared, even on error
  Future<bool> signOut() async {
    bool hasError = false;
    try {
      final entraConfig = envConfig.variables.entraConfig;

      // Attempt to sign out from Entra ID
      try {
        await _appAuth.endSession(
          EndSessionRequest(
            idTokenHint: await getIdToken(),
            postLogoutRedirectUrl: entraConfig.redirectUrl,
            discoveryUrl: entraConfig.discoveryUrl,
          ),
        );
      } catch (e) {
        // Log but don't fail if end session fails
        AppLogger.instance.info(
          'End session failed (non-critical): $e',
          title: 'EntraAuthService',
        );
        hasError = true;
      }

      // Clear all stored Entra tokens (always clear, even on error)
      await _secureStorage.delete(key: _entraIdTokenKey);
      await _secureStorage.delete(key: _entraAccessTokenKey);
      await _secureStorage.delete(key: _entraRefreshTokenKey);
      await _secureStorage.delete(key: _entraTokenExpiryKey);
      await _secureStorage.delete(key: _codeVerifierKey);
    } catch (e) {
      hasError = true;
      AppLogger.instance.error(
        title: 'EntraAuthService',
        message: 'Error during sign out: $e',
      );
    }
    return !hasError;
  }
}
