import 'package:flutter/cupertino.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/pages/build_pages/build_maxed_unit/build_maxed_unit.dart';
import 'package:optcteams/ui/pages/build_pages/build_rumble_team/build_rumble_team.dart';
import 'package:optcteams/ui/pages/build_pages/build_team/build_team.dart';
import 'package:optcteams/ui/pages/loading_screen/loading_screen.dart';
import 'package:optcteams/ui/pages/main/main_activity.dart';
import 'package:optcteams/ui/pages/settings/settings.dart';
import 'package:optcteams/ui/pages/user_management/user_management.dart';

import 'arguments.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case OPCrewPlannerPages.welcomePageName:
      return CupertinoPageRoute(builder: (context) {
        return const LoadingScreenPage();
      });
    case OPCrewPlannerPages.navigationPageName:
      return CupertinoPageRoute(builder: (context) {
        return const NavigationPage();
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
        return const SettingsPage();
      });
    case OPCrewPlannerPages.userManagementPage:
      final ArgumentsManageAccount args = settings.arguments as ArgumentsManageAccount;
      return CupertinoPageRoute(builder: (context) {
        return UserManagementPage(mode: args.mode, deleteAccount: args.delete);
      });
  }
  return null;
}