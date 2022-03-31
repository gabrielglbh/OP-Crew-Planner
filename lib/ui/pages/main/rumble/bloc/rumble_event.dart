part of 'rumble_bloc.dart';

abstract class RumbleListEvent extends Equatable {
  const RumbleListEvent();

  @override
  List<Object> get props => [];
}

class RumbleListEventLoading extends RumbleListEvent {
  final bool showATK;

  const RumbleListEventLoading({required this.showATK});

  @override
  List<Object> get props => [showATK];
}

class RumbleListEventSearching extends RumbleListEvent {
  final String query;

  const RumbleListEventSearching(this.query);

  @override
  List<Object> get props => [query];
}

class RumbleListEventDelete extends RumbleListEvent {
  final RumbleTeam team;
  final bool showATK;

  const RumbleListEventDelete(this.team, {required this.showATK});

  @override
  List<Object> get props => [team, showATK];
}