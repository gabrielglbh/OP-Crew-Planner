import 'package:flutter/cupertino.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/pages/buildPages/buildMaxedUnit/buildMaxedUnit.dart';
import 'package:optcteams/ui/pages/buildPages/buildRumbleTeam/buildRumbleTeam.dart';
import 'package:optcteams/ui/pages/buildPages/buildTeam/buildTeam.dart';
import 'package:optcteams/ui/pages/loadingScreen/loadingScreen.dart';
import 'package:optcteams/ui/pages/main/main_activity.dart';
import 'package:optcteams/ui/pages/settings/settings.dart';
import 'package:optcteams/ui/pages/userManagement/user_management.dart';

import 'arguments.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OPCrewPlannerPages.welcomePageName:
      return CupertinoPageRoute(builder: (context) {
        return LoadingScreenPage();
      });
    case OPCrewPlannerPages.navigationPageName:
      return CupertinoPageRoute(builder: (context) {
        return NavigationPage();
      });
    case OPCrewPlannerPages.buildTeamPageName:
      final TeamBuild args = settings.arguments as TeamBuild;
      return CupertinoPageRoute(builder: (context) {
        return BuildTeamPage(
            toBeUpdatedTeam: args.team, update: args.update);
      });
    case OPCrewPlannerPages.buildMaxedUnitPageName:
      final UnitBuild args = settings.arguments as UnitBuild;
      return CupertinoPageRoute(builder: (context) {
        return BuildMaxedUnitPage(
            toBeUpdatedUnit: args.unit, update: args.update);
      });
    case OPCrewPlannerPages.buildRumbleTeamPageName:
      final RumbleBuild args = settings.arguments as RumbleBuild;
      return CupertinoPageRoute(builder: (context) {
        return BuildRumbleTeamPage(
            toBeUpdatedTeam: args.team, update: args.update);
      });
    case OPCrewPlannerPages.settingsPageName:
      return CupertinoPageRoute(builder: (context) {
        return SettingsPage();
      });
    case OPCrewPlannerPages.userManagementPage:
      final ArgumentsManageAccount args = settings.arguments as ArgumentsManageAccount;
      return CupertinoPageRoute(builder: (context) {
        return UserManagementPage(mode: args.mode, deleteAccount: args.delete);
      });
  }
  return null;
}