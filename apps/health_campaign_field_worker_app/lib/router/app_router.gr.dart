// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AcknowledgementRoute.name: (routeData) {
      final args = routeData.argsAs<AcknowledgementRouteArgs>(
          orElse: () => const AcknowledgementRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AcknowledgementPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
          isDataRecordSuccess: args.isDataRecordSuccess,
          label: args.label,
          description: args.description,
          descriptionTableData: args.descriptionTableData,
        ),
      );
    },
    AuthenticatedRouteWrapper.name: (routeData) {
      final args = routeData.argsAs<AuthenticatedRouteWrapperArgs>(
          orElse: () => const AuthenticatedRouteWrapperArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: AuthenticatedPageWrapper(key: args.key),
      );
    },
    BeneficiariesReportRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const BeneficiariesReportPage(),
      );
    },
    BoundarySelectionRoute.name: (routeData) {
      final args = routeData.argsAs<BoundarySelectionRouteArgs>(
          orElse: () => const BoundarySelectionRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: BoundarySelectionPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CaregiverConsentRoute.name: (routeData) {
      final args = routeData.argsAs<CaregiverConsentRouteArgs>(
          orElse: () => const CaregiverConsentRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CaregiverConsentPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomHouseHoldDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<CustomHouseHoldDetailsRouteArgs>(
          orElse: () => const CustomHouseHoldDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomHouseHoldDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomHouseholdLocationRoute.name: (routeData) {
      final args = routeData.argsAs<CustomHouseholdLocationRouteArgs>(
          orElse: () => const CustomHouseholdLocationRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomHouseholdLocationPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomInventoryReportDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<CustomInventoryReportDetailsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomInventoryReportDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
          reportType: args.reportType,
        ),
      );
    },
    CustomInventoryReportSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<CustomInventoryReportSelectionRouteArgs>(
          orElse: () => const CustomInventoryReportSelectionRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomInventoryReportSelectionPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomManageStocksRoute.name: (routeData) {
      final args = routeData.argsAs<CustomManageStocksRouteArgs>(
          orElse: () => const CustomManageStocksRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomManageStocksPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomStockDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<CustomStockDetailsRouteArgs>(
          orElse: () => const CustomStockDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomStockDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomStockReconciliationRoute.name: (routeData) {
      final args = routeData.argsAs<CustomStockReconciliationRouteArgs>(
          orElse: () => const CustomStockReconciliationRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomStockReconciliationPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomWarehouseDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<CustomWarehouseDetailsRouteArgs>(
          orElse: () => const CustomWarehouseDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomWarehouseDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomePage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    LanguageSelectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LanguageSelectionPage(),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => const ProfileRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProfilePage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    ProjectFacilitySelectionRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectFacilitySelectionRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProjectFacilitySelectionPage(
          key: args.key,
          projectFacilities: args.projectFacilities,
        ),
      );
    },
    ProjectSelectionRoute.name: (routeData) {
      final args = routeData.argsAs<ProjectSelectionRouteArgs>(
          orElse: () => const ProjectSelectionRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProjectSelectionPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    UnauthenticatedRouteWrapper.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UnauthenticatedPageWrapper(),
      );
    },
    UserQRDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<UserQRDetailsRouteArgs>(
          orElse: () => const UserQRDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserQRDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    ...InventoryRoute().pagesMap,
    ...RegistrationDeliveryRoute().pagesMap,
  };
}

/// generated route for
/// [AcknowledgementPage]
class AcknowledgementRoute extends PageRouteInfo<AcknowledgementRouteArgs> {
  AcknowledgementRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    bool isDataRecordSuccess = false,
    String? label,
    String? description,
    Map<String, dynamic>? descriptionTableData,
    List<PageRouteInfo>? children,
  }) : super(
          AcknowledgementRoute.name,
          args: AcknowledgementRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
            isDataRecordSuccess: isDataRecordSuccess,
            label: label,
            description: description,
            descriptionTableData: descriptionTableData,
          ),
          initialChildren: children,
        );

  static const String name = 'AcknowledgementRoute';

  static const PageInfo<AcknowledgementRouteArgs> page =
      PageInfo<AcknowledgementRouteArgs>(name);
}

class AcknowledgementRouteArgs {
  const AcknowledgementRouteArgs({
    this.key,
    this.appLocalizations,
    this.isDataRecordSuccess = false,
    this.label,
    this.description,
    this.descriptionTableData,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  final bool isDataRecordSuccess;

  final String? label;

  final String? description;

  final Map<String, dynamic>? descriptionTableData;

  @override
  String toString() {
    return 'AcknowledgementRouteArgs{key: $key, appLocalizations: $appLocalizations, isDataRecordSuccess: $isDataRecordSuccess, label: $label, description: $description, descriptionTableData: $descriptionTableData}';
  }
}

/// generated route for
/// [AuthenticatedPageWrapper]
class AuthenticatedRouteWrapper
    extends PageRouteInfo<AuthenticatedRouteWrapperArgs> {
  AuthenticatedRouteWrapper({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          AuthenticatedRouteWrapper.name,
          args: AuthenticatedRouteWrapperArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AuthenticatedRouteWrapper';

  static const PageInfo<AuthenticatedRouteWrapperArgs> page =
      PageInfo<AuthenticatedRouteWrapperArgs>(name);
}

class AuthenticatedRouteWrapperArgs {
  const AuthenticatedRouteWrapperArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'AuthenticatedRouteWrapperArgs{key: $key}';
  }
}

/// generated route for
/// [BeneficiariesReportPage]
class BeneficiariesReportRoute extends PageRouteInfo<void> {
  const BeneficiariesReportRoute({List<PageRouteInfo>? children})
      : super(
          BeneficiariesReportRoute.name,
          initialChildren: children,
        );

  static const String name = 'BeneficiariesReportRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [BoundarySelectionPage]
class BoundarySelectionRoute extends PageRouteInfo<BoundarySelectionRouteArgs> {
  BoundarySelectionRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          BoundarySelectionRoute.name,
          args: BoundarySelectionRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'BoundarySelectionRoute';

  static const PageInfo<BoundarySelectionRouteArgs> page =
      PageInfo<BoundarySelectionRouteArgs>(name);
}

class BoundarySelectionRouteArgs {
  const BoundarySelectionRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'BoundarySelectionRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CaregiverConsentPage]
class CaregiverConsentRoute extends PageRouteInfo<CaregiverConsentRouteArgs> {
  CaregiverConsentRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CaregiverConsentRoute.name,
          args: CaregiverConsentRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CaregiverConsentRoute';

  static const PageInfo<CaregiverConsentRouteArgs> page =
      PageInfo<CaregiverConsentRouteArgs>(name);
}

class CaregiverConsentRouteArgs {
  const CaregiverConsentRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CaregiverConsentRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomHouseHoldDetailsPage]
class CustomHouseHoldDetailsRoute
    extends PageRouteInfo<CustomHouseHoldDetailsRouteArgs> {
  CustomHouseHoldDetailsRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomHouseHoldDetailsRoute.name,
          args: CustomHouseHoldDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomHouseHoldDetailsRoute';

  static const PageInfo<CustomHouseHoldDetailsRouteArgs> page =
      PageInfo<CustomHouseHoldDetailsRouteArgs>(name);
}

class CustomHouseHoldDetailsRouteArgs {
  const CustomHouseHoldDetailsRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomHouseHoldDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomHouseholdLocationPage]
class CustomHouseholdLocationRoute
    extends PageRouteInfo<CustomHouseholdLocationRouteArgs> {
  CustomHouseholdLocationRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomHouseholdLocationRoute.name,
          args: CustomHouseholdLocationRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomHouseholdLocationRoute';

  static const PageInfo<CustomHouseholdLocationRouteArgs> page =
      PageInfo<CustomHouseholdLocationRouteArgs>(name);
}

class CustomHouseholdLocationRouteArgs {
  const CustomHouseholdLocationRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomHouseholdLocationRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomInventoryReportDetailsPage]
class CustomInventoryReportDetailsRoute
    extends PageRouteInfo<CustomInventoryReportDetailsRouteArgs> {
  CustomInventoryReportDetailsRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    required InventoryReportType reportType,
    List<PageRouteInfo>? children,
  }) : super(
          CustomInventoryReportDetailsRoute.name,
          args: CustomInventoryReportDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
            reportType: reportType,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomInventoryReportDetailsRoute';

  static const PageInfo<CustomInventoryReportDetailsRouteArgs> page =
      PageInfo<CustomInventoryReportDetailsRouteArgs>(name);
}

class CustomInventoryReportDetailsRouteArgs {
  const CustomInventoryReportDetailsRouteArgs({
    this.key,
    this.appLocalizations,
    required this.reportType,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  final InventoryReportType reportType;

  @override
  String toString() {
    return 'CustomInventoryReportDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations, reportType: $reportType}';
  }
}

/// generated route for
/// [CustomInventoryReportSelectionPage]
class CustomInventoryReportSelectionRoute
    extends PageRouteInfo<CustomInventoryReportSelectionRouteArgs> {
  CustomInventoryReportSelectionRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomInventoryReportSelectionRoute.name,
          args: CustomInventoryReportSelectionRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomInventoryReportSelectionRoute';

  static const PageInfo<CustomInventoryReportSelectionRouteArgs> page =
      PageInfo<CustomInventoryReportSelectionRouteArgs>(name);
}

class CustomInventoryReportSelectionRouteArgs {
  const CustomInventoryReportSelectionRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomInventoryReportSelectionRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomManageStocksPage]
class CustomManageStocksRoute
    extends PageRouteInfo<CustomManageStocksRouteArgs> {
  CustomManageStocksRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomManageStocksRoute.name,
          args: CustomManageStocksRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomManageStocksRoute';

  static const PageInfo<CustomManageStocksRouteArgs> page =
      PageInfo<CustomManageStocksRouteArgs>(name);
}

class CustomManageStocksRouteArgs {
  const CustomManageStocksRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomManageStocksRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomStockDetailsPage]
class CustomStockDetailsRoute
    extends PageRouteInfo<CustomStockDetailsRouteArgs> {
  CustomStockDetailsRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomStockDetailsRoute.name,
          args: CustomStockDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomStockDetailsRoute';

  static const PageInfo<CustomStockDetailsRouteArgs> page =
      PageInfo<CustomStockDetailsRouteArgs>(name);
}

class CustomStockDetailsRouteArgs {
  const CustomStockDetailsRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomStockDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomStockReconciliationPage]
class CustomStockReconciliationRoute
    extends PageRouteInfo<CustomStockReconciliationRouteArgs> {
  CustomStockReconciliationRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomStockReconciliationRoute.name,
          args: CustomStockReconciliationRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomStockReconciliationRoute';

  static const PageInfo<CustomStockReconciliationRouteArgs> page =
      PageInfo<CustomStockReconciliationRouteArgs>(name);
}

class CustomStockReconciliationRouteArgs {
  const CustomStockReconciliationRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomStockReconciliationRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomWarehouseDetailsPage]
class CustomWarehouseDetailsRoute
    extends PageRouteInfo<CustomWarehouseDetailsRouteArgs> {
  CustomWarehouseDetailsRoute({
    Key? key,
    InventoryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomWarehouseDetailsRoute.name,
          args: CustomWarehouseDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomWarehouseDetailsRoute';

  static const PageInfo<CustomWarehouseDetailsRouteArgs> page =
      PageInfo<CustomWarehouseDetailsRouteArgs>(name);
}

class CustomWarehouseDetailsRouteArgs {
  const CustomWarehouseDetailsRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final InventoryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomWarehouseDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<HomeRouteArgs> page = PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [LanguageSelectionPage]
class LanguageSelectionRoute extends PageRouteInfo<void> {
  const LanguageSelectionRoute({List<PageRouteInfo>? children})
      : super(
          LanguageSelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'LanguageSelectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<ProfileRouteArgs> page =
      PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [ProjectFacilitySelectionPage]
class ProjectFacilitySelectionRoute
    extends PageRouteInfo<ProjectFacilitySelectionRouteArgs> {
  ProjectFacilitySelectionRoute({
    Key? key,
    required List<ProjectFacilityModel> projectFacilities,
    List<PageRouteInfo>? children,
  }) : super(
          ProjectFacilitySelectionRoute.name,
          args: ProjectFacilitySelectionRouteArgs(
            key: key,
            projectFacilities: projectFacilities,
          ),
          initialChildren: children,
        );

  static const String name = 'ProjectFacilitySelectionRoute';

  static const PageInfo<ProjectFacilitySelectionRouteArgs> page =
      PageInfo<ProjectFacilitySelectionRouteArgs>(name);
}

class ProjectFacilitySelectionRouteArgs {
  const ProjectFacilitySelectionRouteArgs({
    this.key,
    required this.projectFacilities,
  });

  final Key? key;

  final List<ProjectFacilityModel> projectFacilities;

  @override
  String toString() {
    return 'ProjectFacilitySelectionRouteArgs{key: $key, projectFacilities: $projectFacilities}';
  }
}

/// generated route for
/// [ProjectSelectionPage]
class ProjectSelectionRoute extends PageRouteInfo<ProjectSelectionRouteArgs> {
  ProjectSelectionRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          ProjectSelectionRoute.name,
          args: ProjectSelectionRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'ProjectSelectionRoute';

  static const PageInfo<ProjectSelectionRouteArgs> page =
      PageInfo<ProjectSelectionRouteArgs>(name);
}

class ProjectSelectionRouteArgs {
  const ProjectSelectionRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'ProjectSelectionRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [UnauthenticatedPageWrapper]
class UnauthenticatedRouteWrapper extends PageRouteInfo<void> {
  const UnauthenticatedRouteWrapper({List<PageRouteInfo>? children})
      : super(
          UnauthenticatedRouteWrapper.name,
          initialChildren: children,
        );

  static const String name = 'UnauthenticatedRouteWrapper';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserQRDetailsPage]
class UserQRDetailsRoute extends PageRouteInfo<UserQRDetailsRouteArgs> {
  UserQRDetailsRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          UserQRDetailsRoute.name,
          args: UserQRDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'UserQRDetailsRoute';

  static const PageInfo<UserQRDetailsRouteArgs> page =
      PageInfo<UserQRDetailsRouteArgs>(name);
}

class UserQRDetailsRouteArgs {
  const UserQRDetailsRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'UserQRDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}
