import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/theme_manager.dart';
import 'package:optcteams/ui/pages/settings/widgets/AccountSettings.dart';
import 'package:optcteams/ui/pages/settings/widgets/BackUpSettings.dart';
import 'package:optcteams/ui/pages/settings/widgets/InformationSettings.dart';
import 'package:optcteams/ui/pages/settings/widgets/SettingTile.dart';
import 'package:optcteams/ui/widgets/BottomSheetChoices.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:optcteams/ui/widgets/CustomIconButtons.dart';
import 'package:optcteams/ui/widgets/LoadingWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _uid;
  bool _currentlyLoading = false;
  ThemeMode _mode = ThemeMode.light;

  @override
  void initState() {
    _mode = ThemeManager.instance.themeMode;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getUid();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    AdManager.disposeInterstitial();
    super.dispose();
  }

  _onThemeChanged() async {
    _mode = ThemeManager.instance.themeMode;
    ThemeManager.instance.switchMode(_mode == ThemeMode.light);
  }

  _getUid() {
    String? uid = AuthQueries.instance.getCurrentUserID();
    setState(() {
      _uid = uid;
    });
  }

  _disclaimerInfoOnBackup() {
    BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        dialogContext = context;
        return UIAlert(
          title: "backUpTab".tr(),
          content: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("infoOnBackUp".tr())
                ],
              ),
            ),
          ),
          acceptButton: "Ok",
          dialogContext: dialogContext,
          cancel: false,
          onAccepted: () {
            Navigator.of(context).pop();
          }
        );
      }
    );
  }

  _openBSForVersionNotes() async {
    UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.openVersionNotes);
    List<String> n = await UpdateQueries.instance.getVersionNotes(context);
    if (n.isNotEmpty) {
      List<Text> content = List.generate(n.length, (c) => Text(n[c] + "\n"));
      Scrollbar child = Scrollbar(child: ListView(
          padding: EdgeInsets.only(top: 8),
          children: content
      ));
      ChoiceBottomSheet.callModalSheet(context, "versionNotes".tr(), child, height: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentlyLoading) return false;
        else return true;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("titleSettings".tr()),
              automaticallyImplyLeading: false,
              leading: BackIcon(onTap: () => Navigator.of(context).pop()),
              actions: [
                RegularIcon(
                  icon: Icons.info,
                  onTap: () { _disclaimerInfoOnBackup(); },
                ),
                FaviconIcon(
                  icon: StorageUtils.readData(StorageUtils.darkMode, false)
                      ? Icons.wb_sunny : FontAwesomeIcons.moon,
                  onTap: () async {
                    await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.changedTheme);
                    _onThemeChanged();
                  },
                ),
              ],
            ),
            body: Container(
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 56),
                    child: _settings()
                  )
                ),
              ),
            )
          ),
          FullScreenLoadingWidget(isLoading: _currentlyLoading)
        ],
      ),
    );
  }

  Column _settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingHeader(title: "versionNotes".tr()),
        SettingTile(
            title: Text("newThingsAdded".tr()),
            icon: Icon(Icons.star, size: 20, color: Colors.green),
            onTap: () => _openBSForVersionNotes()),
        /// BackUp Settings
        BackUpSettings(
          uid: _uid,
          loading: (loading) => setState(() => _currentlyLoading = loading),
        ),
        /// Donate
        SettingHeader(title: "support".tr(), subtitle: "donateCheers".tr()),
        SettingTile(
            title: Text("reviewLabel".tr()),
            icon: Image.asset(Platform.isIOS ? "res/icons/appStore.png" : "res/icons/googlePlay.png", scale: 20),
            onTap: () async {
              if (await canLaunch(Data.storeLink)) {
                await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.writeReview);
                await launch(Data.storeLink);
              }
            }),
        /// Account Settings
        AccountSettings(uid: _uid),
        /// Information Settings
        InformationSettings()
      ],
    );
  }
}