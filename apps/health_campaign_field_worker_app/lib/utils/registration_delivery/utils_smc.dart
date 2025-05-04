import 'package:collection/collection.dart';
import 'package:digit_data_model/models/entities/individual.dart';
import 'package:digit_data_model/models/entities/project_type.dart';
import 'package:digit_data_model/models/project_type/project_type_model.dart';
import 'package:health_campaign_field_worker_app/utils/constants.dart';
import 'package:registration_delivery/models/entities/additional_fields_type.dart';
import 'package:registration_delivery/models/entities/side_effect.dart';
import 'package:registration_delivery/models/entities/status.dart';
import 'package:registration_delivery/models/entities/task.dart';

import '../../models/entities/additional_fields_type.dart'
    as additional_fields_local;
import '../app_enums.dart';

bool redosePending(List<TaskModel>? tasks, ProjectCycle? selectedCycle) {
  var redosePending = true;
  if ((tasks ?? []).isEmpty) {
    return true;
  }

  if (selectedCycle == null) {
    return false;
  }

  // get the fist task which was marked as visited as this is the one which was created in redose flow
  TaskModel? redoseTask = tasks!
      .where(
        (element) => element.status == Status.visited.toValue(),
      )
      .lastOrNull;
  TaskModel? successfullTask = tasks
      .where(
        (element) => element.status == Status.administeredSuccess.toValue(),
      )
      .lastOrNull;
  int diff = DateTime.now().millisecondsSinceEpoch -
      (successfullTask?.clientAuditDetails?.createdTime ??
          DateTime.now().millisecondsSinceEpoch);
  redosePending = redoseTask == null
      ? true
      : (redoseTask.additionalFields?.fields
                  .where(
                    (element) => element.key == Constants.reAdministeredKey,
                  )
                  .toList() ??
              [])
          .isEmpty;

  return redosePending &&
      (selectedCycle.mandatoryWaitSinceLastCycleInDays == null ||
          diff <=
              (selectedCycle.mandatoryWaitSinceLastCycleInDays ?? 0) *
                  60 *
                  1000);
}

bool assessmentSMCPending(List<TaskModel>? tasks) {
  // this task confirms eligibility and dose administrations is done
  if ((tasks ?? []).isEmpty) {
    return true;
  }
  var successfulTask = tasks!
      .where(
        (element) =>
            element.status == Status.administeredSuccess.toValue() &&
            element.additionalFields?.fields.firstWhereOrNull(
                  (e) =>
                      e.key ==
                          additional_fields_local
                              .AdditionalFieldsType.deliveryType
                              .toValue() &&
                      e.value == EligibilityAssessmentStatus.smcDone.name,
                ) !=
                null,
      )
      .lastOrNull;

  return successfulTask == null;
}

bool assessmentVASPending(List<TaskModel>? tasks) {
  // this task confirms eligibility and dose administrations is done
  if ((tasks ?? []).isEmpty) {
    return true;
  }
  var successfulTask = tasks!
      .where(
        (element) => (element.status == Status.administeredSuccess.toValue() &&
            element.additionalFields?.fields.firstWhereOrNull(
                  (e) =>
                      e.key ==
                          additional_fields_local
                              .AdditionalFieldsType.deliveryType
                              .toValue() &&
                      e.value == EligibilityAssessmentStatus.vasDone.name,
                ) !=
                null),
      )
      .lastOrNull;

  return successfulTask == null;
}

bool recordedSideEffect(
  Cycle? selectedCycle,
  TaskModel? task,
  List<SideEffectModel>? sideEffects,
) {
  if (selectedCycle != null &&
      selectedCycle.startDate != null &&
      selectedCycle.endDate != null) {
    if ((task != null) && (sideEffects ?? []).isNotEmpty) {
      final lastTaskCreatedTime =
          task.clientReferenceId == sideEffects?.last.taskClientReferenceId
              ? task.clientAuditDetails?.createdTime
              : null;

      return lastTaskCreatedTime != null &&
          lastTaskCreatedTime >= selectedCycle.startDate! &&
          lastTaskCreatedTime <= selectedCycle.endDate!;
    }
  }

  return false;
}

bool allDosesDelivered(
  List<TaskModel>? tasks,
  Cycle? selectedCycle,
  List<SideEffectModel>? sideEffects,
  IndividualModel? individualModel,
) {
  if (selectedCycle == null ||
      selectedCycle.id == 0 ||
      (selectedCycle.deliveries ?? []).isEmpty) {
    return true;
  } else {
    if ((tasks ?? []).isNotEmpty) {
      final lastCycle = int.tryParse(tasks?.last.additionalFields?.fields
              .where(
                (e) => e.key == AdditionalFieldsType.cycleIndex.toValue(),
              )
              .firstOrNull
              ?.value ??
          '');
      final lastDose = int.tryParse(tasks?.last.additionalFields?.fields
              .where(
                (e) => e.key == AdditionalFieldsType.doseIndex.toValue(),
              )
              .firstOrNull
              ?.value ??
          '');
      if (lastDose != null &&
          lastDose == selectedCycle.deliveries?.length &&
          lastCycle != null &&
          lastCycle == selectedCycle.id &&
          tasks?.last.status != Status.delivered.toValue()) {
        return true;
      } else if (selectedCycle.id == lastCycle &&
          tasks?.last.status == Status.delivered.toValue()) {
        return false;
      } else if ((sideEffects ?? []).isNotEmpty) {
        return recordedSideEffect(selectedCycle, tasks?.last, sideEffects);
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
