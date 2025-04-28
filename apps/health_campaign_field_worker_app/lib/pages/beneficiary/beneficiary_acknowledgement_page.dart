// import 'package:collection/collection.dart';
// import 'package:digit_components/digit_components.dart';
// import 'package:digit_data_model/models/entities/beneficiary_type.dart';
// // import 'package:reactive_forms/reactive_forms.dart';
// import 'package:registration_delivery/registration_delivery.dart';
// // import 'package:digit_data_model/models/entities/identifier_types.dart';
// import '../../models/entities/entities_beneficiary/identifier_types.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
// // import 'package:registration_delivery/blocs/search_households/search_households.dart';

// import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
// import '../../../utils/i18_key_constants.dart' as i18_local;
// // import 'package:registration_delivery/utils/utils.dart';
// import 'package:registration_delivery/widgets/localized.dart';
// // import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
// import 'package:registration_delivery/router/registration_delivery_router.gm.dart';

// import '../../../router/app_router.dart';
// // import '../../../utils/environment_config.dart';

// @RoutePage()
// class CustomBeneficiaryAcknowledgementPage extends LocalizedStatefulWidget {
//   final bool? enableViewHousehold;

//   const CustomBeneficiaryAcknowledgementPage({
//     super.key,
//     super.appLocalizations,
//     this.enableViewHousehold,
//   });

//   @override
//   State<CustomBeneficiaryAcknowledgementPage> createState() =>
//       CustomBeneficiaryAcknowledgementPageState();
// }

// class CustomBeneficiaryAcknowledgementPageState
//     extends LocalizedState<CustomBeneficiaryAcknowledgementPage> {
//   late final HouseholdMemberWrapper? wrapper;

//   @override
//   void initState() {
//     super.initState();
//     final bloc = context.read<SearchBlocWrapper>();
//     final overviewBloc = context.read<HouseholdOverviewBloc>();
//     final memberBloc = context.read<BeneficiaryRegistrationBloc>();
//     print("This init state is working and the value of the wrapper is: ${bloc.state.householdMembers.isEmpty}");
//     wrapper = bloc.state.householdMembers.isEmpty
//         ? overviewBloc.state.householdMemberWrapper
//         : bloc.state.householdMembers.lastOrNull;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final individualBloc = context.read<BeneficiaryRegistrationBloc>();
//     print("The individual in the acknowlegment is : ${individualBloc}");
//     return Scaffold(
//       body: DigitAcknowledgement.success(
//         action: () {
//           final bloc = context.read<SearchBlocWrapper>();
//           bloc.clearEvent();
//           final parent = context.router.parent() as StackRouter;
//           parent.popUntilRouteWithName(CustomSearchBeneficiaryRoute.name);
//         },
//         secondaryAction: () {
//           final parent = context.router.parent() as StackRouter;
//           final searchBlocState = context.read<SearchBlocWrapper>().state;

//           Future.delayed(
//             const Duration(
//               milliseconds: 0,
//             ),
//             () {
//               final overviewBloc = context.read<HouseholdOverviewBloc>();

//               overviewBloc.add(
//                 HouseholdOverviewReloadEvent(
//                   projectId:
//                       RegistrationDeliverySingleton().projectId.toString(),
//                   projectBeneficiaryType:
//                       RegistrationDeliverySingleton().beneficiaryType ??
//                           BeneficiaryType.household,
//                 ),
//               );
//             },
//           ).then((value) {
//             final overviewBloc = context.read<HouseholdOverviewBloc>();
//             parent.popUntilRouteWithName(CustomSearchBeneficiaryRoute.name);
//             parent.push(
//               BeneficiaryWrapperRoute(
//                 wrapper: searchBlocState.householdMembers.isEmpty
//                     ? overviewBloc.state.householdMemberWrapper
//                     : searchBlocState.householdMembers.first,
//               ),
//             );
//           });
//         },
//         enableViewHousehold: widget.enableViewHousehold ?? false,
//         secondaryLabel: localizations.translate(
//           i18.householdDetails.viewHouseHoldDetailsAction,
//         ),
//         subLabel: getSubText(wrapper),
//         actionLabel:
//             localizations.translate(i18.acknowledgementSuccess.actionLabelText),
//         description: localizations.translate(
//           i18.acknowledgementSuccess.acknowledgementDescriptionText,
//         ),
//         label: localizations
//             .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
//       ),
//     );
//   }

//   getSubText(HouseholdMemberWrapper? wrapper) {
//     return wrapper != null
//         ? '${localizations.translate(i18_local.beneficiaryDetails.beneficiaryId)}\n'
//             '${wrapper.members?.lastOrNull!.name!.givenName} - '
//             '${wrapper.members?.lastOrNull!.identifiers!.lastWhereOrNull(
//                   (e) =>
//                       e.identifierType ==
//                       IdentifierTypes.uniqueBeneficiaryID.toValue(),
//                 )!.identifierId ?? localizations.translate(i18.common.noResultsFound)}'
//         : '';
//   }
// }


import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/widgets/molecules/panel_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:registration_delivery/blocs/beneficiary_registration/beneficiary_registration.dart';
import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
// import 'package:health_campaign_field_worker_app/blocs/beneficiary_registration/beneficiary_registration.dart';
// import 'package:registration_delivery/blocs/household_overview/household_overview.dart';
import 'package:registration_delivery/blocs/search_households/search_households.dart';

