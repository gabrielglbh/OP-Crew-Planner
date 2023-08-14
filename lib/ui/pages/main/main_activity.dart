import 'dart:async';
import 'package:flutter/material.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/database/queries/util_queries.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/messaging.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/routing/arguments.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/pages/main/data/data_tab.dart';
import 'package:optcteams/ui/pages/main/rumble/rumble_tab.dart';
import 'package:optcteams/ui/pages/main/teams/teams_tab.dart';
import 'package:optcteams/ui/pages/main/units/units_tab.dart';
import 'package:optcteams/core/types/list_type.dart';
import 'package:optcteams/ui/widgets/unitInfo/bottom_sheet_unit_info.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  FocusNode? _unitFocusNode;
  FocusNode? _dataFocusNode;
  FocusNode? _teamFocusNode;
  FocusNode? _rumbleTeamFocusNode;

  PageController? _pageController;

  final List<Unit> _recentUnits = [];

  TypeList _type = TypeList.data;
  int _recentUnitsLength = 0;

  bool _showLastAddedUnits = true;
  bool _bannerIsLoaded = false;
  String? _user;
  String? _uid;

  //int _numTeams = 0;
  //int _numRumble = 0;
  //int _numUnits = 0;

  Container _banner = Container();

  @override
  void initState() {
    _pageController = PageController();
    _unitFocusNode = FocusNode();
    _dataFocusNode = FocusNode();
    _teamFocusNode = FocusNode();
    _rumbleTeamFocusNode = FocusNode();
    _updateUIBasedOnSession();
    AdManager.createBanner(
        onLoaded: _onBannerLoaded, onFailed: _onBannerFailedOrExit);
    _banner = AdManager.showBanner();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MessagingHandler.handler(context);
      _recentUnitsLength = await _getRecentUnits();
    });
    super.initState();
  }

  @override
  void dispose() {
    AdManager.disposeBanner();
    _unitFocusNode?.dispose();
    _dataFocusNode?.dispose();
    _teamFocusNode?.dispose();
    _rumbleTeamFocusNode?.dispose();
    super.dispose();
  }

  _onBannerLoaded() => setState(() => _bannerIsLoaded = true);

  _onBannerFailedOrExit() => setState(() => _bannerIsLoaded = false);

  Future<void> _updateUIBasedOnSession() async {
    await _getEmail();
    await _getUid();
  }

  _getEmail() {
    String email = AuthQueries.instance.getCurrentUserEmail(context);
    setState(() => _user = email);
  }

  _getUid() {
    String? uid = AuthQueries.instance.getCurrentUserID();
    setState(() => _uid = uid);
  }

  Future<int> _getRecentUnits() async {
    List<String> u = await UpdateQueries.instance.getRecentUnits();
    if (u.isNotEmpty) {
      for (int z = 0; z < u.length; z++) {
        Unit unit = await UnitQueries.instance.getUnit(u[z]);
        setState(() => _recentUnits.add(unit));
      }
      return u.length;
    }
    return StorageUtils.readData(StorageUtils.lastAddedUnitsLength, 0);
  }

  @override
  WillPopScope build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_unitFocusNode?.hasFocus ?? false) {
          _unitFocusNode?.unfocus();
          return false;
        }
        if (_dataFocusNode?.hasFocus ?? false) {
          _dataFocusNode?.unfocus();
          return false;
        }
        if (_teamFocusNode?.hasFocus ?? false) {
          _teamFocusNode?.unfocus();
          return false;
        }
        if (_rumbleTeamFocusNode?.hasFocus ?? false) {
          _rumbleTeamFocusNode?.unfocus();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _appBar(),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Visibility(
              visible: _showLastAddedUnits,
              child: _recentList(),
            ),
            Visibility(
              visible: _bannerIsLoaded,
              child: _banner,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DataTab(focus: _dataFocusNode),
                    UnitsTab(focus: _unitFocusNode),
                    TeamsTab(focus: _teamFocusNode),
                    RumbleTab(focus: _rumbleTeamFocusNode)
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: _bnb(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: _appBarTitle(),
      automaticallyImplyLeading: false,
      leading: _uid == null
          ? null
          : Container(
              padding: const EdgeInsets.only(right: 15),
              margin: const EdgeInsets.only(left: 15),
              child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child:
                            Text((_user?.substring(0, 1).toUpperCase() ?? ""))),
                  ))),
      actions: [
        Visibility(
          visible: _type != TypeList.data,
          child: IconButton(
              onPressed: () async {
                await UtilQueries.instance
                    .checkIfLimitReached(_type)
                    .then((success) {
                  if (success) {
                    if (_type == TypeList.unit) {
                      Navigator.pushNamed(
                          context, OPCrewPlannerPages.buildMaxedUnitPageName,
                          arguments:
                              UnitBuild(unit: Unit.empty(), update: false));
                    } else if (_type == TypeList.team) {
                      Navigator.pushNamed(
                          context, OPCrewPlannerPages.buildTeamPageName,
                          arguments:
                              TeamBuild(team: Team.empty(), update: false));
                    } else if (_type == TypeList.rumble) {
                      Navigator.pushNamed(
                          context, OPCrewPlannerPages.buildRumbleTeamPageName,
                          arguments: RumbleBuild(
                              team: RumbleTeam.empty(), update: false));
                    }
                  } else {
                    UI.showSnackBar(context, _type.label);
                  }
                });
              },
              icon: const Icon(Icons.add)),
        ),
        IconButton(
            onPressed: () async {
              await Navigator.of(context)
                  .pushNamed(OPCrewPlannerPages.settingsPageName)
                  .then((_) async {
                await _getEmail();
                await _getUid();
              });
            },
            icon: const Icon(Icons.settings)),
      ],
    );
  }

  Widget _appBarTitle() {
    if (_type == TypeList.data) {
      return Text("databaseTab".tr());
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_type.label),
          /*Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(_type == TypeList.unit
                  ? "$_numUnits/${Data.maxUnits}"
                  : _type == TypeList.team
                  ? "$_numTeams/${Data.maxTeams}"
                  : _type == TypeList.rumble
                  ? "$_numRumble/${Data.maxRumbleTeams}"
                  : "",
                  style: TextStyle(fontSize: 10)
              )
          ),*/
        ],
      );
    }
  }

  Padding _recentList() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"lastAddedUnits".tr()} (${_recentUnits.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () async {
                  await UpdateQueries.instance
                      .registerAnalyticsEvent(AnalyticsEvents.closeRecentList);
                  setState(() => _showLastAddedUnits = false);
                  StorageUtils.saveData(
                      StorageUtils.lastAddedUnitsLength, _recentUnitsLength);
                },
                child: Text("dismiss".tr(),
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              )
            ],
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentUnits.length,
                itemBuilder: (context, index) {
                  return _recentUnit(index);
                }),
          )
        ],
      ),
    );
  }

  InkWell _recentUnit(int index) {
    return InkWell(
        onTap: () async {
          await UpdateQueries.instance.registerAnalyticsEvent(
              AnalyticsEvents.openUnitDataFromRecentList);
          await UnitQueries.instance.updateHistoryUnit(_recentUnits[index]);
          // ignore: use_build_context_synchronously
          await AdditionalUnitInfo.callModalSheet(
              context, _recentUnits[index].id,
              onClose: () {});
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: UI.placeholderImageWhileLoading(_recentUnits[index].url),
        ));
  }

  Container _bnb() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)],
      ),
      child: BottomNavigationBar(
        currentIndex: _type.index,
        selectedFontSize: 12,
        items: [
          _navigationBarItem(TypeList.data),
          _navigationBarItem(TypeList.unit),
          _navigationBarItem(TypeList.team),
          _navigationBarItem(TypeList.rumble)
        ],
        onTap: (index) async {
          if (index != _type.index) {
            setState(() => _type = TypeList.values[index]);
            _pageController?.jumpToPage(_type.index);
            //_getNumberOfTeamsAndUnits();
          }
        },
      ),
    );
  }

  BottomNavigationBarItem _navigationBarItem(TypeList mode) {
    return BottomNavigationBarItem(
        label: mode.label, icon: Image.asset(mode.asset, scale: mode.scale));
  }
}
