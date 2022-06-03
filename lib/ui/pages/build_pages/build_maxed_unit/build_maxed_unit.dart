import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/pages/build_pages/bloc/build_bloc.dart';
import 'package:optcteams/core/types/unit_attributes.dart';
import 'package:optcteams/ui/pages/build_pages/build_maxed_unit/widgets/attribute_unit.dart';
import 'package:optcteams/ui/pages/build_pages/build_maxed_unit/widgets/info_button.dart';
import 'package:optcteams/ui/pages/build_pages/build_maxed_unit/widgets/ready_button.dart';
import 'package:optcteams/ui/widgets/custom_icon_buttons.dart';
import 'package:optcteams/ui/widgets/unit_search_list.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:optcteams/ui/widgets/unitInfo/bottom_sheet_unit_info.dart';
import 'package:optcteams/ui/widgets/custom_search_bar.dart';

class BuildMaxedUnitPage extends StatefulWidget {
  final Unit toBeUpdatedUnit;
  final bool update;
  const BuildMaxedUnitPage({
    Key? key,
    required this.toBeUpdatedUnit,
    required this.update,
  }) : super(key: key);

  @override
  _BuildMaxedUnitPageState createState() => _BuildMaxedUnitPageState();
}

class _BuildMaxedUnitPageState extends State<BuildMaxedUnitPage> {
  TextEditingController? _searchController;
  FocusNode? _focus;

  Unit _updateUnit = Unit.empty();
  List<bool> _checks = List.generate(Attribute.values.length, (_) => false);
  String _img = "";
  String _id = "";
  bool _available = false;

