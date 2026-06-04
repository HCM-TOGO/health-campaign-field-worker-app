import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data/local_store/sql_store/tables/package_tables/referral.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/models/RadioButtonModel.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/dropdown_wrapper.dart';
import 'package:digit_ui_components/widgets/atoms/pop_up_card.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_campaign_field_worker_app/widgets/custom_back_navigation.dart';
import 'package:intl/intl.dart';
import 'package:registration_delivery/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:referral_reconciliation/models/entities/referral_recon_enums.dart';
import 'package:referral_reconciliation/router/referral_reconciliation_router.gm.dart';
import 'package:referral_reconciliation/utils/extensions/extensions.dart';
import 'package:survey_form/survey_form.dart';

import 'package:referral_reconciliation/utils/i18_key_constants.dart' as i18;
import '../../utils/i18_key_constants.dart' as i18_local;
import 'package:referral_reconciliation/blocs/referral_recon_record.dart';
import 'package:referral_reconciliation/blocs/referral_recon_service_definition.dart';
import 'package:referral_reconciliation/models/entities/hf_referral.dart';
import 'package:referral_reconciliation/utils/utils.dart';
import 'package:referral_reconciliation/widgets/localized.dart';
import '../../router/app_router.dart';
import '../../utils/upper_case.dart';
import '../../widgets/registration_delivery/custom_labeled_field.dart';

@RoutePage()
class CustomRecordReferralDetailsPage extends LocalizedStatefulWidget {
  final bool isEditing;
  final String projectId;
  final List<String> cycles;

  const CustomRecordReferralDetailsPage({
    super.key,
    super.appLocalizations,
    this.isEditing = false,
    required this.projectId,
    required this.cycles,
  });

  @override
  State<CustomRecordReferralDetailsPage> createState() =>
      _CustomRecordReferralDetailsPageState();
}

