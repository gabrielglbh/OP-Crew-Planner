part of 'team_bloc.dart';

abstract class TeamListEvent extends Equatable {
  const TeamListEvent();

  @override
  List<Object> get props => [];
}

class TeamListEventLoading extends TeamListEvent {
  final bool showMax;

  const TeamListEventLoading({required this.showMax});

  @override
  List<Object> get props => [showMax];
}

class TeamListEventSearching extends TeamListEvent {
  final String query;

  const TeamListEventSearching(this.query);

  @override
  List<Object> get props => [query];
}

class TeamListEventDelete extends TeamListEvent {
  final Team team;
  final bool showMaxed;

  const TeamListEventDelete(this.team, {required this.showMaxed});

  @override
  List<Object> get props => [team, showMaxed];
}