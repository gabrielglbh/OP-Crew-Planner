import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';

part 'build_event.dart';
part 'build_state.dart';

class BuildBloc extends Bloc<BuildEvent, BuildState> {
  BuildBloc() : super(BuildStateIdle()) {
    on<BuildEventIdle>((event, emit) => emit(BuildStateIdle()));

    on<BuildEventLoading>((event, emit) async {
      try {
        emit(BuildStateLoading());
        List<Unit> units = await UnitQueries.instance.getMostRecentSearchedUnits();
        emit(BuildStateLoaded(units: units));
      } on Exception {
        emit(BuildStateFailure());
      }
    });

    on<BuildEventSearching>((event, emit) async {
      try {
        emit(BuildStateLoading());
        List<Unit> units = [];
        if (event.filterOnMaxUnits) {
          units = await UnitQueries.instance.getUnitsCurrentlyNotMaxing(event.query, event.type);
        } else {
          units = await UnitQueries.instance.getUnitsAccordingToName(event.query, event.type);
        }
        List<Unit> parsedUnits = [];
        parsedUnits.addAll(units);
        for (var unit in units) {
          if (unit.name.contains("[VS Unit]") || unit.name.contains("[Dual Unit]")) {
            parsedUnits.remove(unit);
          }
        }
        emit(BuildStateLoaded(units: parsedUnits));
      } on Exception {
        emit(BuildStateFailure());
      }
    });
  }
}