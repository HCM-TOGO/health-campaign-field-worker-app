import 'package:closed_household/closed_household.dart';
import 'package:closed_household/router/closed_household_router.gm.dart';
import 'package:health_campaign_field_worker_app/models/entities/assessment_checklist/status.dart';

import 'package:inventory_management/router/inventory_router.gm.dart';
import 'package:recase/recase.dart';
import 'package:referral_reconciliation/referral_reconciliation.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';

import 'package:referral_reconciliation/blocs/search_referral_reconciliations.dart';
import 'package:referral_reconciliation/referral_reconciliation.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';

import 'package:attendance_management/attendance_management.dart';
import 'package:attendance_management/router/attendance_router.gm.dart';
import 'package:complaints/complaints.dart';

import 'package:complaints/models/pgr_complaints.dart';
import 'package:complaints/router/complaints_router.gm.dart';

import 'package:digit_data_model/models/entities/household_type.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import 'package:inventory_management/inventory_management.dart';

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_dss/data/local_store/no_sql/schema/dashboard_config_schema.dart';
import 'package:digit_dss/models/entities/dashboard_response_model.dart';
import 'package:digit_dss/router/dashboard_router.gm.dart';
import 'package:digit_dss/utils/utils.dart';
import 'package:digit_location_tracker/utils/utils.dart';
import 'package:digit_components/widgets/digit_card.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/utils/component_utils.dart';
import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:survey_form/models/entities/service.dart';
import 'package:survey_form/router/survey_form_router.gm.dart';
import 'package:survey_form/utils/utils.dart';
import 'package:sync_service/blocs/sync/sync.dart';

import '../blocs/app_initialization/app_initialization.dart';
import '../blocs/auth/auth.dart';
import '../blocs/localization/app_localization.dart';
import '../blocs/localization/localization.dart';
import '../data/local_store/app_shared_preferences.dart';
import '../data/local_store/no_sql/schema/app_configuration.dart';
import '../data/local_store/no_sql/schema/service_registry.dart';
import '../data/local_store/secure_store/secure_store.dart';
import '../models/entities/roles_type.dart';
import '../router/app_router.dart';
import '../utils/cdd_sync_summary.dart';
import '../utils/debound.dart';
import '../utils/environment_config.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../utils/least_level_boundary_singleton.dart';
import '../utils/hf_referral_cdd_singleton.dart';
import '../utils/utils.dart';
import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/home/home_item_card.dart';
import '../widgets/localized.dart';
import '../widgets/registration_delivery/custom_beneficiary_progress.dart';
import '../widgets/stock_balance/stock_balance_card.dart';
import '../widgets/showcase/config/showcase_constants.dart';
import '../widgets/showcase/showcase_button.dart';
import 'edit/task_list.dart';
// import 'package:referral_reconciliation/blocs/search_referral_reconciliations.dart';
// import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';
// import 'package:referral_reconciliation/pages/search_referral_reconciliations.dart';

