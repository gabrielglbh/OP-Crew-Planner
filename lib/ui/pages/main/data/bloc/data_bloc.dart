import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_info_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';

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
  }
}