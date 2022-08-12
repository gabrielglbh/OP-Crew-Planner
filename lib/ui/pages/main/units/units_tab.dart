import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/pages/main/units/bloc/unit_bloc.dart';
import 'package:optcteams/core/types/list_type.dart';
import 'package:optcteams/core/types/unit_filters.dart';
import 'package:optcteams/ui/widgets/action_button.dart';
import 'package:optcteams/ui/widgets/empty_list.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:optcteams/ui/widgets/max_unit_element.dart';
import 'package:optcteams/ui/widgets/custom_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/widgets/unitInfo/bottom_sheet_unit_info.dart';

class UnitsTab extends StatefulWidget {
  final FocusNode? focus;
  const UnitsTab({Key? key, required this.focus}) : super(key: key);

  @override
  State<UnitsTab> createState() => _UnitsTabState();
}

class _UnitsTabState extends State<UnitsTab>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _controller;

  bool _showOnlyAvailable = true;

  /// This variable keeps track of the actual filter applied. The value is
  /// saved into the shared preferences when a filter is applied.
  /// This value is then restored upon new session.
  UnitFilter _currentAppliedFilter = UnitFilter.all;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _controller = TextEditingController();
    final int index = StorageUtils.readData(
        StorageUtils.unitListFilter, UnitFilter.all.index);
    _currentAppliedFilter = UnitFilter.values[index];
    setState(() {
      _showOnlyAvailable =
          StorageUtils.readData(StorageUtils.availableFilter, false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  _addLoadingEvent(BuildContext blocContext) {
    blocContext.read<UnitListBloc>().add(UnitListEventLoading(
        filter: _currentAppliedFilter, showOnlyAvailable: _showOnlyAvailable));
  }

  Future<void> _onFilterSelected(BuildContext blocContext, int index) async {
    await UpdateQueries.instance
        .registerAnalyticsEvent(AnalyticsEvents.changedFiltersOnUnits);
    setState(() {
      _currentAppliedFilter = UnitFilter.values[index];
    });

    /// Adds the loading event to the bloc builder to load the new lists
    if (!mounted) return;
    _addLoadingEvent(blocContext);
    StorageUtils.saveData(
        StorageUtils.unitListFilter, _currentAppliedFilter.index);
  }

  bool _onScrolling(ScrollNotification sn) {
    if (sn is ScrollStartNotification || sn is ScrollUpdateNotification) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<UnitListBloc>(
      create: (_) => UnitListBloc()
        ..add(UnitListEventLoading(
            filter: _currentAppliedFilter,
            showOnlyAvailable: _showOnlyAvailable)),
      child: BlocBuilder<UnitListBloc, UnitListState>(
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
                      onQuery: (query, type) => context.read<UnitListBloc>()
                        ..add(UnitListEventSearching(query)),
                      onExitSearch: () => _addLoadingEvent(context),
                      mode: SearchMode.unitTab,
                    ),
                  ),
                  ActionButton(
                    child: Text("RDY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _showOnlyAvailable ? Colors.red[700] : null)),
                    onTap: () async {
                      await UpdateQueries.instance.registerAnalyticsEvent(
                          AnalyticsEvents.unitReadyFilter);
                      setState(() => _showOnlyAvailable = !_showOnlyAvailable);
                      StorageUtils.saveData(
                          StorageUtils.availableFilter, _showOnlyAvailable);
                      if (!mounted) return;
                      _addLoadingEvent(context);
                    },
                  )
                ],
              ),
              _filterChips(context),
              _showWidgetOnState(context, state)
            ],
          );
        },
      ),
    );
  }

  Widget _showWidgetOnState(BuildContext blocContext, UnitListState state) {
    if (state is UnitListStateLoading || state is UnitListStateSearching) {
      return const LoadingWidget();
    } else if (state is UnitListStateLoaded) {
      if (state.units.isEmpty) {
        return EmptyList(
            onRefresh: () => _addLoadingEvent(blocContext),
            type: TypeList.unit);
      } else {
        return _unitList(blocContext, state);
      }
    } else {
      return EmptyList(
          onRefresh: () => _addLoadingEvent(blocContext), type: TypeList.unit);
    }
  }

  Container _filterChips(BuildContext blocContext) {
    return Container(
        height: 58,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8),
        child: ListView.builder(
            itemCount: UnitFilter.values.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: Text(UnitFilter.values[index].label),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  avatar: index == UnitFilter.all.index
                      ? const Icon(Icons.filter_list, color: Colors.white)
                      : Image.asset(UnitFilter.values[index].asset),
                  onSelected: (bool selected) async =>
                      await _onFilterSelected(blocContext, index),
                  selected: _currentAppliedFilter.index == index,
                ),
              );
            }));
  }

  Expanded _unitList(BuildContext blocContext, UnitListStateLoaded state) {
    return Expanded(
        child: NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScrolling(notification),
      child: RefreshIndicator(
        onRefresh: () async => _addLoadingEvent(blocContext),
        color: Colors.orange.shade400,
        child: ListView.builder(
          key: const PageStorageKey<String>('unitTab'),
          itemCount: state.units.length,
          itemBuilder: ((context, index) {
            Unit unit = state.units[index];
            return MaxedUnitElement(
              unit: unit,
              toBeMaxed: [
                unit.maxLevel == 1,
                unit.skills == 1,
                unit.specialLevel == 1,
                unit.cottonCandy == 1,
                unit.supportLevel == 1,
                unit.potentialAbility == 1,
                unit.evolution == 1,
                unit.limitBreak == 1,
                unit.rumbleSpecial == 1,
                unit.rumbleAbility == 1,
                unit.maxLevelLimitBreak == 1
              ],
              onTappedImage: () async {
                _controller?.text = "";
                widget.focus?.unfocus();
                await UpdateQueries.instance.registerAnalyticsEvent(
                    AnalyticsEvents.openUnitDataFromUnitList);
                await UnitQueries.instance.updateHistoryUnit(unit);
                if (!mounted) return;
                await AdditionalUnitInfo.callModalSheet(context, unit.id,
                    onClose: () {
                  _addLoadingEvent(blocContext);
                });
              },
              onSelected: () => widget.focus?.unfocus(),
              onDelete: () {
                blocContext.read<UnitListBloc>().add(UnitListEventDelete(unit,
                    filter: _currentAppliedFilter,
                    showOnlyAvailable: _showOnlyAvailable));
                Navigator.pop(context);
              },
            );
          }),
        ),
      ),
    ));
  }
}
