import 'package:health_campaign_field_worker_app/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:registration_delivery/blocs/app_localization.dart'
    as registration_delivery_localization;
import 'package:referral_reconciliation/blocs/app_localization.dart'
    as referral_reconciliation_localization;
import 'package:inventory_management/blocs/app_localization.dart'
    as inventory_localization;
import 'package:complaints/blocs/localization/app_localization.dart'
    as complaints_localization;
import 'dart:ui';

import 'package:attendance_management/blocs/app_localization.dart'
    as attendance_localization;
import 'package:digit_data_model/data/local_store/sql_store/sql_store.dart';
import 'package:digit_dss/blocs/app_localization.dart'
    as digit_dss_localization;
import 'package:digit_scanner/blocs/app_localization.dart'
    as scanner_localization;
import 'package:digit_ui_components/services/AppLocalization.dart'
    as component_localization;
import 'package:flutter_localizations/flutter_localizations.dart';

import '../blocs/localization/app_localization.dart';
import '../data/local_store/no_sql/schema/app_configuration.dart';
import '../data/repositories/local/localization.dart';

getAppLocalizationDelegates({
  required LocalSqlDataStore sql,
  required AppConfiguration appConfig,
  required Locale selectedLocale,
  required Isar isar,
}) {
  return [
    AppLocalizations.getDelegate(appConfig, sql),
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,

    // INFO : Need to add package delegates here

    attendance_localization.AttendanceLocalization.getDelegate(
      LocalizationLocalRepository().returnLocalizationFromSQL(sql) as Future,
      appConfig.languages!,
    ),
    scanner_localization.ScannerLocalization.getDelegate(
      LocalizationLocalRepository().returnLocalizationFromSQL(sql) as Future,
      appConfig.languages!,
    ),
    digit_dss_localization.DashboardLocalization.getDelegate(
      LocalizationLocalRepository().returnLocalizationFromSQL(sql) as Future,
      appConfig.languages!,
    ),
    component_localization.ComponentLocalization.getDelegate(
      LocalizationLocalRepository().returnLocalizationFromSQL(sql) as Future,
      appConfig.languages!,
    ),
    attendance_localization.AttendanceLocalization.getDelegate(
      getLocalizationString(
        isar,
        selectedLocale.toString(),
      ),
      appConfig.languages!,
    ),
    complaints_localization.ComplaintsLocalization.getDelegate(
      LocalizationLocalRepository().returnLocalizationFromSQL(sql) as Future,
      appConfig.languages!,
    ),
    scanner_localization.ScannerLocalization.getDelegate(
      getLocalizationString(
        isar,
        selectedLocale.toString(),
      ),
      appConfig.languages!,
    ),
    inventory_localization.InventoryLocalization.getDelegate(
      getLocalizationString(
        isar,
        selectedLocale.toString(),
      ),
      appConfig.languages!,
    ),
    referral_reconciliation_localization.ReferralReconLocalization.getDelegate(
      getLocalizationString(
        isar,
        selectedLocale.toString(),
      ),
      appConfig.languages!,
    ),
    registration_delivery_localization.RegistrationDeliveryLocalization
        .getDelegate(
      getLocalizationString(
        isar,
        selectedLocale.toString(),
      ),
      appConfig.languages!,
    ),
  ];
}
