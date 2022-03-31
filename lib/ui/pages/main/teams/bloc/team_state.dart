part of 'team_bloc.dart';

class TeamListState extends Equatable {
  const TeamListState();

  @override
  List<Object?> get props => [];
}

class TeamListStateLoading extends TeamListState {}

class TeamListStateSearching extends TeamListState {}

class TeamListStateLoaded extends TeamListState {
  final List<Team> teams;

  const TeamListStateLoaded({this.teams = const []});

  @override
  List<Object> get props => [teams];
}

class TeamListStateFailure extends TeamListState {}