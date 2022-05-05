import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/pages/main/enum_lists.dart';
import 'package:optcteams/ui/pages/main/teams/bloc/team_bloc.dart';
import 'package:optcteams/ui/widgets/action_button.dart';
import 'package:optcteams/ui/widgets/empty_list.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:optcteams/ui/widgets/custom_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/widgets/team_element.dart';

class TeamsTab extends StatefulWidget {
  final FocusNode? focus;
  const TeamsTab({Key? key, required this.focus}) : super(key: key);

  @override
  _TeamsTabState createState() => _TeamsTabState();
}

class _TeamsTabState extends State<TeamsTab> with AutomaticKeepAliveClientMixin {
  TextEditingController? _controller;

  bool _showMaxed = true;

  _addLoadingEvent(BuildContext blocContext) {
    blocContext.read<TeamListBloc>().add(TeamListEventLoading(showMax: _showMaxed));
  }

  bool _onScrolling(ScrollNotification sn) {
    if (sn is ScrollStartNotification || sn is ScrollUpdateNotification) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return true;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller = TextEditingController();
    setState(() {
      _showMaxed = StorageUtils.readData(StorageUtils.maxFilter, false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<TeamListBloc>(
      create: (_) => TeamListBloc()..add(TeamListEventLoading(showMax: _showMaxed)),
      child: BlocBuilder<TeamListBloc, TeamListState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _controller,
                      hint: "searchHintTeams".tr(),
                      focus: widget.focus,
                      onQuery: (query, type) => context.read<TeamListBloc>()..add(TeamListEventSearching(query)),
                      onExitSearch: () => _addLoadingEvent(context),
                      mode: SearchMode.teamTab,
                    ),
                  ),
                  ActionButton(
                    child: Text("MAX", style: TextStyle(fontWeight: FontWeight.bold,
                      color: _showMaxed ? Colors.red[700] : null)
                    ),
                    onTap: () async {
                      await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.teamMaxFilter);
                      setState(() => _showMaxed = !_showMaxed);
                      StorageUtils.saveData(StorageUtils.maxFilter, _showMaxed);
                      _addLoadingEvent(context);
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

  Widget _setWidgetOnState(BuildContext blocContext, TeamListState state) {
    if (state is TeamListStateLoading || state is TeamListStateSearching) {
      return const LoadingWidget();
    } else if (state is TeamListStateLoaded) {
      if (state.teams.isEmpty) {
        return EmptyList(onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.team);
      } else {
        return _teamList(blocContext, state);
      }
    } else {
      return EmptyList(onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.team);
    }
  }

  Expanded _teamList(BuildContext blocContext, TeamListStateLoaded state) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScrolling(notification),
        child: RefreshIndicator(
          onRefresh: () async => _addLoadingEvent(blocContext),
          color: Colors.orange.shade400,
          child: ListView.builder(
            key: const PageStorageKey<String>('teamTab'),
            itemCount: state.teams.length,
            itemBuilder: ((context, index) {
              return TeamElement(
                team: state.teams[index],
                index: index,
                onSelected: () {
                  _controller?.text = "";
                  widget.focus?.unfocus();
                },
                onDelete: () async {
                  blocContext.read<TeamListBloc>().add(
                      TeamListEventDelete(state.teams[index], showMaxed: _showMaxed));
                  Navigator.pop(context);
                },
              );
            }),
          ),
        ),
      )
    );
  }
}
