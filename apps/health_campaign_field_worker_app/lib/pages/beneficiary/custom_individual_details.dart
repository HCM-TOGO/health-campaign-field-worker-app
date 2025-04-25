import 'package:collection/collection.dart';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_data_model/models/entities/household_type.dart';
import 'package:digit_scanner/blocs/scanner.dart';
import 'package:digit_ui_components/enum/app_enums.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/theme/spacers.dart';
import 'package:digit_ui_components/utils/date_utils.dart';
import 'package:digit_ui_components/widgets/atoms/digit_button.dart';
import 'package:digit_ui_components/widgets/atoms/digit_checkbox.dart';
import 'package:digit_ui_components/widgets/atoms/digit_dob_picker.dart';
import 'package:digit_ui_components/widgets/atoms/digit_text_form_input.dart';
import 'package:digit_ui_components/widgets/atoms/reactive_fields.dart';
import 'package:digit_ui_components/widgets/atoms/selection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/registration_delivery.dart';
import 'package:registration_delivery/router/registration_delivery_router.gm.dart';
import 'package:registration_delivery/utils/constants.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import 'package:registration_delivery/utils/utils.dart';
import 'package:registration_delivery/widgets/back_navigation_help_header.dart';
import 'package:registration_delivery/widgets/showcase/config/showcase_constants.dart';

import '../../../utils/utils.dart' as utils;
import '../../../widgets/localized.dart';
import '../../models/entities/entities_beneficiary/identifier_types.dart';
import '../../router/app_router.dart';
import '../../utils/i18_key_constants.dart' as i18_local;
import '../../utils/uniqueid_generation.dart';

@RoutePage()
class CustomIndividualDetailsPage extends LocalizedStatefulWidget {
  final bool isHeadOfHousehold;

  const CustomIndividualDetailsPage({
    super.key,
    super.appLocalizations,
    this.isHeadOfHousehold = false,
  });

  @override
  State<CustomIndividualDetailsPage> createState() =>
      CustomIndividualDetailsPageState();
}

