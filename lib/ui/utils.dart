import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class UI {
  static Color strT = Colors.red;
  static Color qckT = Colors.blue;
  static Color dexT = Colors.green;
  static Color psyT = Colors.orangeAccent;
  static Color intT = Colors.purple;
  static Color blockT = Colors.deepPurple[900]!;
  static Color tndT = Colors.deepOrange[600]!;
  static Color rcvT = Colors.brown;
  static Color semlaT = Colors.brown[300]!;
  static Color wanoT = Colors.red[900]!;
  static Color bombT = Colors.black;
  static Color gT = Colors.orange[900]!;

  static int formatDateToMilliseconds(String? date) {
    if (date != null) {
      var dateTimeFormat = DateFormat("HH:mm - dd/MM/yyyy").parse(date);
      return dateTimeFormat.millisecondsSinceEpoch;
    } else {
      return -1;
    }
  }

  static Future<void> launch(BuildContext context, String uri) async {
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri),
          mode: LaunchMode.externalNonBrowserApplication);
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, "errOnLaunch".tr());
    }
  }

  static bool isDarkTheme(BuildContext context) {
    final theme = StorageUtils.readData(
      StorageUtils.themeMode,
      ThemeMode.light.name,
    );
    if (theme == ThemeMode.light.name) return false;
    if (theme == ThemeMode.dark.name) return true;
    if (theme == ThemeMode.system.name) {
      final brightness = MediaQuery.of(context).platformBrightness;
      if (brightness == Brightness.light) return false;
      if (brightness == Brightness.dark) return true;
    }
    return false;
  }

  static void showDialogOnExit(BuildContext c) {
    BuildContext dialogContext;
    showDialog(
        context: c,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
            title: "exitDialogTitle".tr(),
            content: Text("exitDialogContent".tr()),
            acceptButton: "yes".tr(),
            dialogContext: dialogContext,
            onAccepted: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pop();
            },
          );
        });
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(contentSnackBar(message));
  }

  static SnackBar contentSnackBar(String msg, {int duration = 2}) {
    return SnackBar(
      duration: Duration(seconds: duration),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 32, left: 8, right: 8),
      content: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.info, color: Colors.white),
          ),
          Expanded(child: Text(msg, overflow: TextOverflow.fade))
        ],
      ),
    );
  }

  static Widget placeholderImageWhileLoadingUnit(Unit u,
      {bool little = false}) {
    return Stack(
      children: [
        placeholderImageWhileLoading(u.url),
        unitInfoDownloaded((u.downloaded ?? 0), little: little)
      ],
    );
  }

  static Widget placeholderImageWhileLoading(String? img,
      {bool fullArt = false}) {
    String res = fullArt ? "res/info/artNotFound.png" : "res/units/noimage.png";
    if (img == null) return Image.asset(res);
    return img.startsWith("res")
        ? Image.asset(img)
        : CachedNetworkImage(
            placeholder: (context, s) {
              return fullArt
                  ? Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5,
                        color: Colors.orange[400],
                      ))
                  : Image.asset(res);
            },
            imageUrl: img,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            errorWidget: (context, s, _) => Image.asset(res));
  }

  static Positioned unitInfoDownloaded(int downloaded, {bool little = false}) {
    return Positioned(
      top: 2,
      right: 2,
      child: Visibility(
        visible: downloaded == 1,
        child: Container(
          width: little ? 15 : 25,
          height: little ? 15 : 25,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(50)),
          child: Icon(Icons.download_rounded,
              color: Colors.black87, size: little ? 10 : 20),
        ),
      ),
    );
  }

  static String getThumbnail(String? id, {bool art = false}) {
    const String png = ".png";
    const String slash = "%2F";
    const String fbUrlUnits =
        'https://firebasestorage.googleapis.com/v0/b/optc-teams-96a76.appspot.com/o/units';
    const String fbUrlArt =
        'https://firebasestorage.googleapis.com/v0/b/optc-teams-96a76.appspot.com/o/art';

    final String firstFolder = id?.substring(0, 1) ?? "0";
    final String secondFolder = "${id?.substring(1, 2) ?? "0"}00";

    return art
        ? "$fbUrlArt$slash$firstFolder$slash$secondFolder$slash$id$png?alt=media"
        : "$fbUrlUnits$slash$firstFolder$slash$secondFolder$slash$id$png?alt=media";
  }
}
