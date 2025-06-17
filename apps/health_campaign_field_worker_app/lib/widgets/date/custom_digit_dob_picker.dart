// import 'package:digit_components/digit_components.dart';
// import '../../../utils/date_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:reactive_forms/reactive_forms.dart';

// class CustomDigitDobPicker extends StatelessWidget {
//   // Properties to hold the form control name, labels, and error messages for the components
//   final String datePickerFormControl;
//   final bool isVerified;
//   final ControlValueAccessor? valueAccessor;
//   final String datePickerLabel;
//   final String ageFieldLabel;
//   final String yearsHintLabel;
//   final String monthsHintLabel;
//   final String separatorLabel;
//   final String yearsAndMonthsErrMsg;
//   final String cancelText;
//   final String confirmText;
//   final DateTime? initialDate;
//   final DateTime? finalDate;
//   final bool isHead;
//   final String requiredErrMsg;
//   final void Function(FormControl<dynamic>)? onChangeOfFormControl;

//   const CustomDigitDobPicker({
//     super.key,
//     required this.datePickerFormControl,
//     this.isVerified = false,
//     this.valueAccessor,
//     required this.datePickerLabel,
//     required this.ageFieldLabel,
//     required this.yearsHintLabel,
//     required this.monthsHintLabel,
//     required this.separatorLabel,
//     required this.yearsAndMonthsErrMsg,
//     this.requiredErrMsg = 'This field is required',
//     this.isHead = false,
//     this.initialDate,
//     this.finalDate,
//     this.confirmText = 'OK',
//     this.cancelText = 'Cancel',
//     this.onChangeOfFormControl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.only(
//         top: 8,
//         bottom: 8,
//       ),
//       child: Container(
//         padding: const EdgeInsets.only(
//           left: 8,
//           right: 8,
//           bottom: 8,
//         ),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(
//               color: Colors.grey, style: BorderStyle.solid, width: 1.0),
//         ),
//         child: Column(
//           children: [
//             // Date picker component to select the date of birth
//             DigitDateFormPicker(
//               label: datePickerLabel,
//               isRequired: true,
//               start: initialDate,
//               formControlName: datePickerFormControl,
//               cancelText: cancelText,
//               confirmText: confirmText,
//               onChangeOfFormControl: onChangeOfFormControl,
//               end: finalDate ?? DateTime.now(),
//             ),
//             const SizedBox(height: 16),
//             // Text widget to display a separator label between the date picker and age fields
//             Text(
//               separatorLabel,
//               style: theme.textTheme.bodyLarge,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   // Text form field for entering the age in years
//                   child: DigitTextFormField(
//                       padding: EdgeInsets.zero,
//                       maxLength: 3,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       valueAccessor:
//                           DobValueAccessorYearsString(DobValueAccessor()),
//                       formControlName: datePickerFormControl,
//                       label: ageFieldLabel,
//                       isRequired: true,
//                       keyboardType: TextInputType.number,
//                       suffix: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           yearsHintLabel,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       readOnly: isVerified || !isHead,
//                       onChanged: onChangeOfFormControl),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   // Text form field for entering the age in months
//                   child: DigitTextFormField(
//                       padding: EdgeInsets.zero,
//                       maxLength: 2,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       valueAccessor:
//                           DobValueAccessorMonthString(DobValueAccessor()),
//                       formControlName: datePickerFormControl,
//                       label: '',
//                       keyboardType: TextInputType.number,
//                       suffix: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           monthsHintLabel,
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       readOnly: isVerified,
//                       onChanged: onChangeOfFormControl),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8.0),
//             ReactiveFormConsumer(
//               builder: (context, form, child) {
//                 final datePickerControl = form.control(datePickerFormControl);
//                 if (datePickerControl.hasErrors) {
//                   if (datePickerControl.value == null || isHead) {
//                     return Text(
//                       requiredErrMsg,
//                       style: TextStyle(
//                           color: DigitTheme.instance.colorScheme.error),
//                     );
//                   }
//                   return Text(
//                     yearsAndMonthsErrMsg,
//                     style:
//                         TextStyle(color: DigitTheme.instance.colorScheme.error),
//                   );
//                 } else {
//                   return const SizedBox.shrink();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // A custom ControlValueAccessor to convert the model value (DateTime) to the view value (DigitDOBAge) and vice versa.
// class DobValueAccessor extends ControlValueAccessor<DateTime, DigitDOBAge> {
//   @override
//   DigitDOBAge? modelToViewValue(DateTime? modelValue) {
//     if (modelValue == null) {
//       return null;
//     } else {
//       return DigitDateUtils.calculateAge(modelValue);
//     }
//   }

//   @override
//   DateTime? viewToModelValue(DigitDOBAge? viewValue) {
//     if (viewValue == null || (viewValue.years == 0 && viewValue.months == 0)) {
//       return null;
//     } else {
//       return (viewValue.years == 0 && viewValue.months == 0) ||
//               viewValue.months > 11
//           ? null
//           : DigitDateUtils.calculateDob(viewValue);
//     }
//   }
// }

