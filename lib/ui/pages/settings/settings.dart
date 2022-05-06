import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/theme/theme_manager.dart';
import 'package:optcteams/ui/pages/settings/widgets/account_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/back_up_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/information_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/setting_tile.dart';
import 'package:optcteams/ui/widgets/bottom_sheet_choices.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:optcteams/ui/widgets/custom_icon_buttons.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.only(top: 8),
          children: content
      ));
      ChoiceBottomSheet.callModalSheet(context, "versionNotes".tr(), child, height: 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentlyLoading) {
          return false;
        } else {
          return true;
        }
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
            body: SizedBox(
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 56),
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
            icon: const Icon(Icons.star, size: 20, color: Colors.green),
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
        SettingTile(
            title: const Text("OP Crew Planner"),
            icon: Image.asset("res/icons/github.png", scale: 20),
            onTap: () async {
              const url = "https://github.com/gabrielglbh/op-crew-planner";
              if (await canLaunch(url)) {
                await launch(url);
              }
            }),
        /// Account Settings
        AccountSettings(uid: _uid),
        /// Information Settings
        const InformationSettings()
      ],
    );
  }
}