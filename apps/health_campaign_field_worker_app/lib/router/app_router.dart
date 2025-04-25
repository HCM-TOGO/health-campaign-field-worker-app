import 'package:registration_delivery/router/registration_delivery_router.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.dart';

import 'package:attendance_management/router/attendance_router.dart';
import 'package:attendance_management/router/attendance_router.gm.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:inventory_management/router/inventory_router.dart';
import 'package:inventory_management/router/inventory_router.gm.dart';
import 'package:complaints/router/complaints_router.dart';
import 'package:complaints/router/complaints_router.gm.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:auto_route/auto_route.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:registration_delivery/blocs/app_localization.dart';
import 'package:inventory_management/blocs/app_localization.dart';
import '../blocs/localization/app_localization.dart';
import '../pages/acknowledgement.dart';
import '../pages/authenticated.dart';
import '../pages/boundary_selection.dart';
import '../pages/home.dart';
import '../pages/language_selection.dart';
import '../pages/login.dart';
import '../pages/profile.dart';
import '../pages/project_facility_selection.dart';
import '../pages/project_selection.dart';
import '../pages/qr_details_page.dart';
import '../pages/reports/beneficiary/beneficaries_report.dart';
import '../pages/unauthenticated.dart';
import '../pages/beneficiary/beneficiary_search_page.dart';
import '../pages/beneficiary/house_location_page.dart';
import '../pages/inventory/custom_facility_selection.dart';
import '../pages/inventory/custom_manage_stocks.dart';
import '../pages/inventory/custom_record_stock_wrapper.dart';
import '../pages/inventory/custom_stock_details.dart';
import '../pages/inventory/custom_warehouse_details.dart';
import '../pages/inventory/custom_stock_details_in_tabs.dart';
export 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  // INFO : Need to add the router modules here
  modules: [
    AttendanceRoute,
    ComplaintsRoute,
    InventoryRoute,
    ReferralReconciliationRoute,
    RegistrationDeliveryRoute,
  ],
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> routes = [
    AutoRoute(
      page: UnauthenticatedRouteWrapper.page,
      path: '/',
      children: [
        AutoRoute(
          page: LanguageSelectionRoute.page,
          path: 'language_selection',
          initial: true,
        ),
        AutoRoute(page: LoginRoute.page, path: 'login'),
      ],
    ),
    AutoRoute(
      page: AuthenticatedRouteWrapper.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),

        AutoRoute(page: ProfileRoute.page, path: 'profile'),
        AutoRoute(page: UserQRDetailsRoute.page, path: 'user-qr-code'),
        AutoRoute(
          page: BeneficiariesReportRoute.page,
          path: 'beneficiary-downsync-report',
        ),

        // INFO : Need to add Router of package Here
        AutoRoute(
            page: RegistrationDeliveryWrapperRoute.page,
            path: 'registration-delivery-wrapper',
            children: [
              AutoRoute(
                  // initial: true,
                  page: SearchBeneficiaryRoute.page,
                  path: 'search-beneficiary'),

              AutoRoute(
                  initial: true,
                  page: CustomSearchBeneficiaryRoute.page,
                  path: 'custom-search-beneficiary'),
              RedirectRoute(
                  path: 'search-beneficiary',
                  redirectTo: 'custom-search-beneficiary'),

              AutoRoute(
                page: FacilitySelectionRoute.page,
                path: 'select-facilities',
              ),

              /// Beneficiary Registration
              AutoRoute(
                page: BeneficiaryRegistrationWrapperRoute.page,
                path: 'beneficiary-registration',
                children: [
                  AutoRoute(
                      page: IndividualDetailsRoute.page,
                      path: 'individual-details'),
                  AutoRoute(
                      page: HouseHoldDetailsRoute.page,
                      path: 'household-details'),
                  AutoRoute(
                    page: HouseholdLocationRoute.page,
                    path: 'household-location',
                    // initial: true,
                  ),
                  AutoRoute(
                    page: CustomHouseholdLocationRoute.page,
                    path: 'custom-household-location',
                    initial: true,
                  ),
                  RedirectRoute(
                      path: 'household-location',
                      redirectTo: 'custom-household-location'),
                  AutoRoute(
                    page: BeneficiaryAcknowledgementRoute.page,
                    path: 'beneficiary-acknowledgement',
                  ),
                ],
              ),
              AutoRoute(
                page: BeneficiaryWrapperRoute.page,
                path: 'beneficiary',
                children: [
                  AutoRoute(
                    page: HouseholdOverviewRoute.page,
                    path: 'overview',
                    initial: true,
                  ),
                  AutoRoute(
                    page: BeneficiaryDetailsRoute.page,
                    path: 'beneficiary-details',
                  ),
                  AutoRoute(
                    page: DeliverInterventionRoute.page,
                    path: 'deliver-intervention',
                  ),
                  AutoRoute(
                    page: SideEffectsRoute.page,
                    path: 'side-effects',
                  ),
                  AutoRoute(
                    page: ReferBeneficiaryRoute.page,
                    path: 'refer-beneficiary',
                  ),
                  AutoRoute(
                    page: DoseAdministeredRoute.page,
                    path: 'dose-administered',
                  ),
                  AutoRoute(
                    page: SplashAcknowledgementRoute.page,
                    path: 'splash-acknowledgement',
                  ),
                  AutoRoute(
                    page: ReasonForDeletionRoute.page,
                    path: 'reason-for-deletion',
                  ),
                  AutoRoute(
                    page: RecordPastDeliveryDetailsRoute.page,
                    path: 'record-past-delivery-details',
                  ),
                  AutoRoute(
                    page: HouseholdAcknowledgementRoute.page,
                    path: 'household-acknowledgement',
                  ),
                ],
              ),
            ]),

        // Referral Reconciliation Route
        AutoRoute(
            page: HFCreateReferralWrapperRoute.page,
            path: 'hf-referral',
            children: [
              AutoRoute(
                  page: ReferralFacilityRoute.page,
                  path: 'facility-details',
                  initial: true),
              AutoRoute(
                  page: RecordReferralDetailsRoute.page,
                  path: 'referral-details'),
              AutoRoute(
                page: ReferralReasonChecklistRoute.page,
                path: 'referral-checklist-create',
              ),
              AutoRoute(
                page: ReferralReasonChecklistPreviewRoute.page,
                path: 'referral-checklist-view',
              ),
            ]),
        AutoRoute(
          page: ReferralReconAcknowledgementRoute.page,
          path: 'referral-acknowledgement',
        ),
        AutoRoute(
          page: ReferralReconProjectFacilitySelectionRoute.page,
          path: 'referral-project-facility',
        ),
        AutoRoute(
          page: SearchReferralReconciliationsRoute.page,
          path: 'search-referrals',
        ),

        // Inventory Route
        AutoRoute(
          page: CustomManageStocksRoute.page,
          path: 'custom-manage-stocks',
        ),
        AutoRoute(
          page: CustomRecordStockWrapperRoute.page,
          path: 'custom-record-stock',
          children: [
            AutoRoute(
              page: CustomWarehouseDetailsRoute.page,
              path: 'custom-warehouse-details',
              initial: true,
            ),
            AutoRoute(
                page: CustomStockDetailsRoute.page, path: 'custom-details'),
            // AutoRoute(
            //     page: DynamicTabsPageRoute.page, path: 'custom-details-in-tab'),
          ],
        ),
        AutoRoute(
          page: InventoryFacilitySelectionRoute.page,
          path: 'inventory-select-facilities',
        ),
        AutoRoute(
          page: StockReconciliationRoute.page,
          path: 'stock-reconciliation',
        ),
        AutoRoute(
          page: InventoryReportSelectionRoute.page,
          path: 'inventory-report-selection',
        ),
        AutoRoute(
          page: InventoryReportDetailsRoute.page,
          path: 'inventory-report-details',
        ),
        AutoRoute(
          page: InventoryAcknowledgementRoute.page,
          path: 'inventory-acknowledgement',
        ),

        AutoRoute(
          page: ComplaintsInboxWrapperRoute.page,
          path: 'complaints-inbox',
          children: [
            AutoRoute(
              page: ComplaintsInboxRoute.page,
              path: 'complaints-inbox-items',
              initial: true,
            ),
            AutoRoute(
              page: ComplaintsInboxFilterRoute.page,
              path: 'complaints-inbox-filter',
            ),
            AutoRoute(
              page: ComplaintsInboxSearchRoute.page,
              path: 'complaints-inbox-search',
            ),
            AutoRoute(
              page: ComplaintsInboxSortRoute.page,
              path: 'complaints-inbox-sort',
            ),
            AutoRoute(
              page: ComplaintsDetailsViewRoute.page,
              path: 'complaints-inbox-view-details',
            ),
          ],
        ),

        /// Complaints registration
        AutoRoute(
          page: ComplaintsRegistrationWrapperRoute.page,
          path: 'complaints-registration',
          children: [
            AutoRoute(
              page: ComplaintTypeRoute.page,
              path: 'complaints-type',
              initial: true,
            ),
            AutoRoute(
              page: ComplaintsLocationRoute.page,
              path: 'complaints-location',
            ),
            AutoRoute(
              page: ComplaintsDetailsRoute.page,
              path: 'complaints-details',
            ),
          ],
        ),

        /// Complaints Acknowledgemnet
        AutoRoute(
          page: ComplaintsAcknowledgementRoute.page,
          path: 'complaints-acknowledgement',
        ),

        // Attendance Route
        AutoRoute(
          page: ManageAttendanceRoute.page,
          path: 'manage-attendance',
        ),
        AutoRoute(
          page: AttendanceDateSessionSelectionRoute.page,
          path: 'attendance-date-session-selection',
        ),
        AutoRoute(
          page: MarkAttendanceRoute.page,
          path: 'mark-attendance',
        ),
        AutoRoute(
          page: AttendanceAcknowledgementRoute.page,
          path: 'attendance-acknowledgement',
        ),

        AutoRoute(page: AcknowledgementRoute.page, path: 'acknowledgement'),

        AutoRoute(
          page: ProjectFacilitySelectionRoute.page,
          path: 'select-project-facilities',
        ),

        /// Project Selection
        AutoRoute(
          page: ProjectSelectionRoute.page,
          path: 'select-project',
          initial: true,
        ),

        /// Boundary Selection
        AutoRoute(
          page: BoundarySelectionRoute.page,
          path: 'select-boundary',
        ),
      ],
    )
  ];
}
