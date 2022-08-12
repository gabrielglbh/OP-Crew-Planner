import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/core/routing/routing.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  if (AdManager.test) {
    await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['[GOOGLE-DEVICE-TESTS-AD]']));
  }
  await StorageUtils.getInstance();
  await EasyLocalization.ensureInitialized();
  runApp(const SetUpApp());
}

class SetUpApp extends StatelessWidget {
  const SetUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale("en"),
        Locale("es"),
        Locale("de"),
        Locale("fr"),
        Locale("pt"),
      ],
      path: "lib/core/localization",
      fallbackLocale: const Locale("en"),
      child: const OPCrewPlanner(),
    );
  }
}

class OPCrewPlanner extends StatefulWidget {
  const OPCrewPlanner({Key? key}) : super(key: key);

  @override
  State<OPCrewPlanner> createState() => _OPCrewPlannerState();

  static void setLocale(BuildContext context, Locale newLocale) async {
    context.setLocale(newLocale);
    _OPCrewPlannerState? state =
        context.findAncestorStateOfType<_OPCrewPlannerState>();
    state?.changeLanguage();
  }
}

class _OPCrewPlannerState extends State<OPCrewPlanner> {
  changeLanguage() => setState(() {});

  @override
  void initState() {
    ThemeManager.instance.addListenerTo(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    CustomDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "OP Crew Planner",
        debugShowCheckedModeBanner: false,
        theme: ThemeManager.instance.currentLightThemeData,
        darkTheme: ThemeManager.instance.currentDarkThemeData,
        themeMode: ThemeManager.instance.themeMode,
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        initialRoute: OPCrewPlannerPages.welcomePageName,
        onGenerateRoute: (settings) => onGenerateRoute(settings));
  }
}
