import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/database/queries/ship_queries.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/database/models/ship.dart';
import 'package:optcteams/core/database/models/skills.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/ui/pages/buildPages/bloc/build_bloc.dart';
import 'package:optcteams/ui/widgets/CustomIconButtons.dart';
import 'package:optcteams/ui/widgets/UnitSearchList.dart';
import 'package:optcteams/ui/widgets/LoadingWidget.dart';
import 'package:optcteams/ui/widgets/unitInfo/BottomSheetUnitInfo.dart';
import 'package:optcteams/ui/widgets/CustomSearchBar.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class BuildTeamPage extends StatefulWidget {
  final Team toBeUpdatedTeam;
  final bool update;
  BuildTeamPage({required this.toBeUpdatedTeam, required this.update});

  @override
  _BuildTeamPageState createState() => _BuildTeamPageState();
}

class _BuildTeamPageState extends State<BuildTeamPage> with SingleTickerProviderStateMixin {
  TextEditingController? _searchController;
  FocusNode? _focus;
  TextEditingController? _nameController;
  FocusNode? _nameFocus;
  TextEditingController? _descController;
  FocusNode? _descFocus;

  TabController? _tabController;

  List<Unit> _units = [];
  List<Unit> _supports = [];
  List<Unit> _recent = [];
  List<Ship> _ships = [];
  List<Unit> _emptyUnits = [];
  Unit _emptyUnit = Unit.empty();
  Ship _emptyShip = Ship.empty;
  Ship _ship = Ship.empty;
  Skills _emptySkills = Skills();
  List<double> _skillLevels = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<double> _maxLevelSkills = [];

  bool _showSupports = false;
  bool _showMostUsedUnits = false;