// // A custom ControlValueAccessor to handle the view value as a string for years.
// class DobValueAccessorYearsString
//     extends ControlValueAccessor<DateTime, String> {
//   final DobValueAccessor accessor;

//   DobValueAccessorYearsString(this.accessor);
//   String existingMonth = '';
//   String existingDays = '';

//   @override
//   String? modelToViewValue(DateTime? modelValue) {
//     final dobAge = accessor.modelToViewValue(modelValue);
//     if (dobAge == null || (dobAge.years == 0 && dobAge.months == 0)) {
//       existingMonth = '';
//       existingDays = '';
//       return null;
//     }

//     existingMonth = dobAge.months.toString();
//     existingDays = dobAge.days.toString();
//     return dobAge.years.toString();
//   }

//   @override
//   DateTime? viewToModelValue(String? viewValue) {
//     final years = int.tryParse(viewValue ?? '');

//     final dobAge = DigitDOBAge(
//         years: years ?? 0,
//         months: int.tryParse(existingMonth) ?? 0,
//         days: int.tryParse(existingDays) ?? 0);
//     return accessor.viewToModelValue(dobAge);
//   }
// }

// // A custom ControlValueAccessor to handle the view value as a string for months.
// class DobValueAccessorMonthString
//     extends ControlValueAccessor<DateTime, String> {
//   final DobValueAccessor accessor;
//   final bool isHead;

//   DobValueAccessorMonthString(this.accessor, {this.isHead = true});
//   String existingYear = '';
//   String existingDays = '';

//   @override
//   String? modelToViewValue(DateTime? modelValue) {
//     final dobAge = accessor.modelToViewValue(modelValue);

//     if (dobAge == null || (dobAge.years == 0 && dobAge.months == 0)) {
//       existingYear = '';
//       existingDays = '';
//       return null;
//     }

//     existingYear = dobAge.years.toString();
//     existingDays = dobAge.days.toString();
//     int months = dobAge.months;
//     return months.toString();
//   }

//   // @override
//   // DateTime? viewToModelValue(String? viewValue) {
//   //   final months = int.tryParse(viewValue ?? '');
//   //   final dobAge = DigitDOBAge(
//   //       years: int.tryParse(existingYear) ?? 0,
//   //       months: months ?? 0,
//   //       days: int.tryParse(existingDays) ?? 0);
//   //   return accessor.viewToModelValue(dobAge);
//   // }
//   @override
//   DateTime? viewToModelValue(String? viewValue) {
//     int months = int.tryParse(viewValue ?? '') ?? 0;
//     int years = isHead ? int.tryParse(existingYear) ?? 0 : 0;
//     int days = int.tryParse(existingDays) ?? 0;

//     // If months > 11, convert to years and months
//     if (months > 11) {
//       years += months ~/ 12;
//       months = months % 12;
//     }

//     final dobAge = DigitDOBAge(
//       years: years,
//       months: months,
//       days: days,
//     );
//     return accessor.viewToModelValue(dobAge);
//   }
// }

import 'package:digit_ui_components/digit_components.dart';
import 'package:digit_ui_components/theme/digit_extended_theme.dart';
import 'package:digit_ui_components/utils/date_utils.dart';
import 'package:digit_ui_components/widgets/molecules/digit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:registration_delivery/blocs/app_localization.dart';
import '../localized.dart';
import 'package:registration_delivery/utils/i18_key_constants.dart' as i18;
import '../../utils/i18_key_constants.dart' as i18_local;

class CustomDigitDobPicker extends LocalizedStatefulWidget {
  final String datePickerFormControl;
  final bool readOnly;
  final bool isHeadOfHousehold; // <-- Add this
  final ControlValueAccessor? valueAccessor;
  final String datePickerLabel;
  final String ageFieldLabel;
  final String yearsHintLabel;
  final String monthsHintLabel;
  final String separatorLabel;
  final String? initialValue;
  final String yearsAndMonthsErrMsg;
  final String cancelText;
  final String confirmText;
  final String? errorMessage;
  final String? ageErrorMessage;
  final String? monthErrorMessage;
  final DateTime? initialDate;
  final String? requiredErrMsg;
  final void Function(DateTime?)? onChangeOfFormControl;

  const CustomDigitDobPicker({
    super.key,
    super.appLocalizations,
    required this.datePickerFormControl,
    this.readOnly = false,
    this.isHeadOfHousehold = false, // <-- Add this
    this.valueAccessor,
    required this.datePickerLabel,
    required this.ageFieldLabel,
    required this.yearsHintLabel,
    required this.monthsHintLabel,
    required this.separatorLabel,
    this.initialDate,
    required this.yearsAndMonthsErrMsg,
    this.initialValue,
    this.ageErrorMessage,
    this.errorMessage,
    this.monthErrorMessage,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.requiredErrMsg,
    this.onChangeOfFormControl,
  });