@RoutePage()
class HomePage extends LocalizedStatefulWidget {
  const HomePage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends LocalizedState<HomePage> {
  bool skipProgressBar = false;
  final storage = const FlutterSecureStorage();
  final _homeShowcaseData = HomePageShowcaseData();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool isTriggerLocalisation = true;
  // Stock in hand UI is handled by StockBalanceCard.
  CddSyncSummary? _cddSyncSummary;

  @override
  initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      if (result.firstOrNull == ConnectivityResult.none) {
        if (context.mounted) {
          context.syncRefresh();
        }
      }
    });
    //// Function to set initial Data required for the packages to run
    setPackagesSingleton(context);
  }

  //  Be sure to cancel subscription after you are done
  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.read<AuthBloc>().state;
    final localSecureStore = LocalSecureStore.instance;
    if (state is! AuthAuthenticatedState) {
      return Container();
    }
    final roles = state.userModel.roles.map((e) {
      return e.code;
    });
    final isDistributorRole =
        roles.contains(RolesType.communityDistributor.toValue()) ||
            roles.contains(RolesType.communityDistributor.toValue());

    if (!(roles.contains(RolesType.distributor.toValue()) ||
        roles.contains(RolesType.communityDistributor.toValue()) ||
        roles.contains(RolesType.registrar.toValue()))) {
      skipProgressBar = true;
    }

    final mappedItems = _getItems(context);

    final homeItems = mappedItems?.homeItems ?? [];
    final showcaseKeys = <GlobalKey>[
      if (!skipProgressBar)
        _homeShowcaseData.distributorProgressBar.showcaseKey,
      ...(mappedItems?.showcaseKeys ?? []),
    ];

    return Scaffold(
      backgroundColor: DigitTheme.instance.colorScheme.surface,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ScrollableContent(
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return homeItems.elementAt(index);
                },
                childCount: homeItems.length,
              ),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 145,
                childAspectRatio: 104 / 128,
              ),
            ),
          ],
          header: Column(
            children: [
              const BackNavigationHelpHeaderWidget(
                showBackNavigation: false,
                showHelp: false,
              ),
              skipProgressBar
                  ? const SizedBox.shrink()
                  : _homeShowcaseData.distributorProgressBar.buildWith(
                      child: CustomBeneficiaryProgressBar(
                        label: localizations.translate(
                          i18.home.progressIndicatorTitle,
                        ),
                        prefixLabel: localizations.translate(
                          i18.home.progressIndicatorPrefixLabel,
                        ),
                      ),
                    ),
              Visibility(
                visible: isDistributorRole,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacer2),
                  child: const StockBalanceCard(),
                ),
              ),
            ],
          ),
          footer: Padding(
            padding: const EdgeInsets.only(bottom: spacer2),
            child: PoweredByDigit(
              version: Constants().version,
            ),
          ),
          children: [
            const SizedBox(height: spacer2 * 2),
            // INFO : Need to add sync bloc of package Here
            BlocConsumer<SyncBloc, SyncState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () => null,
                  pendingSync: (count) {
                    if (context.isCDD) {
                      final summary = getCddSyncSummary(
                        context.read<Isar>(),
                        context.loggedInUserUuid,
                      );
                      if (mounted) {
                        setState(() => _cddSyncSummary = summary);
                      }
                    }

                    final debouncer = Debouncer(seconds: 5);
                    debouncer.run(() async {
                      if (count != 0) {
                        await localSecureStore.setManualSyncTrigger(false);
                        if (context.mounted) {
                          await performBackgroundService(
                            isBackground: false,
                            stopService: false,
                            context: context,
                          );
                        }
                      } else {
                        await localSecureStore.setManualSyncTrigger(true);
                      }
                    });
                  },
                  syncInProgress: () async {
                    await localSecureStore.setManualSyncTrigger(false);
                    if (context.mounted) {
                      DigitSyncDialog.show(
                        context,
                        type: DialogType.inProgress,
                        label: localizations.translate(
                          i18.syncDialog.syncInProgressTitle,
                        ),
                        barrierDismissible: false,
                      );
                    }
                  },
                  completedSync: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await localSecureStore.setManualSyncTrigger(true);
                    if (context.mounted) {
                      DigitSyncDialog.show(context,
                          type: DialogType.complete,
                          label: localizations.translate(
                            i18.syncDialog.dataSyncedTitle,
                          ),
                          primaryAction: DigitDialogActions(
                            label: localizations.translate(
                              i18.syncDialog.closeButtonLabel,
                            ),
                            action: (ctx) {
                              Navigator.pop(ctx);
                            },
                          ),
                          barrierDismissible: true);
                    }
                  },
                  failedSync: () async {
                    await localSecureStore.setManualSyncTrigger(true);
                    if (context.mounted) {
                      _showSyncFailedDialog(
                        context,
                        message: localizations.translate(
                          i18.syncDialog.syncFailedTitle,
                        ),
                      );
                    }
                  },
                  failedDownSync: () async {
                    await localSecureStore.setManualSyncTrigger(true);
                    if (context.mounted) {
                      _showSyncFailedDialog(
                        context,
                        message: localizations.translate(
                          i18.syncDialog.downSyncFailedTitle,
                        ),
                      );
                    }
                  },
                  failedUpSync: () async {
                    await localSecureStore.setManualSyncTrigger(true);
                    if (context.mounted) {
                      _showSyncFailedDialog(
                        context,
                        message: localizations.translate(
                          i18.syncDialog.upSyncFailedTitle,
                        ),
                      );
                    }
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const Offstage(),
                  pendingSync: (count) {
                    if (count == 0) return const Offstage();

                    final cddSyncSummary = _cddSyncSummary;
                    final description = context.isCDD && cddSyncSummary != null
                        ? _cddSyncInfoContent(cddSyncSummary)
                        : localizations
                            .translate(i18.home.dataSyncInfoContent)
                            .replaceAll('{}', count.toString());

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacer2,
                      ),
                      child: InfoCard(
                        type: InfoType.info,
                        description: description,
                        title: localizations.translate(
                          i18.home.dataSyncInfoLabel,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSyncFailedDialog(
    BuildContext context, {
    required String message,
  }) {
    Navigator.of(context, rootNavigator: true).pop();

    DigitSyncDialog.show(
      context,
      type: DialogType.failed,
      label: message,
      primaryAction: DigitDialogActions(
        label: localizations.translate(
          i18.syncDialog.retryButtonLabel,
        ),
        action: (ctx) {
          Navigator.pop(ctx);
          // Sync Failed Manual Sync is Enabled
          _attemptSyncUp(context);
        },
      ),
      secondaryAction: DigitDialogActions(
        label: localizations.translate(
          i18.syncDialog.closeButtonLabel,
        ),
        action: (ctx) => Navigator.pop(ctx),
      ),
    );
  }

  String _cddSyncInfoContent(CddSyncSummary summary) {
    return [
      localizations
          .translateWithDefault(
            i18.home.cddSyncInfoChildrenRegistered,
            fallback: '{} enfants enregistrés',
          )
          .replaceAll('{}', summary.childrenRegistered.toString()),
      localizations
          .translateWithDefault(
            i18.home.cddSyncInfoTasksAdministered,
            fallback: '{} tâches administrées',
          )
          .replaceAll('{}', summary.tasksAdministered.toString()),
      localizations
          .translateWithDefault(
            i18.home.cddSyncInfoStockReceived,
            fallback: '{spaq1} SPAQ1 + {spaq2} SPAQ2 reçus',
          )
          .replaceAll('{spaq1}', summary.spaq1Received.toString())
          .replaceAll('{spaq2}', summary.spaq2Received.toString()),
    ].join('\n');
  }

  _HomeItemDataModel? _getItems(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    if (state is! AuthAuthenticatedState) {
      return null;
    }

    final Map<String, Widget> homeItemsMap = {
      i18.home.dashboard: _homeShowcaseData.dashBoard.buildWith(
        child: HomeItemCard(
          icon: Icons.bar_chart_sharp,
          label: i18.home.dashboard,
          onPressed: () {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            context.router.push(const UserDashboardRoute());
          },
        ),
      ),
      i18.home.beneficiaryLabel:
          _homeShowcaseData.distributorBeneficiaries.buildWith(
        child: HomeItemCard(
          icon: Icons.family_restroom_rounded,
          label: i18.home.beneficiaryLabel,
          onPressed: () async {
            RegistrationDeliverySingleton()
                .setHouseholdType(HouseholdType.family);
            context.router.push(const CustomRegistrationDeliveryWrapperRoute());
          },
        ),
      ),
      i18.home.beneficiaryReferralLabel:
          _homeShowcaseData.hfBeneficiaryReferral.buildWith(
        child: HomeItemCard(
          icon: Icons.supervised_user_circle_rounded,
          label: i18.home.beneficiaryReferralLabel,
          onPressed: () async {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            context.router.push(CustomSearchReferralReconciliationsRoute());
          },
        ),
      ),
      i18.home.manageStockLabel:
          _homeShowcaseData.warehouseManagerManageStock.buildWith(
        child: HomeItemCard(
          icon: Icons.store_mall_directory,
          label: i18.home.manageStockLabel,
          onPressed: () {
            context.read<AppInitializationBloc>().state.maybeWhen(
                  orElse: () {},
                  initialized: (
                    AppConfiguration appConfiguration,
                    _,
                    __,
                  ) {
                    context.router.push(CustomManageStocksRoute());
                  },
                );
          },
        ),
      ),
      i18.home.summaryLabel: _homeShowcaseData.summaryReport.buildWith(
        child: HomeItemCard(
          icon: Icons.summarize,
          label: i18.home.summaryLabel,
          onPressed: () {
            context.router.push(CustomSummaryReportRoute());
          },
        ),
      ),
      i18.home.stockReconciliationLabel:
          _homeShowcaseData.wareHouseManagerStockReconciliation.buildWith(
        child: HomeItemCard(
          icon: Icons.menu_book,
          label: i18.home.stockReconciliationLabel,
          onPressed: () {
            context.router.push(CustomStockReconciliationRoute());
          },
        ),
      ),
      i18.home.viewReportsLabel: _homeShowcaseData.inventoryReport.buildWith(
        child: HomeItemCard(
          icon: Icons.announcement,
          label: i18.home.viewReportsLabel,
          onPressed: () {
            context.router.push(CustomInventoryReportSelectionRoute());
          },
        ),
      ),
      i18.home.beneficiaryReferralLabel: HomeItemCard(
        icon: Icons.supervised_user_circle_rounded,
        label: i18.home.beneficiaryReferralLabel,
        onPressed: () async {
          await context.router.push(CustomSearchReferralReconciliationsRoute());
        },
      ),
      i18.home.syncDataLabel: _homeShowcaseData.distributorSyncData.buildWith(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: FlutterBackgroundService().on('serviceRunning'),
          builder: (context, snapshot) {
            return HomeItemCard(
              icon: Icons.sync_alt,
              label: i18.home.syncDataLabel,
              onPressed: () async {
                if (snapshot.data == null ||
                    snapshot.data?['enablesManualSync'] == true) {
                  if (context.mounted) _attemptSyncUp(context);
                } else {
                  if (context.mounted) {
                    Toast.showToast(
                      context,
                      message: localizations
                          .translate(i18.common.coreCommonSyncInProgress),
                      type: ToastType.success,
                    );
                  }
                }
              },
            );
          },
        ),
      ),
      i18.home.db: _homeShowcaseData.db.buildWith(
        child: HomeItemCard(
          icon: Icons.table_chart,
          label: i18.home.db,
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DriftDbViewer(
                  context.read<LocalSqlDataStore>(),
                ),
              ),
            );
          },
        ),
      ),
      i18.home.dashboard: _homeShowcaseData.dashBoard.buildWith(
        child: HomeItemCard(
          icon: Icons.bar_chart_sharp,
          label: i18.home.dashboard,
          onPressed: () {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            ;
            context.router.push(const UserDashboardRoute());
          },
        ),
      ),
      i18.home.fileComplaint:
          _homeShowcaseData.distributorFileComplaint.buildWith(
        child: HomeItemCard(
          icon: Icons.announcement,
          label: i18.home.fileComplaint,
          onPressed: () {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            context.router.push(const ComplaintsInboxWrapperRoute());
          },
        ),
      ),
      i18.home.manageAttendanceLabel:
          _homeShowcaseData.manageAttendance.buildWith(
        child: HomeItemCard(
          icon: Icons.fingerprint_outlined,
          label: i18.home.manageAttendanceLabel,
          onPressed: () {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            ;
            context.router.push(const ManageAttendanceRoute());
          },
        ),
      ),
      i18.home.mySurveyForm: _homeShowcaseData.supervisorMySurveyForm.buildWith(
        child: HomeItemCard(
          enableCustomIcon: true,
          customIcon: mySurveyFormSvg,
          iconPadding: const EdgeInsets.all(spacer1),
          icon: Icons.checklist,
          customIconSize: spacer8,
          label: i18.home.mySurveyForm,
          onPressed: () {
            if (isTriggerLocalisation) {
              triggerLocalization();
              isTriggerLocalisation = false;
            }
            context.router.push(CustomSurveyFormWrapperRoute());
          },
        ),
      ),
      i18.home.closedHouseHoldLabel:
          _homeShowcaseData.closedHouseHold.buildWith(
        child: HomeItemCard(
          icon: Icons.home,
          enableCustomIcon: true,
          customIconSize: 48,
          customIcon: Constants.closedHouseholdSvg,
          label: i18.home.closedHouseHoldLabel,
          onPressed: () {
            context.router.push(const ClosedHouseholdWrapperRoute());
          },
        ),
      ),
      i18.home.editTasks: _homeShowcaseData.editTasks.buildWith(
        child: HomeItemCard(
          icon: Icons.edit_note,
          label: i18.home.editTasks,
          onPressed: () {
            context.router.push(const TaskListRoute());
          },
        ),
      ),
    };

    final Map<String, GlobalKey> homeItemsShowcaseMap = {
      // INFO : Need to add showcase keys of package Here
      i18.home.closedHouseHoldLabel:
          _homeShowcaseData.closedHouseHold.showcaseKey,

      i18.home.manageAttendanceLabel:
          _homeShowcaseData.manageAttendance.showcaseKey,

      i18.home.beneficiaryReferralLabel:
          _homeShowcaseData.hfBeneficiaryReferral.showcaseKey,

      i18.home.beneficiaryLabel:
          _homeShowcaseData.distributorBeneficiaries.showcaseKey,

      i18.home.manageStockLabel:
          _homeShowcaseData.warehouseManagerManageStock.showcaseKey,
      i18.home.stockReconciliationLabel:
          _homeShowcaseData.wareHouseManagerStockReconciliation.showcaseKey,
      i18.home.viewReportsLabel: _homeShowcaseData.inventoryReport.showcaseKey,
      i18.home.syncDataLabel: _homeShowcaseData.distributorSyncData.showcaseKey,
      i18.home.fileComplaint:
          _homeShowcaseData.distributorFileComplaint.showcaseKey,
      i18.home.db: _homeShowcaseData.db.showcaseKey,
      i18.home.dashboard: _homeShowcaseData.dashBoard.showcaseKey,
      i18.home.clfLabel: _homeShowcaseData.clf.showcaseKey,
      i18.home.mySurveyForm:
          _homeShowcaseData.supervisorMySurveyForm.showcaseKey,
      i18.home.summaryLabel: _homeShowcaseData.summaryReport.showcaseKey,
      i18.home.editTasks: _homeShowcaseData.editTasks.showcaseKey,
    };

    final homeItemsLabel = <String>[
      // INFO: Need to add items label of package Here
      i18.home.closedHouseHoldLabel,

      i18.home.manageAttendanceLabel,

      i18.home.beneficiaryReferralLabel,
      i18.home.mySurveyForm,
      i18.home.beneficiaryLabel,
      i18.home.manageStockLabel,
      i18.home.stockReconciliationLabel,
      i18.home.viewReportsLabel,
      i18.home.syncDataLabel,
      i18.home.fileComplaint,
      i18.home.db,
      i18.home.dashboard,
      i18.home.summaryLabel,
      i18.home.editTasks,
    ];

    final List<String> filteredLabels = homeItemsLabel
        .where((element) =>
            state.actionsWrapper.actions
                .map((e) => e.displayName)
                .toList()
                .contains(element) ||
            element == i18.home.db)
        .toList();

    final showcaseKeys = filteredLabels
        .where((f) => f != i18.home.db)
        .map((label) => homeItemsShowcaseMap[label]!)
        .toList();
    if (context.isCDD) filteredLabels.add(i18.home.editTasks);
    if (context.isCDD) filteredLabels.add(i18.home.summaryLabel);

    // if ((envConfig.variables.envType == EnvType.demo && kReleaseMode) ||
    //     envConfig.variables.envType == EnvType.uat) {
    filteredLabels.remove(i18.home.db);
    // }

    final List<Widget> widgetList =
        filteredLabels.map((label) => homeItemsMap[label]!).toList();

    return _HomeItemDataModel(
      widgetList,
      showcaseKeys,
    );
  }

  void _attemptSyncUp(BuildContext context) async {
    await LocalSecureStore.instance.setManualSyncTrigger(true);

    if (context.mounted) {
      context.read<SyncBloc>().add(
            SyncSyncUpEvent(
              userId: context.loggedInUserUuid,
              localRepositories: [
                // INFO : Need to add local repo of package Here
                context.read<
                    LocalRepository<HFReferralModel, HFReferralSearchModel>>(),

                context.read<
                    LocalRepository<AttendanceLogModel,
                        AttendanceLogSearchModel>>(),

                context.read<
                    LocalRepository<PgrServiceModel, PgrServiceSearchModel>>(),

                context
                    .read<LocalRepository<ServiceModel, ServiceSearchModel>>(),
                context.read<
                    LocalRepository<HouseholdModel, HouseholdSearchModel>>(),
                context.read<
                    LocalRepository<ProjectBeneficiaryModel,
                        ProjectBeneficiarySearchModel>>(),
                context.read<
                    LocalRepository<HouseholdMemberModel,
                        HouseholdMemberSearchModel>>(),
                context.read<LocalRepository<TaskModel, TaskSearchModel>>(),
                context.read<
                    LocalRepository<SideEffectModel, SideEffectSearchModel>>(),
                context.read<
                    LocalRepository<ReferralModel, ReferralSearchModel>>(),

                context.read<LocalRepository<StockModel, StockSearchModel>>(),
                context.read<
                    LocalRepository<StockReconciliationModel,
                        StockReconciliationSearchModel>>(),

                context.read<
                    LocalRepository<IndividualModel, IndividualSearchModel>>(),
                // context.read<
                //     LocalRepository<UserActionModel, UserActionSearchModel>>(),
                // context.read<LocalRepository<StockModel, StockSearchModel>>(),
              ],
              remoteRepositories: [
                // INFO : Need to add repo repo of package Here
                context.read<
                    RemoteRepository<HFReferralModel, HFReferralSearchModel>>(),

                context.read<
                    RemoteRepository<AttendanceLogModel,
                        AttendanceLogSearchModel>>(),

                context.read<
                    RemoteRepository<HouseholdModel, HouseholdSearchModel>>(),
                context.read<
                    RemoteRepository<ProjectBeneficiaryModel,
                        ProjectBeneficiarySearchModel>>(),
                context.read<
                    RemoteRepository<HouseholdMemberModel,
                        HouseholdMemberSearchModel>>(),
                context.read<RemoteRepository<TaskModel, TaskSearchModel>>(),
                context.read<
                    RemoteRepository<SideEffectModel, SideEffectSearchModel>>(),
                context.read<
                    RemoteRepository<ReferralModel, ReferralSearchModel>>(),

                context.read<RemoteRepository<StockModel, StockSearchModel>>(),
                context.read<
                    RemoteRepository<StockReconciliationModel,
                        StockReconciliationSearchModel>>(),

                context.read<
                    RemoteRepository<IndividualModel, IndividualSearchModel>>(),
                context.read<
                    RemoteRepository<PgrServiceModel, PgrServiceSearchModel>>(),
                context
                    .read<RemoteRepository<ServiceModel, ServiceSearchModel>>()
                // context.read<
                //     RemoteRepository<UserActionModel, UserActionSearchModel>>(),
              ],
            ),
          );
    }
  }

  void triggerLocalization() {
    context.read<AppInitializationBloc>().state.maybeWhen(
          orElse: () {},
          initialized: (
            AppConfiguration appConfiguration,
            _,
            __,
          ) {
            final appConfig = appConfiguration;
            final localizationModulesList = appConfiguration.backendInterface;
            final selectedLocale = AppSharedPreferences().getSelectedLocale;
            LocalizationParams()
                .setCode(LeastLevelBoundarySingleton().boundary);
            context
                .read<LocalizationBloc>()
                .add(LocalizationEvent.onLoadLocalization(
                  module:
                      "${localizationModulesList?.interfaces.where((element) => element.type == Modules.localizationModule).map((e) => e.name.toString()).join(',')}",
                  tenantId: appConfig.tenantId ?? "default",
                  locale: selectedLocale!,
                  path: Constants.localizationApiPath,
                ));
          },
        );
  }
}

