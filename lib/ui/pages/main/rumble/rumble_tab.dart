import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/types/list_type.dart';
import 'package:optcteams/ui/pages/main/rumble/bloc/rumble_bloc.dart';
import 'package:optcteams/ui/widgets/action_button.dart';
import 'package:optcteams/ui/widgets/empty_list.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:optcteams/ui/widgets/rumble_element.dart';
import 'package:optcteams/ui/widgets/custom_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class RumbleTab extends StatefulWidget {
  final FocusNode? focus;
  const RumbleTab({Key? key, required this.focus}) : super(key: key);

  @override
  State<RumbleTab> createState() => _RumbleTabState();
}

class _RumbleTabState extends State<RumbleTab>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _controller;
  bool _showATKRumble = true;

  _addLoadingEvent(BuildContext blocContext) {
    blocContext
        .read<RumbleListBloc>()
        .add(RumbleListEventLoading(showATK: _showATKRumble));
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
      _showATKRumble = StorageUtils.readData(StorageUtils.rumbleMode, true);
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
    return BlocProvider<RumbleListBloc>(
      create: (_) => RumbleListBloc()
        ..add(RumbleListEventLoading(showATK: _showATKRumble)),
      child: BlocBuilder<RumbleListBloc, RumbleListState>(
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
                      onQuery: (query, type) => context.read<RumbleListBloc>()
                        ..add(RumbleListEventSearching(query)),
                      onExitSearch: () => _addLoadingEvent(context),
                      mode: SearchMode.rumbleTab,
                    ),
                  ),
                  ActionButton(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                            _showATKRumble
                                ? "res/icons/atk.png"
                                : "res/icons/def.png",
                            scale: 2.5),
                      ),
                      onTap: () async {
                        await UpdateQueries.instance.registerAnalyticsEvent(
                            AnalyticsEvents.rumbleTeamModeFilter);
                        setState(() => _showATKRumble = !_showATKRumble);
                        StorageUtils.saveData(
                            StorageUtils.rumbleMode, _showATKRumble);
                        if (!mounted) return;
                        _addLoadingEvent(context);
                      })
                ],
              ),
              _setWidgetOnState(context, state)
            ],
          );
        },
      ),
    );
  }

  Widget _setWidgetOnState(BuildContext blocContext, RumbleListState state) {
    if (state is RumbleListStateLoading || state is RumbleListStateSearching) {
      return const LoadingWidget();
    } else if (state is RumbleListStateLoaded) {
      if (state.teams.isEmpty) {
        return EmptyList(
            onRefresh: () => _addLoadingEvent(blocContext),
            type: TypeList.team);
      } else {
        return _teamList(blocContext, state);
      }
    } else {
      return EmptyList(
          onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.team);
    }
  }

  Expanded _teamList(BuildContext blocContext, RumbleListStateLoaded state) {
    return Expanded(
        child: NotificationListener<ScrollNotification>(
            onNotification: (notification) => _onScrolling(notification),
            child: RefreshIndicator(
              onRefresh: () async => _addLoadingEvent(blocContext),
              color: Colors.orange.shade400,
              child: ListView.builder(
                key: const PageStorageKey<String>('rumbleTab'),
                itemCount: state.teams.length,
                itemBuilder: ((context, index) {
                  return RumbleElement(
                    team: state.teams[index],
                    index: index,
                    onSelected: () {
                      _controller?.text = "";
                      widget.focus?.unfocus();
                    },
                    onDelete: () async {
                      blocContext.read<RumbleListBloc>().add(
                          RumbleListEventDelete(state.teams[index],
                              showATK: _showATKRumble));
                      Navigator.pop(context);
                    },
                  );
                }),
              ),
            )));
  }
}