  @override
  State<CustomDigitDobPicker> createState() => _DigitDobPickerState();
}

class _DigitDobPickerState extends LocalizedState<CustomDigitDobPicker> {
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  DateTime? selectedDate;
  // late RegistrationDeliveryLocalization _localizations;
  // RegistrationDeliveryLocalization get localizations => _localizations;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedDate = DigitDateUtils.getFormattedDateToDateTime(
          widget.initialValue.toString());
      _setAgeFromDate(selectedDate);
    }
    // Initialize controllers from form if possible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final form = ReactiveForm.of(context) as FormGroup?;
      final dob =
          form?.control(widget.datePickerFormControl).value as DateTime?;
      if (dob != null) _setAgeFromDate(dob);
    });
  }

  void _setAgeFromDate(DateTime? date) {
    if (date == null) return;
    final now = DateTime.now();
    int years = now.year - date.year;
    int months = now.month - date.month;
    int days = now.day - date.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    setState(() {
      yearController.text = years.toString();
      monthController.text = months.toString();
    });
  }

  DateTime _getDateFromAge() {
    int years =
        widget.isHeadOfHousehold ? int.tryParse(yearController.text) ?? 0 : 0;
    int months = int.tryParse(monthController.text) ?? 0;
    DateTime now = DateTime.now();
    // If months > 11, convert to years+months
    if (!widget.isHeadOfHousehold && months > 11) {
      years += months ~/ 12;
      months = months % 12;
    }
    if (widget.isHeadOfHousehold && months > 11) {
      Toast.showToast(context,
          type: ToastType.error,
          message: localizations
              .translate(i18_local.householdDetails.monthsValidationErrorMsg)
          );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        monthController.text = '';
      });
    }

    return DateTime(now.year - years, now.month - months);
  }

  void _updateFormControl(DateTime? dob) {
    final form = ReactiveForm.of(context) as FormGroup?;
    if (form != null) {
      form.control(widget.datePickerFormControl).value = dob;
    }
    if (widget.onChangeOfFormControl != null) {
      widget.onChangeOfFormControl!(dob);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.digitTextTheme(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigitCard(
          borderColor:
              widget.errorMessage != null ? theme.colorTheme.alert.error : null,
          cardType: CardType.secondary,
          children: [
            Column(
              children: [
                LabeledField(
                  label: widget.datePickerLabel,
                  child: DigitDateFormInput(
                    readOnly: widget.readOnly,
                    editable: false,
                    initialValue: selectedDate != null
                        ? DateFormat('dd MMM yyyy').format(selectedDate!)
                        : '',
                    firstDate: widget.initialDate,
                    cancelText: widget.cancelText,
                    confirmText: widget.confirmText,
                    lastDate: DateTime.now(),
                    onChange: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          selectedDate = DateFormat('dd/MM/yyyy').parse(value);
                          _setAgeFromDate(selectedDate);
                        });
                        _updateFormControl(selectedDate);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.separatorLabel,
                  style: theme.textTheme.bodyLarge,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: LabeledField(
                        labelInline: false,
                        label: widget.ageFieldLabel,
                        child: DigitTextFormInput(
                          errorMessage: widget.ageErrorMessage,
                          prefixTextStyle: textTheme.bodyS.copyWith(
                            color: theme.colorTheme.text.secondary,
                          ),
                          prefixText: widget.yearsHintLabel,
                          maxLength: 3,
                          controller: yearController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChange: (value) {
                            setState(() {
                              selectedDate = _getDateFromAge();
                            });
                            _updateFormControl(selectedDate);
                          },
                          keyboardType: TextInputType.number,
                          readOnly:
                              widget.readOnly || !widget.isHeadOfHousehold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LabeledField(
                        labelInline: false,
                        label: '',
                        child: DigitTextFormInput(
                          errorMessage: widget.monthErrorMessage,
                          prefixTextStyle: textTheme.bodyS.copyWith(
                            color: theme.colorTheme.text.secondary,
                          ),
                          prefixText: widget.monthsHintLabel,
                          maxLength: 3,
                          controller: monthController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChange: (value) {
                            setState(() {
                              selectedDate = _getDateFromAge();
                            });
                            _updateFormControl(selectedDate);
                          },
                          keyboardType: TextInputType.number,
                          readOnly: widget.readOnly,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacer3),
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    final control = form.control('dob');
                    if (control.hasError('required') && control.touched) {
                      return Text(
                        widget.requiredErrMsg ??
                            'Required field cannot be empty',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorTheme.alert.error,
                        ),
                      );
                    }
                    if (control.hasError('ageLimit')) {
                      return Text(
                        localizations.translate(i18_local.householdDetails.ageValidationErrorMsg),
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorTheme.alert.error,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