// Function to set initial Data required for the packages to run
void setPackagesSingleton(BuildContext context) {
  context.read<AppInitializationBloc>().state.maybeWhen(
      orElse: () {},
      initialized: (
        AppConfiguration appConfiguration,
        List<ServiceRegistry> serviceRegistry,
        List<DashboardConfigSchema?>? dashboardConfigSchema,
      ) {
        final filteredDashboardConfig = filterDashboardConfig(
            dashboardConfigSchema ?? [], context.projectTypeCode ?? "");
        loadLocalization(context, appConfiguration);
        // INFO : Need to add singleton of package Here
        ClosedHouseholdSingleton().setInitialData(
          loggedInUserUuid: context.loggedInUserUuid,
          projectId: context.projectId,
          beneficiaryType: context.beneficiaryType,
        );

        AttendanceSingleton().setInitialData(
            projectId: context.projectId,
            loggedInIndividualId: context.loggedInIndividualId ?? '',
            loggedInUserUuid: context.loggedInUserUuid,
            appVersion: Constants().version);

        ReferralReconSingleton().setInitialData(
          userName: context.loggedInUser.name ?? '',
          userUUid: context.loggedInUserUuid,
          projectId: context.selectedProject.id,
          projectName: context.selectedProject.name,
          roleCode: RolesType.healthFacilitySupervisor.toValue(),
          appVersion: Constants().version,
          tenantId: envConfig.variables.tenantId,
          validIndividualAgeForCampaign: ValidIndividualAgeForCampaign(
            validMinAge: context.selectedProjectType?.validMinAge ?? 3,
            validMaxAge: context.selectedProjectType?.validMaxAge ?? 64,
          ),
          genderOptions:
              appConfiguration.genderOptions?.map((e) => e.code).toList() ?? [],
          cycles: context.cycles,
          referralReasons:
              appConfiguration.referralReasons?.map((e) => e.code).toList() ??
                  [],
          checklistTypes:
              appConfiguration.checklistTypes?.map((e) => e.code).toList() ??
                  [],
        );

        if (context.isHealthFacilitySupervisor) {
          _fetchAndStoreCddUsers(context);
        }

        RegistrationDeliverySingleton().setInitialData(
          loggedInUserUuid: context.loggedInUserUuid,
          maxRadius: appConfiguration.maxRadius!,
          projectId: context.projectId,
          selectedBeneficiaryType: context.beneficiaryType,
          projectType: context.selectedProjectType,
          selectedProject: context.selectedProject,
          genderOptions:
              appConfiguration.genderOptions!.map((e) => e.code).toList(),
          idTypeOptions:
              appConfiguration.idTypeOptions!.map((e) => e.code).toList(),
          householdDeletionReasonOptions: appConfiguration
              .householdDeletionReasonOptions!
              .map((e) => e.code)
              .toList(),
          householdMemberDeletionReasonOptions: appConfiguration
              .householdMemberDeletionReasonOptions!
              .map((e) => e.code)
              .toList(),
          deliveryCommentOptions: appConfiguration.deliveryCommentOptions!
              .map((e) => e.code)
              .toList(),
          symptomsTypes:
              appConfiguration.symptomsTypes!.map((e) => e.code).toList(),
          referralReasons:
              appConfiguration.referralReasons!.map((e) => e.code).toList(),
          searchHouseHoldFilter: [
            Status.beneficiaryRefused.toValue(),
            Status.beneficiaryReferred.toValue(),
            Status.beneficiaryInEligible.toValue(),
            Status.administeredSuccess.toValue(),
            Status.closeHousehold.toValue(),
            Status.administeredFailed.toValue(),
          ],
          searchCLFFilters: [
            Status.beneficiaryRefused.toValue(),
            Status.beneficiaryReferred.toValue(),
            Status.beneficiaryInEligible.toValue(),
            Status.administeredSuccess.toValue(),
            Status.closeHousehold.toValue(),
            Status.administeredFailed.toValue(),
          ],
          houseStructureTypes: [],
          refusalReasons: [],
          loggedInUser: context.loggedInUserModel,
        );

        InventorySingleton().setInitialData(
          isWareHouseMgr: context.loggedInUserRoles
              .where((role) =>
                  role.code == RolesType.warehouseManager.toValue() ||
                  role.code == RolesType.healthFacilitySupervisor.toValue())
              .toList()
              .isNotEmpty,
          isDistributor: context.loggedInUserRoles
              .where(
                (role) =>
                    role.code == RolesType.distributor.toValue() ||
                    role.code == RolesType.communityDistributor.toValue(),
              )
              .toList()
              .isNotEmpty,
          projectId: context.projectId,
          loggedInUserUuid: context.loggedInUserUuid,
          transportTypes: appConfiguration.transportTypes
              ?.map((e) => InventoryTransportTypes()
                ..name = e.code
                ..code = e.code)
              .toList(),
        );

        DashboardSingleton().setInitialData(
            projectId: context.projectId,
            tenantId: envConfig.variables.tenantId,
            dashboardConfig: filteredDashboardConfig.firstOrNull,
            appVersion: Constants().version,
            selectedProject: context.selectedProject,
            actionPath: Constants.getEndPoint(
              serviceRegistry: serviceRegistry,
              service: DashboardResponseModel.schemaName.toUpperCase(),
              action: ApiOperation.search.toValue(),
              entityName: DashboardResponseModel.schemaName,
            ));
        LocationTrackerSingleton().setInitialData(
          projectId: context.projectId,
          loggedInUserUuid: context.loggedInUserUuid,
        );
        InventorySingleton().setInitialData(
          isWareHouseMgr: context.loggedInUserRoles
              .where((role) =>
                  role.code == RolesType.warehouseManager.toValue() ||
                  role.code == RolesType.healthFacilitySupervisor.toValue())
              .toList()
              .isNotEmpty,
          isDistributor: context.loggedInUserRoles
              .where(
                (role) =>
                    role.code == RolesType.distributor.toValue() ||
                    role.code == RolesType.communityDistributor.toValue(),
              )
              .toList()
              .isNotEmpty,
          loggedInUser: context.loggedInUserModel,
          projectId: context.projectId,
          loggedInUserUuid: context.loggedInUserUuid,
          transportTypes: appConfiguration.transportTypes
              ?.map((e) => InventoryTransportTypes()
                ..name = e.code
                ..code = e.code)
              .toList(),
        );
        InventorySingleton().setBoundary(boundary: context.boundary);
        ClosedHouseholdSingleton().setBoundary(boundary: context.boundary);
        ComplaintsSingleton().setInitialData(
          tenantId: envConfig.variables.tenantId,
          loggedInUserUuid: context.loggedInUserUuid,
          userMobileNumber: context.loggedInUser.mobileNumber,
          loggedInUserName: context.loggedInUser.name,
          complaintTypes:
              appConfiguration.complaintTypes!.map((e) => e.code).toList(),
          userName: context.loggedInUser.name ?? '',
        );
        ComplaintsSingleton().setBoundary(boundary: context.boundary);
        SurveyFormSingleton().setInitialData(
          projectId: context.projectId,
          projectName: context.selectedProject.name,
          loggedInIndividualId: context.loggedInIndividualId ?? '',
          loggedInUserUuid: context.loggedInUserUuid,
          appVersion: Constants().version,
          roles: context.read<AuthBloc>().state.maybeMap(
              orElse: () => const Offstage(),
              authenticated: (res) {
                return res.userModel.roles
                    .map((e) => e.code.snakeCase.toUpperCase())
                    .toList();
              }),
        );
      });
}

