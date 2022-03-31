import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamListBloc extends Bloc<TeamListEvent, TeamListState> {
  TeamListBloc() : super(TeamListStateLoading()) {
    on<TeamListEventLoading>((event, emit) async {
      try {
        emit(TeamListStateLoading());
        List<Team> teams = await TeamQueries.instance.getTeams(event.showMax, null);
        emit(TeamListStateLoaded(teams: teams));
      } on Exception {
        emit(TeamListStateFailure());
      }
    });

    on<TeamListEventSearching>((event, emit) async {
      try {
        emit(TeamListStateLoading());
        final teams = await TeamQueries.instance.getTeams(true, event.query);
        emit(TeamListStateLoaded(teams: teams));
      } on Exception {
        emit(TeamListStateFailure());
      }
    });

    on<TeamListEventDelete>((event, emit) async {
      if (state is TeamListStateLoaded) {
        try {
          emit(TeamListStateLoading());
          await TeamQueries.instance.deleteTeam(event.team.name);
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteTeam);
          List<Team> teams = await TeamQueries.instance.getTeams(event.showMaxed, null);
          emit(TeamListStateLoaded(teams: teams));
        } on Exception {
          emit(TeamListStateFailure());
        }
      }
    });
  }
}