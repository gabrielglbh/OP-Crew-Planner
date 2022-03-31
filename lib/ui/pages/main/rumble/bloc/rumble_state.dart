part of 'rumble_bloc.dart';

class RumbleListState extends Equatable {
  const RumbleListState();

  @override
  List<Object?> get props => [];
}

class RumbleListStateLoading extends RumbleListState {}

class RumbleListStateSearching extends RumbleListState {}

class RumbleListStateLoaded extends RumbleListState {
  final List<RumbleTeam> teams;

  const RumbleListStateLoaded({this.teams = const []});

  @override
  List<Object> get props => [teams];
}

class RumbleListStateFailure extends RumbleListState {}