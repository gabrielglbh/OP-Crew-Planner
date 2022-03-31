import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_info_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/queries/backup_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataListBloc extends Bloc<DataListEvent, DataListState> {
  DataListBloc() : super(DataListStateLoading()) {
    on<DataListEventLoading>((event, emit) async {
      try {
        emit(DataListStateLoading());
        List<Unit> units = await UnitQueries.instance.getMostRecentSearchedUnits();
        emit(DataListStateLoaded(units: units));
      } on Exception {
        emit(DataListStateFailure());
      }
    });

    on<DataListEventSearching>((event, emit) async {
      try {
        emit(DataListStateLoading());
        List<Unit> units = await UnitQueries.instance.getUnitsAccordingToName(event.query, event.type);
        List<Unit> parsedUnits = [];
        parsedUnits.addAll(units);
        units.forEach((unit) {
          if (unit.name.contains("[VS Unit]") || unit.name.contains("[Dual Unit]"))
            parsedUnits.remove(unit);
        });
        emit(DataListStateLoaded(units: parsedUnits));
      } on Exception {
        emit(DataListStateFailure());
      }
    });

    on<DataListEventDelete>((event, emit) async {
      if (state is DataListStateLoaded) {
        try {
          emit(DataListStateLoading());
          await UnitInfoQueries.instance.deleteSpecificUnitInfoFromDatabase(event.unit);
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteDataUnit);
          List<Unit> units = await UnitQueries.instance.getMostRecentSearchedUnits();
          emit(DataListStateLoaded(units: units));
        } on Exception {
          emit(DataListStateFailure());
        }
      }
    });

    on<DataListEventClearHistory>((event, emit) async {
      try {
        emit(DataListStateLoading());
        await UnitQueries.instance.clearHistory();
        await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.clearHistory);
        emit(DataListStateLoaded(units: []));
      } on Exception {
        emit(DataListStateFailure());
      }
    });

    on<DataListEventRemoveData>((event, emit) async {
      try {
        emit(DataListStateLoading());
        await UnitInfoQueries.instance.deleteUnitInfoFromDatabase();
        StorageUtils.saveData(StorageUtils.downloadedLegends, false);
        await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteAllDataUnit);
        List<Unit> units = await UnitQueries.instance.getMostRecentSearchedUnits();
        emit(DataListStateLoaded(units: units));
      } on Exception {
        emit(DataListStateFailure());
      }
    });

    on<DataListEventDownloadLegends>((event, emit) async {
      try {
        emit(DataListStateLoading(message: "loadingLegends".tr()));
        for (int x = 0; x < Data.legends.length; x++) {
          await BackUpRecords.instance.getUnitAdditionalInfo(Data.legends[x]).then((info) async {
            if (info != null) {
              Unit unit = await UnitQueries.instance.getUnit(Data.legends[x]);
              unit.downloaded = 1;
              info.unitId = Data.legends[x];
              await UnitInfoQueries.instance.insertUnitInfoIntoDatabase(info, unit);
            }
          });
        }
        await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.downloadLegends);
        StorageUtils.saveData(StorageUtils.downloadedLegends, true);
        List<Unit> units = await UnitQueries.instance.getMostRecentSearchedUnits();
        emit(DataListStateLoaded(units: units));
      } on Exception {
        emit(DataListStateFailure());
      }
    });
  }
}