class _CustomRecordReferralDetailsPageState
    extends LocalizedState<CustomRecordReferralDetailsPage> {
  static const _nameOfChildKey = 'nameOfChild';
  // static const _evaluationFacilityKey = 'evaluationFacility';
  static const _referralReason = 'referralReason';
  // static const _referredByKey = 'referredBy';
  static const _genderKey = 'gender';
  // static const _cycleKey = 'cycle';
  static const _beneficiaryIdKey = '';
  static const _referralCodeKey = 'referralCode';
  static const _ageKey = 'ageInMonths';

  // Code for side-effect reporting service definition
  static const _sideEffectServiceCode =
      'SMCTogo.HF_RF_SIDE_EFFECTS.HEALTH_FACILITY_SUPERVISOR';

  String selectedReasonIndex = '';
  final clickedStatus = ValueNotifier<bool>(false);

  // ---- helpers reading from bloc state ----

  bool _isSideEffectMode(RecordHFReferralState recordState) {
    return recordState.mapOrNull(
          create: (v) =>
              v.hfReferralModel?.additionalFields?.fields.any((f) =>
                  f.key == 'isSideEffect' && f.value?.toString() == 'true') ??
              false,
        ) ??
        false;
  }

  String? _additionalFieldValue(RecordHFReferralState recordState, String key) {
    return recordState.mapOrNull(
      create: (v) => v.hfReferralModel?.additionalFields?.fields
          .firstWhereOrNull((f) => f.key == key)
          ?.value
          ?.toString(),
    );
  }

  /// [IndividualModel.dateOfBirth] is usually app-formatted (e.g. d MMMM yyyy),
  /// not ISO-8601; [DateTime.tryParse] alone leaves age empty.
  DateTime? _parseIndividualDob(String? dob) {
    if (dob == null || dob.trim().isEmpty) return null;
    final trimmed = dob.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;
    try {
      return DateFormat(Constants().dateFormat).parse(trimmed);
    } catch (_) {
      return null;
    }
  }

  int? _ageInMonthsFromDob(String? dob) {
    final birthDate = _parseIndividualDob(dob);
    if (birthDate == null) return null;
    final now = DateTime.now();
    return ((now.year - birthDate.year) * 12 + now.month - birthDate.month)
        .abs();
  }

  String _individualDisplayName(IndividualModel individual) {
    return [
      individual.name?.givenName,
      individual.name?.familyName,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' ');
  }

  String? _individualBeneficiaryId(IndividualModel individual) {
    return individual.identifiers
        ?.firstWhereOrNull(
          (id) => id.identifierType == 'UNIQUE_BENEFICIARY_ID',
        )
        ?.identifierId;
  }

  @override
  void dispose() {
    clickedStatus.dispose();
    super.dispose();
  }

  /// Re-enable submit after returning from the checklist without completing it.
  /// Also restores [ServiceBloc] — the checklist dispatches [ServiceSurveyFormEvent]
  /// on mount, which switches the footer to a different submit handler.
  Future<void> _pushReferralReasonChecklist({
    required CustomReferralReasonChecklistRoute route,
    required RecordHFReferralState recordState,
  }) async {
    try {
      await context.router.push(route);
    } finally {
      if (mounted) {
        _restoreStateAfterChecklistReturn(recordState);
      }
    }
  }

  void _restoreStateAfterChecklistReturn(RecordHFReferralState recordState) {
    clickedStatus.value = false;
    context.read<ServiceBloc>().add(
          ServiceSearchEvent(
            serviceSearchModel: ServiceSearchModel(
              relatedClientReferenceId: recordState.mapOrNull(
                create: (v) => v.hfReferralModel?.clientReferenceId,
              ),
            ),
          ),
        );
  }

  String _referralClientRefIdForChecklist({
    required bool isSideEffect,
    required RecordHFReferralState recordState,
  }) {
    if (isSideEffect) {
      return recordState.mapOrNull(
            create: (v) => v.hfReferralModel?.clientReferenceId,
          ) ??
          IdGen.i.identifier;
    }
    return IdGen.i.identifier;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    // Read the individual model provided by CustomHFCreateReferralWrapperPage.
    // Will be non-null only in side-effect mode.
    final individual = context.watch<IndividualModel?>();

    return BlocBuilder<ReferralReconServiceDefinitionBloc,
        ReferralReconServiceDefinitionState>(
      builder: (context, state) {
        return state.map(
          empty: (value) => const Text('No Checklist'),
          isloading: (value) => const Center(
            child: CircularProgressIndicator(),
          ),
          serviceDefinitionFetch:
              (ReferralReconServiceDefinitionServiceFetchedState value) {
            return Scaffold(
              body: BlocBuilder<RecordHFReferralBloc, RecordHFReferralState>(
                builder: (context, recordState) {
                  final bool viewOnly = recordState.mapOrNull(
                        create: (value) => value.viewOnly,
                      ) ??
                      false;

                  return ReactiveFormBuilder(
                    key: ValueKey(individual),
                    form: () => buildForm(recordState, individual),
                    builder: (context, form, child) {
                      // In side-effect mode, always sync all pre-filled fields
                      // from the individual model every rebuild.  This is needed
                      // because ReactiveFormBuilder caches the FormGroup and
                      // only calls the `form:` callback once — the first build
                      // may fire before individual is non-null.
                      final isSideEffect = _isSideEffectMode(recordState);
                      if (isSideEffect && individual != null) {
                        final displayName = _individualDisplayName(individual);
                        if (displayName.isNotEmpty &&
                            form.control(_nameOfChildKey).value !=
                                displayName) {
                          form.control(_nameOfChildKey).value = displayName;
                        }
                        final benefId = _individualBeneficiaryId(individual);
                        if (benefId != null &&
                            form.control(_beneficiaryIdKey).value != benefId) {
                          form.control(_beneficiaryIdKey).value = benefId;
                        }
                        // Gender — genderOptions are uppercase codes (e.g. 'MALE'),
                        // but individual.gender?.name is lowercase enum name.
                        // Uppercase it so the Dropdown.selectedOption match works.
                        final genderVal = individual.gender?.name.toUpperCase();
                        if (form.control(_genderKey).value != genderVal) {
                          form.control(_genderKey).value = genderVal;
                        }
                        // Age in months (DOB is app-formatted, not ISO-only)
                        final ageMonths =
                            _ageInMonthsFromDob(individual.dateOfBirth);
                        if (ageMonths != null &&
                            form.control(_ageKey).value != ageMonths) {
                          form.control(_ageKey).value = ageMonths;
                        }
                        // Referral reason
                        form.control(_referralReason).value =
                            _sideEffectServiceCode;
                      } else if (!isSideEffect) {
                        final isViewOnly = recordState.mapOrNull(
                              create: (value) => value.viewOnly,
                            ) ??
                            false;
                        if (isViewOnly &&
                            form.control(_referralReason).value == null) {
                          form.control(_referralReason).value =
                              recordState.mapOrNull(
                            create: (value) => ReferralReconSingleton()
                                .referralReasons
                                .where(
                                    (e) => e == value.hfReferralModel?.symptom)
                                .firstOrNull,
                          );
                        }
                      }
                      return ScrollableContent(
                        enableFixedDigitButton: true,
                        header: const Column(children: [
                          CustomBackNavigationHelpHeaderWidget(
                            showHelp: false,
                          ),
                        ]),
                        footer: BlocBuilder<ServiceBloc, ServiceState>(
                          builder: (context, serviceState) {
                            return serviceState.maybeWhen(
                              orElse: () => DigitCard(
                                  padding:
                                      EdgeInsets.all(theme.spacerTheme.spacer2),
                                  cardType: CardType.primary,
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: clickedStatus,
                                      builder: (context, bool isClicked, _) {
                                        return DigitButton(
                                          size: DigitButtonSize.large,
                                          type: DigitButtonType.primary,
                                          mainAxisSize: MainAxisSize.max,
                                          label: localizations
                                              .translate(recordState.mapOrNull(
                                                    create: (value) {
                                                      if (!value.viewOnly) {
                                                        return i18.common
                                                            .coreCommonSubmit;
                                                      }
                                                      final symptom = form
                                                          .control(
                                                              _referralReason)
                                                          .value
                                                          ?.toString()
                                                          .toUpperCase();
                                                      return symptom == 'SICK'
                                                          ? i18.common
                                                              .corecommonclose
                                                          : i18.common
                                                              .coreCommonNext;
                                                    },
                                                  ) ??
                                                  i18.common.coreCommonSubmit),
                                          onPressed: isClicked
                                              ? () {}
                                              : () async {
                                                  if (form
                                                          .control(_genderKey)
                                                          .value ==
                                                      null) {
                                                    clickedStatus.value = false;
                                                    form
                                                        .control(_genderKey)
                                                        .setErrors({'': true});
                                                  } else if (form
                                                          .control(
                                                              _referralReason)
                                                          .value ==
                                                      null) {
                                                    clickedStatus.value = false;
                                                    form
                                                        .control(
                                                            _referralReason)
                                                        .setErrors({'': true});
                                                  } else if (form
                                                          .control(
                                                              _beneficiaryIdKey)
                                                          .value ==
                                                      null) {
                                                    clickedStatus.value = false;
                                                    form
                                                        .control(
                                                            _beneficiaryIdKey)
                                                        .setErrors({'': true});
                                                  }

                                                  form.markAllAsTouched();

                                                  if (viewOnly) {
                                                    final symptom = form
                                                        .control(
                                                            _referralReason)
                                                        .value as String;
                                                    if (symptom.toUpperCase() ==
                                                        'SICK') {
                                                      context.router.popUntil(
                                                          (route) =>
                                                              route.settings
                                                                  .name ==
                                                              CustomSearchReferralReconciliationsRoute
                                                                  .name);
                                                      context.router.maybePop();
                                                    } else {
                                                      context
                                                          .read<
                                                              ReferralReconServiceDefinitionBloc>()
                                                          .add(
                                                            ReferralReconServiceDefinitionSelectionEvent(
                                                              serviceDefinitionCode:
                                                                  symptom,
                                                            ),
                                                          );
                                                      context
                                                          .read<ServiceBloc>()
                                                          .add(
                                                            ServiceSearchEvent(
                                                              serviceSearchModel:
                                                                  ServiceSearchModel(
                                                                relatedClientReferenceId:
                                                                    recordState
                                                                        .mapOrNull(
                                                                  create: (value) => value
                                                                          .viewOnly
                                                                      ? value
                                                                          .hfReferralModel
                                                                          ?.clientReferenceId
                                                                      : null,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                      context.router.push(
                                                        CustomReferralReasonChecklistPreviewRoute(),
                                                      );
                                                    }
                                                  } else if (!form.valid) {
                                                    return;
                                                  } else if (value
                                                      .serviceDefinitionList
                                                      .isEmpty) {
                                                    Toast.showToast(
                                                      context,
                                                      message: localizations
                                                          .translate(i18
                                                              .referralReconciliation
                                                              .noChecklistFound),
                                                      type: ToastType.error,
                                                    );
                                                  } else {
                                                    final hfState = BlocProvider
                                                        .of<RecordHFReferralBloc>(
                                                      context,
                                                    ).state;
                                                    clickedStatus.value = true;
                                                    final nameOfChild = form
                                                        .control(
                                                            _nameOfChildKey)
                                                        .value as String;
                                                    final age = form
                                                        .control(_ageKey)
                                                        .value as int;
                                                    final gender = form
                                                        .control(_genderKey)
                                                        .value as String;
                                                    final beneficiaryId = form
                                                        .control(
                                                            _beneficiaryIdKey)
                                                        .value as String?;
                                                    final referralCode = form
                                                        .control(
                                                            _referralCodeKey)
                                                        .value as String?;
                                                    final symptom = form
                                                        .control(
                                                            _referralReason)
                                                        .value as String;
                                                    final hfCoordinator =
                                                        hfState.mapOrNull(
                                                      create: (val) => val
                                                          .healthFacilityCord,
                                                    );
                                                    final referredBy =
                                                        hfState.mapOrNull(
                                                      create: (val) =>
                                                          val.referredBy,
                                                    );
                                                    final dateOfEvaluation = hfState
                                                        .mapOrNull(
                                                          create: (val) => val
                                                              .dateOfEvaluation,
                                                        )
                                                        ?.millisecondsSinceEpoch;
                                                    final facilityId =
                                                        hfState.mapOrNull(
                                                      create: (val) =>
                                                          val.facilityId,
                                                    );
                                                    final hfClientRefId =
                                                        _referralClientRefIdForChecklist(
                                                      isSideEffect:
                                                          isSideEffect,
                                                      recordState: recordState,
                                                    );

                                                    if (!isSideEffect) {
                                                      final event = context.read<
                                                          RecordHFReferralBloc>();
                                                      event.add(
                                                        RecordHFReferralCreateEntryEvent(
                                                          hfReferralModel:
                                                              HFReferralModel(
                                                            clientReferenceId:
                                                                hfClientRefId,
                                                            projectFacilityId:
                                                                facilityId,
                                                            projectId: widget
                                                                .projectId,
                                                            name: nameOfChild
                                                                .trim(),
                                                            beneficiaryId:
                                                                beneficiaryId,
                                                            referralCode:
                                                                referralCode,
                                                            symptom: symptom,
                                                            tenantId:
                                                                ReferralReconSingleton()
                                                                    .tenantId,
                                                            rowVersion: 1,
                                                            auditDetails:
                                                                AuditDetails(
                                                              createdBy:
                                                                  ReferralReconSingleton()
                                                                      .userUUid,
                                                              createdTime: context
                                                                  .millisecondsSinceEpoch(),
                                                              lastModifiedBy:
                                                                  ReferralReconSingleton()
                                                                      .userUUid,
                                                              lastModifiedTime:
                                                                  context
                                                                      .millisecondsSinceEpoch(),
                                                            ),
                                                            clientAuditDetails:
                                                                ClientAuditDetails(
                                                              createdBy:
                                                                  ReferralReconSingleton()
                                                                      .userUUid,
                                                              createdTime: context
                                                                  .millisecondsSinceEpoch(),
                                                              lastModifiedBy:
                                                                  ReferralReconSingleton()
                                                                      .userUUid,
                                                              lastModifiedTime:
                                                                  context
                                                                      .millisecondsSinceEpoch(),
                                                            ),
                                                            additionalFields:
                                                                HFReferralAdditionalFields(
                                                              version: 1,
                                                              fields: [
                                                                AdditionalField(
                                                                    "boundaryCode",
                                                                    ReferralReconSingleton()
                                                                        .boundary
                                                                        ?.code),
                                                                if (hfCoordinator !=
                                                                        null &&
                                                                    hfCoordinator
                                                                        .toString()
                                                                        .trim()
                                                                        .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .hFCoordinator
                                                                        .toValue(),
                                                                    hfCoordinator,
                                                                  ),
                                                                if (referredBy !=
                                                                        null &&
                                                                    referredBy
                                                                        .toString()
                                                                        .trim()
                                                                        .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .referredBy
                                                                        .toValue(),
                                                                    referredBy,
                                                                  ),
                                                                if (dateOfEvaluation !=
                                                                        null &&
                                                                    dateOfEvaluation
                                                                        .toString()
                                                                        .trim()
                                                                        .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .dateOfEvaluation
                                                                        .toValue(),
                                                                    dateOfEvaluation,
                                                                  ),
                                                                if (nameOfChild
                                                                    .toString()
                                                                    .trim()
                                                                    .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .nameOfReferral
                                                                        .toValue(),
                                                                    nameOfChild,
                                                                  ),
                                                                if (age
                                                                    .toString()
                                                                    .trim()
                                                                    .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .age
                                                                        .toValue(),
                                                                    age,
                                                                  ),
                                                                if (gender
                                                                    .toString()
                                                                    .trim()
                                                                    .isNotEmpty)
                                                                  AdditionalField(
                                                                    ReferralReconEnums
                                                                        .gender
                                                                        .toValue(),
                                                                    gender,
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    if (symptom.toUpperCase() ==
                                                        'SICK') {
                                                      final shouldSubmit =
                                                          await showDialog<
                                                              bool>(
                                                        context: context,
                                                        builder:
                                                            (BuildContext ctx) {
                                                          return Popup(
                                                            title: localizations
                                                                .translate(
                                                              i18.checklist
                                                                  .checklistDialogLabel,
                                                            ),
                                                            description:
                                                                localizations
                                                                    .translate(
                                                              i18.checklist
                                                                  .checklistDialogDescription,
                                                            ),
                                                            actions: [
                                                              DigitButton(
                                                                label: localizations
                                                                    .translate(
                                                                  i18.checklist
                                                                      .checklistDialogPrimaryAction,
                                                                ),
                                                                type:
                                                                    DigitButtonType
                                                                        .primary,
                                                                size:
                                                                    DigitButtonSize
                                                                        .large,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                    ctx,
                                                                    rootNavigator:
                                                                        true,
                                                                  ).pop(true);
                                                                },
                                                              ),
                                                              DigitButton(
                                                                label: localizations
                                                                    .translate(
                                                                  i18.checklist
                                                                      .checklistDialogSecondaryAction,
                                                                ),
                                                                type: DigitButtonType
                                                                    .secondary,
                                                                size:
                                                                    DigitButtonSize
                                                                        .large,
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                    ctx,
                                                                    rootNavigator:
                                                                        true,
                                                                  ).pop(false);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                      if (!context.mounted)
                                                        return;
                                                      if (shouldSubmit ??
                                                          false) {
                                                        context.router.push(
                                                          CustomReferralReconAcknowedgmentRoute(),
                                                        );
                                                      } else {
                                                        clickedStatus.value =
                                                            false;
                                                      }
                                                    } else {
                                                      context
                                                          .read<
                                                              ReferralReconServiceDefinitionBloc>()
                                                          .add(
                                                            ReferralReconServiceDefinitionSelectionEvent(
                                                                serviceDefinitionCode:
                                                                    symptom),
                                                          );
                                                      _pushReferralReasonChecklist(
                                                        route:
                                                            CustomReferralReasonChecklistRoute(
                                                          beneficiaryId:
                                                              beneficiaryId,
                                                          referralClientRefId:
                                                              hfClientRefId,
                                                          isSideEffect:
                                                              isSideEffect,
                                                          projectBeneficiaryClientReferenceId:
                                                              _additionalFieldValue(
                                                            recordState,
                                                            'projectBeneficiaryClientReferenceId',
                                                          ),
                                                          taskClientReferenceId:
                                                              _additionalFieldValue(
                                                            recordState,
                                                            'taskClientReferenceId',
                                                          ),
                                                        ),
                                                        recordState:
                                                            recordState,
                                                      );
                                                    }
                                                  }
                                                },
                                        );
                                      },
                                    ),
                                  ]),
                              serviceSearch: (value1, value2, value3) {
                                return DigitCard(
                                    cardType: CardType.primary,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: clickedStatus,
                                        builder: (context, bool isClicked, _) {
                                          return DigitButton(
                                            size: DigitButtonSize.large,
                                            type: DigitButtonType.primary,
                                            mainAxisSize: MainAxisSize.max,
                                            label: localizations.translate(
                                                recordState.mapOrNull(
                                                      create: (value) {
                                                        if (!value.viewOnly) {
                                                          return i18.common
                                                              .coreCommonSubmit;
                                                        }
                                                        final symptom = form
                                                            .control(
                                                                _referralReason)
                                                            .value
                                                            ?.toString()
                                                            .toUpperCase();
                                                        return symptom == 'SICK'
                                                            ? i18_local.common
                                                                .corecommonclose
                                                            : i18.common
                                                                .coreCommonNext;
                                                      },
                                                    ) ??
                                                    i18.common
                                                        .coreCommonSubmit),
                                            onPressed: isClicked
                                                ? () {}
                                                : () async {
                                                    if (form
                                                            .control(_genderKey)
                                                            .value ==
                                                        null) {
                                                      clickedStatus.value =
                                                          false;
                                                      form
                                                          .control(_genderKey)
                                                          .setErrors(
                                                              {'': true});
                                                    }
                                                    form.markAllAsTouched();
                                                    if (form.invalid) return;

                                                    if (viewOnly) {
                                                      final symptom = form
                                                          .control(
                                                              _referralReason)
                                                          .value as String;
                                                      final beneficiaryId = form
                                                          .control(
                                                              _beneficiaryIdKey)
                                                          .value as String?;
                                                      if (symptom
                                                              .toUpperCase() ==
                                                          'SICK') {
                                                        context.router.popUntil(
                                                            (route) =>
                                                                route.settings
                                                                    .name ==
                                                                CustomSearchReferralReconciliationsRoute
                                                                    .name);
                                                        context.router
                                                            .maybePop();
                                                      } else if (value1
                                                          .isNotEmpty) {
                                                        context
                                                            .read<
                                                                ReferralReconServiceDefinitionBloc>()
                                                            .add(
                                                              ReferralReconServiceDefinitionSelectionEvent(
                                                                  serviceDefinitionCode:
                                                                      symptom),
                                                            );
                                                        context
                                                            .read<ServiceBloc>()
                                                            .add(
                                                              ServiceSearchEvent(
                                                                serviceSearchModel:
                                                                    ServiceSearchModel(
                                                                  relatedClientReferenceId:
                                                                      recordState
                                                                          .mapOrNull(
                                                                    create: (value) => value
                                                                            .viewOnly
                                                                        ? value
                                                                            .hfReferralModel
                                                                            ?.clientReferenceId
                                                                        : null,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                        context.router.push(
                                                          CustomReferralReasonChecklistPreviewRoute(),
                                                        );
                                                      } else {
                                                        final hfClientRefId =
                                                            recordState
                                                                .mapOrNull(
                                                          create: (value) => value
                                                              .hfReferralModel
                                                              ?.clientReferenceId,
                                                        );
                                                        context
                                                            .read<
                                                                ReferralReconServiceDefinitionBloc>()
                                                            .add(
                                                              ReferralReconServiceDefinitionSelectionEvent(
                                                                serviceDefinitionCode:
                                                                    isSideEffect
                                                                        ? 'SIDE_EFFECT'
                                                                        : symptom,
                                                              ),
                                                            );
                                                        _pushReferralReasonChecklist(
                                                          route:
                                                              CustomReferralReasonChecklistRoute(
                                                            beneficiaryId:
                                                                beneficiaryId,
                                                            referralClientRefId:
                                                                hfClientRefId ??
                                                                    IdGen.i
                                                                        .identifier,
                                                            isSideEffect:
                                                                isSideEffect,
                                                            projectBeneficiaryClientReferenceId:
                                                                _additionalFieldValue(
                                                              recordState,
                                                              'projectBeneficiaryClientReferenceId',
                                                            ),
                                                            taskClientReferenceId:
                                                                _additionalFieldValue(
                                                              recordState,
                                                              'taskClientReferenceId',
                                                            ),
                                                          ),
                                                          recordState:
                                                              recordState,
                                                        );
                                                      }
                                                    } else if (!form.valid) {
                                                      return;
                                                    } else if (value
                                                        .serviceDefinitionList
                                                        .isEmpty) {
                                                      Toast.showToast(
                                                        context,
                                                        message: localizations
                                                            .translate(i18
                                                                .referralReconciliation
                                                                .noChecklistFound),
                                                        type: ToastType.error,
                                                      );
                                                    } else {
                                                      final hfState =
                                                          BlocProvider.of<
                                                              RecordHFReferralBloc>(
                                                        context,
                                                      ).state;
                                                      clickedStatus.value =
                                                          true;
                                                      final nameOfChild = form
                                                          .control(
                                                              _nameOfChildKey)
                                                          .value as String;
                                                      final age = form
                                                          .control(_ageKey)
                                                          .value as int;
                                                      final gender = form
                                                          .control(_genderKey)
                                                          .value as String;
                                                      final beneficiaryId = form
                                                          .control(
                                                              _beneficiaryIdKey)
                                                          .value as String?;
                                                      final referralCode = form
                                                          .control(
                                                              _referralCodeKey)
                                                          .value as String?;
                                                      final symptom = form
                                                          .control(
                                                              _referralReason)
                                                          .value as String;
                                                      final hfCoordinator =
                                                          hfState.mapOrNull(
                                                        create: (val) => val
                                                            .healthFacilityCord,
                                                      );
                                                      final referredBy =
                                                          hfState.mapOrNull(
                                                        create: (val) =>
                                                            val.referredBy,
                                                      );
                                                      final dateOfEvaluation =
                                                          hfState
                                                              .mapOrNull(
                                                                create: (val) =>
                                                                    val.dateOfEvaluation,
                                                              )
                                                              ?.millisecondsSinceEpoch;
                                                      final facilityId =
                                                          hfState.mapOrNull(
                                                        create: (val) =>
                                                            val.facilityId,
                                                      );
                                                      final hfClientRefId =
                                                          _referralClientRefIdForChecklist(
                                                        isSideEffect:
                                                            isSideEffect,
                                                        recordState:
                                                            recordState,
                                                      );

                                                      // Do NOT create HFReferralModel in
                                                      // side-effect mode — only SideEffectModel
                                                      // is created in the checklist step.
                                                      if (!isSideEffect) {
                                                        final event = context.read<
                                                            RecordHFReferralBloc>();
                                                        event.add(
                                                          RecordHFReferralCreateEntryEvent(
                                                            hfReferralModel:
                                                                HFReferralModel(
                                                              clientReferenceId:
                                                                  hfClientRefId,
                                                              projectFacilityId:
                                                                  facilityId,
                                                              projectId:
                                                                  ReferralReconSingleton()
                                                                      .projectId,
                                                              name: nameOfChild
                                                                  .trim(),
                                                              beneficiaryId:
                                                                  beneficiaryId,
                                                              referralCode:
                                                                  referralCode,
                                                              symptom: symptom,
                                                              tenantId:
                                                                  ReferralReconSingleton()
                                                                      .tenantId,
                                                              rowVersion: 1,
                                                              auditDetails:
                                                                  AuditDetails(
                                                                createdBy:
                                                                    ReferralReconSingleton()
                                                                        .userUUid,
                                                                createdTime: context
                                                                    .millisecondsSinceEpoch(),
                                                                lastModifiedBy:
                                                                    ReferralReconSingleton()
                                                                        .userUUid,
                                                                lastModifiedTime:
                                                                    context
                                                                        .millisecondsSinceEpoch(),
                                                              ),
                                                              clientAuditDetails:
                                                                  ClientAuditDetails(
                                                                createdBy:
                                                                    ReferralReconSingleton()
                                                                        .userUUid,
                                                                createdTime: context
                                                                    .millisecondsSinceEpoch(),
                                                                lastModifiedBy:
                                                                    ReferralReconSingleton()
                                                                        .userUUid,
                                                                lastModifiedTime:
                                                                    context
                                                                        .millisecondsSinceEpoch(),
                                                              ),
                                                              additionalFields:
                                                                  HFReferralAdditionalFields(
                                                                version: 1,
                                                                fields: [
                                                                  AdditionalField(
                                                                      "boundaryCode",
                                                                      ReferralReconSingleton()
                                                                          .boundary
                                                                          ?.code),
                                                                  if (hfCoordinator !=
                                                                          null &&
                                                                      hfCoordinator
                                                                          .toString()
                                                                          .trim()
                                                                          .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .hFCoordinator
                                                                          .toValue(),
                                                                      hfCoordinator,
                                                                    ),
                                                                  if (referredBy !=
                                                                          null &&
                                                                      referredBy
                                                                          .toString()
                                                                          .trim()
                                                                          .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .referredBy
                                                                          .toValue(),
                                                                      referredBy,
                                                                    ),
                                                                  if (dateOfEvaluation !=
                                                                          null &&
                                                                      dateOfEvaluation
                                                                          .toString()
                                                                          .trim()
                                                                          .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .dateOfEvaluation
                                                                          .toValue(),
                                                                      dateOfEvaluation,
                                                                    ),
                                                                  if (nameOfChild
                                                                      .toString()
                                                                      .trim()
                                                                      .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .nameOfReferral
                                                                          .toValue(),
                                                                      nameOfChild,
                                                                    ),
                                                                  if (age
                                                                      .toString()
                                                                      .trim()
                                                                      .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .age
                                                                          .toValue(),
                                                                      age,
                                                                    ),
                                                                  if (gender
                                                                      .toString()
                                                                      .trim()
                                                                      .isNotEmpty)
                                                                    AdditionalField(
                                                                      ReferralReconEnums
                                                                          .gender
                                                                          .toValue(),
                                                                      gender,
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      if (symptom
                                                              .toUpperCase() ==
                                                          'SICK') {
                                                        final shouldSubmit =
                                                            await showDialog<
                                                                bool>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              ctx) {
                                                            return Popup(
                                                              title:
                                                                  localizations
                                                                      .translate(
                                                                i18.checklist
                                                                    .checklistDialogLabel,
                                                              ),
                                                              description:
                                                                  localizations
                                                                      .translate(
                                                                i18.checklist
                                                                    .checklistDialogDescription,
                                                              ),
                                                              actions: [
                                                                DigitButton(
                                                                  label: localizations
                                                                      .translate(
                                                                    i18.checklist
                                                                        .checklistDialogPrimaryAction,
                                                                  ),
                                                                  type: DigitButtonType
                                                                      .primary,
                                                                  size:
                                                                      DigitButtonSize
                                                                          .large,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .of(
                                                                      ctx,
                                                                      rootNavigator:
                                                                          true,
                                                                    ).pop(true);
                                                                  },
                                                                ),
                                                                DigitButton(
                                                                  label: localizations
                                                                      .translate(
                                                                    i18.checklist
                                                                        .checklistDialogSecondaryAction,
                                                                  ),
                                                                  type: DigitButtonType
                                                                      .secondary,
                                                                  size:
                                                                      DigitButtonSize
                                                                          .large,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .of(
                                                                      ctx,
                                                                      rootNavigator:
                                                                          true,
                                                                    ).pop(
                                                                        false);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        if (shouldSubmit ??
                                                            false) {
                                                          context.router.push(
                                                            CustomReferralReconAcknowedgmentRoute(),
                                                          );
                                                        } else {
                                                          clickedStatus.value =
                                                              false;
                                                        }
                                                      } else {
                                                        context
                                                            .read<
                                                                ReferralReconServiceDefinitionBloc>()
                                                            .add(
                                                              ReferralReconServiceDefinitionSelectionEvent(
                                                                serviceDefinitionCode:
                                                                    symptom,
                                                              ),
                                                            );
                                                        _pushReferralReasonChecklist(
                                                          route:
                                                              CustomReferralReasonChecklistRoute(
                                                            beneficiaryId:
                                                                beneficiaryId,
                                                            referralClientRefId:
                                                                hfClientRefId,
                                                            isSideEffect:
                                                                isSideEffect,
                                                            projectBeneficiaryClientReferenceId:
                                                                _additionalFieldValue(
                                                              recordState,
                                                              'projectBeneficiaryClientReferenceId',
                                                            ),
                                                            taskClientReferenceId:
                                                                _additionalFieldValue(
                                                              recordState,
                                                              'taskClientReferenceId',
                                                            ),
                                                          ),
                                                          recordState:
                                                              recordState,
                                                        );
                                                      }
                                                    }
                                                  },
                                          );
                                        },
                                      ),
                                    ]);
                              },
                            );
                          },
                        ),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                DigitCard(
                                    cardType: CardType.primary,
                                    margin: const EdgeInsets.all(spacer2),
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              localizations.translate(
                                                i18.referralReconciliation
                                                    .referralDetails,
                                              ),
                                              style: textTheme.headingXl,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ReactiveWrapperField<String>(
                                          validationMessages: {
                                            'required': (_) =>
                                                localizations.translate(
                                                  i18.common.corecommonRequired,
                                                ),
                                          },
                                          formControlName: _nameOfChildKey,
                                          showErrors: (control) =>
                                              control.invalid &&
                                              control.touched,
                                          // Ensures error is shown if invalid and touched
                                          builder: (field) {
                                            return LabeledField(
                                              isRequired: true,
                                              label: localizations.translate(
                                                i18.referralReconciliation
                                                    .nameOfTheChildLabel,
                                              ),
                                              child: DigitTextFormInput(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter(),
                                                ],
                                                onChange: (val) => {
                                                  form
                                                      .control(_nameOfChildKey)
                                                      .markAsTouched(),
                                                  form
                                                      .control(_nameOfChildKey)
                                                      .value = val,
                                                },
                                                errorMessage: field.errorText,
                                                readOnly: viewOnly,
                                                initialValue: form
                                                    .control(_nameOfChildKey)
                                                    .value,
                                              ),
                                            );
                                          }),
                                      ReactiveWrapperField<String>(
                                          validationMessages: {
                                            'required': (_) =>
                                                localizations.translate(
                                                  i18.common.corecommonRequired,
                                                ),
                                            'onlyAlphabets': (_) =>
                                                localizations.translate(
                                                  i18_local.individualDetails
                                                      .onlyAlphabetsValidationMessage,
                                                ),
                                          },
                                          formControlName: _beneficiaryIdKey,
                                          showErrors: (control) =>
                                              control.invalid &&
                                              control.touched,
                                          builder: (field) {
                                            return CustomLabeledField(
                                              isRequired: true,
                                              label: localizations
                                                  .translate(i18_local
                                                      .beneficiaryDetails
                                                      .beneficiaryId)
                                                  .toString(),
                                              child: DigitTextFormInput(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter(),
                                                ],
                                                onChange: (val) => {
                                                  form
                                                      .control(
                                                          _beneficiaryIdKey)
                                                      .markAsTouched(),
                                                  form
                                                      .control(
                                                          _beneficiaryIdKey)
                                                      .value = val,
                                                },
                                                initialValue: form
                                                    .control(_beneficiaryIdKey)
                                                    .value,
                                                readOnly: viewOnly,
                                                errorMessage: field.errorText,
                                              ),
                                            );
                                          }),
                                      ReactiveWrapperField<int>(
                                          formControlName: _ageKey,
                                          validationMessages: {
                                            'required': (_) =>
                                                localizations.translate(
                                                  i18.common.corecommonRequired,
                                                ),
                                            'max': (_) => localizations
                                                .translate(
                                                  i18.common.maxValue,
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  ReferralReconSingleton()
                                                      .validIndividualAgeForCampaign
                                                      .validMaxAge
                                                      .toString(),
                                                ),
                                            'min': (_) => localizations
                                                .translate(
                                                  i18.common.minValue,
                                                )
                                                .replaceAll(
                                                  '{}',
                                                  ReferralReconSingleton()
                                                      .validIndividualAgeForCampaign
                                                      .validMinAge
                                                      .toString(),
                                                ),
                                          },
                                          showErrors: (control) =>
                                              control.invalid &&
                                              control.touched,
                                          // Ensures error is shown if invalid and touched
                                          builder: (field) {
                                            return LabeledField(
                                              isRequired: true,
                                              label: localizations.translate(
                                                i18.common.ageInMonths,
                                              ),
                                              child: DigitTextFormInput(
                                                onChange: (val) => {
                                                  form
                                                      .control(_ageKey)
                                                      .markAsTouched(),
                                                  form.control(_ageKey).value =
                                                      int.tryParse(val),
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  UpperCaseTextFormatter(),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      4)
                                                ],
                                                readOnly: viewOnly,
                                                initialValue: form
                                                            .control(_ageKey)
                                                            .value ==
                                                        null
                                                    ? ""
                                                    : form
                                                        .control(_ageKey)
                                                        .value
                                                        .toString(),
                                                errorMessage: field.errorText,
                                              ),
                                            );
                                          }),
                                      ReactiveWrapperField<String>(
                                          validationMessages: {
                                            '': (_) => localizations.translate(
                                                  i18.common.corecommonRequired,
                                                ),
                                          },
                                          formControlName: _genderKey,
                                          showErrors: (control) =>
                                              control.invalid &&
                                              control.touched,
                                          // Ensures error is shown if invalid and touched
                                          builder: (field) {
                                            return LabeledField(
                                                isRequired: true,
                                                label: localizations.translate(
                                                  i18.common.genderLabelText,
                                                ),
                                                child: Dropdown(
                                                  readOnly: viewOnly,
                                                  onSelect: (val) => {
                                                    form
                                                        .control(_genderKey)
                                                        .markAsTouched(),
                                                    form
                                                        .control(_genderKey)
                                                        .value = val.code,
                                                  },
                                                  errorMessage: field.errorText,
                                                  selectedOption:
                                                      ReferralReconSingleton()
                                                          .genderOptions
                                                          .map(
                                                              (item) =>
                                                                  DropdownItem(
                                                                    name: localizations
                                                                        .translate(
                                                                            item.toUpperCase()),
                                                                    code: item
                                                                        .toString()
                                                                        .toUpperCase(),
                                                                  ))
                                                          .firstWhere(
                                                            (item) =>
                                                                item.code ==
                                                                form
                                                                    .control(
                                                                        _genderKey)
                                                                    .value,
                                                            orElse: () =>
                                                                const DropdownItem(
                                                                    name: '',
                                                                    code: ''),
                                                          ),
                                                  items:
                                                      ReferralReconSingleton()
                                                          .genderOptions
                                                          .map(
                                                            (item) =>
                                                                DropdownItem(
                                                              name: localizations
                                                                  .translate(
                                                                      item),
                                                              code: item
                                                                  .toString(),
                                                            ),
                                                          )
                                                          .toList(),
                                                ));
                                          }),
                                    ]),
                                StatefulBuilder(builder: (context, set) {
                                  final isViewOnly = recordState.mapOrNull(
                                        create: (value) => value.viewOnly,
                                      ) ??
                                      false;
                                  if (isViewOnly &&
                                      form.control(_referralReason).value ==
                                          null) {
                                    form.control(_referralReason).value =
                                        recordState.mapOrNull(
                                      create: (value) =>
                                          ReferralReconSingleton()
                                              .referralReasons
                                              .where((e) =>
                                                  e ==
                                                  value
                                                      .hfReferralModel?.symptom)
                                              .firstOrNull,
                                    );
                                  }
                                  return DigitCard(
                                      cardType: CardType.primary,
                                      margin: const EdgeInsets.all(spacer2),
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ReactiveWrapperField<String>(
                                              formControlName: _referralReason,
                                              validationMessages: {
                                                'required': (_) =>
                                                    localizations.translate(
                                                      i18.common
                                                          .corecommonRequired,
                                                    ),
                                              },
                                              showErrors: (control) =>
                                                  control.invalid &&
                                                  control.touched,
                                              // Ensures error is shown if invalid and touched
                                              builder: (field) {
                                                return LabeledField(
                                                  isRequired: true,
                                                  label:
                                                      localizations.translate(
                                                    i18.referralReconciliation
                                                        .reasonForReferralHeader,
                                                  ),
                                                  child: RadioList(
                                                    readOnly: viewOnly,
                                                    onChanged: (val) {
                                                      form
                                                          .control(
                                                              _referralReason)
                                                          .markAsTouched();
                                                      form
                                                          .control(
                                                              _referralReason)
                                                          .value = val.code;
                                                    },
                                                    groupValue: form
                                                            .control(
                                                                _referralReason)
                                                            .value ??
                                                        "",
                                                    errorMessage:
                                                        field.errorText,
                                                    radioDigitButtons:
                                                        (isSideEffect
                                                                // Side-effect mode: show only the
                                                                // SIDE_EFFECT reason from the
                                                                // backend-provided referralReasons.
                                                                ? ReferralReconSingleton()
                                                                    .referralReasons
                                                                    .where((r) => r
                                                                        .toString()
                                                                        .toUpperCase()
                                                                        .contains(
                                                                            'SIDE_EFFECT'))
                                                                    .toList()
                                                                // Normal mode: exclude side-effect
                                                                // reasons.
                                                                : ReferralReconSingleton()
                                                                    .referralReasons
                                                                    .where((r) => !r
                                                                        .toString()
                                                                        .toUpperCase()
                                                                        .contains(
                                                                            'SIDE_EFFECT'))
                                                                    .toList())
                                                            .map((r) {
                                                      final code = r
                                                          .toString()
                                                          .toUpperCase();
                                                      // Translate if the key exists;
                                                      // if the library echoes the key
                                                      // back, fall back to title-case.
                                                      final translated =
                                                          localizations
                                                              .translate(code);
                                                      final displayName = translated ==
                                                              code
                                                          ? code
                                                              .split('_')
                                                              .where((w) =>
                                                                  w.isNotEmpty)
                                                              .map((w) =>
                                                                  '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
                                                              .join(' ')
                                                          : translated;
                                                      return RadioButtonModel(
                                                        code: code,
                                                        name: displayName,
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ]);
                                }),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  FormGroup buildForm(
      RecordHFReferralState referralState, IndividualModel? individual) {
    return fb.group(<String, Object>{
      _nameOfChildKey: FormControl<String>(
        value: individual != null
            ? _individualDisplayName(individual)
            : referralState.mapOrNull(
                create: (value) => value.viewOnly &&
                        value.hfReferralModel?.additionalFields?.fields
                                .where((e) =>
                                    e.key ==
                                    ReferralReconEnums.nameOfReferral.toValue())
                                .firstOrNull
                                ?.value !=
                            null
                    ? value.hfReferralModel?.additionalFields?.fields
                        .where((e) =>
                            e.key ==
                            ReferralReconEnums.nameOfReferral.toValue())
                        .firstOrNull
                        ?.value
                        .toString()
                    : value.hfReferralModel?.name ?? '',
              ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
        validators: [
          Validators.required,
          Validators.delegate((validator) {
            final value = validator.value?.toString().trim();
            if (value == null || value.isEmpty) return null;
            const pattern = r"^[A-Za-z\s]+$";
            final regExp = RegExp(pattern);
            return regExp.hasMatch(value) ? null : {'onlyAlphabets': true};
          }),
        ],
      ),
      _beneficiaryIdKey: FormControl<String>(
        validators: [Validators.required],
        value: individual != null
            ? _individualBeneficiaryId(individual)
            : referralState.mapOrNull(
                create: (value) => value.hfReferralModel?.beneficiaryId,
              ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
      ),
      _referralCodeKey: FormControl<String>(
        value: referralState.mapOrNull(
          create: (value) =>
              value.viewOnly ? value.hfReferralModel?.referralCode : null,
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
      ),
      _genderKey: FormControl<String>(
        // Side-effect mode: read gender directly from IndividualModel.
        // Normal / view-only mode: fall back to additionalFields on the record.
        value: individual != null
            ? individual.gender?.name
            : referralState.mapOrNull(
                create: (value) => value.viewOnly &&
                        value.hfReferralModel?.additionalFields?.fields
                                .where((e) =>
                                    e.key ==
                                    ReferralReconEnums.gender.toValue())
                                .firstOrNull
                                ?.value !=
                            null
                    ? value.hfReferralModel?.additionalFields?.fields
                        .where(
                            (e) => e.key == ReferralReconEnums.gender.toValue())
                        .firstOrNull
                        ?.value
                        .toString()
                    : null,
              ),
        disabled: individual != null ||
            (referralState.mapOrNull(
                  create: (value) => value.viewOnly,
                ) ??
                false),
      ),
      _ageKey: FormControl<int>(
        // Side-effect mode: compute age in months from the IndividualModel.
        // Normal / view-only mode: fall back to additionalFields on the record.
        value: individual != null
            ? _ageInMonthsFromDob(individual.dateOfBirth)
            : referralState.mapOrNull(
                create: (value) => value.viewOnly &&
                        value.hfReferralModel?.additionalFields?.fields
                                .where((e) =>
                                    e.key == ReferralReconEnums.age.toValue())
                                .firstOrNull
                                ?.value !=
                            null
                    ? int.tryParse(value
                            .hfReferralModel?.additionalFields?.fields
                            .where((e) =>
                                e.key == ReferralReconEnums.age.toValue())
                            .firstOrNull
                            ?.value
                            .toString() ??
                        '')
                    : null,
              ),
        disabled: individual != null ||
            (referralState.mapOrNull(
                  create: (value) => value.viewOnly,
                ) ??
                false),
        validators: (ReferralReconSingleton()
                        .validIndividualAgeForCampaign
                        .validMaxAge !=
                    0 &&
                ReferralReconSingleton()
                        .validIndividualAgeForCampaign
                        .validMinAge !=
                    0)
            ? [
                Validators.required,
                Validators.max<int>(
                  ReferralReconSingleton()
                      .validIndividualAgeForCampaign
                      .validMaxAge,
                ),
                Validators.min<int>(
                  ReferralReconSingleton()
                      .validIndividualAgeForCampaign
                      .validMinAge,
                ),
              ]
            : [Validators.required],
      ),
      _referralReason: FormControl<String>(
        value: referralState.mapOrNull(
          create: (value) =>
              value.viewOnly && value.hfReferralModel?.symptom != null
                  ? value.hfReferralModel?.symptom
                  : null,
        ),
        disabled: referralState.mapOrNull(
              create: (value) => value.viewOnly,
            ) ??
            false,
        validators: [
          Validators.required,
        ],
      ),
    });
  }
}
