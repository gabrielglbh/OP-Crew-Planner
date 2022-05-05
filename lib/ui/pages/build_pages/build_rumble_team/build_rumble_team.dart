import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/queries/rumble_team_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/pages/build_pages/bloc/build_bloc.dart';
import 'package:optcteams/ui/widgets/custom_icon_buttons.dart';
import 'package:optcteams/ui/widgets/unit_search_list.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:optcteams/ui/widgets/unitInfo/bottom_sheet_unit_info.dart';
import 'package:optcteams/ui/widgets/custom_search_bar.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';

class BuildRumbleTeamPage extends StatefulWidget {
  final RumbleTeam toBeUpdatedTeam;
  final bool update;
  const BuildRumbleTeamPage({Key? key, required this.toBeUpdatedTeam, required this.update}) : super(key: key);

  @override
  _BuildRumbleTeamPageState createState() => _BuildRumbleTeamPageState();
}

class _BuildRumbleTeamPageState extends State<BuildRumbleTeamPage> with SingleTickerProviderStateMixin {
  TextEditingController? _searchController;
  FocusNode? _focus;
  TextEditingController? _nameController;
  FocusNode? _nameFocus;
  TextEditingController? _descController;
  FocusNode? _descFocus;

  TabController? _tabController;

  List<Unit> _units = [];
  List<Unit> _recent = [];
  List<Unit> _emptyUnits = [];
  final Unit _emptyUnit = Unit.empty();

  bool _mode = true;
  bool _showMostUsedUnits = false;

  // Variables to change size of team units display
  final double _imgSize = 80;

  Container _banner = Container();
  bool _bannerIsLoaded = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _focus = FocusNode();
    _nameController = TextEditingController();
    _nameFocus = FocusNode();
    _descController = TextEditingController();
    _descFocus = FocusNode();

    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(() {
      setState(() => _loseFocusOnFields());
    });

    if (widget.update) {
      _units = List.from(widget.toBeUpdatedTeam.units);
      _descController?.text = widget.toBeUpdatedTeam.description;
      _nameController?.text = widget.toBeUpdatedTeam.name;
      _mode = widget.toBeUpdatedTeam.mode == 0 ? true : false;
    }
    else {
      _units = [_emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit];
    }
    _emptyUnits = [_emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit];

    AdManager.createBanner(onLoaded: _onBannerLoaded, onFailed: _onBannerFailedOrExit);
    _banner = AdManager.showBanner();

