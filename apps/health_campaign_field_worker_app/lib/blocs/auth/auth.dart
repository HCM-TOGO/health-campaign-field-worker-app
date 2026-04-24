import 'dart:async';

import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/local_store/secure_store/secure_store.dart';
import '../../data/repositories/remote/auth.dart';
import '../../data/repositories/remote/mdms.dart';
import '../../models/auth/auth_model.dart';
import '../../data/repositories/remote/sso_auth.dart';
import '../../models/entities/roles_type.dart';
import '../../models/role_actions/role_actions_model.dart';
import '../../services/entra_auth_service.dart';
import '../../services/sso_provider_auth.dart';
import '../../utils/environment_config.dart';

// part 'auth.freezed.dart' need to be added to auto generate the files for freezed model
part 'auth.freezed.dart';

typedef AuthEmitter = Emitter<AuthState>;

//Auth Bloc will be used to handle user authentication services
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalSecureStore localSecureStore;
  final AuthRepository authRepository;
  final SSOAuthRepository? ssoAuthRepository;
  final MdmsRepository mdmsRepository;
  final RemoteRepository<IndividualModel, IndividualSearchModel>
      individualRemoteRepository;
  final EntraAuthService entraAuthService;
  final Map<String, SSOProviderAuthService> ssoProviderAuthServices;

  AuthBloc({
    required this.authRepository,
    this.ssoAuthRepository,
    required this.mdmsRepository,
    required this.individualRemoteRepository,
    LocalSecureStore? localSecureStore,
    EntraAuthService? entraAuthService,
    Map<String, SSOProviderAuthService>? ssoProviderAuthServices,
  })  : localSecureStore = LocalSecureStore.instance,
        entraAuthService = entraAuthService ?? EntraAuthService(),
        ssoProviderAuthServices = ssoProviderAuthServices ??
            {
              'microsoft': MicrosoftSSOProviderAuthService(
                entraAuthService ?? EntraAuthService(),
              ),
            },
        super(const AuthUnauthenticatedState()) {
    on(_onLogin);
    on(_onLogout);
    on(_onSSOLogin);
    on(_onAutoLogin);
    on(_onAddSpaqCounts);
  }

  //_onAutoLogin event handles auto-login of the user when the user is already logged in and token is not expired, AuthenticatedWrapper is returned in UI
  FutureOr<void> _onAutoLogin(
    AuthAutoLoginEvent event,
    AuthEmitter emit,
  ) async {
    emit(const AuthLoadingState());

    try {
      final accessToken = await localSecureStore.accessToken;
      final refreshToken = await localSecureStore.refreshToken;
      final userObject = await localSecureStore.userRequestModel;
      final actionsList = await localSecureStore.savedActions;
      final userIndividualId = await localSecureStore.userIndividualId;
      final spaq1 = await localSecureStore.spaq1;
      final spaq2 = await localSecureStore.spaq2;

      if (accessToken == null ||
          refreshToken == null ||
          userObject == null ||
          actionsList == null) {
        emit(const AuthUnauthenticatedState());
      } else {
        emit(AuthAuthenticatedState(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userModel: userObject,
          individualId: userIndividualId,
          actionsWrapper: actionsList,
          spaq1Count: spaq1,
          spaq2Count: spaq2,
        ));
      }
    } catch (_) {
      emit(const AuthUnauthenticatedState());
      rethrow;
    }
  }

  //_onLogin event handles login of the user
  // Here we set the authToken and loggedIn user details in local storage and allow the user to perform actions
  FutureOr<void> _onLogin(AuthLoginEvent event, AuthEmitter emit) async {
    emit(const AuthLoadingState());

    try {
      final AuthModel result = await authRepository.fetchAuthToken(
        loginModel: LoginModel(
          username: event.userId,
          password: event.password,
          tenantId: event.tenantId,
        ),
      );
      await localSecureStore.setAuthCredentials(result);
      await localSecureStore.setBoundaryRefetch(true);

      final actionsWrapper = await mdmsRepository
          .searchRoleActions(envConfig.variables.actionMapApiPath, {
        "roleCodes": result.userRequestModel.roles.map((e) => e.code).toList(),
        "tenantId": envConfig.variables.tenantId,
        "actionMaster": "actions-test",
        "enabled": true,
      });
      await localSecureStore.setBoundaryRefetch(true);
      final spaq1 = await localSecureStore.spaq1;
      final spaq2 = await localSecureStore.spaq2;

      await localSecureStore.setRoleActions(actionsWrapper);
      if (result.userRequestModel.roles
          .where((role) =>
              role.code == RolesType.districtSupervisor.toValue() ||
              role.code == RolesType.attendanceStaff.toValue())
          .toList()
          .isNotEmpty) {
        final loggedInIndividual = await individualRemoteRepository.search(
          IndividualSearchModel(
            userUuid: [result.userRequestModel.uuid],
          ),
        );
        await localSecureStore
            .setSelectedIndividual(loggedInIndividual.firstOrNull?.id);
      }

      emit(
        AuthAuthenticatedState(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          userModel: result.userRequestModel,
          actionsWrapper: actionsWrapper,
          individualId: await localSecureStore.userIndividualId,
          spaq1Count: spaq1,
          spaq2Count: spaq2,
        ),
      );
    } on DioException catch (error) {
      emit(const AuthErrorState());
      emit(const AuthUnauthenticatedState());

      AppLogger.instance.error(
        title: 'Login error',
        message: error.response?.data.toString(),
      );
    } catch (_) {
      emit(const AuthErrorState());
      emit(const AuthUnauthenticatedState());
      rethrow;
    }
  }

  //_onSSOLogin handles provider-based SSO login
  // For unsupported providers, a user-friendly message is emitted.
  FutureOr<void> _onSSOLogin(
    AuthSSOLoginEvent event,
    AuthEmitter emit,
  ) async {
    emit(const AuthLoadingState());

    try {
      final providerKey = event.providerKey.toLowerCase();
      final providerService = ssoProviderAuthServices[providerKey];
      if (providerService == null) {
        emit(const AuthErrorState('Provider not supported yet'));
        emit(const AuthUnauthenticatedState());
        return;
      }

      // Step 1: Authenticate with selected provider
      final providerResult = await providerService.signIn();
      if (providerResult == null) {
        emit(AuthErrorState(
            '${event.providerKey} sign-in cancelled or failed'));
        emit(const AuthUnauthenticatedState());
        return;
      }

      // Step 2: Exchange Entra tokens for DIGIT tokens via backend
      if (ssoAuthRepository == null) {
        throw Exception(
          'SSO authentication not configured. Please provide SSOAuthRepository.',
        );
      }

      final AuthModel result = await ssoAuthRepository!
          .exchangeEntraTokensForDigitAuth(
              idToken: providerResult.idToken,
              authToken: providerResult.accessToken,
              tenantId: event.tenantId);

      // Step 3: Persist DIGIT session (same as regular login)
      await localSecureStore.setAuthCredentials(result);
      await localSecureStore.setBoundaryRefetch(true);

      // Step 4: Fetch role actions
      final actionsWrapper = await mdmsRepository
          .searchRoleActions(envConfig.variables.actionMapApiPath, {
        "roleCodes": result.userRequestModel.roles.map((e) => e.code).toList(),
        "tenantId": envConfig.variables.tenantId,
        "actionMaster": "actions-test",
        "enabled": true,
      });

      await localSecureStore.setBoundaryRefetch(true);
      await localSecureStore.setRoleActions(actionsWrapper);

      // Step 5: Handle special roles (same as regular login)
      if (result.userRequestModel.roles
          .where((role) =>
              role.code == RolesType.districtSupervisor.toValue() ||
              role.code == RolesType.distributor.toValue())
          .toList()
          .isNotEmpty) {
        final loggedInIndividual = await individualRemoteRepository.search(
          IndividualSearchModel(
            userUuid: [result.userRequestModel.uuid],
          ),
        );
        await localSecureStore
            .setSelectedIndividual(loggedInIndividual.firstOrNull?.id);
      }

      // Step 6: Emit authenticated state
      emit(
        AuthAuthenticatedState(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          userModel: result.userRequestModel,
          actionsWrapper: actionsWrapper,
          individualId: result.userRequestModel.uuid,
        ),
      );
    } on DioException catch (error) {
      String errorMessage = '${event.providerKey} SSO login failed';

      // Handle specific error cases
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final responseData = error.response!.data;

        if (statusCode == 401) {
          errorMessage =
              'Unauthorized. Please check if your Microsoft account is linked to DIGIT.';
        } else if (statusCode == 403) {
          errorMessage =
              'Access denied. Your account does not have the required permissions.';
        } else if (statusCode == 400) {
          errorMessage =
              'Invalid request. Please ensure your Microsoft account is properly configured.';
        } else if (responseData is Map) {
          errorMessage = responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              errorMessage;
        }
      }

      emit(AuthErrorState(errorMessage));
      emit(const AuthUnauthenticatedState());

      AppLogger.instance.error(
        title: '${event.providerKey} SSO login error',
        message: error.response?.data.toString() ?? error.toString(),
      );
    } catch (error) {
      String errorMessage = '${event.providerKey} SSO login failed';

      if (error.toString().contains('cancelled') ||
          error.toString().contains('canceled')) {
        errorMessage = 'Sign-in cancelled';
      } else if (error.toString().contains('network')) {
        errorMessage =
            'Network error. Please check your connection and try again.';
      } else {
        errorMessage = error.toString();
      }

      emit(AuthErrorState(errorMessage));
      emit(const AuthUnauthenticatedState());

      AppLogger.instance.error(
        title: '${event.providerKey} SSO login error',
        message: error.toString(),
      );
    }
  }

  //_onLogout event logs out the user and deletes the saved user details from local storage
  FutureOr<void> _onLogout(AuthLogoutEvent event, AuthEmitter emit) async {
    try {
      // Check if user has Entra tokens (SSO login)
      final entraIdToken = await entraAuthService.getIdToken();
      bool entraSignOutSuccess = true;

      if (entraIdToken != null) {
        // Sign out from Microsoft Entra ID
        try {
          entraSignOutSuccess = await entraAuthService.signOut();
          if (!entraSignOutSuccess) {
            // If Entra sign-out failed, mark as error
            AppLogger.instance.error(
              title: 'AuthBloc',
              message:
                  'Entra sign-out failed, clearing Entra tokens but preserving local storage',
            );
          }
        } catch (e) {
          // If there's an exception, mark as error
          entraSignOutSuccess = false;
          AppLogger.instance.error(
            title: 'AuthBloc',
            message: 'Entra sign-out error: $e',
          );
        }
      }

      // Only clear DIGIT session data if Entra sign-out was successful or no Entra tokens
      // If Entra sign-out failed, do not delete localstorage as per requirement

      emit(const AuthLoadingState());
      await localSecureStore.deleteAll();
      await localSecureStore.setBoundaryRefetch(true);
      emit(const AuthUnauthenticatedState());

      // If hasError is true, we skip deleting localstorage
    } catch (error) {
      // On any error during logout, do not delete localstorage
      AppLogger.instance.error(
        title: 'AuthBloc',
        message: 'Error during logout: $error',
      );
    }
  }

  FutureOr<void> _onAddSpaqCounts(
    AuthAddSpaqCountsEvent event,
    AuthEmitter emit,
  ) async {
    // emit(const AuthLoadingState());

    try {
      int spaq1 = await localSecureStore.spaq1;
      int spaq2 = await localSecureStore.spaq2;

      int additionSpaq1Count = event.spaq1Count;
      int additionSpaq2Count = event.spaq2Count;

      spaq1 = spaq1 + additionSpaq1Count;
      spaq2 = spaq2 + additionSpaq2Count;

      localSecureStore.setSpaqCounts(spaq1, spaq2);

      final accessToken = await localSecureStore.accessToken;
      final refreshToken = await localSecureStore.refreshToken;
      final userObject = await localSecureStore.userRequestModel;
      final actionsList = await localSecureStore.savedActions;
      final userIndividualId = await localSecureStore.userIndividualId;

      if (accessToken == null ||
          refreshToken == null ||
          userObject == null ||
          actionsList == null) {
        emit(const AuthUnauthenticatedState());
      } else {
        emit(AuthAuthenticatedState(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userModel: userObject,
          individualId: userIndividualId,
          actionsWrapper: actionsList,
          spaq1Count: spaq1,
          spaq2Count: spaq2,
        ));
      }
    } catch (_) {
      await localSecureStore.deleteAll();
      emit(const AuthUnauthenticatedState());
      rethrow;
    }
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login({
    required String userId,
    required String password,
    required String tenantId,
  }) = AuthLoginEvent;

  const factory AuthEvent.addSpaqCounts({
    required int spaq1Count,
    required int spaq2Count,
  }) = AuthAddSpaqCountsEvent;

  const factory AuthEvent.ssoLogin({
    required String providerKey,
    required String tenantId,
  }) = AuthSSOLoginEvent;

  const factory AuthEvent.autoLogin({
    required String tenantId,
  }) = AuthAutoLoginEvent;

  const factory AuthEvent.logout() = AuthLogoutEvent;
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = AuthUnauthenticatedState;

  const factory AuthState.loading() = AuthLoadingState;

  const factory AuthState.authenticated({
    required String accessToken,
    required String refreshToken,
    required UserRequestModel userModel,
    required RoleActionsWrapperModel actionsWrapper,
    String? individualId,
    final int? spaq1Count,
    final int? spaq2Count,
  }) = AuthAuthenticatedState;

  const factory AuthState.error([String? error]) = AuthErrorState;
}
