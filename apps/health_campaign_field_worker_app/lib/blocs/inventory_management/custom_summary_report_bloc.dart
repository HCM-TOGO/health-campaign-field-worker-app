import 'dart:async';
import 'package:digit_data_model/utils/typedefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_management/utils/typedefs.dart';
import 'package:registration_delivery/models/entities/household_member.dart';
import 'package:registration_delivery/utils/typedefs.dart';

import '../../utils/constants.dart';
import '../../utils/date_utils.dart';

part 'custom_summary_report_bloc.freezed.dart';

typedef SummaryReportEmitter = Emitter<SummaryReportState>;

class SummaryReportBloc extends Bloc<SummaryReportEvent, SummaryReportState> {
  final IndividualDataRepository individualRepository;
  final HouseholdMemberDataRepository householdMemberRepository;
  final TaskDataRepository taskDataRepository;
  final StockDataRepository stockRepository;
  final StockReconciliationDataRepository stockReconciliationRepository;

  SummaryReportBloc({
    required this.stockRepository,
    required this.stockReconciliationRepository,
    required this.householdMemberRepository,
    required this.individualRepository,
    required this.taskDataRepository,
  }) : super(const SummaryReportEmptyState()) {
    on<SummaryReportLoadDataEvent>(_handleLoadDataEvent);
    on<SummaryReportLoadingEvent>(_handleLoadingEvent);
  }

  Future<void> _handleLoadDataEvent(
    SummaryReportLoadDataEvent event,
    SummaryReportEmitter emit,
  ) async {
    emit(const SummaryReportLoadingState());

    List<HouseholdMemberModel> householdMemberList = [];
    householdMemberList = await (householdMemberRepository)
        .search(HouseholdMemberSearchModel(isHeadOfHousehold: false));

    Map<String, List<HouseholdMemberModel>> dateVsHouseholdMembers = {};
    Set<String> uniqueDates = {};
    Map<String, int> dateVsHouseholdMembersCount = {};
    Map<String, Map<String, int>> dateVsEntityVsCountMap = {};
    for (var element in householdMemberList) {
      var dateKey = DigitDateUtils.getDateFromTimestamp(
          element.clientAuditDetails!.createdTime);
      dateVsHouseholdMembers.putIfAbsent(dateKey, () => []).add(element);
    }

    // get a set of unique dates
    getUniqueSetOfDates(
      dateVsHouseholdMembers,
      uniqueDates,
    );

    // populate the day vs count for that day map
    populateDateVsCountMap(dateVsHouseholdMembers, dateVsHouseholdMembersCount);

    popoulateDateVsEntityCountMap(
      dateVsEntityVsCountMap,
      dateVsHouseholdMembersCount,
      uniqueDates,
    );
    dateVsEntityVsCountMap =
        sortMapByDateKeyAndRenameDate(dateVsEntityVsCountMap);
    dateVsEntityVsCountMap = addTotalEntryToMap(dateVsEntityVsCountMap);

    emit(SummaryReportDataState(data: dateVsEntityVsCountMap));
  }

  void getUniqueSetOfDates(
    Map<String, List<HouseholdMemberModel>> dateVsHouseholdMembers,
    Set<String> uniqueDates,
  ) {
    uniqueDates.addAll(dateVsHouseholdMembers.keys.toSet());
  }

  void populateDateVsCountMap(
      Map<String, List> map, Map<String, int> dateVsCount) {
    map.forEach((key, value) {
      dateVsCount[key] = value.length;
    });
  }

  void popoulateDateVsEntityCountMap(
    Map<String, Map<String, int>> dateVsEntityVsCountMap,
    Map<String, int> dateVsHouseholdMembersCount,
    Set<String> uniqueDates,
  ) {
    for (var date in uniqueDates) {
      Map<String, int> elementVsCount = {};
      if (dateVsHouseholdMembersCount.containsKey(date) &&
          dateVsHouseholdMembersCount[date] != null) {
        var count = dateVsHouseholdMembersCount[date];
        elementVsCount[Constants.registered] = count ?? 0;
      }

      dateVsEntityVsCountMap[date] = elementVsCount;
    }
  }

  Map<String, Map<String, int>> sortMapByDateKeyAndRenameDate(
    Map<String, Map<String, int>> dateVsEntityVsCountMap,
  ) {
    final sortedEntries = dateVsEntityVsCountMap.entries.toList()
      ..sort((a, b) {
        final dateA = DateTime.parse(_toIsoFormat(a.key));
        final dateB = DateTime.parse(_toIsoFormat(b.key));
        return dateA.compareTo(dateB);
      });

    final Map<String, Map<String, int>> renamedMap = {};

    for (int i = 0; i < sortedEntries.length; i++) {
      final originalDate = sortedEntries[i].key;
      final newKey = '$originalDate Day${i + 1}';
      renamedMap[newKey] = sortedEntries[i].value;
    }

    return renamedMap;
  }

  Map<String, Map<String, int>> addTotalEntryToMap(
      Map<String, Map<String, int>> originalMap) {
    final Map<String, int> totalMap = {};

    for (final dayEntry in originalMap.entries) {
      final dayData = dayEntry.value;
      for (final entry in dayData.entries) {
        totalMap.update(entry.key, (value) => value + entry.value,
            ifAbsent: () => entry.value);
      }
    }

    // Create new map with 'Total' at the beginning
    final Map<String, Map<String, int>> newMap = {
      'Total': totalMap,
      ...originalMap,
    };

    return newMap;
  }

  /// Converts 'dd/MM/yyyy' to 'yyyy-MM-dd' for proper DateTime parsing
  String _toIsoFormat(String dateStr) {
    final parts = dateStr.split('/');
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  Future<void> _handleLoadingEvent(
    SummaryReportLoadingEvent event,
    SummaryReportEmitter emit,
  ) async {
    emit(const SummaryReportLoadingState());
  }
}

@freezed
class SummaryReportEvent with _$SummaryReportEvent {
  const factory SummaryReportEvent.loadSummaryData({
    required String userId,
  }) = SummaryReportLoadDataEvent;

  const factory SummaryReportEvent.loading() = SummaryReportLoadingEvent;
}

@freezed
class SummaryReportState with _$SummaryReportState {
  const factory SummaryReportState.loading() = SummaryReportLoadingState;
  const factory SummaryReportState.empty() = SummaryReportEmptyState;

  const factory SummaryReportState.data({
    @Default({}) Map<String, Map<String, int>> data,
  }) = SummaryReportDataState;
}