    _getMostUsedUnits();
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    _focus?.dispose();
    _nameFocus?.dispose();
    _descFocus?.dispose();
    _nameController?.dispose();
    _descController?.dispose();
    _tabController?.dispose();
    AdManager.disposeBanner();
    super.dispose();
  }

  _onBannerLoaded() => setState(() => _bannerIsLoaded = true);
  _onBannerFailedOrExit() => setState(() => _bannerIsLoaded = false);

  Future<bool> _onWillPop({bool fromLeading = false}) async {
    bool? _isFocused = ((_focus?.hasFocus ?? false) ||
        (_nameFocus?.hasFocus ?? false) || (_descFocus?.hasFocus ?? false));
    if (_isFocused) {
      _focus?.unfocus();
      _nameFocus?.unfocus();
      _descFocus?.unfocus();
      return false;
    } else {
      RumbleTeam currentTeam = RumbleTeam(name: (_nameController?.text ?? ""), description: (_descController?.text ?? ""),
        units: _units, mode: _mode ? 0 : 1);
      // If everything is the exact same, nothing changed OR the entire team is empty, just pop: else show alert
      if (widget.update) {
        bool a = widget.toBeUpdatedTeam.compare(currentTeam);
        if (a) {
          if (fromLeading) Navigator.pop(context);
          return true;
        }
        else {
          UI.showDialogOnExit(context);
          return true;
        }
      } else {
        RumbleTeam emptyTeam = RumbleTeam(name: "", description: "", units: _emptyUnits, mode: 0);
        bool a = (currentTeam.compare(emptyTeam));
        if (a) {
          if (fromLeading) Navigator.pop(context);
          return true;
        }
        else {
          UI.showDialogOnExit(context);
          return true;
        }
      }
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(widget.update ? "titleUpdateRumblePage".tr() : "titleRumblePage".tr()),
      automaticallyImplyLeading: false,
      leading: BackIcon(onTap: () => _onWillPop(fromLeading: true)),
      actions: <Widget>[
        FaviconIcon(
          onTap: () {
            _nameFocus?.unfocus();
            _descFocus?.requestFocus();
            _trash();
          },
          icon: FontAwesomeIcons.trashCan
        ),
        FaviconIcon(
          onTap: () {
            _nameFocus?.unfocus();
            _descFocus?.unfocus();
            _validateAndInsertTeam();
          },
          icon: FontAwesomeIcons.check
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar(),
        body: BlocProvider<BuildBloc>(
          create: (_) => BuildBloc()..add(BuildEventIdle()),
          child: BlocBuilder<BuildBloc, BuildState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Visibility(visible: _bannerIsLoaded, child: _banner),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          /// Banner size (68)
                          height:  MediaQuery.of(context).size.height - _appBar().preferredSize.height -
                              (_bannerIsLoaded ? (32 + 68) : 32),
                          child: Column(
                            children: [
                              CustomSearchBar(
                                controller: _searchController,
                                hint: "searchHintUnits".tr(),
                                focus: _focus,
                                mode: SearchMode.regularUnitSearch,
                                onExitSearch: ()
                                => context.read<BuildBloc>()..add(BuildEventIdle()),
                                onQuery: (query, type)
                                => context.read<BuildBloc>()..add(BuildEventSearching(false, query, type)),
                              ),
                              _setWidgetOnState(context, state)
                            ],
                          ),
                        ),
                      ),
                    )
                  ]
                ),
              );
            }
          ),
        )
      ),
    );
  }

  Widget _setWidgetOnState(BuildContext blocContext, BuildState state) {
    if (state is BuildStateLoading || state is BuildEventSearching) {
      return const LoadingWidget();
    } else if (state is BuildStateLoaded) {
      return UnitSearchList(
        units: state.units,
        onTap: (String uid) {
          _searchController?.text = "";
          blocContext.read<BuildBloc>().add(BuildEventIdle());
          _onSelectedTeammate(uid, _units);
        },
      );
    } else if (state is BuildStateIdle) {
      return _content();
    } else {
      return Container();
    }
  }

  Expanded _content() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 2),
            child: _recentList()
          ),
          Divider(color: StorageUtils.readData(StorageUtils.darkMode, false)
            ? Colors.grey : Colors.black, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 4),
            child: _modeAndTitleUI()
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              _tabElement("crewTab".tr()),
              _tabElement("guideTab".tr()),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TabBarView(
                controller: _tabController,
                children: _pageViewWidgets(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _tabElement(String tab) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(tab, style: TextStyle(
        color: StorageUtils.readData(StorageUtils.darkMode, false) ? Colors.white : Colors.black87)
      ),
    );
  }

  List<Widget> _pageViewWidgets() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(
          top: 32,
          left: MediaQuery.of(context).size.width / 12,
          right: MediaQuery.of(context).size.width / 12
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: false,
          child: _team(),
        ),
      ),
      _descriptionBox(),
    ];
  }

  Column _recentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("mostUsedUnits".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {
                setState(() => _showMostUsedUnits = !_showMostUsedUnits);
              },
              child: Icon(_showMostUsedUnits
                  ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded)
            )
          ],
        ),
        AnimatedContainer(
          height: _showMostUsedUnits ? 60 : 0,
          duration: const Duration(milliseconds: 300),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recent.length,
            itemBuilder: (context, index) {
              return _recentUnit(index);
            }
          ),
        )
      ],
    );
  }

  Row _modeAndTitleUI() {
    return Row(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 18),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          onTap: () {
            _loseFocusOnFields();
            setState(() {
              _mode = !_mode;
            });
          },
          child: SizedBox(
            width: 70,
            height: 70,
            child: Image.asset(
              _mode ? "res/icons/atk.png" : "res/icons/def.png",
              scale: 2,
            )
          ),
        )
      ),
      Expanded(
        child: TextField(
          controller: _nameController,
          focusNode: _nameFocus,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          maxLength: 30,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "teamName".tr(),
            counterText: "",
          ),
          onEditingComplete: () {
            _nameFocus?.unfocus();
            _descFocus?.requestFocus();
          },
        ),
      )
    ],
    );
  }

  GridView _team() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      physics: const ScrollPhysics(),
      itemCount: _units.length,
      itemBuilder: (context, index) {
        return _teamUnit(index);
      }
    );
  }

  TextField _descriptionBox() {
    return TextField(
      controller: _descController,
      focusNode: _descFocus,
      maxLines: 13,
      maxLength: 200,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: "actionsInfo".tr(),
      ),
      onEditingComplete: () {
        _descFocus?.unfocus();
      },
    );
  }

  Widget _teamUnit(int index) {
    Unit unit = _units[index];
    String img = (unit.url ?? "");
    return DragTarget(
      builder: (context, List<int?> data, b) {
        return Draggable(
          child: GestureDetector(
            onTap: () async {
              if (unit.id != "noimage") {
                await UnitQueries.instance.updateHistoryUnit(unit);
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.openUnitDataFromUnitOnRumbleTeam);
                await AdditionalUnitInfo.callModalSheet(context, unit.id);
              }
            },
            onLongPress: () async {
              if (unit.id != "noimage") {
                _removeUnitFromTeam(index);
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.removeUnitFromRumbleTeam);
              }
            },
            child: Container(
              width: _imgSize, height: _imgSize,
              padding: index > 4 ? null : const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: index > 4 ? Border.all(color: Colors.blue[700]!, width: 3) : null,
              ),
              child: FittedBox(child: UI.placeholderImageWhileLoadingUnit(unit)),
            ),
          ),
          feedback: FittedBox(child: UI.placeholderImageWhileLoading(img)),
          childWhenDragging: Container(),
          data: index,
        );
      },
      onAccept: (int? data) { _onAcceptedDrag(index, data); },
      onWillAccept: (data) {
        setState(() {
          _focus?.unfocus();
          _nameFocus?.unfocus();
        });
        return true;
      },
    );
  }

  InkWell _recentUnit(int index) {
    Unit unit = _recent[index];
    return InkWell(
      onTap: () {
        _loseFocusOnFields();
        _onSelectedTeammate(unit.id, _units, fromRecent: true);
      },
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: UI.placeholderImageWhileLoadingUnit(unit, little: true)
      )
    );
  }

  /// HELP FUNCTIONS

  _trash() {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
            title: "onEmptyTeam".tr(),
            acceptButton: "deleteLabel".tr(),
            dialogContext: dialogContext,
            onAccepted: () async {
              setState(() {
                for (int x = 0; x < _units.length; x++) {
                  _units.removeAt(x);
                  _units.insert(x, _emptyUnit);
                }
              });
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.resetRumbleTeam);
              Navigator.of(dialogContext).pop();
            },
          );
        }
    );
  }

  _validateAndInsertTeam() {
    String lastName = "";
    String name = (_nameController?.text ?? "");
    String description = (_descController?.text ?? "");
    DateTime parser = DateTime.parse(DateTime.now().toString());
    String minute = parser.minute < 10 ? "0${parser.minute}" : parser.minute.toString();
    String hour = parser.hour < 10 ? "0${parser.hour}" : parser.hour.toString();
    String date = "$hour:$minute - ${parser.day}/${parser.month}/${parser.year}";
    RumbleTeam newTeam = RumbleTeam(name: name, description: description, units: _units,
      mode: _mode ? 0 : 1, updated: date.toString());

    if (widget.update) {
      // If name is not empty and valid
      if (name.trim().isNotEmpty && name.length >= 4 && name.length <= 30) {
        // if has visited page only for consulting, pop
        if (newTeam.compare(widget.toBeUpdatedTeam)) {
          Navigator.of(context).pop();
        } else {
          // Make sure the updated team has one unit at least
          if (_compareUnitsWithEmpty()) {
            UI.showSnackBar(context, "errEmptyPvP".tr());
          } else {
            // Check if team's name has changed only if its updating
            if (widget.toBeUpdatedTeam.name != name) lastName = widget.toBeUpdatedTeam.name;
            RumbleTeamQueries.instance.updateRumbleTeam(newTeam, lastName).then((isSuccessful) async {
              if (isSuccessful) {
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.updatedRumbleTeam);
                Navigator.of(context).pop();
              }
              else {
                UI.showSnackBar(context, "errDupTeam".tr());
              }
            });
          }
        }
      } else {
        UI.showSnackBar(context, "errNoName".tr());
      }
    } else {
      // Make sure name is valid and more than 4 but less than 20 letters
      if (name.trim().isNotEmpty && name.length >= 4 && name.length <= 30) {
        // Make sure the team has at least one unit
        if (_compareUnitsWithEmpty()) {
          UI.showSnackBar(context, "errEmptyPvP".tr());
        } else {
          RumbleTeamQueries.instance.insertRumbleTeam(newTeam).then((isSuccessful) async {
            if (isSuccessful) {
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.createdRumbleTeam);
              Navigator.of(context).pop();
            }
            else {
              UI.showSnackBar(context, "errDupTeam".tr());
            }
          });
        }
      } else {
        UI.showSnackBar(context, "errNoName".tr());
      }
    }
  }

  _removeUnitFromTeam(int index) {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
            title: "onDeleteUnit".tr(),
            acceptButton: "deleteLabel".tr(),
            dialogContext: dialogContext,
            onAccepted: () {
              setState(() {
                _units.removeAt(index);
                _units.insert(index, _emptyUnit);
              });
              Navigator.of(dialogContext).pop();
            },
          );
        }
    );
  }

  _onAcceptedDrag(int index, int? data) {
    // Remove focus on search when tapped or dragged
    setState(() {
      _focus?.unfocus();
      _nameFocus?.unfocus();
    });
    // Tapped on unit
    if (data != null && data != index) {
      Unit aux = _units[data];
      _units[data] = _units[index];
      _units[index] = aux;
    }
  }

  _onSelectedTeammate(String id, List<Unit> units, {bool fromRecent = false}) async {
    int emptyIndex = -1;
    for (int x = 0; x < units.length; x++) {
      if (units[x].id == "noimage") {
        emptyIndex = x;
        break;
      }
    }

    if (emptyIndex != -1) {
      if (!fromRecent) _showKeyboard();
      Unit newUnit = await UnitQueries.instance.getUnit(id);
      setState(() {
        units.removeAt(emptyIndex);
        units.insert(emptyIndex, newUnit);
      });

      // Update taps
      int updatedTaps = newUnit.taps + 1;
      newUnit.setTaps(updatedTaps);
      UnitQueries.instance.updateUnit(newUnit);

      _getMostUsedUnits();
    }
    else {
      UI.showSnackBar(context, "errOnExtraUnit".tr());
    }
  }

  _getMostUsedUnits() {
    UnitQueries.instance.getMostUsedUnits().then((recent) => {
      setState(() { _recent = recent; })
    });
  }

  _showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  _loseFocusOnFields() {
    _focus?.unfocus();
    _nameFocus?.unfocus();
    _descFocus?.unfocus();
  }

  bool _compareUnitsWithEmpty() {
    int units = _units.length;
    for (int x = 0; x < _units.length; x++) {
      if (_units[x].id != "noimage") units--;
    }
    return units == _units.length;
  }
}