import 'package:attendance_management/attendance_management.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_dss/digit_dss.dart';
import 'package:digit_location_tracker/location_tracker.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/services/location_bloc.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/utils/component_utils.dart';
import 'package:digit_ui_components/widgets/atoms/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/blocs/app_initialization/app_initialization.dart';
import 'package:health_campaign_field_worker_app/data/local_store/no_sql/schema/service_registry.dart';
import 'package:health_campaign_field_worker_app/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:inventory_management/inventory_management.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:inventory_management/models/entities/inventory_transport_type.dart';

import '../blocs/auth/auth.dart';
import '../blocs/project/project.dart';
import '../data/local_store/no_sql/schema/app_configuration.dart';
import '../router/app_router.dart';
import '../utils/constants.dart';
import '../utils/extensions/extensions.dart';
import '../utils/i18_key_constants.dart' as i18;
import '../widgets/header/back_navigation_help_header.dart';
import '../widgets/localized.dart';
import '../models/entities/roles_type.dart';

@RoutePage()
class ProjectSelectionPage extends LocalizedStatefulWidget {
  const ProjectSelectionPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<ProjectSelectionPage> createState() => _ProjectSelectionPageState();
}

class _ProjectSelectionPageState extends LocalizedState<ProjectSelectionPage> {
  /// [_selectedProject] is to keep track of the project the user selected.
  /// Primary intention is to use this project during the retry mechanism of a
  /// failing down-sync. At this point, the [ProjectState] has not persisted the
  /// selected project yet
  ProjectModel? _selectedProject;
  DialogRoute? syncDialogRoute;

