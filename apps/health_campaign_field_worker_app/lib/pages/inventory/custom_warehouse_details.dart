import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:digit_data_model/data_model.dart';
import 'package:digit_scanner/blocs/scanner.dart';
import 'package:digit_scanner/pages/qr_scanner.dart';
import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/widgets/atoms/input_wrapper.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management/router/inventory_router.gm.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:inventory_management/utils/i18_key_constants.dart' as i18;
import '../../utils//i18_key_constants.dart' as i18_local;
import 'package:inventory_management/widgets/localized.dart';
import 'package:inventory_management/blocs/record_stock.dart';
import 'package:inventory_management/utils/utils.dart';
import 'package:inventory_management/widgets/back_navigation_help_header.dart';
import 'package:inventory_management/widgets/inventory/no_facilities_assigned_dialog.dart';
import '../../router/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/extensions.dart';
import '../../utils/upper_case.dart';
import 'custom_facility_selection.dart';

@RoutePage()
class CustomWarehouseDetailsPage extends LocalizedStatefulWidget {
  const CustomWarehouseDetailsPage({
    super.key,
    super.appLocalizations,
  });

  @override
  State<CustomWarehouseDetailsPage> createState() =>
      CustomWarehouseDetailsPageState();
}

class CustomWarehouseDetailsPageState
    extends LocalizedState<CustomWarehouseDetailsPage> {
  static const _dateOfEntryKey = 'dateOfReceipt';
  static const _administrativeUnitKey = 'administrativeUnit';
  static const _warehouseKey = 'warehouse';
  static const _teamCodeKey = 'teamCode';
  bool deliveryTeamSelected = false;
  String? selectedFacilityId;
  TextEditingController controller1 = TextEditingController();

  @override
  void initState() {
    clearQRCodes();
    final stockState = context.read<RecordStockBloc>().state;
    setState(() {
      selectedFacilityId = stockState.primaryId;
    });
    super.initState();
  }

  FormGroup buildForm(bool isDistributor, RecordStockState stockState) =>
      fb.group(<String, Object>{
        _dateOfEntryKey: FormControl<DateTime>(value: DateTime.now()),
        _administrativeUnitKey: FormControl<String>(
          value: localizations
              .translate(InventorySingleton().boundary!.code ?? ''),
        ),
        _warehouseKey: FormControl<String>(
          validators: isDistributor ? [] : [Validators.required],
        ),
        _teamCodeKey: FormControl<String>(
          value: stockState.primaryId ??
              context.loggedInUser.userName.toString() +
                  Constants.pipeSeparator +
                  context.loggedInUserUuid,
          validators: isDistributor
              ? [
                  Validators.required,
                ]
              : [],
        ),
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recordStockBloc = BlocProvider.of<RecordStockBloc>(context);
    final textTheme = theme.digitTextTheme(context);
    final userUuid = context.loggedInUserUuid;

    return InventorySingleton().projectId.isEmpty
        ? Center(
            child: Text(localizations
                .translate(i18.stockReconciliationDetails.noProjectSelected)))
        : BlocConsumer<FacilityBloc, FacilityState>(
            listener: (context, state) {
              state.whenOrNull(
                empty: () =>
                    NoFacilitiesAssignedDialog.show(context, localizations),
              );
            },
            builder: (ctx, facilityState) {
              final facilities = facilityState.whenOrNull(
                    fetched: (facilities, allFacilities) {
                      if (ctx.selectedProject.address?.boundaryType ==
                          Constants.stateBoundaryLevel) {
                        List<FacilityModel> filteredFacilities = facilities
                            .where((element) =>
                                element.usage == Constants.stateFacility)
                            .toList();
                        facilities = filteredFacilities.isEmpty
                            ? facilities
                            : filteredFacilities;
                      } else if (ctx.selectedProject.address?.boundaryType ==
                          Constants.lgaBoundaryLevel) {
                        List<FacilityModel> filteredFacilities = facilities
                            .where(
                              (element) =>
                                  element.usage == Constants.lgaFacility,
                            )
                            .toList();
                        facilities = filteredFacilities.isEmpty
                            ? facilities
                            : filteredFacilities;
                      } else {
                        List<FacilityModel> filteredFacilities = facilities
                            .where(
                              (element) =>
                                  element.usage == Constants.healthFacility,
                            )
                            .toList();
                        facilities = filteredFacilities.isEmpty
                            ? facilities
                            : filteredFacilities;
                      }

                      final teamFacilities = [
                        FacilityModel(
                          id: 'Delivery Team',
                          name: 'Delivery Team',
                        ),
                      ];
                      // teamFacilities.addAll(
                      //   facilities,
                      // );

                      return InventorySingleton().isDistributor! &&
                              !InventorySingleton().isWareHouseMgr!
                          ? teamFacilities
                          : facilities;
                    },
                  ) ??
                  [];
              final stockState = recordStockBloc.state;

              final entryType = stockState.entryType;
              String dateLabel;

              switch (entryType) {
                case StockRecordEntryType.receipt:
                  dateLabel = localizations.translate(
                    i18.warehouseDetails.dateOfReceipt,
                  );
                  break;
                case StockRecordEntryType.dispatch:
                  dateLabel = localizations.translate(
                    i18_local.warehouseDetailsShowcase.dateOfIssue,
                  );
                  break;
                case StockRecordEntryType.returned:
                  dateLabel = localizations.translate(
                    i18_local.warehouseDetailsShowcase.dateOfReturn,
                  );
                  break;
                case StockRecordEntryType.damaged:
                  dateLabel = localizations.translate(
                    i18.warehouseDetails.dateOfReceipt,
                  );
                  break;
                case StockRecordEntryType.loss:
                  dateLabel = localizations.translate(
                    i18.warehouseDetails.dateOfReceipt,
                  );
                  break;

                default:
                  dateLabel = '';
              }

              return Scaffold(
                body: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: BlocBuilder<DigitScannerBloc, DigitScannerState>(
                    builder: (context, scannerState) {
                      return ReactiveFormBuilder(
                        form: () => buildForm(
                            InventorySingleton().isDistributor! &&
                                !InventorySingleton().isWareHouseMgr!,
                            stockState),
                        builder: (context, form, child) {
                          // form.control(_teamCodeKey).value =
                          //     scannerState.qrCodes.isNotEmpty
                          //         ? scannerState.qrCodes.firstOrNull
                          //         : '';
                          final teamFacilities = [
                            FacilityModel(
                              id: 'Delivery Team',
                              name: 'Delivery Team',
                            ),
                          ];
                          if (InventorySingleton().isDistributor! &&
                              !InventorySingleton().isWareHouseMgr!) {
                            form.control(_warehouseKey).value = localizations
                                .translate('FAC_${teamFacilities.first.id}');
                            controller1.text = localizations
                                .translate('FAC_${teamFacilities.first.id}');
                            selectedFacilityId = teamFacilities.first.id;
                            deliveryTeamSelected = true;
                          }

                          return ScrollableContent(
                            header: const Column(children: [
                              BackNavigationHelpHeaderWidget(),
                            ]),
                            footer: SizedBox(
                              child: DigitCard(
                                  margin: const EdgeInsets.fromLTRB(
                                      0, spacer2, 0, 0),
                                  children: [
                                    ReactiveFormConsumer(
                                      builder: (context, form, child) {
                                        return DigitButton(
                                          type: DigitButtonType.primary,
                                          mainAxisSize: MainAxisSize.max,
                                          size: DigitButtonSize.large,
                                          label: localizations.translate(
                                            i18.householdDetails.actionLabel,
                                          ),
                                          onPressed: !form.valid
                                              ? () {}
                                              : () {
                                                  form.markAllAsTouched();

                                                  if (!form.valid) {
                                                    return;
                                                  }
                                                  final dateOfRecord = form
                                                      .control(_dateOfEntryKey)
                                                      .value as DateTime;

                                                  // final teamCode = form
                                                  //     .control(_teamCodeKey)
                                                  final teamCode =
                                                      (context.loggedInUser
                                                                  .userName
                                                                  .toString() +
                                                              Constants
                                                                  .pipeSeparator +
                                                              context
                                                                  .loggedInUserUuid)
                                                          as String?;
                                                  final uuidRegex = RegExp(
                                                      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
                                                  final trainingRegex =
                                                      RegExp(r'^cps-f\d{5}$');
                                                  final productionRegex =
                                                      RegExp(
                                                          r'^CPS26-(\d{6})$');
                                                  /* if (deliveryTeamSelected &&
                                                      (teamCode == null ||
                                                          !uuidRegex.hasMatch(
                                                              teamCode) && !trainingRegex.hasMatch(
                                                              teamCode) && !productionRegex.hasMatch(
                                                              teamCode))) {
                                                    Toast.showToast(
                                                      context,
                                                      type: ToastType.error,
                                                      message: localizations
                                                          .translate(i18_local
                                                              .stockReconciliationDetails
                                                              .qrCodeInvalidFormat),
                                                    );
                                                    return;
                                                   }*/

                                                  final facility =
                                                      deliveryTeamSelected
                                                          ? FacilityModel(
                                                              id: teamCode ??
                                                                  'Delivery Team',
                                                            )
                                                          : selectedFacilityId !=
                                                                  null
                                                              ? FacilityModel(
                                                                  id: selectedFacilityId
                                                                      .toString(),
                                                                )
                                                              : null;

                                                  context
                                                      .read<DigitScannerBloc>()
                                                      .add(
                                                        const DigitScannerEvent
                                                            .handleScanner(
                                                            qrCode: [],
                                                            barCode: []),
                                                      );
                                                  if (facility == null) {
                                                    Toast.showToast(
                                                      type: ToastType.error,
                                                      context,
                                                      message: localizations
                                                          .translate(
                                                        i18.stockDetails
                                                            .facilityRequired,
                                                      ),
                                                    );
                                                  } else if (deliveryTeamSelected &&
                                                      (teamCode == null ||
                                                          teamCode
                                                              .trim()
                                                              .isEmpty)) {
                                                    Toast.showToast(
                                                      context,
                                                      type: ToastType.error,
                                                      message: localizations
                                                          .translate(
                                                        i18.stockDetails
                                                            .teamCodeRequired,
                                                      ),
                                                    );
                                                  } else {
                                                    recordStockBloc.add(
                                                      RecordStockSaveTransactionDetailsEvent(
                                                        dateOfRecord:
                                                            dateOfRecord,
                                                        facilityModel: InventorySingleton()
                                                                    .isDistributor! &&
                                                                !InventorySingleton()
                                                                    .isWareHouseMgr!
                                                            ? FacilityModel(
                                                                id: teamCode
                                                                    .toString(),
                                                              )
                                                            : facility,
                                                        primaryId: facility
                                                                    .id ==
                                                                "Delivery Team"
                                                            ? (teamCode ?? '')
                                                                .split(Constants
                                                                    .pipeSeparator)
                                                                .last
                                                            : facility.id,
                                                        primaryType: (InventorySingleton()
                                                                        .isDistributor! &&
                                                                    !InventorySingleton()
                                                                        .isWareHouseMgr! &&
                                                                    deliveryTeamSelected) ||
                                                                deliveryTeamSelected
                                                            ? "STAFF"
                                                            : "WAREHOUSE",
                                                      ),
                                                    );
                                                    context.router.push(
                                                      CustomStockDetailsRoute(),
                                                    );
                                                  }
                                                },
                                        );
                                      },
                                    ),
                                  ]),
                            ),
                            children: [
                              DigitCard(
                                  margin: const EdgeInsets.all(spacer2),
                                  children: [
                                    Text(
                                      InventorySingleton().isDistributor! &&
                                              !InventorySingleton()
                                                  .isWareHouseMgr!
                                          ? localizations.translate(
                                              i18.stockDetails
                                                  .transactionDetailsLabel,
                                            )
                                          : localizations.translate(
                                              i18.warehouseDetails
                                                  .warehouseDetailsLabel,
                                            ),
                                      style: textTheme.headingXl,
                                    ),
                                    ReactiveWrapperField(
                                        formControlName: _dateOfEntryKey,
                                        builder: (field) {
                                          return InputField(
                                            inputFormatters: [
                                              UpperCaseTextFormatter(),
                                            ],
                                            type: InputType.date,
                                            label: dateLabel,
                                            confirmText:
                                                localizations.translate(
                                              i18.common.coreCommonOk,
                                            ),
                                            cancelText: localizations.translate(
                                              i18.common.coreCommonCancel,
                                            ),
                                            initialValue: DateFormat(
                                                    'd MMMM yyyy')
                                                .format(field.control.value),
                                            readOnly: true,
                                          );
                                        }),
                                    ReactiveWrapperField(
                                        formControlName: _administrativeUnitKey,
                                        builder: (field) {
                                          return InputField(
                                            inputFormatters: [
                                              UpperCaseTextFormatter(),
                                            ],
                                            isRequired: true,
                                            type: InputType.text,
                                            label: localizations.translate(
                                              i18.warehouseDetails
                                                  .administrativeUnit,
                                            ),
                                            initialValue: field.control.value,
                                            readOnly: true,
                                          );
                                        }),
                                    InkWell(
                                      onTap: () async {
                                        clearQRCodes();
                                        form.control(_teamCodeKey).value = '';

                                        final facility =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CustomInventoryFacilitySelectionPage(
                                              facilities: facilities,
                                            ),
                                          ),
                                        );

                                        if (facility == null) return;
                                        form.control(_warehouseKey).value =
                                            localizations.translate(
                                                'FAC_${facility.id}');
                                        controller1.text = localizations
                                            .translate('FAC_${facility.id}');

                                        setState(() {
                                          selectedFacilityId = facility.id;
                                        });
                                        if (facility.id == 'Delivery Team') {
                                          setState(() {
                                            deliveryTeamSelected = true;
                                          });
                                        } else {
                                          setState(() {
                                            deliveryTeamSelected = false;
                                          });
                                        }
                                      },
                                      child: IgnorePointer(
                                        child: ReactiveWrapperField(
                                            formControlName: _warehouseKey,
                                            validationMessages: {
                                              'required': (object) =>
                                                  localizations.translate(
                                                    '${i18.individualDetails.nameLabelText}_IS_REQUIRED',
                                                  ),
                                            },
                                            showErrors: (control) =>
                                                control.invalid &&
                                                control.touched,
                                            builder: (field) {
                                              return InputField(
                                                inputFormatters: [
                                                  UpperCaseTextFormatter(),
                                                ],
                                                type: InputType.search,
                                                label: localizations.translate(
                                                  i18.stockReconciliationDetails
                                                      .facilityLabel,
                                                ),
                                                controller: controller1,
                                                isRequired: true,
                                                errorMessage: field.errorText,
                                                onChange: (value) {
                                                  field.control.markAsTouched();
                                                },
                                              );
                                            }),
                                      ),
                                    ),
                                    if (deliveryTeamSelected)
                                      ReactiveWrapperField(
                                          formControlName: _teamCodeKey,
                                          builder: (field) {
                                            return InputField(
                                              inputFormatters: [
                                                UpperCaseTextFormatter(),
                                              ],
                                              readOnly: true,
                                              keyboardType: TextInputType.none,
                                              type: InputType.search,
                                              label: localizations.translate(
                                                i18.stockReconciliationDetails
                                                    .teamCodeLabel,
                                              ),
                                              initialValue: context
                                                      .loggedInUser.userName
                                                      .toString() +
                                                  Constants.pipeSeparator +
                                                  context.loggedInUserUuid,
                                              isRequired: deliveryTeamSelected,
                                              suffixIcon: Icons.qr_code_2,
                                              onSuffixTap: null,
                                            );
                                          })
                                  ]),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
  }

  void clearQRCodes() {
    context.read<DigitScannerBloc>().add(const DigitScannerEvent.handleScanner(
          barCode: [],
          qrCode: [],
        ));
  }
}
