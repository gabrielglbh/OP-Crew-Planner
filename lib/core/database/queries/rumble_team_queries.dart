import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/models/rumbleTeamUnit.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:sqflite/sqflite.dart';

class RumbleTeamQueries {
  Database? _database;

  /// Singleton instance of [RumbleTeamQueries]
  static RumbleTeamQueries instance = RumbleTeamQueries();

  RumbleTeamQueries() {
    _database = CustomDatabase.instance.database;
  }

  Future<List<RumbleTeam>> getAllRumbleTeams() async {
    if (_database != null) {
      // Get all teams
      List<Map<String, dynamic>>? res = await _database?.query(Data.rumbleTeamTable);

      if (res != null) {
        List<RumbleTeam> teams = generateRumbleTeamList(res);

        for (int x = 0; x < teams.length; x++) {
          // For each team, retrieve the units id
          List<String> unitsOfTeam = await UnitQueries.instance.getUnitsOfRumbleTeam(teams[x].name);

          // With the units id, retrieve the info of every unit of a team
          List<Unit> units = [];
          for (int y = 0; y < unitsOfTeam.length; y++) {
            units.add(await UnitQueries.instance.getUnit(unitsOfTeam[y]));
          }

          teams[x].units = units;
        }

        // Rearrange teams based on date
        teams.sort((a, b) {
          return UI.formatDateToMilliseconds(a.updated)
              .compareTo(UI.formatDateToMilliseconds(b.updated));
        });

        return teams.reversed.toList();
      } else {
        return [];
      }
    }
    else {
      await CustomDatabase.instance.open(onUpdate: (_) {});
      return getAllRumbleTeams();
    }
  }

  Future<List<RumbleTeam>> getRumbleTeams(bool mode, String? query) async {
    if (_database != null) {
      // Get all teams
      List<Map<String, dynamic>>? res;

      if (mode) {
        if (query != null) {
          // Case 1: Query is for all teams with specific name to be searched
          res = await _database?.query(Data.rumbleTeamTable, where: "${Data.rumbleTeamName} LIKE ?", whereArgs: ["%$query%"]);
        } else {
          // Case 2: Query is for only the ATK teams
          res = await _database?.query(Data.rumbleTeamTable, where: "${Data.rumbleTeamMode}=?", whereArgs: [0]);
        }
      }
      // Case 3: Query is for all DEF teams
      else res = await _database?.query(Data.rumbleTeamTable, where: "${Data.rumbleTeamMode}=?", whereArgs: [1]);

      if (res != null) {
        List<RumbleTeam> teams = generateRumbleTeamList(res);

        for (int x = 0; x < teams.length; x++) {
          // For each team, retrieve the units id
          List<String> unitsOfTeam = await UnitQueries.instance.getUnitsOfRumbleTeam(teams[x].name);

          // With the units id, retrieve the info of every unit of a team
          List<Unit> units = [];
          for (int y = 0; y < unitsOfTeam.length; y++) {
            units.add(await UnitQueries.instance.getUnit(unitsOfTeam[y]));
          }

          teams[x].units = units;
        }

        // Rearrange teams based on date
        teams.sort((a, b) {
          return UI.formatDateToMilliseconds(a.updated)
              .compareTo(UI.formatDateToMilliseconds(b.updated));
        });

        return teams.reversed.toList();
      } else {
        return [];
      }
    }
    else {
      await CustomDatabase.instance.open(onUpdate: (_) {});
      return getRumbleTeams(mode, query);
    }
  }

  Future<List<String>> getRumbleTeamNames() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(
          Data.rumbleTeamTable,
          columns: [Data.rumbleTeamName]
      );
      if (res != null)
        return List.generate(res.length, (i) => res[i][Data.rumbleTeamName]);
      else
        return [];
    }
    return [];
  }

  Future<bool> insertRumbleTeam(RumbleTeam team) async {
    if (_database != null) {
      await _database?.insert(Data.rumbleTeamTable, team.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      // Insert units
      for (int x = 0; x < team.units.length; x++) {
        try {
          await _database?.insert(Data.relRumbleUnitTable, RumbleTeamUnit(
              teamId: team.name,
              unitId: team.units[x].id
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        } catch (e) {
          await _database?.insert(Data.relRumbleUnitTable, RumbleTeamUnit(
              teamId: team.name,
              unitId: "noimage"
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        }
      }
    }
    return true;
  }

  Future<void> deleteRumbleTeam(String name) async {
    if (_database != null) {
      await _database?.delete(Data.rumbleTeamTable, where: "${Data.rumbleTeamName}=?", whereArgs: [name]);
    }
    return null;
  }

  Future<bool> updateRumbleTeam(RumbleTeam team, String? lastName) async {
    if (_database != null) {
      // Delete & Update because PK might be updated
      if (lastName != null) {
        // If enter here, user has changed the team name
        List<String> teamNames = await getRumbleTeamNames();
        if (teamNames.contains(team.name)) return false;
        else await deleteRumbleTeam(lastName);
      }
      await deleteRumbleTeam(team.name);
      await insertRumbleTeam(team);
    }
    return true;
  }

  Future<int> getNumberOfRumbleTeams() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.rawQuery("SELECT ${Data.rumbleTeamName} FROM ${Data.rumbleTeamTable}");
      if (res != null)
        return List.generate(res.length, (i) { return res[i][Data.rumbleTeamName]; }).length;
      else
        return 0;
    } else {
      return -1;
    }
  }

  List<RumbleTeam> generateRumbleTeamList(List<Map<String, dynamic>> res) {
    return List.generate(res.length, (i) {
      return RumbleTeam(
          name: res[i][Data.rumbleTeamName],
          description: res[i][Data.rumbleTeamDescription],
          mode: res[i][Data.rumbleTeamMode],
          updated: res[i][Data.rumbleTeamUpdated]);
    });
  }
}