Future<void> _fetchAndStoreCddUsers(BuildContext context) async {
  try {
    // Read both repos before any await to avoid BuildContext across async gaps
    final staffRepo = context
        .read<RemoteRepository<ProjectStaffModel, ProjectStaffSearchModel>>();
    final individualRepo = context
        .read<RemoteRepository<IndividualModel, IndividualSearchModel>>();

    // Step 1: get all project staff for this project → collect user UUIDs
    final projectStaffList = await staffRepo.search(
      ProjectStaffSearchModel(
        projectId: [ReferralReconSingleton().projectId],
      ),
    );

    if (projectStaffList.isEmpty) return;

    final userUuids = projectStaffList
        .where((s) => s.userId != null)
        .map((s) => s.userId!)
        .toList();

    if (userUuids.isEmpty) return;

    // Step 2: fetch individual details by userUuid; parse raw response to get
    // userDetails.roles which is not part of IndividualModel
    final response = await individualRepo.dio.post(
      individualRepo.searchPath,
      queryParameters: {
        'offset': 0,
        'limit': userUuids.length,
        'tenantId': DigitDataModelSingleton().tenantId,
      },
      data: {
        'Individual': {
          'userUuid': userUuids,
        },
      },
    );

    final responseMap = response.data;
    if (responseMap is! Map<String, dynamic> ||
        !responseMap.containsKey('Individual')) return;

    final individualList = responseMap['Individual'];
    if (individualList is! List) return;

    const cddRoles = {'COMMUNITY_DISTRIBUTOR', 'DISTRIBUTOR'};

    final users = individualList
        .whereType<Map<String, dynamic>>()
        .where((ind) {
          final userDetails = ind['userDetails'];
          if (userDetails is! Map<String, dynamic>) return false;
          final roles = userDetails['roles'];
          if (roles is! List) return false;
          return roles.any((role) =>
              role is Map<String, dynamic> && cddRoles.contains(role['code']));
        })
        .map((ind) {
          final nameMap = ind['name'];
          final givenName = nameMap is Map<String, dynamic>
              ? nameMap['givenName'] as String? ?? ''
              : '';
          final userDetails = ind['userDetails'] as Map<String, dynamic>?;
          final username = userDetails?['username'] as String? ?? '';
          return CddUser(
            name: givenName.isNotEmpty ? givenName : username,
            username: username,
          );
        })
        .where((u) => u.username.isNotEmpty)
        .toList();

    HFReferralCddSingleton().setCddUsers(users);
  } catch (_) {
    // silently ignore — singleton retains empty list for this session
  }
}

void loadLocalization(
    BuildContext context, AppConfiguration appConfiguration) async {
  LocalizationParams().setModule(['boundary'], true);
  context
      .read<LocalizationBloc>()
      .add(LocalizationEvent.onUpdateLocalizationIndex(
        index: appConfiguration.languages!.indexWhere((element) =>
            element.value == AppSharedPreferences().getSelectedLocale),
        code: AppSharedPreferences().getSelectedLocale!,
      ));
}

class _HomeItemDataModel {
  final List<Widget> homeItems;
  final List<GlobalKey> showcaseKeys;

  const _HomeItemDataModel(this.homeItems, this.showcaseKeys);
}
