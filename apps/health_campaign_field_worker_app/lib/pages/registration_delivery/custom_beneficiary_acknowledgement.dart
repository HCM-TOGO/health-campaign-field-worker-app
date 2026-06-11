import 'package:collection/collection.dart';
import 'package:digit_data_model/models/entities/individual.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart'
    as registration_delivery;
import 'package:registration_delivery/models/entities/household.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import '../../blocs/registration_delivery/custom_beneficairy_registration.dart';
import '../../blocs/registration_delivery/custom_search_household.dart';
import '../../models/entities/identifier_types.dart';
import '../../router/app_router.dart';
import '../../widgets/digit_ui_component/custom_panel_card.dart';
import '../../utils/i18_key_constants.dart' as i18_local;

enum AcknowledgementType { addHousehold, addMember }

@RoutePage()
class CustomBeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;
  final AcknowledgementType acknowledgementType;
  final IndividualModel? selectedIndividual;

  const CustomBeneficiaryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    required this.acknowledgementType,
    this.enableViewHousehold,
    this.selectedIndividual,
  });

  @override
  State<CustomBeneficiaryAcknowledgementPage> createState() =>
      CustomBeneficiaryAcknowledgementPageState();
}

class CustomBeneficiaryAcknowledgementPageState
    extends LocalizedState<CustomBeneficiaryAcknowledgementPage> {
  @override
  void initState() {
    super.initState();
  }

  Map<String, String>? subtitleMap(
      registration_delivery.HouseholdMemberWrapper? householdMember,
      HouseholdModel? household) {
    if (widget.acknowledgementType == AcknowledgementType.addHousehold) {
      final householdId = household?.additionalFields?.fields
          .where((field) =>
              field.key == IdentifierTypes.uniqueBeneficiaryID.toValue())
          .first
          .value;
      return householdId == null
          ? null
          : {
              'id': localizations
                  .translate(i18_local.beneficiaryDetails.householdId),
              'value': householdId,
            };
    } else {
      String? beneficiaryId = widget.selectedIndividual != null
          ? householdMember?.members
              ?.firstWhereOrNull((member) =>
                  member.clientReferenceId ==
                  widget.selectedIndividual?.clientReferenceId)
              ?.identifiers
              ?.lastWhereOrNull((e) =>
                  e.identifierType ==
                  IdentifierTypes.uniqueBeneficiaryID.toValue())
              ?.identifierId
          : householdMember?.members?.lastOrNull?.identifiers
              ?.lastWhereOrNull((e) =>
                  e.identifierType ==
                  IdentifierTypes.uniqueBeneficiaryID.toValue())
              ?.identifierId;
      return beneficiaryId == null
          ? null
          : {
              'id': localizations
                  .translate(i18_local.beneficiaryDetails.beneficiaryId),
              'value': beneficiaryId,
            };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(spacer2),
        child: BlocConsumer<CustomSearchHouseholdsBloc,
            CustomSearchHouseholdsState>(
          listener: (context, searchHouseholdsState) {},
          builder: (context, searchHouseholdsState) {
            HouseholdMemberWrapper? i =
                searchHouseholdsState.householdMembers.lastOrNull;
            registration_delivery.HouseholdMemberWrapper?
                householdMemberWrapper;
            if (i == null) {
              householdMemberWrapper = null;
            } else {
              householdMemberWrapper =
                  registration_delivery.HouseholdMemberWrapper(
                household: i.household,
                headOfHousehold: i.headOfHousehold,
                members: i.members,
                projectBeneficiaries: i.projectBeneficiaries,
                distance: i.distance,
                tasks: i.tasks,
                sideEffects: i.sideEffects,
                referrals: i.referrals,
              );
            }

            return BlocBuilder<CustomBeneficiaryRegistrationBloc,
                BeneficiaryRegistrationState>(
              builder: (context, state) {
                return CustomPanelCard(
                  type: PanelType.success,
                  title: localizations.translate(i18_local
                      .acknowledgementSuccess
                      .acknowledgementSuccessUpdateLabelText),
                  subTitle:
                      subtitleMap(householdMemberWrapper, state.householdModel),
                  actions: [
                    if (householdMemberWrapper != null)
                      DigitButton(
                          label: localizations.translate(
                            i18.householdDetails.viewHouseHoldDetailsAction,
                          ),
                          onPressed: () {
                            final wrapper = householdMemberWrapper!;
                            // The stale household overview / edit pages are
                            // still sitting beneath this acknowledgement (see
                            // the back-to-search handler below), so a plain
                            // popAndPush would reveal them on back. Rebuild the
                            // registration-delivery wrapper's stack as
                            // [search, household overview] so backing out of
                            // the overview lands on a fresh search page.
                            context.read<CustomSearchHouseholdsBloc>().add(
                                  const CustomSearchHouseholdsEvent.clear(),
                                );
                            RoutingController? wrapperRouter = context.router;
                            while (wrapperRouter != null &&
                                wrapperRouter.routeData.name !=
                                    CustomRegistrationDeliveryWrapperRoute
                                        .name) {
                              wrapperRouter = wrapperRouter.parent();
                            }
                            if (wrapperRouter is StackRouter) {
                              wrapperRouter.replaceAll([
                                CustomSearchBeneficiaryRoute(),
                                BeneficiaryWrapperRoute(wrapper: wrapper),
                              ]);
                            } else {
                              context.router.popAndPush(
                                BeneficiaryWrapperRoute(wrapper: wrapper),
                              );
                            }
                          },
                          type: DigitButtonType.primary,
                          size: DigitButtonSize.large),
                    DigitButton(
                        label: localizations.translate(i18_local
                            .acknowledgementSuccess
                            .backToSearchActionLabelText),
                        onPressed: () {
                          context.read<CustomSearchHouseholdsBloc>().add(
                                const CustomSearchHouseholdsEvent.clear(),
                              );
                          // By the time we reach this acknowledgement, the
                          // add-member flow has already destroyed the original
                          // CustomSearchBeneficiaryRoute, so there is nothing to
                          // pop back to - the registration-delivery wrapper's
                          // stack bottoms out at the (stale) household overview.
                          // Walk up to that wrapper's router and replace its
                          // whole stack with a fresh search page. The wrapper
                          // then holds only [search], so backing out of search
                          // bubbles up and pops the wrapper off, landing on Home.
                          RoutingController? wrapperRouter = context.router;
                          while (wrapperRouter != null &&
                              wrapperRouter.routeData.name !=
                                  CustomRegistrationDeliveryWrapperRoute.name) {
                            wrapperRouter = wrapperRouter.parent();
                          }
                          if (wrapperRouter is StackRouter) {
                            wrapperRouter
                                .replaceAll([CustomSearchBeneficiaryRoute()]);
                          } else {
                            context.router
                                .navigate(CustomSearchBeneficiaryRoute());
                          }
                        },
                        type: DigitButtonType.secondary,
                        size: DigitButtonSize.large),
                  ],
                  description: localizations.translate(
                    i18.acknowledgementSuccess.acknowledgementDescriptionText,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
