import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class ContributorsTile extends StatelessWidget {
  const ContributorsTile({Key? key}) : super(key: key);

  final String _optcDBLink = "'OPTC DB'";
  final String _optcDBUrl = "https://optc-db.github.io/";
  final String _nakamaLink = "'Nakama Network'\n";
  final String _nakamaUrl = "https://www.nakama.network/";
  final String _graphicsLink = "'Graphics'\n";
  final String _graphicsUrl =
      "https://drive.google.com/drive/u/0/folders/0B2876gCiqJjGQXhfZlRVd2JJUmM";
  final String _freepikLink = "'Freepik'";
  final String _freepikUrl = "https://www.flaticon.com/authors/freepik";
  final String _flaticonLink = "'www.flaticon.com'\n";
  final String _flaticonUrl = "https://www.flaticon.com/";

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          _richText("contributorsInspiration".tr(), _optcDBLink, _optcDBUrl,
              "and".tr(), _nakamaLink, _nakamaUrl),
          _richText("contributorsIcons".tr(), "u/ShokugekiNoZeff", "",
              "contributorsDrive".tr(), _graphicsLink, _graphicsUrl),
          Text("translators".tr() + "@LenweGLoc, u/EnishiY\n",
              style: const TextStyle(fontSize: 14)),
          _richText("contributorsFlaticon".tr(), _freepikLink, _freepikUrl,
              "from".tr(), _flaticonLink, _flaticonUrl),
        ],
      ),
    );
  }

  RichText _richText(String firstText, String firstLink, String firstUrl,
      String secondText, String secondLink, String secondUrl) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: firstText,
              style: TextStyle(
                  color: (!StorageUtils.readData(StorageUtils.darkMode, false)
                      ? Colors.black87
                      : null),
                  fontSize: 14)),
          TextSpan(
            text: firstLink,
            style: TextStyle(
                color: firstUrl != ""
                    ? Colors.orange[400]
                    : (!StorageUtils.readData(StorageUtils.darkMode, false)
                        ? Colors.black87
                        : null),
                decoration: firstUrl != "" ? TextDecoration.underline : null,
                fontSize: 14),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (firstUrl != "") launch(firstUrl);
              },
          ),
          TextSpan(
              text: secondText,
              style: TextStyle(
                  color: (!StorageUtils.readData(StorageUtils.darkMode, false)
                      ? Colors.black87
                      : null),
                  fontSize: 14)),
          TextSpan(
            text: secondLink,
            style: TextStyle(
                color: Colors.orange[400],
                decoration: TextDecoration.underline,
                fontSize: 14),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(secondUrl);
              },
          ),
        ],
      ),
    );
  }
}