  Container _banner = Container();
  bool _bannerIsLoaded = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _focus = FocusNode();
    if (widget.update) {
      setState(() {
        _updateUnit = widget.toBeUpdatedUnit;
        _available = _updateUnit.available == 0 ? false : true;
        _checks = [
          _updateUnit.maxLevel == 0 ? false : true,
          _updateUnit.skills == 0 ? false : true,
          _updateUnit.specialLevel == 0 ? false : true,
          _updateUnit.cottonCandy == 0 ? false : true,
          _updateUnit.supportLevel == 0 ? false : true,
          _updateUnit.potentialAbility == 0 ? false : true,
          _updateUnit.evolution == 0 ? false : true,
          _updateUnit.limitBreak == 0 ? false : true,
          _updateUnit.rumbleSpecial == 0 ? false : true,
          _updateUnit.rumbleAbility == 0 ? false : true,
          _updateUnit.maxLevelLimitBreak == 0 ? false : true
        ];
      });
    }
    setState(() {
      _img = (_updateUnit.url ?? "");
      _id = _updateUnit.id;
    });
    AdManager.createBanner(
        onLoaded: _onBannerLoaded, onFailed: _onBannerFailedOrExit);
    _banner = AdManager.showBanner();
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    _focus?.dispose();
    AdManager.disposeBanner();
    super.dispose();
  }

  _onBannerLoaded() => setState(() => _bannerIsLoaded = true);
  _onBannerFailedOrExit() => setState(() => _bannerIsLoaded = false);

  _validateAndInsertOnDB() {
    _updateUnit.setAttributes(
        _checks[0] ? 1 : 0,
        _checks[1] ? 1 : 0,
        _checks[2] ? 1 : 0,
        _checks[3] ? 1 : 0,
        _checks[4] ? 1 : 0,
        _checks[5] ? 1 : 0,
        _checks[6] ? 1 : 0,
        _checks[7] ? 1 : 0,
        _available ? 1 : 0,
        _checks[8] ? 1 : 0,
        _checks[9] ? 1 : 0,
        _checks[10] ? 1 : 0);
    UnitQueries.instance.updateUnit(_updateUnit).then((isSuccessful) async {
      if (isSuccessful) {
        if (widget.update) {
          await UpdateQueries.instance
              .registerAnalyticsEvent(AnalyticsEvents.updatedUnitToBeMaxed);
        } else {
          await UpdateQueries.instance
              .registerAnalyticsEvent(AnalyticsEvents.createdUnitToBeMaxed);
        }
        Navigator.of(context).pop();
      }
    });
  }

  _onSelectedUnit(String id) async {
    _updateUnit = await UnitQueries.instance.getUnit(id);
    _focus?.unfocus();
    setState(() {
      _img = (_updateUnit.url ?? "");
      _id = _updateUnit.id;
    });
  }

  Future<bool> _onWillPop({bool fromLeading = false}) async {
    bool? _isFocused = _focus?.hasFocus;
    if (_isFocused != null && _isFocused) {
      _focus?.unfocus();
      return false;
    } else {
      Unit newUnit = Unit(
          id: _updateUnit.id,
          name: _updateUnit.name,
          type: _updateUnit.type,
          taps: _updateUnit.taps,
          maxLevel: _checks[0] ? 1 : 0,
          skills: _checks[1] ? 1 : 0,
          specialLevel: _checks[2] ? 1 : 0,
          cottonCandy: _checks[3] ? 1 : 0,
          supportLevel: _checks[4] ? 1 : 0,
          potentialAbility: _checks[5] ? 1 : 0,
          evolution: _checks[6] ? 1 : 0,
          limitBreak: _checks[7] ? 1 : 0,
          available: _available ? 1 : 0,
          rumbleSpecial: _checks[8] ? 1 : 0,
          rumbleAbility: _checks[9] ? 1 : 0,
          maxLevelLimitBreak: _checks[10] ? 1 : 0);
      // If everything is the exact same, nothing changed OR the entire team is empty, just pop: else show alert
      if (widget.update) {
        bool a = widget.toBeUpdatedUnit.compare(newUnit, false);
        if (a) {
          if (fromLeading) Navigator.pop(context);
          return true;
        } else {
          UI.showDialogOnExit(context);
          return true;
        }
      } else {
        if (!_checks[0] &&
            !_checks[1] &&
            !_checks[2] &&
            !_checks[3] &&
            !_checks[4] &&
            !_checks[5] &&
            !_checks[6] &&
            !_checks[7] &&
            !_available &&
            !_checks[8] &&
            !_checks[9] &&
            !_checks[10] &&
            _img.contains("noimage")) {
          if (fromLeading) Navigator.pop(context);
          return true;
        } else {
          UI.showDialogOnExit(context);
          return true;
        }
      }
    }
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
          widget.update ? "titleUpdateUnitPage".tr() : "titleUnitPage".tr()),
      automaticallyImplyLeading: false,
      leading: BackIcon(onTap: () => _onWillPop(fromLeading: true)),
      actions: <Widget>[
        FaviconIcon(
            onTap: () {
              _validateAndInsertOnDB();
            },
            icon: FontAwesomeIcons.check)
      ],
    );
  }

  @override
  WillPopScope build(BuildContext context) {
    if (widget.update) {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _appBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Flex(direction: Axis.vertical, children: [
                Visibility(visible: _bannerIsLoaded, child: _banner),
                _content()
              ]),
            )),
      );
    } else {
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _appBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: BlocProvider<BuildBloc>(
                      create: (_) => BuildBloc()..add(BuildEventIdle()),
                      child: BlocBuilder<BuildBloc, BuildState>(
                          builder: (context, state) {
                        return Column(
                          children: [
                            Visibility(
                                visible: _bannerIsLoaded, child: _banner),
                            CustomSearchBar(
                              controller: _searchController,
                              hint: "searchHintUnits".tr(),
                              focus: _focus,
                              mode: SearchMode.regularUnitSearch,
                              onExitSearch: () => context.read<BuildBloc>()
                                ..add(BuildEventIdle()),
                              onQuery: (query, type) => context
                                  .read<BuildBloc>()
                                ..add(BuildEventSearching(true, query, type)),
                            ),
                            _setWidgetOnState(context, state)
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            )),
      );
    }
  }

  Widget _setWidgetOnState(BuildContext blocContext, BuildState state) {
    if (state is BuildStateLoading || state is BuildEventSearching) {
      return const LoadingWidget();
    } else if (state is BuildStateLoaded) {
      return UnitSearchList(
        units: state.units,
        onTap: (String uid) {
          _searchController?.text = "";
          _focus?.unfocus();
          blocContext.read<BuildBloc>().add(BuildEventIdle());
          _onSelectedUnit(uid);
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
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.update,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
                child: Text(widget.toBeUpdatedUnit.name,
                    textAlign: TextAlign.center),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (_updateUnit.id != "noimage") {
                  await UpdateQueries.instance.registerAnalyticsEvent(
                      AnalyticsEvents.openUnitDataFromUnit);
                  await AdditionalUnitInfo.callModalSheet(context, _id);
                }
              },
              child: SizedBox(
                width: 80,
                height: 80,
                child: UI.placeholderImageWhileLoadingUnit(_updateUnit),
              ),
            ),
            Row(
              mainAxisAlignment: _updateUnit.id != "noimage"
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                ReadyButton(
                  onTap: () => setState(() => _available = !_available),
                  color: _available
                      ? Colors.orange[400]
                      : (StorageUtils.readData(StorageUtils.darkMode, false)
                          ? Colors.grey[800]
                          : Colors.white),
                ),
                Visibility(
                  visible: _updateUnit.id != "noimage",
                  child: InfoButton(onTap: () async {
                    await UpdateQueries.instance.registerAnalyticsEvent(
                        AnalyticsEvents.openUnitDataFromUnitInfoButton);
                    await AdditionalUnitInfo.callModalSheet(context, _id);
                  }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text("subtitleUnitPage".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18)),
            ),
            Expanded(child: attributes())
          ],
        ),
      ),
    );
  }

  Container attributes() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: GridView.builder(
            addAutomaticKeepAlives: false,
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8),
            itemCount: Attribute.values.length,
            itemBuilder: (context, index) {
              return AttributeUnit(
                attribute: Attribute.values[index],
                isMaxedVisible: !_checks[index],
                onTap: () {
                  if (_updateUnit.id != "noimage") {
                    setState(() => _checks[index] = !_checks[index]);
                  } else {
                    UI.showSnackBar(context, "errOnChangeAttr".tr());
                  }
                },
                color: _checks[index]
                    ? Colors.orange[400]
                    : (StorageUtils.readData(StorageUtils.darkMode, false)
                        ? Colors.grey[800]
                        : Colors.white),
              );
            }));
  }
}
