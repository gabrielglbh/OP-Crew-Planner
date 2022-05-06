import 'package:flutter/material.dart';
import 'package:optcteams/core/database/queries/unit_info_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/backup_queries.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/models/unit_info.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:optcteams/ui/widgets/unitInfo/elevated_button.dart';
import 'package:optcteams/ui/widgets/unitInfo/unit_info_holders.dart';
import 'package:optcteams/ui/widgets/unitInfo/unit_info_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class AdditionalUnitInfo extends StatefulWidget {
  final String uid;
  const AdditionalUnitInfo({Key? key, required this.uid}) : super(key: key);

  @override
  _AdditionalUnitInfoState createState() => _AdditionalUnitInfoState();

  static Future<void> callModalSheet(BuildContext context, String uid, {Function? onClose}) async {
    await showModalBottomSheet(context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) {
        return AdditionalUnitInfo(uid: uid);
      }
    ).then((_) {
      if(onClose != null) onClose();
    });
  }
}

class _AdditionalUnitInfoState extends State<AdditionalUnitInfo> {

  UnitInfo _information = UnitInfo.empty();
  String _name = "";
  String _img = "res/units/noimage.png";

  bool _loading = false;
  bool _offline = false;
  bool _bannerIsLoaded = false;
  bool _isInterstitialReady = false;
  bool _isTappedOnOptcDb = true;

