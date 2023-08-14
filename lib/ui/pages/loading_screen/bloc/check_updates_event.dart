part of 'check_updates_bloc.dart';

abstract class CheckUpdatesEvent extends Equatable {
  const CheckUpdatesEvent();

  @override
  List<Object> get props => [];
}

class CheckUpdatesInstallEvent extends CheckUpdatesEvent {
  final BuildContext context;

  const CheckUpdatesInstallEvent({required this.context});

  @override
  List<Object> get props => [context];
}

class CheckUpdatesResumeInstallEvent extends CheckUpdatesEvent {
  final BuildContext context;

  const CheckUpdatesResumeInstallEvent({required this.context});

  @override
  List<Object> get props => [context];
}

class CheckUpdatesResumeVersionEvent extends CheckUpdatesEvent {
  final BuildContext context;

  const CheckUpdatesResumeVersionEvent({required this.context});

  @override
  List<Object> get props => [context];
}
