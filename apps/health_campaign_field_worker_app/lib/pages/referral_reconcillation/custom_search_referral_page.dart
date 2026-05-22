import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_scanner/blocs/scanner.dart';
import 'package:digit_ui_components/enum/app_enums.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/digit_button.dart';
import 'package:digit_ui_components/widgets/atoms/digit_info_card.dart';
import 'package:digit_ui_components/widgets/atoms/digit_search_bar.dart';
import 'package:digit_ui_components/widgets/scrollable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:health_campaign_field_worker_app/widgets/custom_back_navigation.dart';
import 'package:referral_reconciliation/utils/extensions/extensions.dart';
import 'package:survey_form/survey_form.dart';
import 'package:registration_delivery/blocs/search_households/household_global_seach.dart';
import 'package:registration_delivery/blocs/search_households/individual_global_search.dart';
import 'package:registration_delivery/data/repositories/local/individual_global_search.dart';
import 'package:registration_delivery/data/repositories/local/household_global_search.dart';
import 'package:registration_delivery/data/repositories/local/registration_delivery_address.dart';
import 'package:registration_delivery/models/entities/household.dart';
import 'package:registration_delivery/models/entities/household_member.dart';
import 'package:registration_delivery/models/entities/project_beneficiary.dart';
import 'package:registration_delivery/models/entities/referral.dart';
import 'package:registration_delivery/models/entities/side_effect.dart';
import 'package:registration_delivery/models/entities/task.dart';

import 'package:referral_reconciliation/blocs/search_referral_reconciliations.dart';
import 'package:referral_reconciliation/models/entities/hf_referral.dart';
import 'package:health_campaign_field_worker_app/router/app_router.dart';
import 'package:referral_reconciliation/utils/i18_key_constants.dart' as i18;
import '../../utils/i18_key_constants.dart' as i18_local;
import 'package:referral_reconciliation/utils/utils.dart';
import 'package:referral_reconciliation/widgets/localized.dart';
import 'package:referral_reconciliation/widgets/view_referral_card.dart';
import 'package:registration_delivery/utils/utils.dart';

import '../../blocs/registration_delivery/custom_search_household.dart';
import '../../data/repositories/local/registration_delivery/custom_individual_global_repository.dart';
import '../../data/repositories/local/registration_delivery/custom_registration_delivery.dart';
import '../../utils/upper_case.dart';

@RoutePage()
class CustomSearchReferralReconciliationsPage extends LocalizedStatefulWidget {
  const CustomSearchReferralReconciliationsPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CustomSearchReferralReconciliationsPage> createState() =>
      _CustomSearchReferralReconciliationsPageState();
}

