part of 'unit_bloc.dart';

abstract class UnitListEvent extends Equatable {
  const UnitListEvent();

  @override
  List<Object> get props => [];
}

class UnitListEventLoading extends UnitListEvent {
  /// Maintains the filter applied by the user for loading new lists
  final UnitFilter filter;
  final bool showOnlyAvailable;

  const UnitListEventLoading(
      {required this.filter, required this.showOnlyAvailable});

  @override
  List<Object> get props => [filter, showOnlyAvailable];
}

class UnitListEventSearching extends UnitListEvent {
  final String query;

  const UnitListEventSearching(this.query);

  @override
  List<Object> get props => [query];
}

class UnitListEventDelete extends UnitListEvent {
  final Unit unit;

  /// Maintains the filter applied by the user for loading new lists
  final UnitFilter filter;
  final bool showOnlyAvailable;

  const UnitListEventDelete(this.unit,
      {required this.filter, required this.showOnlyAvailable});

  @override
  List<Object> get props => [unit, filter, showOnlyAvailable];
}