class CustomIndividualDetailsPageState
    extends LocalizedState<CustomIndividualDetailsPage> {
  static const _individualNameKey = 'individualName';
  // static const _individualLastNameKey = 'individualLastName';
  static const _dobKey = 'dob';
  static const _genderKey = 'gender';
  static const _mobileNumberKey = 'mobileNumber';
  static const _beneficiaryIdKey = 'beneficiaryId';
  bool isDuplicateTag = false;
  static const maxLength = 200;
  final clickedStatus = ValueNotifier<bool>(false);
  DateTime now = DateTime.now();
  bool isEditIndividual = false;
  Set<String>? beneficiaryId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final router = context.router;
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);
    DateTime before150Years = DateTime(now.year - 150, now.month, now.day);
    // final beneficiaryType = RegistrationDeliverySingleton().beneficiaryType!;

    return Scaffold(
      body: ReactiveFormBuilder(
        form: () => buildForm(bloc.state),
        builder: (context, form, child) => BlocConsumer<
            BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
          listener: (context, state) {
            state.mapOrNull(
              // persisted: (value) async {
              //   print("🎉 We are in the persisted state!: ${value.navigateToRoot}");
              //   if (value.navigateToRoot) {
              //     final overviewBloc = context.read<HouseholdOverviewBloc>();

              //     overviewBloc.add(
              //       HouseholdOverviewReloadEvent(
              //         projectId:
              //             RegistrationDeliverySingleton().projectId.toString(),
              //         projectBeneficiaryType:
              //             RegistrationDeliverySingleton().beneficiaryType ??
              //                 BeneficiaryType.household,
              //       ),
              //     );

              //     await overviewBloc.stream.firstWhere((element) =>
              //         element.loading == false &&
              //         element.householdMemberWrapper.household != null);
              //     HouseholdMemberWrapper memberWrapper =
              //         overviewBloc.state.householdMemberWrapper;
              //     final route = router.parent() as StackRouter;
              //     route.popUntilRouteWithName(SearchBeneficiaryRoute.name);
              //     route.push(BeneficiaryWrapperRoute(wrapper: memberWrapper));
              //   }
              //   else {
              //     Future.delayed(
              //       const Duration(
              //         milliseconds: 200,
              //       ),
              //       () {
              //         // ignore: deprecated_member_use
              //         (router.parent() as StackRouter).pop();
              //         context.read<SearchHouseholdsBloc>().add(
              //               SearchHouseholdsByHouseholdsEvent(
              //                 householdModel: value.householdModel,
              //                 projectId: context.projectId,
              //                 isProximityEnabled: false,
              //               ),
              //             );
              //       },
              //     ).then((value) => {
              //          // ignore: avoid_print
              //          print("➡️ THEN block executed, pushing acknowledgement page $router"), 
              //           router.push(CustomBeneficiaryAcknowledgementRoute(
              //             enableViewHousehold: true,
              //           )),
              //         });
              //   }
              // },
              persisted: (value) {
                if (value.navigateToRoot) {
                  Future.delayed(
                    const Duration(
                      milliseconds: 500,
                    ),
                    () {
                      context.read<SearchHouseholdsBloc>().add(
                            SearchHouseholdsByHouseholdsEvent(
                              householdModel: value.householdModel,
                              projectId: context.projectId,
                              isProximityEnabled: false,
                            ),
                          );
                    },
                  ).then((value) => {
                        context.router
                            .push(CustomBeneficiaryAcknowledgementRoute(
                          enableViewHousehold: true,
                        ))
                      });
                } else {
                  Future.delayed(
                    const Duration(
                      milliseconds: 500,
                    ),
                    () {
                      print("This is working :)");
                      context.read<SearchHouseholdsBloc>().add(
                            SearchHouseholdsByHouseholdsEvent(
                              householdModel: value.householdModel,
                              projectId: context.projectId,
                              isProximityEnabled: false,
                            ),
                          );
                    },
                  ).then((value) => {
                        context.router
                            .push(CustomBeneficiaryAcknowledgementRoute(
                          enableViewHousehold: widget.isHeadOfHousehold,
                        )),
                      });
                }
              },
            );
          },

          builder: (context, state) {
            return ScrollableContent(
              enableFixedButton: true,
              header: Column(children: [
                BackNavigationHelpHeaderWidget(
                  showHelp: false,
                  showcaseButton: null,
                  handleBack: () {
                    if (isEditIndividual) {
                      final parent = context.router.parent() as StackRouter;
                      parent.maybePop();
                    } else {
                      context.router.maybePop();
                    }
                  },
                ),
              ]),
              footer: DigitCard(
                margin: const EdgeInsets.fromLTRB(0, kPadding, 0, kPadding),
                padding:
                    const EdgeInsets.fromLTRB(kPadding, 0, kPadding, kPadding),
                child: ValueListenableBuilder(
                  valueListenable: clickedStatus,
                  builder: (context, bool isClicked, _) {
                    return DigitButton(
                      label: state.mapOrNull(
                            editIndividual: (value) => localizations
                                .translate(i18.common.coreCommonSave),
                          ) ??
                          localizations.translate(i18.common.coreCommonSubmit),
                      type: DigitButtonType.primary,
                      size: DigitButtonSize.large,
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () async {
                        if (form.control(_dobKey).value == null) {
                          setState(() {
                            form.control(_dobKey).setErrors({'': true});
                          });
                        }
                        final age = (form.control(_dobKey).value != null)
                            ? DigitDateUtils.calculateAge(
                                form.control(_dobKey).value as DateTime,
                              )
                            : DigitDOBAgeConvertor(
                                years: 0,
                                months: 0,
                                days: 0,
                              );
                        if ((age.years == 0 && age.months == 0) ||
                            age.years >= 150 && age.months > 0) {
                          form.control(_dobKey).setErrors({'': true});
                        }

                        if (form.control(_genderKey).value == null) {
                          setState(() {
                            form.control(_genderKey).setErrors({'': true});
                          });
                        }

                        final userId =
                            RegistrationDeliverySingleton().loggedInUserUuid;
                        final projectId =
                            RegistrationDeliverySingleton().projectId;
                        // form.markAllAsTouched();
                        // print("Form is valid: ${form.valid}, Errors: ${form.errors}");
                        // if (!form.valid) return;
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (age.years < 18 && widget.isHeadOfHousehold) {
                          await DigitToast.show(
                            context,
                            options: DigitToastOptions(
                              localizations.translate(i18_local
                                  .individualDetails.headAgeValidError),
                              true,
                              theme,
                            ),
                          );

                          return;
                        }

                        if (!widget.isHeadOfHousehold) {
                          final boundaryBloc =
                              context.read<BoundaryBloc>().state;
                          final code = boundaryBloc.boundaryList.first.code;
                          final bname = boundaryBloc.boundaryList.first.name;

                          final locality = code == null || bname == null
                              ? null
                              : LocalityModel(code: code, name: bname);

                          String localityCode = locality!.code;

                          beneficiaryId =
                              await UniqueIdGeneration().generateUniqueId(
                            localityCode: localityCode,
                            loggedInUserId: context.loggedInUserUuid,
                            returnCombinedIds: false,
                          );

                          form.control('beneficiaryId').value = beneficiaryId!.first;
                        }

                        form.markAllAsTouched();
                        if (!form.valid) return;

                        final submit = await DigitDialog.show<bool>(
                          context,
                          options: DigitDialogOptions(
                            titleText: localizations.translate(
                              i18.deliverIntervention.dialogTitle,
                            ),
                            contentText: localizations.translate(
                              i18.deliverIntervention.dialogContent,
                            ),
                            primaryAction: DigitDialogActions(
                              label: localizations.translate(
                                i18_local.common.coreCommonSubmit,
                              ),
                              action: (context) {
                                clickedStatus.value = true;
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop(true);
                              },
                            ),
                            secondaryAction: DigitDialogActions(
                              label: localizations.translate(
                                i18_local.common.coreCommonCancel,
                              ),
                              action: (context) => Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pop(false),
                            ),
                          ),
                        );

                        if (!(submit ?? false)) {
                          return;
                        }

                        state.maybeWhen(
                          orElse: () {
                            return;
                          },
                          create: (
                            addressModel,
                            householdModel,
                            individualModel,
                            projectBeneficiaryModel,
                            registrationDate,
                            searchQuery,
                            loading,
                            isHeadOfHousehold,
                          ) {
                            final individual = _getIndividualModel(context,
                                form: form,
                                oldIndividual: null,
                                beneficiaryId: beneficiaryId!.first);
                            isEditIndividual = false;
                            final boundary =
                                RegistrationDeliverySingleton().boundary;

                            bloc.add(
                              BeneficiaryRegistrationSaveIndividualDetailsEvent(
                                model: individual,
                                isHeadOfHousehold: widget.isHeadOfHousehold,
                              ),
                            );
                            final scannerBloc =
                                context.read<DigitScannerBloc>();

                            if (scannerBloc.state.duplicate) {
                              DigitToast.show(
                                context,
                                options: DigitToastOptions(
                                  localizations.translate(
                                    i18.deliverIntervention
                                        .resourceAlreadyScanned,
                                  ),
                                  true,
                                  theme,
                                ),
                              );
                            } else {
                              if (context.mounted) {
                                final scannerBloc =
                                    context.read<DigitScannerBloc>();
                                bloc.add(
                                  BeneficiaryRegistrationSummaryEvent(
                                    projectId: projectId!,
                                    userUuid: userId!,
                                    boundary: boundary!,
                                    tag: scannerBloc.state.qrCodes.isNotEmpty
                                        ? scannerBloc.state.qrCodes.first
                                        : null,
                                  ),
                                );
                                // router.push(SummaryRoute());

                                bloc.add(
                                  BeneficiaryRegistrationCreateEvent(
                                      projectId: projectId,
                                      userUuid: userId,
                                      boundary: boundary,
                                      tag: scannerBloc.state.qrCodes.isNotEmpty
                                          ? scannerBloc.state.qrCodes.first
                                          : null,
                                      navigateToSummary: false),
                                );
                              }
                            }
                          },
                          editIndividual: (
                            householdModel,
                            individualModel,
                            addressModel,
                            projectBeneficiaryModel,
                            loading,
                          ) {
                            // clickedStatus.value = true;
                            isEditIndividual = true;
                            final scannerBloc =
                                context.read<DigitScannerBloc>();
                            var individual = _getIndividualModel(
                              context,
                              form: form,
                              oldIndividual: individualModel,
                            );

                            final tag = scannerBloc.state.qrCodes.isNotEmpty
                                ? scannerBloc.state.qrCodes.first
                                : null;

                            if (tag != null &&
                                tag != projectBeneficiaryModel?.tag &&
                                scannerBloc.state.duplicate) {
                              DigitToast.show(
                                context,
                                options: DigitToastOptions(
                                  localizations.translate(
                                    i18.deliverIntervention
                                        .resourceAlreadyScanned,
                                  ),
                                  true,
                                  theme,
                                ),
                              );
                            } else {
                              bloc.add(
                                BeneficiaryRegistrationUpdateIndividualDetailsEvent(
                                  addressModel: addressModel,
                                  householdModel: householdModel,
                                  model: individual.copyWith(
                                    clientAuditDetails: (individual
                                                    .clientAuditDetails
                                                    ?.createdBy !=
                                                null &&
                                            individual.clientAuditDetails
                                                    ?.createdTime !=
                                                null)
                                        ? ClientAuditDetails(
                                            createdBy: individual
                                                .clientAuditDetails!.createdBy,
                                            createdTime: individual
                                                .clientAuditDetails!
                                                .createdTime,
                                            lastModifiedBy:
                                                RegistrationDeliverySingleton()
                                                    .loggedInUserUuid,
                                            lastModifiedTime: context
                                                .millisecondsSinceEpoch(),
                                          )
                                        : null,
                                  ),
                                  tag: scannerBloc.state.qrCodes.isNotEmpty
                                      ? scannerBloc.state.qrCodes.first
                                      : null,
                                ),
                              );
                            }
                          },
                          addMember: (
                            addressModel,
                            householdModel,
                            loading,
                          ) {
                            // clickedStatus.value = true;
                            final individual = _getIndividualModel(context,
                                form: form,
                                beneficiaryId: beneficiaryId!.first);

                            bloc.add(
                              BeneficiaryRegistrationAddMemberEvent(
                                  beneficiaryType:
                                      RegistrationDeliverySingleton()
                                          .beneficiaryType!,
                                  householdModel: householdModel,
                                  individualModel: individual,
                                  addressModel: addressModel,
                                  userUuid: RegistrationDeliverySingleton()
                                      .loggedInUserUuid!,
                                  projectId: RegistrationDeliverySingleton()
                                      .projectId!),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: DigitCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: kPadding),
                            child: Text(
                              localizations.translate(
                                i18.individualDetails
                                    .individualsDetailsLabelText,
                              ),
                              style: textTheme.headingXl.copyWith(
                                  color: theme.colorTheme.primary.primary2),
                            ),
                          ),
                          Column(children: [
                            individualDetailsShowcaseData.nameOfIndividual
                                .buildWith(
                              child: ReactiveWrapperField(
                                formControlName: _individualNameKey,
                                validationMessages: {
                                  'required': (object) =>
                                      localizations.translate(
                                        '${i18.individualDetails.nameLabelText}_IS_REQUIRED',
                                      ),
                                  'maxLength': (object) => localizations
                                      .translate(i18.common.maxCharsRequired)
                                      .replaceAll('{}', maxLength.toString()),
                                },
                                builder: (field) => LabeledField(
                                  label: localizations.translate(
                                    i18.individualDetails.nameLabelText,
                                  ),
                                  isRequired: true,
                                  child: DigitTextFormInput(
                                    initialValue:
                                        form.control(_individualNameKey).value,
                                    onChange: (value) {
                                      form.control(_individualNameKey).value =
                                          value;
                                    },
                                    errorMessage: field.errorText,
                                  ),
                                ),
                              ),
                            ),

                            // solution customisation
                            if (widget.isHeadOfHousehold) ...[
                              Offstage(
                                offstage: !widget.isHeadOfHousehold,
                                child: DigitCheckbox(
                                  capitalizeFirstLetter: false,
                                  label: (RegistrationDeliverySingleton()
                                              .householdType ==
                                          HouseholdType.community)
                                      ? localizations.translate(i18
                                          .individualDetails
                                          .clfCheckboxLabelText)
                                      : localizations.translate(
                                          i18.individualDetails
                                              .checkboxLabelText,
                                        ),
                                  value: widget.isHeadOfHousehold,
                                  readOnly: widget.isHeadOfHousehold,
                                  onChanged: (_) {},
                                ),
                              ),
                            ],
                          ]),
                          const SizedBox(
                            height: spacer4,
                          ),
                          individualDetailsShowcaseData.dateOfBirth.buildWith(
                            child: DigitDobPicker(
                              datePickerFormControl: _dobKey,
                              datePickerLabel: localizations.translate(
                                i18.individualDetails.dobLabelText,
                              ),
                              ageFieldLabel: localizations.translate(
                                i18.individualDetails.ageLabelText,
                              ),
                              yearsHintLabel: localizations.translate(
                                i18.individualDetails.yearsHintText,
                              ),
                              monthsHintLabel: localizations.translate(
                                i18.individualDetails.monthsHintText,
                              ),
                              separatorLabel: localizations.translate(
                                i18.individualDetails.separatorLabelText,
                              ),
                              yearsAndMonthsErrMsg: localizations.translate(
                                i18.individualDetails.yearsAndMonthsErrorText,
                              ),
                              errorMessage: form.control(_dobKey).hasErrors
                                  ? localizations
                                      .translate(i18.common.corecommonRequired)
                                  : null,
                              initialDate: before150Years,
                              initialValue: getInitialDateValue(form),
                              onChangeOfFormControl: (value) {
                                // Handle changes to the control's value here
                                setState(() {
                                  if (value == null) {
                                    form.control(_dobKey).setErrors({'': true});
                                  } else {
                                    DigitDOBAgeConvertor age =
                                        DigitDateUtils.calculateAge(value);
                                    if ((age.years == 0 && age.months == 0) ||
                                        (age.months > 11) ||
                                        (age.years >= 150 && age.months >= 0)) {
                                      form
                                          .control(_dobKey)
                                          .setErrors({'': true});
                                    } else {
                                      form.control(_dobKey).value = value;
                                      form.control(_dobKey).removeError('');
                                    }
                                  }
                                });
                              },
                              confirmText: localizations.translate(
                                i18.common.coreCommonOk,
                              ),
                              cancelText: localizations.translate(
                                i18.common.coreCommonCancel,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: spacer4,
                          ),
                          SelectionCard<String>(
                            // isRequired: true,
                            showParentContainer: true,
                            title: localizations.translate(
                              i18.individualDetails.genderLabelText,
                            ),
                            allowMultipleSelection: false,
                            width: 126,
                            initialSelection:
                                form.control(_genderKey).value != null
                                    ? [form.control(_genderKey).value]
                                    : [],
                            options: RegistrationDeliverySingleton()
                                .genderOptions!
                                .map(
                                  (e) => e,
                                )
                                .toList(),
                            onSelectionChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  form.control(_genderKey).value = value.first;
                                } else {
                                  form.control(_genderKey).value = null;
                                  setState(() {
                                    form
                                        .control(_genderKey)
                                        .setErrors({'': true});
                                  });
                                }
                              });
                            },
                            valueMapper: (value) {
                              return localizations.translate(value);
                            },
                            errorMessage: form.control(_genderKey).hasErrors
                                ? localizations
                                    .translate(i18.common.corecommonRequired)
                                : null,
                          ),
                          const SizedBox(
                            height: spacer4,
                          ),
                          Offstage(
                            offstage: !widget.isHeadOfHousehold,
                            child:
                                individualDetailsShowcaseData.mobile.buildWith(
                              child: ReactiveWrapperField(
                                formControlName: _mobileNumberKey,
                                validationMessages: {
                                  'maxLength': (object) =>
                                      localizations.translate(i18
                                          .individualDetails
                                          .mobileNumberLengthValidationMessage),
                                  'minLength': (object) =>
                                      localizations.translate(i18
                                          .individualDetails
                                          .mobileNumberLengthValidationMessage),
                                },
                                builder: (field) => LabeledField(
                                  label: localizations.translate(
                                    i18.individualDetails.mobileNumberLabelText,
                                  ),
                                  child: DigitTextFormInput(
                                    keyboardType: TextInputType.number,
                                    maxLength: 11,
                                    isRequired: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    initialValue:
                                        form.control(_mobileNumberKey).value,
                                    onChange: (value) {
                                      form.control(_mobileNumberKey).value =
                                          value;
                                    },
                                    errorMessage: field.errorText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IndividualModel _getIndividualModel(
    BuildContext context, {
    final beneficiaryId,
    required FormGroup form,
    IndividualModel? oldIndividual,
  }) {
    final dob = form.control(_dobKey).value == null
        ? null
        : form.control(_dobKey).value as DateTime?;
    String? dobString;
    if (dob != null) {
      dobString = DateFormat(Constants().dateFormat).format(dob);
    }

    var individual = oldIndividual;
    individual ??= IndividualModel(
      clientReferenceId: IdGen.i.identifier,
      tenantId: RegistrationDeliverySingleton().tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );

    var name = individual.name;
    name ??= NameModel(
      individualClientReferenceId: individual.clientReferenceId,
      tenantId: RegistrationDeliverySingleton().tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );

    var identifier = (individual.identifiers?.isNotEmpty ?? false)
        ? individual.identifiers!.first
        : null;

    identifier ??= IdentifierModel(
      clientReferenceId: individual.clientReferenceId,
      tenantId: RegistrationDeliverySingleton().tenantId,
      rowVersion: 1,
      auditDetails: AuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
      clientAuditDetails: ClientAuditDetails(
        createdBy: RegistrationDeliverySingleton().loggedInUserUuid!,
        createdTime: context.millisecondsSinceEpoch(),
        lastModifiedBy: RegistrationDeliverySingleton().loggedInUserUuid,
        lastModifiedTime: context.millisecondsSinceEpoch(),
      ),
    );

    List<IdentifierModel>? identifiers = individual.identifiers;
    if (isEditIndividual == false) {
      identifiers?.add(IdentifierModel(
        clientReferenceId: individual.clientReferenceId,
        identifierId: beneficiaryId,
        identifierType: IdentifierTypes.uniqueBeneficiaryID.toValue(),
        clientAuditDetails: individual.clientAuditDetails,
        auditDetails: individual.auditDetails,
      ));
    }

    String? individualName = form.control(_individualNameKey).value as String?;
    individual = individual.copyWith(
      // name: name.copyWith(
      //   givenName: individualName?.trim(),
      //   familyName:
      //       (form.control(_individualLastNameKey).value as String).trim(),
      // ),
      name: name.copyWith(
        givenName: individualName?.trim(),
      ),
      gender: form.control(_genderKey).value == null
          ? null
          : Gender.values
              .byName(form.control(_genderKey).value.toString().toLowerCase()),
      mobileNumber: form.control(_mobileNumberKey).value,
      dateOfBirth: dobString,
      identifiers: isEditIndividual
          ? identifiers
          : [
              identifier.copyWith(
                identifierId: beneficiaryId,
                identifierType: IdentifierTypes.uniqueBeneficiaryID.toValue(),
              ),
            ],
    );

    final previousBeneficiaryId =
        form.control(_beneficiaryIdKey).value as String?;

    individual = individual.copyWith(
        additionalFields:
            previousBeneficiaryId != null && previousBeneficiaryId.isNotEmpty
                ? IndividualAdditionalFields(version: 1, fields: [
                    AdditionalField(_beneficiaryIdKey, previousBeneficiaryId)
                  ])
                : null);

    return individual;
  }

  FormGroup buildForm(BeneficiaryRegistrationState state) {
    final individual =
        state.mapOrNull<IndividualModel>(editIndividual: (value) {
      isEditIndividual = true;
      if (value.projectBeneficiaryModel?.tag != null) {
        context.read<DigitScannerBloc>().add(DigitScannerScanEvent(
            barCode: [], qrCode: [value.projectBeneficiaryModel!.tag!]));
      }

      return value.individualModel;
    }, create: (value) {
      return value.individualModel;
    }, summary: (value) {
      return value.individualModel;
    }, editHousehold: (value) {
      isEditIndividual = true;
      return value.headOfHousehold;
    });

    final searchQuery = state.mapOrNull<String>(
      create: (value) {
        return value.searchQuery;
      },
    );

    final beneficiaryId = individual?.additionalFields?.fields
        .firstWhereOrNull((element) => element.key == _beneficiaryIdKey)
        ?.value;

    return fb.group(<String, Object>{
      _individualNameKey: FormControl<String>(
        validators: [
          Validators.required,
          Validators.delegate(
              (validator) => CustomValidator.requiredMin(validator)),
          Validators.maxLength(200),
        ],
        // value: individual?.name?.givenName ?? searchQuery?.trim(),
        value: individual?.name?.givenName ??
            ((RegistrationDeliverySingleton().householdType ==
                    HouseholdType.community)
                ? null
                : searchQuery?.trim()),
      ),
      _dobKey: FormControl<DateTime>(
        value: individual?.dateOfBirth != null
            ? DateFormat(Constants().dateFormat).parse(
                individual!.dateOfBirth!,
              )
            : null,
      ),
      _genderKey: FormControl<String>(value: getGenderOptions(individual)),
      _mobileNumberKey:
          FormControl<String>(value: individual?.mobileNumber, validators: [
        Validators.pattern(Constants.mobileNumberRegExp,
            validationMessage:
                localizations.translate(i18.common.coreCommonMobileNumber)),
        Validators.delegate(
            (validator) => utils.CustomValidator.mobileNumber(validator)),
        Validators.maxLength(11),
      ]),
      _beneficiaryIdKey: FormControl<String>(
        validators: [Validators.required],
        value: individual?.identifiers?.firstOrNull?.identifierId,
      ),
    });
  }

  getGenderOptions(IndividualModel? individual) {
    final options = RegistrationDeliverySingleton().genderOptions;

    return options?.map((e) => e).firstWhereOrNull(
          (element) => element.toLowerCase() == individual?.gender?.name,
        );
  }

  getInitialDateValue(FormGroup form) {
    var date = form.control(_dobKey).value != null
        ? DateFormat(Constants().dateTimeExtFormat)
            .format(form.control(_dobKey).value)
        : null;

    return date;
  }
}
