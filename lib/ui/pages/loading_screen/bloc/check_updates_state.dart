part of 'check_updates_bloc.dart';

abstract class CheckUpdatesState extends Equatable {
  const CheckUpdatesState();

  @override
  List<Object> get props => [];
}

class CheckUpdatesLoadingState extends CheckUpdatesState {
  final String message;
  final double progress;

  const CheckUpdatesLoadingState({this.message = "", this.progress = 0});

  @override
  List<Object> get props => [message, progress];
}

class CheckUpdatesDoneState extends CheckUpdatesState {
  @override
  List<Object> get props => [];
}

class CheckUpdatesFailureState extends CheckUpdatesState {
  final String message;

  const CheckUpdatesFailureState({required this.message});

  @override
  List<Object> get props => [message];
}

class CheckUpdatesNewVersionState extends CheckUpdatesState {
  final String version;

  const CheckUpdatesNewVersionState({required this.version});

  @override
  List<Object> get props => [version];
}