class _CustomSearchReferralReconciliationsPageState
    extends LocalizedState<CustomSearchReferralReconciliationsPage> {
  final TextEditingController searchController = TextEditingController();
  bool isProximityEnabled = false;
  SearchReferralsBloc? searchReferralsBloc;

  CustomSearchHouseholdsBloc? _customSearchHouseholdsBloc;

  // Beneficiary-ID pattern: XXXX-XXXXX-XXXXX (14 chars including dashes)
  static const int _beneficiaryIdLength = 14;

  @override
  void initState() {
    searchReferralsBloc = SearchReferralsBloc(
      const SearchReferralsState(),
      referralReconDataRepository:
          context.repository<HFReferralModel, HFReferralSearchModel>(context),
    );
    context.read<DigitScannerBloc>().add(
          const DigitScannerEvent.handleScanner(),
        );
    super.initState();
  }

  /// Creates the [CustomSearchHouseholdsBloc] used for individual/task search.
  CustomSearchHouseholdsBloc _buildHouseholdsBloc(BuildContext context) {
    return CustomSearchHouseholdsBloc(
      beneficiaryType: RegistrationDeliverySingleton().beneficiaryType!,
      userUid: RegistrationDeliverySingleton().loggedInUserUuid!,
      projectId: RegistrationDeliverySingleton().projectId!,
      addressRepository: context.read<CustomRegistrationDeliveryAddressRepo>(),
      projectBeneficiary: context.repository<ProjectBeneficiaryModel,
          ProjectBeneficiarySearchModel>(context),
      householdMember:
          context.repository<HouseholdMemberModel, HouseholdMemberSearchModel>(
              context),
      household:
          context.repository<HouseholdModel, HouseholdSearchModel>(context),
      individual:
          context.repository<IndividualModel, IndividualSearchModel>(context),
      taskDataRepository:
          context.repository<TaskModel, TaskSearchModel>(context),
      sideEffectDataRepository:
          context.repository<SideEffectModel, SideEffectSearchModel>(context),
      referralDataRepository:
          context.repository<ReferralModel, ReferralSearchModel>(context),
      individualGlobalSearchRepository:
          context.read<IndividualGlobalSearchRepository>(),
      customIndividualGlobalSearchRepository:
          context.read<CustomIndividualGlobalSearchRepository>(),
      houseHoldGlobalSearchRepository:
          context.read<HouseHoldGlobalSearchRepository>(),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _triggerHouseholdSearch(
      BuildContext context, CustomSearchHouseholdsBloc bloc, String value) {
    final trimmed = value.trim();
    setState(_clearHouseholdSelection);

    if (trimmed.isEmpty) {
      bloc.add(const SearchHouseholdsClearEvent());
      return;
    }

    if (_isSearchingByBeneficiaryId(trimmed)) {
      bloc.add(
        CustomSearchHouseholdsEvent.searchByTag(
          tag: trimmed,
          projectId: RegistrationDeliverySingleton().projectId!,
        ),
      );
    } else if (trimmed.length >= 3) {
      bloc.add(
        CustomSearchHouseholdsEvent.searchByHouseholdHead(
          searchText: trimmed,
          projectId: RegistrationDeliverySingleton().projectId!,
          latitude: 0,
          longitude: 0,
          isProximityEnabled: false,
          maxRadius: null,
          offset: 0,
          limit: 10,
        ),
      );
    } else {
      bloc.add(const SearchHouseholdsClearEvent());
    }
  }

  bool _isSideEffectMode = false;
  HouseholdMemberWrapper? _selectedHouseholdMember;
  String? _selectedIndividualClientRef;

  bool _isSearchingByBeneficiaryId(String value) =>
      isBeneficiaryIdValid(value.trim());

  bool isBeneficiaryIdValid(String value) {
    if (value.trim().length != _beneficiaryIdLength) return false;
    for (var i = 0; i < value.length; i++) {
      if ((i == 4 || i == 9) && value[i] != '-') return false;
      if (value[i].codeUnitAt(0) >= 97 && value[i].codeUnitAt(0) <= 122) {
        return false;
      }
    }
    return true;
  }

  void _clearHouseholdSelection() {
    _selectedHouseholdMember = null;
    _selectedIndividualClientRef = null;
  }

  String? _beneficiaryIdForIndividual(IndividualModel? individual) {
    return individual?.identifiers
        ?.firstWhereOrNull(
          (id) => id.identifierType == 'UNIQUE_BENEFICIARY_ID',
        )
        ?.identifierId;
  }

  String _fullName(IndividualModel? individual) {
    return [
      individual?.name?.givenName,
      individual?.name?.familyName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');
  }

  bool _nameMatches(IndividualModel individual, String query) {
    final q = query.trim().toUpperCase();
    if (q.length < 3) return false;
    final given = individual.name?.givenName?.trim().toUpperCase() ?? '';
    final family = individual.name?.familyName?.trim().toUpperCase() ?? '';
    final full = '$given $family'.trim();
    return given.contains(q) ||
        family.contains(q) ||
        full.contains(q) ||
        q.contains(given) && given.isNotEmpty ||
        q.contains(family) && family.isNotEmpty;
  }

  /// Same shape as [searchByTag]: one card per person with tasks/side-effects scoped.
  HouseholdMemberWrapper _wrapperForIndividual(
    HouseholdMemberWrapper source,
    IndividualModel individual,
  ) {
    final projectBeneficiaries = source.projectBeneficiaries
        ?.where(
          (e) => e.beneficiaryClientReferenceId == individual.clientReferenceId,
        )
        .toList();
    final projectBeneficiaryIds =
        projectBeneficiaries?.map((e) => e.clientReferenceId).toList() ?? [];

    final tasks = source.tasks
        ?.where((t) =>
            projectBeneficiaryIds.contains(t.projectBeneficiaryClientReferenceId))
        .toList();
    final taskIds = tasks?.map((t) => t.clientReferenceId).toList() ?? [];

    final sideEffects = source.sideEffects
        ?.where((s) => taskIds.contains(s.taskClientReferenceId))
        .toList();

    final referrals = source.referrals
        ?.where((r) => projectBeneficiaryIds
            .contains(r.projectBeneficiaryClientReferenceId))
        .toList();

    return source.copyWith(
      headOfHousehold: individual,
      members: [individual],
      projectBeneficiaries: (projectBeneficiaries?.isEmpty ?? true)
          ? null
          : projectBeneficiaries,
      tasks: (tasks?.isEmpty ?? true) ? null : tasks,
      sideEffects: (sideEffects?.isEmpty ?? true) ? null : sideEffects,
      referrals: (referrals?.isEmpty ?? true) ? null : referrals,
    );
  }

  /// Tag search: bloc already returns one wrapper per person. Name search: expand here.
  List<HouseholdMemberWrapper> _sideEffectCardWrappers(
    CustomSearchHouseholdsState householdState,
    String query,
  ) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    if (_isSearchingByBeneficiaryId(trimmed)) {
      final upperQuery = trimmed.toUpperCase();
      return householdState.householdMembers
          .where((wrapper) {
            final benefId = _beneficiaryIdForIndividual(
              wrapper.headOfHousehold ?? wrapper.members?.firstOrNull,
            );
            return benefId?.trim().toUpperCase() == upperQuery;
          })
          .toList();
    }

    final seen = <String>{};
    final cards = <HouseholdMemberWrapper>[];

    for (final wrapper in householdState.householdMembers) {
      final individuals = <IndividualModel>[
        ...?wrapper.members,
        if (wrapper.headOfHousehold != null) wrapper.headOfHousehold!,
      ];

      var matchedInWrapper = false;
      for (final individual in individuals) {
        final clientRef = individual.clientReferenceId;
        if (clientRef == null || seen.contains(clientRef)) continue;
        if (!_nameMatches(individual, trimmed)) continue;
        matchedInWrapper = true;
        seen.add(clientRef);
        cards.add(_wrapperForIndividual(wrapper, individual));
      }

      // Only show head when their name actually matches the query (not as a default).
      if (!matchedInWrapper && wrapper.headOfHousehold != null) {
        final head = wrapper.headOfHousehold!;
        final clientRef = head.clientReferenceId;
        if (clientRef != null &&
            !seen.contains(clientRef) &&
            _nameMatches(head, trimmed)) {
          seen.add(clientRef);
          cards.add(_wrapperForIndividual(wrapper, head));
        }
      }
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) =>
            BlocProvider<SearchReferralsBloc>(
              create: (context) =>
                  searchReferralsBloc!..add(const SearchReferralsClearEvent()),
              child: BlocProvider<CustomSearchHouseholdsBloc>(
                create: (context) {
                  final bloc = _buildHouseholdsBloc(context);
                  _customSearchHouseholdsBloc = bloc;
                  return bloc;
                },
                child: StatefulBuilder(
                  builder: (context, setInnerState) => Scaffold(
                    body: BlocListener<DigitScannerBloc, DigitScannerState>(
                      listener: (context, scannerState) {
                        if (scannerState.qrCodes.isNotEmpty) {
                          final tag = scannerState.qrCodes.last;
                          if (_isSideEffectMode) {
                            _triggerHouseholdSearch(
                                context,
                                context.read<CustomSearchHouseholdsBloc>(),
                                tag);
                          } else {
                            context.read<SearchReferralsBloc>().add(
                                SearchReferralsEvent.searchByTag(tag: tag));
                          }
                        }
                      },
                      child: BlocProvider(
                        create: (_) => ServiceBloc(
                          const ServiceEmptyState(),
                          serviceDataRepository: context.repository<
                              ServiceModel, ServiceSearchModel>(context),
                        ),
                        child: BlocBuilder<CustomSearchHouseholdsBloc,
                            CustomSearchHouseholdsState>(
                          builder: (context, householdState) {
                            final householdBloc =
                                context.read<CustomSearchHouseholdsBloc>();
                            return BlocBuilder<SearchReferralsBloc,
                                SearchReferralsState>(
                              builder: (context, searchState) {
                                final sideEffectCards = _sideEffectCardWrappers(
                                  householdState,
                                  searchController.text,
                                );
                                final bool beneficiaryFound =
                                    sideEffectCards.isNotEmpty;

                                return ScrollableContent(
                                  header: const Column(children: [
                                    CustomBackNavigationHelpHeaderWidget(
                                        showHelp: false),
                                  ]),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            theme.spacerTheme.spacer2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // ── Page title ──
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      theme.spacerTheme.spacer2,
                                                  vertical: theme
                                                      .spacerTheme.spacer2),
                                              child: Text(
                                                localizations.translate(
                                                  i18_local.searchBeneficiary
                                                      .searchBeneficiaryLabelText,
                                                ),
                                                style: textTheme.headingXl
                                                    .copyWith(
                                                        color: theme.colorTheme
                                                            .text.primary),
                                              ),
                                            ),

                                            // ── Toggle ──
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: theme
                                                      .spacerTheme.spacer2),
                                              child: Row(
                                                children: [
                                                  Switch(
                                                    value: _isSideEffectMode,
                                                    onChanged: (val) {
                                                      setInnerState(() {
                                                        _isSideEffectMode = val;
                                                        _clearHouseholdSelection();
                                                      });
                                                      setState(() {
                                                        _isSideEffectMode = val;
                                                        _clearHouseholdSelection();
                                                      });
                                                      searchController.clear();
                                                      context
                                                          .read<
                                                              SearchReferralsBloc>()
                                                          .add(
                                                              const SearchReferralsClearEvent());
                                                      householdBloc.add(
                                                          const SearchHouseholdsClearEvent());
                                                    },
                                                  ),
                                                  SizedBox(
                                                      width: theme
                                                          .spacerTheme.spacer2),
                                                  Text(
                                                    localizations.translate(
                                                        i18_local
                                                            .searchBeneficiary
                                                            .recordSideEffectActionLabel),
                                                    style: textTheme.bodyL,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(
                                                height:
                                                    theme.spacerTheme.spacer2),

                                            // ── Search bar ──
                                            DigitSearchBar(
                                              inputFormatters: [
                                                UpperCaseTextFormatter()
                                              ],
                                              controller: searchController,
                                              hintText: localizations.translate(
                                                _isSideEffectMode
                                                    ? i18_local.searchBeneficiary
                                                        .beneficiarySearchHintText
                                                    : i18_local.searchBeneficiary
                                                        .searchBeneficiaryReferralHintText,
                                              ),
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              onChanged: (value) {
                                                if (_isSideEffectMode) {
                                                  _triggerHouseholdSearch(
                                                      context,
                                                      householdBloc,
                                                      value);
                                                } else {
                                                  final referralBloc =
                                                      context.read<
                                                          SearchReferralsBloc>();
                                                  if (value.trim().length < 2) {
                                                    referralBloc.add(
                                                        const SearchReferralsClearEvent());
                                                  } else {
                                                    referralBloc.add(
                                                        SearchReferralsByNameEvent(
                                                            searchText:
                                                                value.trim()));
                                                  }
                                                }
                                              },
                                            ),

                                            SizedBox(
                                                height:
                                                    theme.spacerTheme.spacer2 *
                                                        2),

                                            // ── Side-effect mode results ──
                                            if (_isSideEffectMode) ...[
                                              if (householdState.loading)
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              if (!householdState.loading &&
                                                  searchController
                                                      .text.isNotEmpty &&
                                                  (householdState
                                                          .resultsNotFound ||
                                                      !beneficiaryFound))
                                                InfoCard(
                                                  title: localizations.translate(
                                                      i18.referralReconciliation
                                                          .beneficiaryInfoTitle),
                                                  type: InfoType.info,
                                                  description: localizations
                                                      .translate(i18
                                                          .referralReconciliation
                                                          .referralInfoDescription),
                                                ),
                                            ],

                                            // ── Referral mode: info card ──
                                            if (!_isSideEffectMode &&
                                                searchState.resultsNotFound &&
                                                searchController
                                                    .text.isNotEmpty)
                                              InfoCard(
                                                title: localizations.translate(
                                                    i18.referralReconciliation
                                                        .beneficiaryInfoTitle),
                                                type: InfoType.info,
                                                description:
                                                    localizations.translate(i18
                                                        .referralReconciliation
                                                        .referralInfoDescription),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // ── Side-effect mode: beneficiary cards ──
                                    if (_isSideEffectMode && beneficiaryFound)
                                      SliverList(
                                        delegate:
                                            SliverChildBuilderDelegate(
                                          (ctx, index) {
                                            final wrapper =
                                                sideEffectCards[index];
                                            final ind =
                                                wrapper.headOfHousehold ??
                                                    wrapper.members
                                                        ?.firstOrNull;
                                            final fullName = _fullName(ind);
                                            final identifierId =
                                                _beneficiaryIdForIndividual(ind);
                                            final isSelected =
                                                _selectedIndividualClientRef ==
                                                    ind?.clientReferenceId;
                                            return _BeneficiarySideEffectCard(
                                              name: fullName.isNotEmpty
                                                  ? fullName
                                                  : '—',
                                              beneficiaryId:
                                                  identifierId ?? '—',
                                              taskCount:
                                                  wrapper.tasks?.length ?? 0,
                                              hasSideEffects: wrapper
                                                      .sideEffects
                                                      ?.isNotEmpty ==
                                                  true,
                                              isSelected: isSelected,
                                              localizations: localizations,
                                              onTap: () {
                                                setInnerState(() {
                                                  _selectedHouseholdMember =
                                                      wrapper;
                                                  _selectedIndividualClientRef =
                                                      ind?.clientReferenceId;
                                                });
                                                setState(() {
                                                  _selectedHouseholdMember =
                                                      wrapper;
                                                  _selectedIndividualClientRef =
                                                      ind?.clientReferenceId;
                                                });
                                              },
                                            );
                                          },
                                          childCount: sideEffectCards.length,
                                        ),
                                      ),

                                    // ── Referral mode: results list ──
                                    if (!_isSideEffectMode)
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (ctx, index) {
                                            final i = searchState.referrals
                                                .elementAt(index);
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: theme
                                                      .spacerTheme.spacer2),
                                              child: ViewReferralCard(
                                                hfReferralModel: i,
                                                onOpenPressed: () {
                                                  context
                                                      .read<ServiceBloc>()
                                                      .add(ServiceSearchEvent(
                                                        serviceSearchModel:
                                                            ServiceSearchModel(
                                                          relatedClientReferenceId:
                                                              i.clientReferenceId,
                                                        ),
                                                      ));
                                                  context.router.push(
                                                    CustomHFCreateReferralWrapperRoute(
                                                      viewOnly: true,
                                                      referralReconciliation: i,
                                                      projectId:
                                                          ReferralReconSingleton()
                                                              .projectId,
                                                      cycles:
                                                          ReferralReconSingleton()
                                                              .cycles,
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          childCount:
                                              searchState.referrals.length,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    // ── Bottom bar ──
                    bottomNavigationBar: Card(
                      margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: EdgeInsets.all(theme.spacerTheme.spacer2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isSideEffectMode)
                              BlocBuilder<CustomSearchHouseholdsBloc,
                                  CustomSearchHouseholdsState>(
                                builder: (context, hsState) {
                                  final cards = _sideEffectCardWrappers(
                                    hsState,
                                    searchController.text,
                                  );
                                  final wrapper = _selectedHouseholdMember ??
                                      (cards.length == 1 ? cards.first : null);

                                  // Scoped wrapper always stores the selected person here.
                                  final ind = wrapper?.headOfHousehold;

                                  final projectBeneficiaryId = wrapper
                                      ?.projectBeneficiaries
                                      ?.firstOrNull
                                      ?.clientReferenceId;

                                  final taskId = wrapper
                                      ?.tasks?.lastOrNull?.clientReferenceId;

                                  // Require both a project beneficiary AND a
                                  // completed task — the server rejects null.
                                  // Also do not allow recording if a side effect already exists.
                                  final canRecord = wrapper != null &&
                                      ind != null &&
                                      projectBeneficiaryId != null &&
                                      taskId != null &&
                                      (wrapper.sideEffects?.isEmpty ?? true);

                                  return DigitButton(
                                    size: DigitButtonSize.large,
                                    label: 'Record Side Effects',
                                    mainAxisSize: MainAxisSize.max,
                                    isDisabled: !canRecord,
                                    onPressed: canRecord
                                        ? () {
                                            // canRecord guarantees ind, taskId,
                                            // and projectBeneficiaryId are non-null.
                                            context.router.push(
                                              CustomHFCreateReferralWrapperRoute(
                                                viewOnly: false,
                                                isSideEffect: true,
                                                individual: ind!,
                                                referralReconciliation:
                                                    HFReferralModel(
                                                  clientReferenceId:
                                                      IdGen.i.identifier,
                                                  name: _fullName(ind),
                                                  beneficiaryId:
                                                      _beneficiaryIdForIndividual(
                                                          ind),
                                                  additionalFields:
                                                      HFReferralAdditionalFields(
                                                    version: 1,
                                                    fields: [
                                                      AdditionalField(
                                                          'isSideEffect',
                                                          'true'),
                                                      AdditionalField(
                                                          'projectBeneficiaryClientReferenceId',
                                                          projectBeneficiaryId!),
                                                      AdditionalField(
                                                          'taskClientReferenceId',
                                                          taskId!),
                                                    ],
                                                  ),
                                                ),
                                                projectId:
                                                    ReferralReconSingleton()
                                                        .projectId,
                                                cycles: ReferralReconSingleton()
                                                    .cycles,
                                              ),
                                            );
                                          }
                                        : () {},
                                    type: DigitButtonType.secondary,
                                  );
                                },
                              )
                            else
                              BlocBuilder<SearchReferralsBloc,
                                  SearchReferralsState>(
                                builder: (context, state) {
                                  final router = context.router;
                                  return DigitButton(
                                    size: DigitButtonSize.large,
                                    label: localizations.translate(
                                      i18.referralReconciliation
                                          .createReferralLabel,
                                    ),
                                    mainAxisSize: MainAxisSize.max,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      final bloc =
                                          context.read<SearchReferralsBloc>();
                                      router.push(
                                        CustomHFCreateReferralWrapperRoute(
                                          viewOnly: false,
                                          referralReconciliation:
                                              HFReferralModel(
                                            clientReferenceId:
                                                IdGen.i.identifier,
                                            name: state.searchQuery,
                                            beneficiaryId: state.tag,
                                          ),
                                          projectId: ReferralReconSingleton()
                                              .projectId,
                                          cycles:
                                              ReferralReconSingleton().cycles,
                                        ),
                                      );
                                      searchController.clear();
                                      bloc.add(
                                          const SearchReferralsClearEvent());
                                    },
                                    type: DigitButtonType.primary,
                                  );
                                },
                              ),
                            SizedBox(height: theme.spacerTheme.spacer2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}

/// Card displayed when a beneficiary is found in side-effect mode.
class _BeneficiarySideEffectCard extends StatelessWidget {
  final String name;
  final String beneficiaryId;
  final int taskCount;
  final bool hasSideEffects;
  final bool isSelected;
  final VoidCallback? onTap;
  final dynamic localizations;

  const _BeneficiarySideEffectCard({
    required this.name,
    required this.beneficiaryId,
    required this.taskCount,
    this.hasSideEffects = false,
    this.isSelected = false,
    this.onTap,
    this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: theme.spacerTheme.spacer2),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? theme.colorTheme.primary.primary2
              : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
        padding: EdgeInsets.all(theme.spacerTheme.spacer4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: textTheme.headingM),
            SizedBox(height: theme.spacerTheme.spacer2),
            Row(
              children: [
                Icon(Icons.badge_outlined,
                    size: 16, color: theme.colorTheme.text.secondary),
                SizedBox(width: theme.spacerTheme.spacer1),
                Text(
                  beneficiaryId,
                  style: textTheme.bodyS
                      .copyWith(color: theme.colorTheme.text.secondary),
                ),
              ],
            ),
            if (taskCount > 0) ...[
              SizedBox(height: theme.spacerTheme.spacer1),
              Row(
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 16, color: theme.colorTheme.text.secondary),
                  SizedBox(width: theme.spacerTheme.spacer1),
                  Text(
                    'Tasks: $taskCount',
                    style: textTheme.bodyS
                        .copyWith(color: theme.colorTheme.text.secondary),
                  ),
                ],
              ),
            ],
            if (hasSideEffects) ...[
              SizedBox(height: theme.spacerTheme.spacer2),
              InfoCard(
                title: localizations?.translate('ERROR') ?? 'Error',
                type: InfoType.error,
                description: localizations?.translate(i18_local
                        .searchBeneficiary.sideEffectAlreadyRecorded) ??
                    'A side effect has already been recorded for this beneficiary.',
              ),
            ] else if (taskCount == 0) ...[
              SizedBox(height: theme.spacerTheme.spacer2),
              InfoCard(
                title: localizations?.translate('ERROR') ?? 'Error',
                type: InfoType.error,
                description: localizations?.translate(
                        i18_local.searchBeneficiary.noTasksAssociated) ??
                    'There are no tasks associated with this beneficiary.',
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