import '../../../utils/i18_key_constants.dart' as i18;
import '../../../widgets/localized.dart';
import 'package:registration_delivery/blocs/search_households/search_bloc_common_wrapper.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
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
      
//    @override
//   void initState() {
//     super.initState();
//     // final bloc = context.read<SearchBlocWrapper>();
//     // final overviewBloc = context.read<HouseholdOverviewBloc>();
//     final individualbloc = context.read<BeneficiaryRegistrationBloc>();
//     // print("The individual repo is: ${individualbloc.individualRepository.}");
//     // print("This init state is working and the value of the wrapper is: ${bloc.state.householdMembers.isEmpty}");
//     // wrapper = bloc.state.householdMembers.isEmpty
//     //     ? overviewBloc.state.householdMemberWrapper
//     //     : bloc.state.householdMembers.lastOrNull;
//     // Logger().d("this is the individual in ack: ${individualbloc.individualRepository.create}");
//     final bloc = context.read<BeneficiaryRegistrationBloc>();
// final state = bloc.state;
// state.maybeWhen(
//  create: (addressModel, householdModel, individualModel, projectBenficiaryModel, registrationDate, searchQuery, loading, isHeadOfHousehold) {
//    Logger().d("This is the individual: ${individualModel?.toJson()}");
//    // Now you have the individualModel here
//  },
//  orElse: () {
//    Logger().d("State is not 'create'");
//  },
// );
    
//   }

@override
void initState() {
 super.initState();
 // Delay the read until the widget is fully built
 WidgetsBinding.instance.addPostFrameCallback((_) {
   final bloc = context.read<BeneficiaryRegistrationBloc>();
   final state = bloc.state;
   state.maybeWhen(
     create: (addressModel, householdModel, individualModel,projectBeneficiaryModel, registrationDate, searchQuery, loading, isHeadOfHousehold) {
       Logger().d("IndividualModel in initState: ${individualModel?.toJson()}");
     },
     orElse: () {
       Logger().d("Not in create state during initState");
     },
   );
 });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Padding(
      //   padding: const EdgeInsets.all(spacer2),
      //   child: PanelCard(
      //     type: PanelType.success,
      //     title: localizations
      //         .translate(i18.acknowledgementSuccess.acknowledgementLabelText),
      //     actions: [
      //       DigitButton(
      //           label: localizations.translate(
      //             i18.householdDetails.viewHouseHoldDetailsAction,
      //           ),
      //           onPressed: () {
      //             final bloc = context.read<SearchBlocWrapper>();

      //             context.router.popAndPush(
      //               BeneficiaryWrapperRoute(
      //                 wrapper: bloc.state.householdMembers.first,
      //               ),
      //             );
      //           },
      //           type: DigitButtonType.primary,
      //           size: DigitButtonSize.large),
      //       DigitButton(
      //           label: localizations
      //               .translate(i18.acknowledgementSuccess.actionLabelText),
      //           onPressed: () => context.router.maybePop(),
      //           type: DigitButtonType.secondary,
      //           size: DigitButtonSize.large),
      //     ],
      //     additionalDetails: [],
      //     description: localizations.translate(
      //       i18.acknowledgementSuccess.acknowledgementDescriptionText,
      //     ),
      //   ),
      // ),
      body: BlocBuilder<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
 builder: (context, state) {
   return state.maybeWhen(
     summary: (addressModel, householdModel, individualModel, projectBeneficiaryModel, registrationDate, searchQuery, loading, isHeadOfHousehold) {
       if (individualModel != null) {
         // individualModel is the data you saved
         return Text('Name: ${individualModel.name?.givenName}');
       } else {
         return Text('No individual data yet.');
       }
     },
     orElse: () => Text('Invalid state'),
   );
 },
),
    );
  }

  // getSubText(HouseholdMemberWrapper? wrapper) {
  //   return wrapper != null
  //       ? '${localizations.translate(i18_local.beneficiaryDetails.beneficiaryId)}\n'
  //           '${wrapper.members?.lastOrNull!.name!.givenName} - '
  //           '${wrapper.members?.lastOrNull!.identifiers!.lastWhereOrNull(
  //                 (e) =>
  //                     e.identifierType ==
  //                     IdentifierTypes.uniqueBeneficiaryID.toValue(),
  //               )!.identifierId ?? localizations.translate(i18.common.noResultsFound)}'
  //       : '';
  // }
  List<Text>? getSubText(HouseholdMemberWrapper? wrapper) {
  if (wrapper == null) return null;

  final member = wrapper.members?.lastOrNull;
  final givenName = member?.name?.givenName ?? '';
  final identifier = member?.identifiers?.lastWhereOrNull(
        (e) => e.identifierType == IdentifierTypes.uniqueBeneficiaryID.toValue(),
      )?.identifierId ??
      localizations.translate(i18.common.noResultsFound);

  return [
    Text(
      '${localizations.translate(i18_local.beneficiaryDetails.beneficiaryId)}\n$givenName - $identifier',
    ),
  ];
}

}
