import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/queries/rumble_team_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';

part 'rumble_event.dart';
part 'rumble_state.dart';

class RumbleListBloc extends Bloc<RumbleListEvent, RumbleListState> {
  RumbleListBloc() : super(RumbleListStateLoading()) {
    on<RumbleListEventLoading>((event, emit) async {
      try {
        emit(RumbleListStateLoading());
        List<RumbleTeam> teams = await RumbleTeamQueries.instance.getRumbleTeams(event.showATK, null);
        emit(RumbleListStateLoaded(teams: teams));
      } on Exception {
        emit(RumbleListStateFailure());
      }
    });

    on<RumbleListEventSearching>((event, emit) async {
      try {
        emit(RumbleListStateLoading());
        final teams = await RumbleTeamQueries.instance.getRumbleTeams(true, event.query);
        emit(RumbleListStateLoaded(teams: teams));
      } on Exception {
        emit(RumbleListStateFailure());
      }
    });

    on<RumbleListEventDelete>((event, emit) async {
      if (state is RumbleListStateLoaded) {
        try {
          emit(RumbleListStateLoading());
          await RumbleTeamQueries.instance.deleteRumbleTeam(event.team.name);
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteRumbleTeam);
          List<RumbleTeam> teams = await RumbleTeamQueries.instance.getRumbleTeams(event.showATK, null);
          emit(RumbleListStateLoaded(teams: teams));
        } on Exception {
          emit(RumbleListStateFailure());
        }
      }
    });
  }
}