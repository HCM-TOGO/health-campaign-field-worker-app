import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
// import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../../widgets/localized.dart';
import '../../../utils/i18_key_constants.dart' as i18_local;
import '../../models/entities/entities_beneficiary/identifier_types.dart';

@RoutePage()
class CustomBeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
  final bool? enableViewHousehold;

  const CustomBeneficiaryAcknowledgementPage({
    super.key,
    super.appLocalizations,
    this.enableViewHousehold,
  });

  @override
  State<CustomBeneficiaryAcknowledgementPage> createState() =>
      CustomBeneficiaryAcknowledgementPageState();
}

class CustomBeneficiaryAcknowledgementPageState
    extends LocalizedState<CustomBeneficiaryAcknowledgementPage> {
  late final IndividualModel individual;

  @override
  void initState() {
    super.initState();
    // Todo: Need to use household overview bloc to show users

    // final bloc = context.read<SearchBlocWrapper>();
    // final overviewBloc = context.read<HouseholdOverviewBloc>();
    // wrapper = bloc.state.householdMembers.isEmpty
    //     ? overviewBloc.state.householdMemberWrapper
    //     : bloc.state.householdMembers.lastOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(spacer2),
        child: BlocBuilder<BeneficiaryRegistrationBloc,
            BeneficiaryRegistrationState>(
          builder: (context, state) {
            return state.maybeWhen(
              persisted: (
                isHeadOfHousehold,
                householdModel,
                individualModel,
                projectBeneficiaryModel,
                registrationDate,
                addressModel,
                finer,
                searchQuery,
                loading,
              ) {
                if (individualModel != null) {
                  // individualModel is the data you saved
                  return PanelCard(
                    type: PanelType.success,
                    title: localizations.translate(
                        i18.acknowledgementSuccess.acknowledgementLabelText),
                    actions: [
                      DigitButton(
                          label: localizations.translate(
                            i18.householdDetails.viewHouseHoldDetailsAction,
                          ),
                          onPressed: () {
                            // final parent =
                            //     context.router.parent() as StackRouter;
                            // final searchBlocState =
                            //     context.read<SearchHouseholdsBloc>().state;

                            // parent.popUntilRouteWithName(
                            //     CustomSearchBeneficiaryRoute.name);

                            // parent.push(
                            //   CustomHouseholdWrapperRoute(
                            //     wrapper: searchBlocState.householdMembers.first,
                            //   ),
                            // );
                          },
                          type: DigitButtonType.primary,
                          size: DigitButtonSize.large),
                      DigitButton(
                          label: localizations.translate(
                              i18.acknowledgementSuccess.actionLabelText),
                          onPressed: () {
                            // final bloc = context.read<SearchBlocWrapper>();

                            // context.router.popAndPush(
                            //   BeneficiaryWrapperRoute(
                            //     wrapper: bloc.state.householdMembers.first,
                            //   ),
                            // );
                          },
                          type: DigitButtonType.secondary,
                          size: DigitButtonSize.large),
                    ],
                    additionalDetails: [
                      Text(
                        "${individualModel.name!.givenName}",
                         style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${individualModel.additionalFields!.fields.first.value}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                    description: localizations.translate(
                      i18.acknowledgementSuccess.acknowledgementDescriptionText,
                    ),
                  );
                } else {
                  return Text('No individual data yet.');
                }
              },
              orElse: () => Text('Invalid state'),
            );
          },
        ),
      ),
    );
  }

  List<Text>? getSubText(HouseholdMemberWrapper? wrapper) {
    if (wrapper == null) return null;

    final member = wrapper.members?.lastOrNull;
    final givenName = member?.name?.givenName ?? '';
    final identifier = member?.identifiers
            ?.lastWhereOrNull(
              (e) =>
                  e.identifierType ==
                  IdentifierTypes.uniqueBeneficiaryID.toValue(),
            )
            ?.identifierId ??
        localizations.translate(i18.common.noResultsFound);

    return [
      Text(
        '${localizations.translate(i18_local.beneficiaryDetails.beneficiaryId)}\n$givenName - $identifier',
      ),
    ];
  }
}