  // Variables to change size of team units display
  double _imgSize = 80;
  double _imgSupportSize = 45;
  double _widthSkillProgress = 0;

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
    _showSupports = false;

    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      setState(() {
        _loseFocusOnFields();
      });
    });

    Future.delayed(Duration(seconds: 0), () {
      _widthSkillProgress = ((MediaQuery.of(context).size.width - 20) / 2);
    });

    _ship = _emptyShip;
    _maxLevelSkills = Skills.mapSkillsMax();
    if (widget.update) {
      _units = List.from(widget.toBeUpdatedTeam.units);
      _supports = List.from(widget.toBeUpdatedTeam.supports);
      _descController?.text = widget.toBeUpdatedTeam.description;
      _nameController?.text = widget.toBeUpdatedTeam.name;
      _ship = widget.toBeUpdatedTeam.ship;
      _skillLevels = widget.toBeUpdatedTeam.skills.toList();
    }
    else {
      _units = [_emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit];
      _supports = [_emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit];
    }
    _emptyUnits = [_emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit, _emptyUnit];

    AdManager.createBanner(onLoaded: _onBannerLoaded, onFailed: _onBannerFailedOrExit);
    _banner = AdManager.showBanner();

    _getMostUsedUnits();
    _getShips();
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
      Skills skills = _buildSkills();
      Team currentTeam = Team(name: (_nameController?.text ?? ""), description: (_descController?.text ?? ""),
          units: _units, supports: _supports, ship: _ship, skills: skills);
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
        Team emptyTeam = Team(name: "", description: "", units: _emptyUnits,
            supports: _emptyUnits, ship: _emptyShip, skills: _emptySkills);
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
      title: Text(widget.update ? "titleUpdateTeamPage".tr() : "titleTeamPage".tr()),
      automaticallyImplyLeading: false,
      leading: BackIcon(onTap: () => _onWillPop(fromLeading: true)),
      actions: <Widget>[
        FaviconIcon(
            onTap: () {
              _nameFocus?.unfocus();
              _descFocus?.unfocus();
              _launchURLToOPTCCalc();
            },
            icon: FontAwesomeIcons.calculator
        ),
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
              _descFocus?.requestFocus();
              _validateAndInsertTeam();
            },
            icon: FontAwesomeIcons.check
        )
      ],
    );
  }

  @override
  WillPopScope build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBar(),
        body: BlocProvider<BuildBloc>(
          create: (_) => BuildBloc()..add(BuildEventIdle()),
          child: BlocBuilder<BuildBloc, BuildState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: <Widget>[
                    Visibility(visible: _bannerIsLoaded, child: _banner),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          /// Banner size (68)
                          height: MediaQuery.of(context).size.height - _appBar().preferredSize.height -
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
                              _setWidgetOnState(context, state),
                            ],
                          )
                        ),
                      ),
                    ),
                  ]),
              );
            }
          ),
        )
      ),
    );
  }

  Widget _setWidgetOnState(BuildContext blocContext, BuildState state) {
    if (state is BuildStateLoading || state is BuildEventSearching)
      return LoadingWidget();
    else if (state is BuildStateLoaded)
      return UnitSearchList(
        units: state.units,
        onTap: (String uid) {
          _searchController?.text = "";
          blocContext.read<BuildBloc>()..add(BuildEventIdle());
          _onSelectedTeammate(uid, _showSupports ? _supports : _units);
        },
      );
    else if (state is BuildStateIdle)
      return _content();
    else
      return Container();
  }

  Expanded _content() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 4, top: 2),
            child: _recentList()
          ),
          Divider(color: StorageUtils.readData(StorageUtils.darkMode, false)
              ? Colors.grey : Colors.black, thickness: 1),
          Padding(
              padding: EdgeInsets.only(bottom: 4, top: 4),
              child: _shipAndTitleUI()
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              _tabElement("crewTab".tr()),
              _tabElement("guideTab".tr()),
              _tabElement("socketsTab".tr()),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TabBarView(
                controller: _tabController,
                children: _pageViewWidgets(),
              ),
            ),
          )
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
      SingleChildScrollView(
        child: Column(
          children: [
            _supportToggle(),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 6,
                right: MediaQuery.of(context).size.width / 6
              ),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: false,
                child: _team(),
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 16),
        child: _descriptionBox(),
      ),
      SingleChildScrollView(child: _skills()),
    ];
  }

  Column _recentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("mostUsedUnits".tr(), style: TextStyle(fontWeight: FontWeight.bold)),
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
          duration: Duration(milliseconds: 300),
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

  Row _shipAndTitleUI() {
    return Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 18),
        child: InkWell(
          onTap: () {
            _loseFocusOnFields();
            _displayShipList();
          },
          child: Container(
            width: 70,
            height: 70,
            child: UI.placeholderImageWhileLoading(_ship.url)
          ),
        )
      ),
      Expanded(
        child: TextField(
          controller: _nameController,
          focusNode: _nameFocus,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          maxLength: 120,
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

  GestureDetector _supportToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showSupports = !_showSupports;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 35,
        curve: Curves.linear,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: StorageUtils.readData(StorageUtils.darkMode, false)
              ? Colors.white : Colors.grey[800]!),
          color: _showSupports ? Colors.green : StorageUtils.readData(StorageUtils.darkMode, false)
            ? Colors.grey[800] : Colors.white,
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Align(
            alignment: Alignment.center,
            child: Text("supportAction".tr(),
                style: TextStyle(color: _showSupports
                    ? Colors.white : StorageUtils.readData(StorageUtils.darkMode, false)
                    ? Colors.white : Colors.black87)),
          ),
        )
      ),
    );
  }

  GridView _team() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.4),
      physics: ScrollPhysics(),
      itemCount: _showSupports ? _supports.length : _units.length,
      itemBuilder: (context, index) {
        return _teamUnit(index);
      }
    );
  }

  TextField _descriptionBox() {
    return TextField(
      controller: _descController,
      focusNode: _descFocus,
      maxLines: 25,
      maxLength: 3000,
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

  Row _skills() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skillUnit("dmgRed".tr(), "res/skills/skill1.png", 0),
              _skillUnit("rcvBoost".tr(), "res/skills/skill2.png", 1),
              _skillUnit("chargeSp".tr(), "res/skills/skill3.png", 2),
              _skillUnit("slotBoost".tr(), "res/skills/skill4.png", 3),
              _skillUnit("bindRes".tr(), "res/skills/skill5.png", 4),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skillUnit("mapRes".tr(), "res/skills/skill6.png", 5),
              _skillUnit("despairRes".tr(), "res/skills/skill7.png", 6),
              _skillUnit("poisonRes".tr(), "res/skills/skill8.png", 7),
              _skillUnit("autoHeal".tr(), "res/skills/skill9.png", 8),
              _skillUnit("resilience".tr(), "res/skills/skill10.png", 9),
            ],
          ),
        )
      ],
    );
  }

  Widget _teamUnit(int index) {
    Unit unit = _showSupports ? _supports[index] : _units[index];
    String img = (unit.url ?? "");
    return DragTarget(
      builder: (context, List<int?> data, b) {
        return Draggable(
          child: GestureDetector(
              onTap: () async {
                if (unit.id != "noimage") {
                  await UnitQueries.instance.updateHistoryUnit(unit);
                  await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.openUnitDataFromUnitOnTeam);
                  await AdditionalUnitInfo.callModalSheet(context, unit.id);
                }
              },
              onLongPress: () { if (unit.id != "noimage") _removeUnitFromTeam(index); },
              child: Stack(
                children: [
                  Positioned(
                    right: index % 2 == 0 ? 4 : null,
                    left: index % 2 == 0 ? null : 4,
                    child: Container(
                      width: _imgSize, height: _imgSize,
                      child: FittedBox(child: UI.placeholderImageWhileLoadingUnit(unit)),
                    ),
                  ),
                  Positioned(
                    bottom: (MediaQuery.of(context).size.width / 4.5) - _imgSize,
                    right: index % 2 == 0 ? null : 0,
                    child: Visibility(
                      visible: !_showSupports && _supports[index].id != "noimage",
                      child: Container(
                        width: _imgSupportSize, height: _imgSupportSize,
                        child: FittedBox(child: UI.placeholderImageWhileLoadingUnit(_supports[index])),
                      ),
                    ),
                  )
                ],
              )
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
        _onSelectedTeammate(unit.id, _showSupports ? _supports : _units, fromRecent: true);
      },
      child: Padding(
        padding: EdgeInsets.all(2),
        child: UI.placeholderImageWhileLoadingUnit(unit, little: true),
      )
    );
  }

  InkWell _shipUnit(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _ship = _ships[index];
        });
        Navigator.of(context).pop();
      },
      child: Row(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            width: 50,
            height: 50,
            child: UI.placeholderImageWhileLoading(_ships[index].url),
          )
        ),
        Expanded(
          child: Text(_ships[index].name),
        )
      ],
      ),
    );
  }

  Widget _skillUnit(String label, String img, int pos) {
    String level = _skillLevels[pos].toInt().toString();
    double ratio = _widthSkillProgress / _maxLevelSkills[pos];

    return Container(
      height: 85,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          width: _widthSkillProgress,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: Colors.grey[600]!, width: 1),
          ),
          child: Stack(children: [
            // Progress bar for each skill
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: (_skillLevels[pos] == 0)
                ? 0
                : ratio * _skillLevels[pos],
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(11.0)),
                color: Colors.green,
              ),
            ),
            Positioned(
              top: 4,
              right: 8,
              child: Text(level, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 10),
                  child: Image.asset(img, scale: 2),
                ),
                Expanded(
                  child: Text(label, overflow: TextOverflow.clip),
                )
              ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: _widthSkillProgress / 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_skillLevels[pos] != 0) _skillLevels[pos]--;
                      });
                    },
                  )
                ),
                Container(
                  width: _widthSkillProgress / 2 - 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (_skillLevels[pos] < _maxLevelSkills[pos]) _skillLevels[pos]++;
                      });
                    },
                  )
                )
              ],
            )
          ],
          )
        ),
      )
    );
  }

  /// HELPER FUNCTIONS

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
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.resetTeam);
              setState(() {
                for (int x = 0; x < _units.length; x++) {
                  _units.removeAt(x);
                  _units.insert(x, _emptyUnit);
                }
                for (int x = 0; x < _supports.length; x++) {
                  _supports.removeAt(x);
                  _supports.insert(x, _emptyUnit);
                }
              });
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
    Skills skills = _buildSkills();
    DateTime parser = DateTime.parse(DateTime.now().toString());
    String minute = parser.minute < 10 ? "0${parser.minute}" : parser.minute.toString();
    String hour = parser.hour < 10 ? "0${parser.hour}" : parser.hour.toString();
    String date = "$hour:$minute - ${parser.day}/${parser.month}/${parser.year}";
    Team newTeam = Team(name: name, description: description, units: _units,
        supports: _supports, ship: _ship, skills: skills,
        maxed: widget.update ? widget.toBeUpdatedTeam.maxed : 1,
        updated: date.toString());

    if (widget.update) {
      // If name is not empty and valid
      if (name.trim().isNotEmpty && name.length >= 4 && name.length <= 120) {
        // If captains are not empty
        if (!_units[0].id.contains("noimage") && !_units[1].id.contains("noimage")) {
          // if has visited page only for consulting, pop
          if (newTeam.compare(widget.toBeUpdatedTeam)) {
            Navigator.of(context).pop();
          } else {
            // Check if team's name has changed only if its updating
            if (widget.toBeUpdatedTeam.name != name) lastName = widget.toBeUpdatedTeam.name;
            TeamQueries.instance.updateTeam(newTeam, lastName).then((isSuccessful) async {
              if (isSuccessful) {
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.updatedTeam);
                Navigator.of(context).pop();
              }
              else {
                UI.showSnackBar(context, "errDupTeam".tr());
              }
            });
          }
        } else {
          UI.showSnackBar(context, "errNoCaptains".tr());
        }
      } else {
        UI.showSnackBar(context, "errNoName".tr());
      }
    } else {
      // Make sure name is valid and more than 4 but less than 20 letters and that the team has the two captains
      if (name.trim().isNotEmpty && name.length >= 4 && name.length <= 120) {
        if (!_units[0].id.contains("noimage") && !_units[1].id.contains("noimage")) {
          TeamQueries.instance.insertTeam(newTeam).then((isSuccessful) async {
            if (isSuccessful) {
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.createdTeam);
              Navigator.of(context).pop();
            }
            else {
              UI.showSnackBar(context, "errDupTeam".tr());
            }
          });
        } else {
          UI.showSnackBar(context, "errNoCaptains".tr());
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
            onAccepted: () async {
              setState(() {
                if (!_showSupports) {
                  _units.removeAt(index);
                  _units.insert(index, _emptyUnit);
                }
                _supports.removeAt(index);
                _supports.insert(index, _emptyUnit);
              });
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.removeUnitFromTeam);
              Navigator.of(dialogContext).pop();
            },
          );
        }
    );
  }

  _displayShipList() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("shipDialogTitle".tr()),
          content: Container(
            width: 100,
            height: 400,
            child: Scrollbar(
              child: ListView.separated(
                  separatorBuilder: (context, index) { return Divider(color: Colors.grey); },
                  itemCount: _ships.length,
                  itemBuilder: (context, index) {
                    return _shipUnit(index);
                  }
              ),
            )
          )
        );
      }
    );
  }

  Skills _buildSkills() {
    return Skills(
      team: (_nameController?.text ?? ""),
      damageReduction: _skillLevels[0].toInt(),
      chargeSpecials: _skillLevels[1].toInt(),
      bindResistance: _skillLevels[2].toInt(),
      despairResistance: _skillLevels[3].toInt(),
      autoHeal: _skillLevels[4].toInt(),
      rcvBoost: _skillLevels[5].toInt(),
      slotsBoost: _skillLevels[6].toInt(),
      mapResistance: _skillLevels[7].toInt(),
      poisonResistance: _skillLevels[8].toInt(),
      resilience: _skillLevels[9].toInt()
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
      if (!_showSupports) {
        Unit aux = _units[data];
        _units[data] = _units[index];
        _units[index] = aux;
      }
      Unit aux = _supports[data];
      _supports[data] = _supports[index];
      _supports[index] = aux;
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

  _launchURLToOPTCCalc() async {
    String baseUrl = "http://optc-db.github.io/damage/#/transfer/D";
    String units = "";
    for (var x = 0; x < 6; x++) {
      if (!_units[x].id.contains("noimage")) {
        units += _units[x].id + ':99';
      } else {
        units += '!';
      }
      if (x < 5) {
        units += ',';
      }
    }
    String ship = 'C' + _ship.id + ',10';
    String postfix = 'B0D0E0Q0L0G0R0S100H';
    String url = baseUrl + units + ship + postfix;
    if (await canLaunch(url)) {
      await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.redirectToOPTCCalc);
      await launch(url);
    } else {
      UI.showSnackBar(context, "errOnLaunch".tr());
    }
  }

  _getMostUsedUnits() {
    UnitQueries.instance.getMostUsedUnits().then((recent) => {
      setState(() { _recent = recent; })
    });
  }

  _getShips() {
    ShipQueries.instance.getShips().then((value) => {
      setState(() { _ships = value; })
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
}
