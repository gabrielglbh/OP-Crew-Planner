part of 'data_bloc.dart';

class DataListState extends Equatable {
  const DataListState();

  @override
  List<Object?> get props => [];
}

class DataListStateLoading extends DataListState {
  final String message;

  const DataListStateLoading({this.message = ""});

  @override
  List<Object> get props => [message];
}

class DataListStateSearching extends DataListState {}

class DataListStateLoaded extends DataListState {
  final List<Unit> units;

  const DataListStateLoaded({this.units = const []});

  @override
  List<Object> get props => [units];
}

class DataListStateFailure extends DataListState {}