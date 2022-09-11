import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/main.dart';
import 'package:optcteams/ui/pages/settings/widgets/change_theme.dart';
import 'package:optcteams/ui/pages/settings/widgets/account_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/back_up_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/information_settings.dart';
import 'package:optcteams/ui/pages/settings/widgets/setting_tile.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/ui/widgets/bottom_sheet_choices.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:optcteams/ui/widgets/custom_icon_buttons.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _uid;
  bool _currentlyLoading = false;

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
                    children: [Text("infoOnBackUp".tr())],
                  ),
                ),
              ),
              acceptButton: "Ok",
              dialogContext: dialogContext,
              cancel: false,
              onAccepted: () {
                Navigator.of(context).pop();
              });
        });
  }

  _openBSForVersionNotes() async {
    UpdateQueries.instance
        .registerAnalyticsEvent(AnalyticsEvents.openVersionNotes);
    List<String> n = await UpdateQueries.instance.getVersionNotes(context);
    if (n.isNotEmpty) {
      List<Text> content = List.generate(n.length, (c) => Text("${n[c]}\n"));
      Scrollbar child = Scrollbar(
          child: ListView(
              padding: const EdgeInsets.only(top: 8), children: content));
      if (!mounted) return;
      ChoiceBottomSheet.callModalSheet(context, "versionNotes".tr(), child,
          height: 2);
    }
  }

  _openBSForChangingLanguages() {
    Scrollbar child = Scrollbar(
        child: ListView(
      children: [
        ListTile(
            title: const Text("English"),
            onTap: () {
              UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.changeLanguage);
              OPCrewPlanner.setLocale(context, const Locale('en'));
              StorageUtils.saveData(StorageUtils.language, 'en');
              Navigator.of(context).pop();
            }),
        ListTile(
            title: const Text("Español"),
            onTap: () {
              UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.changeLanguage);
              OPCrewPlanner.setLocale(context, const Locale('es'));
              StorageUtils.saveData(StorageUtils.language, 'es');
              Navigator.of(context).pop();
            }),
        ListTile(
            title: const Text("Français"),
            onTap: () {
              UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.changeLanguage);
              OPCrewPlanner.setLocale(context, const Locale('fr'));
              StorageUtils.saveData(StorageUtils.language, 'fr');
              Navigator.of(context).pop();
            }),
        ListTile(
            title: const Text("Português"),
            onTap: () {
              UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.changeLanguage);
              OPCrewPlanner.setLocale(context, const Locale('pt'));
              StorageUtils.saveData(StorageUtils.language, 'pt');
              Navigator.of(context).pop();
            }),
        ListTile(
            title: const Text("Deutsch"),
            onTap: () {
              UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.changeLanguage);
              OPCrewPlanner.setLocale(context, const Locale('de'));
              StorageUtils.saveData(StorageUtils.language, 'de');
              Navigator.of(context).pop();
            }),
      ],
    ));
    ChoiceBottomSheet.callModalSheet(context, "changeLanguages".tr(), child,
        height: 2.5);
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
                    onTap: () {
                      _disclaimerInfoOnBackup();
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
                          child: _settings())),
                ),
              )),
          FullScreenLoadingWidget(isLoading: _currentlyLoading)
        ],
      ),
    );
  }

  Column _settings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// SUpport
        SettingHeader(title: "support".tr(), subtitle: "donateCheers".tr()),
        SettingTile(
            title: Text("reviewLabel".tr()),
            icon: Image.asset(
                Platform.isIOS
                    ? "res/icons/appStore.png"
                    : "res/icons/googlePlay.png",
                scale: 20),
            onTap: () async {
              await UI.launch(context, Data.storeLink);
              await UpdateQueries.instance
                  .registerAnalyticsEvent(AnalyticsEvents.writeReview);
            }),
        SettingTile(
            title: const Text("OP Crew Planner"),
            icon: Image.asset("res/icons/github.png", scale: 20),
            onTap: () async {
              await UI.launch(
                  context, "https://github.com/gabrielglbh/op-crew-planner");
            }),

        SettingHeader(title: "settings_misc".tr()),
        SettingTile(
            title: Text("newThingsAdded".tr()),
            icon: const Icon(Icons.star, size: 20, color: Colors.green),
            onTap: () => _openBSForVersionNotes()),
        SettingTile(
          title: Text("settings_toggle_theme".tr()),
          icon: const Icon(Icons.lightbulb, color: Colors.blue),
          onTap: () {
            ChoiceBottomSheet.callModalSheet(
                context, "settings_toggle_theme".tr(), const ChangeAppTheme(),
                height: 3.5);
          },
        ),
        SettingTile(
            title: Text("changeLanguages".tr()),
            icon: const Icon(Icons.translate, size: 20),
            onTap: () => _openBSForChangingLanguages()),
        SettingTile(
          title: Text("settings_notifications_label".tr()),
          icon: const Icon(Icons.notifications_active_rounded),
          onTap: () {
            AppSettings.openNotificationSettings();
          },
        ),

        /// BackUp Settings
        BackUpSettings(
          uid: _uid,
          loading: (loading) => setState(() => _currentlyLoading = loading),
        ),

        /// Account Settings
        AccountSettings(uid: _uid),

        /// Information Settings
        const InformationSettings()
      ],
    );
  }
}
