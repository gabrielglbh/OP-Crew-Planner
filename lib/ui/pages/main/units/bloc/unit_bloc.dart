import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/ui/pages/main/units/enum_unit_filters.dart';

part 'unit_event.dart';
part 'unit_state.dart';

class UnitListBloc extends Bloc<UnitListEvent, UnitListState> {
  UnitListBloc() : super(UnitListStateLoading()) {
    on<UnitListEventLoading>((event, emit) async {
      try {
        emit(UnitListStateLoading());
        List<Unit> units = [];
        if (event.showOnlyAvailable)
          units = await UnitQueries.instance.getUnitsToBeMaxedOutAvailable(event.filter);
        else
          units = await UnitQueries.instance.getUnitsToBeMaxedOut(event.filter);
        emit(UnitListStateLoaded(units: units));
      } on Exception {
        emit(UnitListStateFailure());
      }
    });

    on<UnitListEventSearching>((event, emit) async {
      try {
        emit(UnitListStateLoading());
        final units = await UnitQueries.instance.getUnitsCurrentlyMaxing(event.query);
        emit(UnitListStateLoaded(units: units));
      } on Exception {
        emit(UnitListStateFailure());
      }
    });

    on<UnitListEventDelete>((event, emit) async {
      if (state is UnitListStateLoaded) {
        try {
          emit(UnitListStateLoading());
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteUnit);
          event.unit.setAttributes(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          await UnitQueries.instance.updateUnit(event.unit);

          List<Unit> units = [];
          if (event.showOnlyAvailable)
            units = await UnitQueries.instance.getUnitsToBeMaxedOutAvailable(event.filter);
          else
            units = await UnitQueries.instance.getUnitsToBeMaxedOut(event.filter);
          emit(UnitListStateLoaded(units: units));
        } on Exception {
          emit(UnitListStateFailure());
        }
      }
    });
  }
}