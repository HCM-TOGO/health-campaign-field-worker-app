import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_data_model/models/entities/beneficiary_type.dart';
import '../../models/entities/entities_beneficiary/identifier_types.dart';
// import 'package:digit_data_model/models/entities/identifier_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';

import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
// import '../../../utils/utils_smc/i18_key_constants.dart' as i18_local;
import '../../utils/i18_key_constants.dart' as i18_local;
import 'package:registration_delivery/utils/utils.dart';
import 'package:registration_delivery/widgets/localized.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

import '../../../router/app_router.dart';
// import '../../../utils/environment_config.dart';

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
  late final HouseholdMemberWrapper? wrapper;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SearchBlocWrapper>();
    final overviewBloc = context.read<HouseholdOverviewBloc>();
    wrapper = bloc.state.householdMembers.isEmpty
        ? overviewBloc.state.householdMemberWrapper
        : bloc.state.householdMembers.lastOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DigitAcknowledgement.success(
        action: () {
          final bloc = context.read<SearchBlocWrapper>();
          bloc.clearEvent();
          final parent = context.router.parent() as StackRouter;
          parent.popUntilRouteWithName(CustomSearchBeneficiaryRoute.name);
        },
        secondaryAction: () {
          final parent = context.router.parent() as StackRouter;
          final searchBlocState = context.read<SearchBlocWrapper>().state;

          Future.delayed(
            const Duration(
              milliseconds: 0,
            ),
            () {
              final overviewBloc = context.read<HouseholdOverviewBloc>();

              overviewBloc.add(
                HouseholdOverviewReloadEvent(
                  projectId:
                      RegistrationDeliverySingleton().projectId.toString(),
                  projectBeneficiaryType:
                      RegistrationDeliverySingleton().beneficiaryType ??
                          BeneficiaryType.household,
                ),
              );
            },
          ).then((value) {
            final overviewBloc = context.read<HouseholdOverviewBloc>();
            parent.popUntilRouteWithName(CustomSearchBeneficiaryRoute.name);
            parent.push(
              BeneficiaryWrapperRoute(
                wrapper: searchBlocState.householdMembers.isEmpty
                    ? overviewBloc.state.householdMemberWrapper
                    : searchBlocState.householdMembers.first,
              ),
            );
          });
        },
        enableViewHousehold: widget.enableViewHousehold ?? false,
        secondaryLabel: localizations.translate(
          i18_local.householdDetails.viewHouseHoldDetailsActionSMC,
        ),
        subLabel: getSubText(wrapper),
        actionLabel:
            localizations.translate(i18.acknowledgementSuccess.actionLabelText),
        description: localizations.translate(
          i18.acknowledgementSuccess.acknowledgementDescriptionText,
        ),
        label: localizations
            .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
      ),
    );
  }

  getSubText(HouseholdMemberWrapper? wrapper) {
    return wrapper != null
        ? '${localizations.translate(i18_local.beneficiaryDetails.beneficiaryId)}\n'
            '${wrapper.members?.lastOrNull!.name!.givenName} - '
            '${wrapper.members?.lastOrNull!.identifiers!.lastWhereOrNull(
                  (e) =>
                      e.identifierType ==
                      IdentifierTypes.uniqueBeneficiaryID.toValue(),
                )!.identifierId ?? localizations.translate(i18.common.noResultsFound)}'
        : '';
  }
}
