import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/utils/app_logger.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/app_initialization/app_initialization.dart';
import '../data/local_store/app_shared_preferences.dart';
import '../data/remote_client.dart';
import '../data/repositories/remote/mdms.dart';
import '../router/app_router.dart';
import '../utils/environment_config.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../widgets/localized.dart';

@RoutePage()
class InitialScreenPage extends LocalizedStatefulWidget {
  const InitialScreenPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<InitialScreenPage> createState() => _InitialScreenPageState();
}

class _InitialScreenPageState extends LocalizedState<InitialScreenPage> {
  bool _isLoading = false;
  bool _hasNavigated = false;
  List<String> _tenantIds = [];
  String? _selectedValue;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (_hasNavigated) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Wait for app initialization to complete
      final appInitBloc = context.read<AppInitializationBloc>();
      await _waitForAppInitialization(appInitBloc);

      // Fetch tenant list using new API
      final mdmsRepository = MdmsRepository(DioClient().dio);
      final tenantIds = await mdmsRepository.searchTenants();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _tenantIds = tenantIds;
          if (tenantIds.isEmpty) {
            _errorMessage = 'No tenants found';
          }
        });
      }
    } catch (e) {
      AppLogger.instance.error(
        title: 'InitialScreen',
        message: 'Error fetching tenants: $e',
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load data. Please try again.';
        });
      }
    }
  }

  Future<void> _handleContinue() async {
    if (_selectedValue == null && _tenantIds.isNotEmpty) {
      // Show error if nothing selected
      return;
    }

    // Store the selected tenantId in AppSharedPreferences
    if (_selectedValue != null) {
      await AppSharedPreferences().setSelectedTenantId(_selectedValue!);
    }

    if (mounted && !_hasNavigated) {
      _hasNavigated = true;
      context.router.replaceAll([const LanguageSelectionRoute()]);
    }
  }

  Future<void> _waitForAppInitialization(
    AppInitializationBloc bloc,
  ) async {
    // Wait for app to be initialized
    int attempts = 0;
    const maxAttempts = 20;

    while (attempts < maxAttempts) {
      final state = bloc.state;
      if (state is AppInitialized) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      body: Container(
        color: theme.colorTheme.primary.primary2,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _tenantIds.isEmpty && _errorMessage == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(spacer4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: spacer8),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: spacer4),
                              child: Text(
                                _errorMessage!,
                                style: textTheme.bodyL.copyWith(
                                  color: theme.colorTheme.alert.error,
                                ),
                              ),
                            ),
                          if (_tenantIds.isNotEmpty) ...[
                            DigitCard(
                              margin: const EdgeInsets.all(spacer2),
                              children: [
                                Text(
                                  localizations.translate(
                                    i18.common.coreCommonTenant,
                                  ),
                                  style: textTheme.headingM.copyWith(
                                    color: theme.colorTheme.primary.primary2,
                                  ),
                                ),
                                const SizedBox(height: spacer4),
                                DigitDropdown<String>(
                                  selectedOption: _selectedValue != null
                                      ? DropdownItem(
                                          code: _selectedValue!,
                                          name: _selectedValue!,
                                        )
                                      : null,
                                  items: _tenantIds
                                      .map((tenantId) => DropdownItem(
                                            code: tenantId,
                                            name: tenantId,
                                          ))
                                      .toList(),
                                  onSelect: (value) {
                                    setState(() {
                                      _selectedValue = value.code;
                                    });
                                  },
                                  onChange: (value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        _selectedValue = null;
                                      });
                                    }
                                  },
                                  emptyItemText: localizations.translate(
                                    i18.common.noMatchFound,
                                  ),
                                ),
                                const SizedBox(height: spacer4),
                                DigitButton(
                                  label: localizations.translate(
                                    i18.common.coreCommonContinue,
                                  ),
                                  type: DigitButtonType.primary,
                                  size: DigitButtonSize.large,
                                  mainAxisSize: MainAxisSize.max,
                                  onPressed: _handleContinue,
                                ),
                              ],
                            ),
                          ] else if (_errorMessage != null) ...[
                            DigitCard(
                              margin: const EdgeInsets.all(spacer2),
                              children: [
                                Text(
                                  _errorMessage!,
                                  style: textTheme.bodyL,
                                ),
                                const SizedBox(height: spacer4),
                                DigitButton(
                                  label: localizations.translate(
                                    i18.common.coreCommonRetry,
                                  ),
                                  type: DigitButtonType.primary,
                                  size: DigitButtonSize.large,
                                  mainAxisSize: MainAxisSize.max,
                                  onPressed: () {
                                    setState(() {
                                      _errorMessage = null;
                                    });
                                    _initializeApp();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

}
