import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/ui/pages/main/data/bloc/data_bloc.dart';
import 'package:optcteams/ui/pages/main/enum_lists.dart';
import 'package:optcteams/ui/pages/main/data/utils.dart';
import 'package:optcteams/ui/widgets/ActionButton.dart';
import 'package:optcteams/ui/widgets/EmptyList.dart';
import 'package:optcteams/ui/widgets/LoadingWidget.dart';
import 'package:optcteams/ui/widgets/CustomSearchBar.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:optcteams/ui/widgets/unitInfo/BottomSheetUnitInfo.dart';

class DataTab extends StatefulWidget {
  final FocusNode? focus;
  const DataTab({required this.focus});

  @override
  _DataTabState createState() => _DataTabState();
}

class _DataTabState extends State<DataTab> with AutomaticKeepAliveClientMixin {
  TextEditingController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _addLoadingEvent(BuildContext blocContext) => blocContext.read<DataListBloc>()..add(DataListEventLoading());

  _showRemoveDownloadedDialog(BuildContext blocContext, Unit unit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return UIAlert(
          title: "onDeleteSpecificData".tr(),
          acceptButton: "deleteLabel".tr(),
          dialogContext: context,
          onAccepted: () async {
            blocContext.read<DataListBloc>()..add(DataListEventDelete(unit));
            Navigator.pop(context);
          },
        );
      }
    );
  }

  bool _onScrolling(ScrollNotification sn) {
    if (sn is ScrollStartNotification || sn is ScrollUpdateNotification) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return true;
  }

  _clearHistory(BuildContext blocContext) {
    Navigator.of(context).pop();
    blocContext.read<DataListBloc>()..add(DataListEventClearHistory());
  }

  _removeData(BuildContext blocContext) {
    Navigator.of(context).pop();
    blocContext.read<DataListBloc>()..add(DataListEventRemoveData());
  }

  _downloadLegends(BuildContext blocContext) {
    Navigator.of(context).pop();
    blocContext.read<DataListBloc>()..add(DataListEventDownloadLegends());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<DataListBloc>(
      create: (_) => DataListBloc()..add(DataListEventLoading()),
      child: BlocBuilder<DataListBloc, DataListState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _controller,
                      hint: "searchHintUnits".tr(),
                      focus: widget.focus,
                      onQuery: (query, type) => context.read<DataListBloc>()..add(DataListEventSearching(query, type)),
                      onExitSearch: () => _addLoadingEvent(context),
                      mode: SearchMode.dataTab,
                    ),
                  ),
                  ActionButton(
                    child: Icon(Icons.menu),
                    onTap: () {
                      widget.focus?.unfocus();
                      MainUtils.instance.showDialogForMenuManage(context,
                          onAccepted: () => _downloadLegends(context),
                          clearHistory: () => _clearHistory(context),
                          removeData: () => _removeData(context)
                      );
                    },
                  )
                ],
              ),
              _setWidgetOnState(context, state)
            ],
          );
        },
      ),
    );
  }

  Widget _setWidgetOnState(BuildContext blocContext, DataListState state) {
    if (state is DataListStateLoading)
      return LoadingWidget(msg: state.message);
    else if (state is DataListEventSearching)
      return LoadingWidget();
    else if (state is DataListStateLoaded) {
      if (state.units.isEmpty)
        return EmptyList(onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.data);
      else
        return _dataList(blocContext, state);
    }
    else
      return EmptyList(onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.data);
  }

  Expanded _dataList(BuildContext blocContext, DataListStateLoaded state) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScrolling(notification),
        child: RefreshIndicator(
          onRefresh: () async => _addLoadingEvent(blocContext),
          child: GridView.builder(
            key: PageStorageKey<String>('dataTab'),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemCount: state.units.length,
            itemBuilder: (context, index) {
              Unit unit = state.units[index];
              return InkWell(
                child: UI.placeholderImageWhileLoadingUnit(unit),
                onTap: () async {
                  _controller?.text = "";
                  await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.openUnitDataFromHistory);
                  await UnitQueries.instance.updateHistoryUnit(unit);
                  await AdditionalUnitInfo.callModalSheet(context, unit.id, onClose: () {
                    _addLoadingEvent(blocContext);
                  });
                },
                onLongPress: () {
                  if (unit.downloaded == 1) _showRemoveDownloadedDialog(context, unit);
                },
              );
            }
          ),
        ),
      )
    );
  }
}
