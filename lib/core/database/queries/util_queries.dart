import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/queries/rumble_team_queries.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/ui/pages/main/enum_lists.dart';
import 'package:sqflite/sqflite.dart';

class UtilQueries {
  Database? _database;

  /// Singleton instance of [UtilQueries]
  static UtilQueries instance = UtilQueries();

  UtilQueries() {
    _database = CustomDatabase.instance.database;
  }

  Future<bool> checkIfLimitReached(TypeList mode) async {
    if (_database != null) {
      if (mode == TypeList.team) {
        int length = await TeamQueries.instance.getNumberOfTeams();
        // Validate teams.length <= maxTeams
        if (length < Data.maxTeams) return true;
        else return false;
      } else if (mode == TypeList.rumble) {
        int length = await RumbleTeamQueries.instance.getNumberOfRumbleTeams();
        // Validate units.length <= maxUnits
        if (length < Data.maxRumbleTeams) return true;
        else return false;
      } else {
        int length = await UnitQueries.instance.getNumberOfToBeMaxedUnits();
        // Validate units.length <= maxUnits
        if (length < Data.maxUnits) return true;
        else return false;
      }
    } else {
      return false;
    }
  }
}