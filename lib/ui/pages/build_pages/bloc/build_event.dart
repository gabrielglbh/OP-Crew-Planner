part of 'build_bloc.dart';

abstract class BuildEvent extends Equatable {
  const BuildEvent();

  @override
  List<Object> get props => [];
}

class BuildEventIdle extends BuildEvent {}

class BuildEventLoading extends BuildEvent {
  const BuildEventLoading();

  @override
  List<Object> get props => [];
}

class BuildEventSearching extends BuildEvent {
  final bool filterOnMaxUnits;
  final String query;
  final String type;

  const BuildEventSearching(this.filterOnMaxUnits, this.query, this.type);

  @override
  List<Object> get props => [filterOnMaxUnits, query, type];
}
