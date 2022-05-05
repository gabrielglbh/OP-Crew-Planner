import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/ui/pages/settings/utils/enum_information.dart';
import 'package:optcteams/ui/pages/settings/widgets/contributors.dart';
import 'package:optcteams/ui/pages/settings/widgets/copyright.dart';
import 'package:optcteams/ui/pages/settings/widgets/developer.dart';
import 'package:optcteams/ui/pages/settings/widgets/setting_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/widgets/bottom_sheet_choices.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationSettings extends StatefulWidget {
  const InformationSettings({Key? key}) : super(key: key);

  @override
  _InformationSettingsState createState() => _InformationSettingsState();
}

class _InformationSettingsState extends State<InformationSettings> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    _getPackageInfo();
    super.initState();
  }

  Future<void> _getPackageInfo() async => _packageInfo = await PackageInfo.fromPlatform();

  _disclaimerInformationDialog(InformationLabel mode) {
    switch (mode) {
      case InformationLabel.copyright:
        ChoiceBottomSheet.callModalSheet(context, mode.label, const CopyrightTile(), height: 3);
        break;
      case InformationLabel.developers:
        ChoiceBottomSheet.callModalSheet(context, mode.label, const DeveloperTile(), height: 3);
        break;
      case InformationLabel.contributors:
        ChoiceBottomSheet.callModalSheet(context, mode.label, const ContributorsTile(), height: 3);
        break;
      case InformationLabel.licenses:
        BuildContext dialogContext;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            dialogContext = context;
            return UIAlert(
              title: (_packageInfo?.appName ?? "--"),
              content: Text((_packageInfo?.version ?? "--")),
              acceptButton: "showLicensesButton".tr(),
              dialogContext: dialogContext,
              cancel: false,
              onAccepted: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) {
                    return LicensePage(
                      applicationName: "",
                      applicationVersion: _packageInfo?.version,
                      applicationIcon: SizedBox(width: 150, height: 150, child: Image.asset("res/icons/license_icon.png")),
                    );
                  }),
                );
              }
            );
          }
        );
        break;
      case InformationLabel.privacy:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingHeader(title: "infoTab".tr()),
        SettingTile(title: Text(InformationLabel.copyright.label),
            icon: InformationLabel.copyright.icon,
            onTap: () => _disclaimerInformationDialog(InformationLabel.copyright)),
        SettingTile(title: Text(InformationLabel.developers.label),
            icon: InformationLabel.developers.icon, onTap: () async {
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.developerDialog);
              _disclaimerInformationDialog(InformationLabel.developers);
            }),
        SettingTile(title: Text(InformationLabel.contributors.label),
            icon: InformationLabel.contributors.icon, onTap: () async {
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.ackDialog);
              _disclaimerInformationDialog(InformationLabel.contributors);
            }),
        SettingTile(title: Text(InformationLabel.licenses.label),
            icon: InformationLabel.licenses.icon,
            onTap: () => _disclaimerInformationDialog(InformationLabel.licenses)),
        SettingTile(title: Text(InformationLabel.privacy.label),
            icon: InformationLabel.privacy.icon, onTap: () async {
              if (await canLaunch("https://optc-teams-96a76.web.app")) {
                await launch("https://optc-teams-96a76.web.app");
              }
        }),
      ],
    );
  }
}
