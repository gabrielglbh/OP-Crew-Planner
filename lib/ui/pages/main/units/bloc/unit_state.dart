part of 'unit_bloc.dart';

class UnitListState extends Equatable {
  const UnitListState();

  @override
  List<Object?> get props => [];
}

class UnitListStateLoading extends UnitListState {}

class UnitListStateSearching extends UnitListState {}

class UnitListStateLoaded extends UnitListState {
  final List<Unit> units;

  const UnitListStateLoaded({this.units = const []});

  @override
  List<Object> get props => [units];
}

class UnitListStateFailure extends UnitListState {}