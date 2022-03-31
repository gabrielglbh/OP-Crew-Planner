part of 'build_bloc.dart';

class BuildState extends Equatable {
  const BuildState();

  @override
  List<Object?> get props => [];
}

class BuildStateIdle extends BuildState {}

class BuildStateLoading extends BuildState {}

class BuildStateSearching extends BuildState {}

class BuildStateLoaded extends BuildState {
  final List<Unit> units;

  const BuildStateLoaded({this.units = const []});

  @override
  List<Object> get props => [units];
}

class BuildStateFailure extends BuildState {}