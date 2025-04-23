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
    ConsentHouseholdAcknowledgementRoute.name: (routeData) {
      final args = routeData.argsAs<ConsentHouseholdAcknowledgementRouteArgs>(
          orElse: () => const ConsentHouseholdAcknowledgementRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ConsentHouseholdAcknowledgementPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
          enableViewHousehold: args.enableViewHousehold,
        ),
      );
    },
    CustomBeneficiaryAcknowledgementRoute.name: (routeData) {
      final args = routeData.argsAs<CustomBeneficiaryAcknowledgementRouteArgs>(
          orElse: () => const CustomBeneficiaryAcknowledgementRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomBeneficiaryAcknowledgementPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
          enableViewHousehold: args.enableViewHousehold,
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
    CustomHouseholdOverviewRoute.name: (routeData) {
      final args = routeData.argsAs<CustomHouseholdOverviewRouteArgs>(
          orElse: () => const CustomHouseholdOverviewRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomHouseholdOverviewPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
        ),
      );
    },
    CustomIndividualDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<CustomIndividualDetailsRouteArgs>(
          orElse: () => const CustomIndividualDetailsRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomIndividualDetailsPage(
          key: args.key,
          appLocalizations: args.appLocalizations,
          isHeadOfHousehold: args.isHeadOfHousehold,
        ),
      );
    },
    CustomSearchBeneficiaryRoute.name: (routeData) {
      final args = routeData.argsAs<CustomSearchBeneficiaryRouteArgs>(
          orElse: () => const CustomSearchBeneficiaryRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CustomSearchBeneficiaryPage(
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
    HouseHoldConsentRoute.name: (routeData) {
      final args = routeData.argsAs<HouseHoldConsentRouteArgs>(
          orElse: () => const HouseHoldConsentRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HouseHoldConsentPage(
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
    ...AttendanceRoute().pagesMap,
    ...ComplaintsRoute().pagesMap,
    ...InventoryRoute().pagesMap,
    ...ReferralReconciliationRoute().pagesMap,
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
/// [ConsentHouseholdAcknowledgementPage]
class ConsentHouseholdAcknowledgementRoute
    extends PageRouteInfo<ConsentHouseholdAcknowledgementRouteArgs> {
  ConsentHouseholdAcknowledgementRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    bool? enableViewHousehold,
    List<PageRouteInfo>? children,
  }) : super(
          ConsentHouseholdAcknowledgementRoute.name,
          args: ConsentHouseholdAcknowledgementRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
            enableViewHousehold: enableViewHousehold,
          ),
          initialChildren: children,
        );

  static const String name = 'ConsentHouseholdAcknowledgementRoute';

  static const PageInfo<ConsentHouseholdAcknowledgementRouteArgs> page =
      PageInfo<ConsentHouseholdAcknowledgementRouteArgs>(name);
}

class ConsentHouseholdAcknowledgementRouteArgs {
  const ConsentHouseholdAcknowledgementRouteArgs({
    this.key,
    this.appLocalizations,
    this.enableViewHousehold,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  final bool? enableViewHousehold;

  @override
  String toString() {
    return 'ConsentHouseholdAcknowledgementRouteArgs{key: $key, appLocalizations: $appLocalizations, enableViewHousehold: $enableViewHousehold}';
  }
}

/// generated route for
/// [CustomBeneficiaryAcknowledgementPage]
class CustomBeneficiaryAcknowledgementRoute
    extends PageRouteInfo<CustomBeneficiaryAcknowledgementRouteArgs> {
  CustomBeneficiaryAcknowledgementRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    bool? enableViewHousehold,
    List<PageRouteInfo>? children,
  }) : super(
          CustomBeneficiaryAcknowledgementRoute.name,
          args: CustomBeneficiaryAcknowledgementRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
            enableViewHousehold: enableViewHousehold,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomBeneficiaryAcknowledgementRoute';

  static const PageInfo<CustomBeneficiaryAcknowledgementRouteArgs> page =
      PageInfo<CustomBeneficiaryAcknowledgementRouteArgs>(name);
}

class CustomBeneficiaryAcknowledgementRouteArgs {
  const CustomBeneficiaryAcknowledgementRouteArgs({
    this.key,
    this.appLocalizations,
    this.enableViewHousehold,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  final bool? enableViewHousehold;

  @override
  String toString() {
    return 'CustomBeneficiaryAcknowledgementRouteArgs{key: $key, appLocalizations: $appLocalizations, enableViewHousehold: $enableViewHousehold}';
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
/// [CustomHouseholdOverviewPage]
class CustomHouseholdOverviewRoute
    extends PageRouteInfo<CustomHouseholdOverviewRouteArgs> {
  CustomHouseholdOverviewRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomHouseholdOverviewRoute.name,
          args: CustomHouseholdOverviewRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomHouseholdOverviewRoute';

  static const PageInfo<CustomHouseholdOverviewRouteArgs> page =
      PageInfo<CustomHouseholdOverviewRouteArgs>(name);
}

class CustomHouseholdOverviewRouteArgs {
  const CustomHouseholdOverviewRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomHouseholdOverviewRouteArgs{key: $key, appLocalizations: $appLocalizations}';
  }
}

/// generated route for
/// [CustomIndividualDetailsPage]
class CustomIndividualDetailsRoute
    extends PageRouteInfo<CustomIndividualDetailsRouteArgs> {
  CustomIndividualDetailsRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    bool isHeadOfHousehold = true,
    List<PageRouteInfo>? children,
  }) : super(
          CustomIndividualDetailsRoute.name,
          args: CustomIndividualDetailsRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
            isHeadOfHousehold: isHeadOfHousehold,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomIndividualDetailsRoute';

  static const PageInfo<CustomIndividualDetailsRouteArgs> page =
      PageInfo<CustomIndividualDetailsRouteArgs>(name);
}

class CustomIndividualDetailsRouteArgs {
  const CustomIndividualDetailsRouteArgs({
    this.key,
    this.appLocalizations,
    this.isHeadOfHousehold = true,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  final bool isHeadOfHousehold;

  @override
  String toString() {
    return 'CustomIndividualDetailsRouteArgs{key: $key, appLocalizations: $appLocalizations, isHeadOfHousehold: $isHeadOfHousehold}';
  }
}

/// generated route for
/// [CustomSearchBeneficiaryPage]
class CustomSearchBeneficiaryRoute
    extends PageRouteInfo<CustomSearchBeneficiaryRouteArgs> {
  CustomSearchBeneficiaryRoute({
    Key? key,
    RegistrationDeliveryLocalization? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          CustomSearchBeneficiaryRoute.name,
          args: CustomSearchBeneficiaryRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'CustomSearchBeneficiaryRoute';

  static const PageInfo<CustomSearchBeneficiaryRouteArgs> page =
      PageInfo<CustomSearchBeneficiaryRouteArgs>(name);
}

class CustomSearchBeneficiaryRouteArgs {
  const CustomSearchBeneficiaryRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final RegistrationDeliveryLocalization? appLocalizations;

  @override
  String toString() {
    return 'CustomSearchBeneficiaryRouteArgs{key: $key, appLocalizations: $appLocalizations}';
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
/// [HouseHoldConsentPage]
class HouseHoldConsentRoute extends PageRouteInfo<HouseHoldConsentRouteArgs> {
  HouseHoldConsentRoute({
    Key? key,
    AppLocalizations? appLocalizations,
    List<PageRouteInfo>? children,
  }) : super(
          HouseHoldConsentRoute.name,
          args: HouseHoldConsentRouteArgs(
            key: key,
            appLocalizations: appLocalizations,
          ),
          initialChildren: children,
        );

  static const String name = 'HouseHoldConsentRoute';

  static const PageInfo<HouseHoldConsentRouteArgs> page =
      PageInfo<HouseHoldConsentRouteArgs>(name);
}

class HouseHoldConsentRouteArgs {
  const HouseHoldConsentRouteArgs({
    this.key,
    this.appLocalizations,
  });

  final Key? key;

  final AppLocalizations? appLocalizations;

  @override
  String toString() {
    return 'HouseHoldConsentRouteArgs{key: $key, appLocalizations: $appLocalizations}';
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
