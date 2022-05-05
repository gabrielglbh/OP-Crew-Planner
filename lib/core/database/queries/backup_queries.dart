import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/rumble_team_queries.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';

class BackUpQueries {
  BackUpQueries._();

  static final BackUpQueries _instance = BackUpQueries._();

  /// Singleton instance of [BackUpQueries]
  static BackUpQueries get instance => _instance;

  Future<bool> insertDataFromBackup(List<Unit> units, List<Team> teams,
      List<RumbleTeam> rumbleTeams, List<Unit> history, List<Unit> backupUnits,
      List<Team> backupTeams, List<RumbleTeam> backupRumbleTeams,
      List<Unit> backupHistory) async {
    try {
      // Remove current units in the to-be-maxed list
      for (int y = 0; y < units.length; y++) {
        units[y].setAttributes(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        await UnitQueries.instance.updateUnit(units[y]);
      }
      // Update units from the backup list
      for (int y = 0; y < backupUnits.length; y++) {
        // If the backed unit has the downloaded flag active
        // Contrast it with the same unit on local db
        Unit u = await UnitQueries.instance.getUnit(backupUnits[y].id);
        // If unit on local db has downloaded flag non-active, change flag on backed unit
        if (u.downloaded == 0) {
          backupUnits[y].downloaded = 0;
        } else {
          backupUnits[y].downloaded = 1;
        }
        // Check url
        if (backupUnits[y].url == null) backupUnits[y].url = u.url;
        // Due to Bandai removing all images from server
        backupUnits[y].url = u.getUrlOfUnitImage();
        await UnitQueries.instance.updateUnit(backupUnits[y]);
      }

      // Insert history units from the backup on current history if any
      for (int y = 0; y < backupHistory.length; y++) {
        // If the backed unit has the downloaded flag active
        Unit u = await UnitQueries.instance.getUnit(backupHistory[y].id);
        // If unit on local db has downloaded flag non-active, change flag on backed unit
        if (u.downloaded == 0) {
          backupHistory[y].downloaded = 0;
        } else {
          backupHistory[y].downloaded = 1;
        }
        // Check url
        if (backupHistory[y].url == null) backupHistory[y].url = u.url;
        // Due to Bandai removing all images from server
        backupHistory[y].url = u.getUrlOfUnitImage();
        await UnitQueries.instance.updateUnit(backupHistory[y]);
      }

      // Remove current teams in the teams list
      for (int y = 0; y < teams.length; y++) {
        await TeamQueries.instance.deleteTeam(teams[y].name);
      }
      // Insert teams from the backup
      for (int y = 0; y < backupTeams.length; y++) {
        // Check on each unit of the team if they have the downloaded flag active
        for (int x = 0; x < backupTeams[y].units.length; x++) {
          // If the backed unit has the downloaded flag active
          // Contrast it with the same unit on local db
          Unit u = await UnitQueries.instance.getUnit(backupTeams[y].units[x].id);
          // If unit on local db has downloaded flag non-active, change flag on backed unit
          if (u.downloaded == 0) {
            backupTeams[y].units[x].downloaded = 0;
          } else {
            backupTeams[y].units[x].downloaded = 1;
          }
          // Check url
          if (backupTeams[y].units[x].url == null) backupTeams[y].units[x].url = u.url;
          // Due to Bandai removing all images from server
          backupTeams[y].units[x].url = u.getUrlOfUnitImage();
        }
        // idem - supports
        for (int x = 0; x < backupTeams[y].supports.length; x++) {
          Unit u = await UnitQueries.instance.getUnit(backupTeams[y].supports[x].id);
          if (u.downloaded == 0) {
            backupTeams[y].supports[x].downloaded = 0;
          } else {
            backupTeams[y].supports[x].downloaded = 1;
          }
          if (backupTeams[y].supports[x].url == null) backupTeams[y].supports[x].url = u.url;
          // Due to Bandai removing all images from server
          backupTeams[y].supports[x].url = u.getUrlOfUnitImage();
        }
        await TeamQueries.instance.insertTeam(backupTeams[y]);
      }

      // Remove current rumble teams in the rumble teams list
      for (int y = 0; y < rumbleTeams.length; y++) {
        await RumbleTeamQueries.instance.deleteRumbleTeam(rumbleTeams[y].name);
      }
      // Insert rumble teams from the backup
      for (int y = 0; y < backupRumbleTeams.length; y++) {
        // Check on each unit of the team if they have the downloaded flag active
        for (int x = 0; x < backupRumbleTeams[y].units.length; x++) {
          // If the backed unit has the downloaded flag active
          // Contrast it with the same unit on local db
          Unit u = await UnitQueries.instance.getUnit(backupRumbleTeams[y].units[x].id);
          // If unit on local db has downloaded flag non-active, change flag on backed unit
          if (u.downloaded == 0) {
            backupRumbleTeams[y].units[x].downloaded = 0;
          } else {
            backupRumbleTeams[y].units[x].downloaded = 1;
          }
          // Check url
          if (backupRumbleTeams[y].units[x].url == null) backupRumbleTeams[y].units[x].url = u.url;
          // Due to Bandai removing all images from server
          backupRumbleTeams[y].units[x].url = u.getUrlOfUnitImage();
        }
        await RumbleTeamQueries.instance.insertRumbleTeam(backupRumbleTeams[y]);
      }
      return true;
    } catch(err) {
      print("insertDataFromBackup: ${err.toString()}");
      return false;
    }
  }
}