  final double ratioOfHeight = 1.18;
  final String _escapedCharDual2 = "/d2/";
  final String _parsedCharDual2 = "\n\n• Character 2: ";
  final String _escapedCharDualC = "/d/";
  final String _parsedCharDualC = "\n\n• Combined: ";
  final String _escapedCharVS = "/n";
  final String _parsedCharVS = "\n\n• ";
  final String _escapedCharSwap = "SUPER";
  final String _parsedCharSwap = "\n\n• SUPER";

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      AdManager.createBanner(onLoaded: _onBannerLoaded, onFailed: _onBannerFailedOrExit);
      AdManager.createInterstitial(
        onLoaded: _onInterstitialLoaded,
        onFailed: _onInterstitialFailedOrExit,
        onClosed: _onInterstitialClosed
      );
      _getAdditionalInfoOnUnit();
      _getUnit();
    });
    super.initState();
  }

  @override
  void dispose() {
    AdManager.disposeBanner();
    AdManager.disposeInterstitial();
    super.dispose();
  }

  _onBannerLoaded() => setState(() => _bannerIsLoaded = true);
  _onBannerFailedOrExit() => setState(() => _bannerIsLoaded = false);
  _onInterstitialLoaded() => setState(() => _isInterstitialReady = true);
  _onInterstitialFailedOrExit() => setState(() => _isInterstitialReady = false);
  _onInterstitialClosed() {
    _isInterstitialReady = false;
    UnitInfoUtils.instance.onTappedOnExternalLink(_isTappedOnOptcDb, uid: _isTappedOnOptcDb ? widget.uid : null);
  }

  // Will first look up on the local DB if there is a record of the info,
  // If not, will retrieve it from Firebase
  Future<void> _getAdditionalInfoOnUnit() async {
    setState(() => _loading = true);
    await UnitInfoQueries.instance.getUnitInfoFromDatabase(widget.uid).then((info) async {
      if (info.isEqualTo(UnitInfo.empty())) {
        await BackUpRecords.instance.getUnitAdditionalInfo(widget.uid).then((info) async {
          if (info != null) {
            setState(() {
              _loading = false;
              if (info.swap != null) _formatDualUnit(info);
              if (info.vsCondition != null && info.vsSpecial != null) _formatVSUnit(info);
              _formatSwapSuper(info);
              _information = info;
            });
          }
        }).timeout(const Duration(seconds: 10)).then((value) => setState(() => _loading = false));
      } else {
        setState(() {
          _loading = false;
          _offline = true;
          _information = info;
        });
      }
    });
  }

  Future<void> _getUnit() async {
    await UnitQueries.instance.getUnit(widget.uid).then((unit) {
      if (unit != Unit.empty()) {
        setState(() {
          _name = unit.name;
          _img = (unit.url ?? _img);
        });
      }
    });
  }

  _formatDualUnit(UnitInfo info) {
    if (info.captain != null) {
      info.captain = info.captain?.replaceFirst(_escapedCharDual2, _parsedCharDual2);
      info.captain = info.captain?.replaceFirst(_escapedCharDualC, _parsedCharDualC);
    }
    if (info.llbCaptain != null) {
      info.llbCaptain = info.llbCaptain?.replaceFirst(_escapedCharDual2, _parsedCharDual2);
      info.llbCaptain = info.llbCaptain?.replaceFirst(_escapedCharDualC, _parsedCharDualC);
    }
  }

  _formatVSUnit(UnitInfo info) {
    if (info.captain != null) info.captain = info.captain?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.llbCaptain != null) info.llbCaptain = info.llbCaptain?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.special != null) info.special = info.special?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.llbSpecial != null) info.llbSpecial = info.llbSpecial?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.festAbility != null) info.festAbility = info.festAbility?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.festSpecial != null) info.festSpecial = info.festSpecial?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.festResistance != null) info.festResistance = info.festResistance?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.llbFestAbility != null) info.llbFestAbility = info.llbFestAbility?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.llbFestSpecial != null) info.llbFestSpecial = info.llbFestSpecial?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.llbFestResistance != null) info.llbFestResistance = info.llbFestResistance?.replaceAll(_escapedCharVS, _parsedCharVS);
    if (info.vsSpecial != null) info.vsSpecial = info.vsSpecial?.replaceAll(_escapedCharVS, _parsedCharVS);
  }

  _formatSwapSuper(UnitInfo info) {
    if (info.swap != null) info.swap = info.swap?.replaceAll(_escapedCharSwap, _parsedCharSwap);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () => {},
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topRight: Radius.circular(18), topLeft: Radius.circular(18))),
      builder: (context) {
        if (_loading) {
          return _body(data: Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / ratioOfHeight,
              child: Center(
                child: CircularProgressIndicator(value: null, strokeWidth: 5, color: Colors.orange[400]!),
              ),
            )
          ));
        } else {
          if(!_information.isEqualTo(UnitInfo.empty())) {
            return _body(data: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Scrollbar(
                  child: ListView(
                    children: [
                      CaptainAbility(info: _information),
                      SpecialAbility(info: _information),
                      SuperTypeAbility(info: _information),
                      VersusAbility(info: _information),
                      SwapAbility(info: _information),
                      SupportAbility(info: _information),
                      SailorAbility(info: _information),
                      PotentialAbility(info: _information),
                      LastTapAbility(info: _information),
                      RumbleSpecial(info: _information),
                      RumbleAbility(info: _information),
                      RumbleResistance(info: _information)
                    ],
                  ),
                )
              ),
            ));
          } else {
            return _body(data: Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / ratioOfHeight,
                child: Center(
                  child: Text("dataNotAvailable".tr())
                ),
              )
            ));
          }
        }
      }
    );
  }

  Widget _body({required Widget data}) {
    return Container(
      height: MediaQuery.of(context).size.height / ratioOfHeight,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 90, height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[300]),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: 90, height: 90,
                child: UI.placeholderImageWhileLoading(_img),
              )
            )
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("[${widget.uid}] $_name", textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _optcDBLink()),
                Container(width: 10),
                Expanded(child: _pirateRumbleLink()),
                Container(width: 10),
                Expanded(child: _downloadData()),
                Container(width: 10),
                Expanded(child: _viewFullArt())
              ],
            )
          ),
          data,
          Visibility(
            visible: _bannerIsLoaded,
            child: AdManager.showBanner()
          )
        ],
      ),
    );
  }

  UnitInfoElevatedButton _optcDBLink() {
    return UnitInfoElevatedButton(
      onPressed: () async {
        _isTappedOnOptcDb = true;
        if (_isInterstitialReady) {
          AdManager.showInterstitial(
            onLoaded: _onInterstitialLoaded,
            onFailed: _onInterstitialFailedOrExit,
            onClosed: _onInterstitialClosed
          );
        } else {
          UnitInfoUtils.instance.onTappedOnExternalLink(true, uid: widget.uid);
        }
      },
      color: StorageUtils.readData(StorageUtils.darkMode, false)
          ? Colors.grey[800] : Colors.grey[300],
      child: Image.asset("res/info/optcdb.png"),
    );
  }

  UnitInfoElevatedButton _pirateRumbleLink() {
    return UnitInfoElevatedButton(
      onPressed: () async {
        _isTappedOnOptcDb = false;
        if (_isInterstitialReady) {
          AdManager.showInterstitial(
          onLoaded: _onInterstitialLoaded,
          onFailed: _onInterstitialFailedOrExit,
          onClosed: _onInterstitialClosed
        );
        } else {
          UnitInfoUtils.instance.onTappedOnExternalLink(false);
        }
      },
      color: StorageUtils.readData(StorageUtils.darkMode, false)
          ? Colors.grey[800] : Colors.grey[300],
      child: Image.asset("res/info/pvpdb.png", scale: 9)
    );
  }

  UnitInfoElevatedButton _downloadData() {
    return UnitInfoElevatedButton(
      onPressed: () async {
        if (!_information.isEqualTo(UnitInfo.empty())) {
          if (!_offline) {
            Unit unit = await UnitQueries.instance.getUnit(widget.uid);
            _information.unitId = widget.uid;
            unit.downloaded = 1;
            await UnitInfoQueries.instance.insertUnitInfoIntoDatabase(_information, unit).then((success) async {
              if (success) {
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.downloadUnitData);
                setState(() => _offline = true);
              }
            });
          }
        }
      },
      color: _offline ? Colors.green : StorageUtils.readData(StorageUtils.darkMode, false)
          ? Colors.grey[800] : Colors.grey[300],
      child: Icon(_offline ? Icons.check : Icons.download_rounded, color: _offline ? Colors.white : null)
    );
  }

  Widget _viewFullArt() {
    return UnitInfoElevatedButton(
      onPressed: () async {
        if (!_information.isEqualTo(UnitInfo.empty())) {
          final art = UI.getThumbnail(_information.art ?? "0", art: true);
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.showFullArt);
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return UIAlert(
                title: _name,
                textSize: 14,
                cancel: false,
                dialogContext: context,
                acceptButton: "cancelLabel".tr(),
                onAccepted: () => Navigator.of(context).pop(),
                content: FittedBox(
                  child: SizedBox(
                    width: 640, height: 512,
                    child: UI.placeholderImageWhileLoading(art, fullArt: true)
                  ),
                )
              );
            }
          );
        }
      },
      color: StorageUtils.readData(StorageUtils.darkMode, false)
          ? Colors.grey[800] : Colors.grey[300],
      child: const Icon(Icons.image_rounded)
    );
  }
}
