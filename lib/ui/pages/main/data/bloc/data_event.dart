part of 'data_bloc.dart';

abstract class DataListEvent extends Equatable {
  const DataListEvent();

  @override
  List<Object> get props => [];
}

class DataListEventLoading extends DataListEvent {
  const DataListEventLoading();

  @override
  List<Object> get props => [];
}

class DataListEventSearching extends DataListEvent {
  final String query;
  final String type;

  const DataListEventSearching(this.query, this.type);

  @override
  List<Object> get props => [query, type];
}

class DataListEventDelete extends DataListEvent {
  final Unit unit;

  const DataListEventDelete(this.unit);

  @override
  List<Object> get props => [unit];
}

class DataListEventClearHistory extends DataListEvent {
  const DataListEventClearHistory();

  @override
  List<Object> get props => [];
}

class DataListEventRemoveData extends DataListEvent {
  const DataListEventRemoveData();

  @override
  List<Object> get props => [];
}

class DataListEventDownloadLegends extends DataListEvent {
  const DataListEventDownloadLegends();

  @override
  List<Object> get props => [];
}