import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/ship.dart';
import 'package:optcteams/core/database/models/skills.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/team_ship.dart';
import 'package:optcteams/core/database/models/team_unit.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/ship_queries.dart';
import 'package:optcteams/core/database/queries/skills_queries.dart';
import 'package:optcteams/core/database/queries/support_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:sqflite/sqflite.dart';

class TeamQueries {
  Database? _database;

  TeamQueries._() {
    _database = CustomDatabase.instance.database;
  }

  static final TeamQueries _instance = TeamQueries._();

  /// Singleton instance of [TeamQueries]
  static TeamQueries get instance => _instance;

  Future<List<Team>> getAllTeams() async {
    if (_database != null) {
      // Get all teams
      List<Map<String, dynamic>>? res = await _database?.query(Data.teamTable);

      if (res != null) {
        List<Team> teams = generateTeamList(res);

        for (int x = 0; x < teams.length; x++) {
          // For each team, retrieve the units id
          List<String> unitsOfTeam = await UnitQueries.instance.getUnitsOfTeam(teams[x].name);
          List<String> supportsOfTeam = await SupportQueries.instance.getSupportUnitFromTeam(teams[x].name);

          // With the units id, retrieve the info of every unit of a team
          List<Unit> units = [];
          List<Unit> supports = [];
          for (int y = 0; y < unitsOfTeam.length; y++) {
            units.add(await UnitQueries.instance.getUnit(unitsOfTeam[y]));
          }
          for (int y = 0; y < supportsOfTeam.length; y++) {
            supports.add(await UnitQueries.instance.getUnit(supportsOfTeam[y]));
          }

          // Get the ship too
          String shipOfTeam = await ShipQueries.instance.getShipOfTeam(teams[x].name);
          Ship ship = await ShipQueries.instance.getShip(shipOfTeam);

          // Get the skills too
          Skills skills = await SkillsQueries.instance.getSkills(teams[x].name);

          teams[x].ship = ship;
          teams[x].units = units;
          teams[x].supports = supports;
          teams[x].skills = skills;
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
      return getAllTeams();
    }
  }

  Future<List<Team>> getTeams(bool maxed, String? query) async {
    if (_database != null) {
      // Get all teams
      List<Map<String, dynamic>>? res;

      if (maxed) {
        if (query != null) {
          // Case 1: Query is for all teams with specific name to be searched
          res = await _database?.query(Data.teamTable, where: "${Data.teamName} LIKE ?", whereArgs: ["%$query%"]);
        } else {
          // Case 2: Query is for only the maxed teams
          res = await _database?.query(Data.teamTable, where: "${Data.teamMaxed}=?", whereArgs: [0]);
        }
      }
      // Case 3: Query is for all teams that are not maxed
      else {
        res = await _database?.query(Data.teamTable, where: "${Data.teamMaxed}=?", whereArgs: [1]);
      }

      if (res != null) {
        List<Team> teams = generateTeamList(res);

        for (int x = 0; x < teams.length; x++) {
          // For each team, retrieve the units id
          List<String> unitsOfTeam = await UnitQueries.instance.getUnitsOfTeam(teams[x].name);
          List<String> supportsOfTeam = await SupportQueries.instance.getSupportUnitFromTeam(teams[x].name);

          // With the units id, retrieve the info of every unit of a team
          List<Unit> units = [];
          List<Unit> supports = [];
          for (int y = 0; y < unitsOfTeam.length; y++) {
            units.add(await UnitQueries.instance.getUnit(unitsOfTeam[y]));
          }
          for (int y = 0; y < supportsOfTeam.length; y++) {
            supports.add(await UnitQueries.instance.getUnit(supportsOfTeam[y]));
          }

          // Get the ship too
          String shipOfTeam = await ShipQueries.instance.getShipOfTeam(teams[x].name);
          Ship ship = await ShipQueries.instance.getShip(shipOfTeam);

          // Get the skills too
          Skills skills = await SkillsQueries.instance.getSkills(teams[x].name);

          teams[x].ship = ship;
          teams[x].units = units;
          teams[x].supports = supports;
          teams[x].skills = skills;
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
      return getTeams(maxed, query);
    }
  }

  Future<List<String>> getTeamNames() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(
          Data.teamTable,
          columns: [Data.teamName]
      );
      if (res != null) {
        return List.generate(res.length, (i) => res[i][Data.teamName]);
      } else {
        return [];
      }
    }
    return [];
  }

  Future<bool> insertTeam(Team team) async {
    if (_database != null) {
      await _database?.insert(Data.teamTable, team.toMap(),
          conflictAlgorithm: ConflictAlgorithm.abort);
      // Insert ship
      await _database?.insert(Data.relShipTable, TeamShip(
          teamId: team.name,
          shipId: team.ship.id
      ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
      // Insert units & support units
      for (int x = 0; x < team.units.length; x++) {
        try {
          await _database?.insert(Data.relUnitTable, TeamUnit(
              teamId: team.name,
              unitId: team.units[x].id
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        } catch (e) {
          await _database?.insert(Data.relUnitTable, TeamUnit(
              teamId: team.name,
              unitId: "noimage"
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        }
        try {
          await _database?.insert(Data.relSupportTable, TeamUnit(
              teamId: team.name,
              unitId: team.supports[x].id
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        } catch (e) {
          await _database?.insert(Data.relSupportTable, TeamUnit(
              teamId: team.name,
              unitId: "noimage"
          ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        }
      }
      // Insert skills
      await _database?.insert(Data.skillsTable, Skills(
          team: team.name,
          damageReduction: team.skills.damageReduction,
          chargeSpecials: team.skills.chargeSpecials,
          bindResistance: team.skills.bindResistance,
          despairResistance: team.skills.despairResistance,
          autoHeal: team.skills.autoHeal,
          rcvBoost: team.skills.rcvBoost,
          slotsBoost: team.skills.slotsBoost,
          mapResistance: team.skills.mapResistance,
          poisonResistance: team.skills.poisonResistance,
          resilience: team.skills.resilience
      ).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    }
    return true;
  }

  Future<void> deleteTeam(String name) async {
    if (_database != null) {
      await _database?.delete(Data.teamTable, where: "${Data.teamName}=?", whereArgs: [name]);
    }
  }

  Future<bool> updateTeam(Team team, String? lastName) async {
    if (_database != null) {
      // Delete & Update because PK might be updated
      if (lastName != null) {
        // If enter here, user has changed the team name
        List<String> teamNames = await getTeamNames();
        if (!teamNames.contains(team.name)) await deleteTeam(lastName);
      }
      await deleteTeam(team.name);
      await insertTeam(team);
    }
    return true;
  }

  Future<bool> updateIsMaxed(Team team) async {
    if (_database != null) {
      _database?.update(Data.teamTable, team.toMap(), where: "${Data.teamName}=?", whereArgs: [team.name]);
    }
    return true;
  }

  Future<int> getNumberOfTeams() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.rawQuery("SELECT ${Data.teamName} FROM ${Data.teamTable}");
      if (res != null) {
        return List.generate(res.length, (i) { return res[i][Data.teamName]; }).length;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }

  static List<Team> generateTeamList(List<Map<String, dynamic>> res) {
    return List.generate(res.length, (i) {
      return Team(
          name: res[i][Data.teamName],
          description: res[i][Data.teamDescription],
          maxed: res[i][Data.teamMaxed],
          updated: res[i][Data.teamUpdated]);
    });
  }
}