  @override
  void initState() {
    context.read<ProjectBloc>().add(const ProjectInitializeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Scaffold(
      body: ScrollableContent(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BackNavigationHelpHeaderWidget(
              showBackNavigation: false,
              showLogoutCTA: true,
            ),
            Padding(
              padding: const EdgeInsets.all(spacer4),
              child: Text(
                localizations.translate(
                  i18.projectSelection.projectDetailsLabelText,
                ),
                style: textTheme.headingXl
                    .copyWith(color: theme.colorTheme.primary.primary2),
              ),
            ),
          ],
        ),
        children: [
          BlocConsumer<ProjectBloc, ProjectState>(
            listener: (context, state) {
              final error = state.syncError;

              if (syncDialogRoute?.isActive ?? false) {
                Navigator.of(context).removeRoute(syncDialogRoute!);
              }

              if (error != null) {
                syncDialogRoute = DialogRoute(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => DigitSyncDialogContent(
                    label: localizations.translate(
                      i18.projectSelection.syncFailedTitleText,
                    ),
                    type: DialogType.failed,
                    primaryAction: DigitDialogActions(
                      label: localizations.translate(
                        i18.projectSelection.retryButtonText,
                      ),
                      action: _selectedProject == null
                          ? null
                          : (context) {
                              if (syncDialogRoute?.isActive ?? false) {
                                Navigator.of(context)
                                    .removeRoute(syncDialogRoute!);
                              }
                              context.read<ProjectBloc>().add(
                                    ProjectSelectProjectEvent(
                                      _selectedProject!,
                                    ),
                                  );
                            },
                    ),
                    secondaryAction: DigitDialogActions(
                      label: localizations.translate(
                        i18.projectSelection.dismissButtonText,
                      ),
                      action: (context) {
                        if (syncDialogRoute?.isActive ?? false) {
                          Navigator.of(context).removeRoute(syncDialogRoute!);
                        }
                      },
                    ),
                  ),
                );

                Navigator.of(context).push(syncDialogRoute!);

                return;
              } else if (state.loading) {
                syncDialogRoute = DialogRoute(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => DigitSyncDialogContent(
                    type: DialogType.inProgress,
                    label: localizations.translate(
                      i18.projectSelection.syncInProgressTitleText,
                    ),
                  ),
                );

                Navigator.of(context).push(syncDialogRoute!);
              }

              final selectedProject = state.selectedProject;
              if (selectedProject != null) {
                final boundary = selectedProject.address?.boundary;

                setPackagesSingleton(context);

                if (boundary != null) {
                  // triggerLocationTracking(state.selectedProject!); // TODO: Enable location tracking
                  navigateToBoundary(boundary);
                } else {
                  Toast.showToast(
                    context,
                    message: localizations.translate(
                      i18.projectSelection.fetchBoundaryFailed,
                    ),
                    type: ToastType.error,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state.loading) {
                return const Expanded(
                  child: Center(child: Offstage()),
                );
              }

              final projects = state.projects;

              if (projects.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(localizations.translate(
                          i18.projectSelection.noProjectsAssigned,
                        )),
                        Text(localizations.translate(
                          i18.projectSelection.contactSysAdmin,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            width: 300,
                            child: DigitButton(
                              label: localizations.translate(
                                i18.common.coreCommonOk,
                              ),
                              type: DigitButtonType.primary,
                              size: DigitButtonSize.large,
                              mainAxisSize: MainAxisSize.max,
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthLogoutEvent());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: projects
                    .map(
                      (element) => Padding(
                        padding: const EdgeInsets.all(spacer2),
                        child: MenuCard(
                          icon: Icons.article,
                          heading: element.name,
                          onTap: () {
                            _selectedProject = element;

                            context.read<ProjectBloc>().add(
                                  ProjectSelectProjectEvent(element),
                                );
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void navigateToBoundary(String boundary) async {
    BoundaryBloc boundaryBloc = context.read<BoundaryBloc>();
    boundaryBloc.add(BoundaryFindEvent(code: boundary));
    try {
      await boundaryBloc.stream
          .firstWhere((element) => element.boundaryList.isNotEmpty);
      if (mounted) {
        context.router.replaceAll([
          BoundarySelectionRoute(),
        ]);
      }
    } catch (e) {
      debugPrint('error $e');
    }
  }

  void triggerLocationTracking(ProjectModel project) async {
    context.read<LocationBloc>().add(const LocationEvent.requestPermission());
    var locationState = context.read<LocationBloc>().state;

    if (locationState.hasPermissions) {
      DateTime now = DateTime.now();
      DateTime startAfterTimestamp =
          project.startDateTime!.isBefore(now) ? now : project.startDateTime!;
      DateTime endAfterTimestamp = project.endDateTime!;
      Isar isar = await Constants().isar;
      final appConfiguration = await isar.appConfigurations.where().findAll();

      if (endAfterTimestamp.isAfter(now)) {
        triggerLocationTracker(
          'com.digit.location_tracker',
          startAfterTimestamp: startAfterTimestamp.millisecondsSinceEpoch,
          locationUpdateInterval: 60 * 1000, // TODO: Read from config
          stopAfterTimestamp: project.endDate ??
              now.add(const Duration(hours: 8)).millisecondsSinceEpoch,
        );

        if (mounted) {
          LocationTrackerService().processLocationData(
              interval: 120, // TODO: Read from config
              createdBy: context.loggedInUserUuid,
              isar: isar);
        }
      }
    } else {
      context.read<LocationBloc>().add(const LocationEvent.requestPermission());
    }
  }

  List<String> getHouseholdFiltersBasedOnProjectType(
      AppConfiguration appConfiguration, BuildContext context) {
    List<String> list = [];
    // TODO add the household search logic if required
    return list;
  }

  void setPackagesSingleton(BuildContext context) {
    context.read<AppInitializationBloc>().state.maybeWhen(
        orElse: () {},
        initialized: (
          AppConfiguration appConfiguration,
          List<ServiceRegistry> serviceRegistry,
          List<DashboardConfigSchema?>? dashboardConfigSchema,
        ) {
          // INFO : Need to add singleton of package Here
          AttendanceSingleton().setInitialData(
              projectId: context.projectId,
              loggedInIndividualId: context.loggedInIndividualId ?? '',
              loggedInUserUuid: context.loggedInUserUuid,
              appVersion: Constants().version);

          InventorySingleton().setInitialData(
            isWareHouseMgr: context.loggedInUserRoles
                .where((role) =>
                    role.code == RolesType.warehouseManager.toValue() ||
                    role.code == RolesType.spaqManager.toValue())
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

          RegistrationDeliverySingleton().setInitialData(
              loggedInUser: context.loggedInUserModel,
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
                  appConfiguration.symptomsTypes?.map((e) => e.code).toList(),
              searchHouseHoldFilter: getHouseholdFiltersBasedOnProjectType(
                  appConfiguration, context),
              referralReasons:
                  appConfiguration.referralReasons?.map((e) => e.code).toList(),
              houseStructureTypes: appConfiguration.houseStructureTypes
                  ?.map((e) => e.code)
                  .toList(),
              refusalReasons:
                  appConfiguration.refusalReasons?.map((e) => e.code).toList(),
              searchCLFFilters: []);
        });
  }
}
