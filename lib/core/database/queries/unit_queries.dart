import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/ui/pages/main/units/enum_unit_filters.dart';
import 'package:sqflite/sqflite.dart';

class UnitQueries {
  Database? _database;

  /// Singleton instance of [UnitQueries]
  static UnitQueries instance = UnitQueries();

  UnitQueries() {
    _database = CustomDatabase.instance.database;
  }

  Future<void> updateHistoryUnit(Unit u) async {
    u.setLastCheckedData(DateTime.now().millisecondsSinceEpoch);
    await updateUnit(u);
  }

  Future<int> getAllUnitsCount() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.unitTable, columns: [Data.unitId]);
      return (res?.length ?? 0);
    }
    return -1;
  }

  Future<bool> clearHistory() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.unitTable,
          where: "${Data.unitLastCheckedData}>?", whereArgs: [0]);
      if (res != null) {
        List<Unit> u = generateUnitList(res);
        u.forEach((unit) async {
          unit.setLastCheckedData(0);
          await _database?.update(Data.unitTable, unit.toJson(), where: "${Data.unitId}=?", whereArgs: [unit.id]);
        });
      }
      else return false;
    }
    return true;
  }

  Future<List<Unit>> getMostRecentSearchedUnits() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(
          Data.unitTable,
          where: "${Data.unitLastCheckedData}>?",
          whereArgs:[0] ,
          orderBy: "${Data.unitLastCheckedData} DESC",
          limit: 128
      );
      if (res != null) return generateUnitList(res);
      else return [];
    }
    return [];
  }

  Future<int> insertUnit(String id, String name, String type, String url) async {
    if (_database != null) {
      try {
        await _database?.insert(Data.unitTable,
            Unit(id: id, name: name, type: type, url: url).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        return 0;
      } catch (err) {
        print("insertUnit: ${err.toString()}");
        return -1;
      }
    } else return -2;
  }

  Future<Unit> getUnit(String id) async {
    if (_database != null) {
      try {
        List<Map<String, dynamic>>? res = await _database?.query(
            Data.unitTable,
            where: "${Data.unitId}=?",
            whereArgs: [id]
        );
        if (res != null) {
          return Unit(
            id: res[0][Data.unitId],
            name: res[0][Data.unitName],
            type: res[0][Data.unitType],
            url: res[0][Data.unitUrl],
            taps: res[0][Data.unitTaps],
            maxLevel: res[0][Data.unitMaxLevel],
            skills: res[0][Data.unitSkills],
            specialLevel: res[0][Data.unitSpecialLevel],
            cottonCandy: res[0][Data.unitCC],
            supportLevel: res[0][Data.unitSupportLevel],
            potentialAbility: res[0][Data.unitPotential],
            evolution: res[0][Data.unitEvolution],
            limitBreak: res[0][Data.unitLimitBreak],
            available: res[0][Data.unitAvailable],
            rumbleSpecial: res[0][Data.unitRumbleSpecial],
            rumbleAbility: res[0][Data.unitRumbleAbility],
            lastCheckedData: res[0][Data.unitLastCheckedData],
            downloaded: res[0][Data.unitDataDownloaded]
          );
        }
      } catch (err) {
        print("getUnit: ${err.toString()}");
        return Unit.empty();
      }
    }
    return Unit.empty();
  }

  Future<List<Unit>> getUnitsToBeMaxedOut(UnitFilter filter) async {
    if (_database != null) {
      List<Map<String, dynamic>>? res;
      switch (filter) {
        case UnitFilter.all:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitMaxLevel} == ? OR ${Data.unitSupportLevel} == ? OR ${Data.unitSpecialLevel} == ? "
              "OR ${Data.unitLimitBreak} == ? OR ${Data.unitCC} == ? OR ${Data.unitEvolution} == ? "
              "OR ${Data.unitSkills} == ? OR ${Data.unitPotential} == ? OR ${Data.unitRumbleSpecial} == ? "
              "OR ${Data.unitRumbleAbility} == ? ORDER BY ${Data.unitId}", [1, 1, 1, 1, 1, 1, 1 ,1, 1, 1]);
          break;
        case UnitFilter.maxLevel:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitMaxLevel} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.skills:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitSkills} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.special:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitSpecialLevel} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.cottonCandy:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitCC} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.support:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitSupportLevel} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.potential:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitPotential} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.evolution:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitEvolution} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.limitBreak:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitLimitBreak} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.rumbleSpecial:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitRumbleSpecial} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.rumbleAbility:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitRumbleAbility} == ? ORDER BY ${Data.unitId}", [1]);
          break;
      }
      if (res != null) return generateUnitList(res);
      else return [];
    }
    return [];
  }

  Future<List<Unit>> getUnitsToBeMaxedOutAvailable(UnitFilter filter) async {
    if (_database != null) {
      List<Map<String, dynamic>>? res;
      switch (filter) {
        case UnitFilter.all:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? ORDER BY ${Data.unitId}", [1]);
          break;
        case UnitFilter.maxLevel:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitMaxLevel} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.skills:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitSkills} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.special:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitSpecialLevel} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.cottonCandy:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitCC} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.support:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitSupportLevel} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.potential:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitPotential} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.evolution:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitEvolution} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.limitBreak:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitLimitBreak} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.rumbleSpecial:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitRumbleSpecial} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
        case UnitFilter.rumbleAbility:
          res = await _database?.rawQuery("SELECT * FROM ${Data.unitTable} "
              "WHERE ${Data.unitAvailable} == ? AND ${Data.unitRumbleAbility} == ? ORDER BY ${Data.unitId}", [1, 1]);
          break;
      }
      if (res != null) return generateUnitList(res);
      else return [];
    }
    return [];
  }

  Future<List<Unit>> getUnitsCurrentlyMaxing(String query) async {
    if (_database != null) {
      List<Map<String, dynamic>>? resUnits = [];
      List<Map<String, dynamic>>? resAlias = [];

      resUnits = await _database?.rawQuery("SELECT DISTINCT * FROM ${Data.unitTable} "
          "WHERE (${Data.unitName} LIKE ? OR ${Data.unitId} LIKE ?) AND (${Data.unitMaxLevel} == ? "
          "AND ${Data.unitSupportLevel} == ? AND ${Data.unitSpecialLevel} == ? "
          "AND ${Data.unitLimitBreak} == ? AND ${Data.unitCC} == ? AND ${Data.unitEvolution} == ? "
          "AND ${Data.unitSkills} == ? AND ${Data.unitPotential} == ? AND ${Data.unitRumbleSpecial} == ? "
          "AND ${Data.unitRumbleAbility} == ?) ORDER BY ${Data.unitId}",
          ["%$query%", "%$query%", 1, 1, 1, 1, 1, 1, 1 ,1, 1, 1]);

      resAlias = await _database?.rawQuery("SELECT DISTINCT "
          "U.${Data.unitId}, U.${Data.unitName}, ${Data.unitType}, ${Data.unitUrl}, "
          "${Data.unitTaps}, ${Data.unitMaxLevel}, ${Data.unitSkills}, ${Data.unitSpecialLevel}, "
          "${Data.unitCC}, ${Data.unitSupportLevel}, ${Data.unitPotential}, ${Data.unitEvolution}, "
          "${Data.unitLimitBreak}, ${Data.unitAvailable}, ${Data.unitRumbleSpecial}, "
          "${Data.unitRumbleAbility}, ${Data.unitLastCheckedData}, ${Data.unitDataDownloaded} "
          "FROM ${Data.unitTable} U "
          "JOIN ${Data.aliasTable} A ON U.${Data.unitId}=A.${Data.aliasUnitId} "
          "WHERE (U.${Data.unitName} LIKE ? OR A.${Data.aliasName} LIKE ? OR U.${Data.unitId} LIKE ?) AND (${Data.unitMaxLevel} == ? "
          "OR ${Data.unitSupportLevel} == ? OR ${Data.unitSpecialLevel} == ? "
          "OR ${Data.unitLimitBreak} == ? OR ${Data.unitCC} == ? OR ${Data.unitEvolution} == ? "
          "OR ${Data.unitSkills} == ? OR ${Data.unitPotential} == ? OR ${Data.unitRumbleSpecial} == ? "
          "OR ${Data.unitRumbleAbility} == ?) ORDER BY U.${Data.unitId}", ["%$query%", "%$query%", "%$query%", 1, 1, 1, 1, 1, 1, 1 ,1, 1, 1]);

      if (resUnits != null && resAlias != null) {
        List<Unit> units = generateUnitList(resUnits);
        List<Unit> aliases = generateUnitList(resAlias);
        units.addAll(aliases);
        final Set<String> ids = units.map((e) => e.id).toSet();
        units.retainWhere((unit) => ids.remove(unit.id));
        return units;
      }
      else return [];
    }
    return [];
  }

  Future<List<Unit>> getUnitsCurrentlyNotMaxing(String query, String type) async {
    if (_database != null) {
      List<Map<String, dynamic>>? resUnits = [];
      List<Map<String, dynamic>> ?resAlias = [];

      if (type == Data.allType) {
        resUnits = await _database?.rawQuery(
            "SELECT DISTINCT * FROM ${Data.unitTable} "
                "WHERE (${Data.unitName} LIKE ? OR ${Data.unitId} LIKE ?) AND ${Data.unitMaxLevel} == ? "
                "AND ${Data.unitSupportLevel} == ? AND ${Data.unitSpecialLevel} == ? "
                "AND ${Data.unitLimitBreak} == ? AND ${Data.unitCC} == ? AND ${Data.unitEvolution} == ? "
                "AND ${Data.unitSkills} == ? AND ${Data.unitPotential} == ? AND ${Data.unitRumbleSpecial} == ? "
                "AND ${Data.unitRumbleAbility} == ? ORDER BY ${Data.unitId}",
            ["%$query%", "%$query%", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

        resAlias = await _database?.rawQuery(
            "SELECT DISTINCT U.${Data.unitId}, U.${Data.unitName}, ${Data.unitType}, ${Data.unitUrl}, "
                "${Data.unitTaps}, ${Data.unitMaxLevel}, ${Data.unitSkills}, ${Data.unitSpecialLevel}, "
                "${Data.unitCC}, ${Data.unitSupportLevel}, ${Data.unitPotential}, ${Data.unitEvolution}, "
                "${Data.unitLimitBreak}, ${Data.unitAvailable}, ${Data.unitRumbleSpecial}, "
                "${Data.unitRumbleAbility}, ${Data.unitLastCheckedData}, ${Data.unitDataDownloaded} "
                "FROM ${Data.unitTable} U "
                "JOIN ${Data.aliasTable} A ON U.${Data.unitId}=A.${Data.aliasUnitId} "
                "WHERE (U.${Data.unitName} LIKE ? OR A.${Data.aliasName} LIKE ? OR U.${Data.unitId} LIKE ?) AND ${Data.unitMaxLevel} == ? "
                "AND ${Data.unitSupportLevel} == ? AND ${Data.unitSpecialLevel} == ? "
                "AND ${Data.unitLimitBreak} == ? AND ${Data.unitCC} == ? AND ${Data.unitEvolution} == ? "
                "AND ${Data.unitSkills} == ? AND ${Data.unitPotential} == ? AND ${Data.unitRumbleSpecial} == ? "
                "AND ${Data.unitRumbleAbility}== ? ORDER BY U.${Data.unitId}",
            ["%$query%", "%$query%", "%$query%", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
      } else {
        resUnits = await _database?.rawQuery(
            "SELECT DISTINCT * FROM ${Data.unitTable} "
                "WHERE (${Data.unitName} LIKE ? OR ${Data.unitId} LIKE ?) AND ${Data.unitType}=? AND ${Data.unitMaxLevel} == ? "
                "AND ${Data.unitSupportLevel} == ? AND ${Data.unitSpecialLevel} == ? "
                "AND ${Data.unitLimitBreak} == ? AND ${Data.unitCC} == ? AND ${Data.unitEvolution} == ? "
                "AND ${Data.unitSkills} == ? AND ${Data.unitPotential} == ? AND ${Data.unitRumbleSpecial} == ? "
                "AND ${Data.unitRumbleAbility} == ? ORDER BY ${Data.unitId}",
            ["%$query%", "%$query%", type, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);

        resAlias = await _database?.rawQuery(
            "SELECT DISTINCT U.${Data.unitId}, U.${Data.unitName}, ${Data.unitType}, ${Data.unitUrl}, "
                "${Data.unitTaps}, ${Data.unitMaxLevel}, ${Data.unitSkills}, ${Data.unitSpecialLevel}, "
                "${Data.unitCC}, ${Data.unitSupportLevel}, ${Data.unitPotential}, ${Data.unitEvolution}, "
                "${Data.unitLimitBreak}, ${Data.unitAvailable}, ${Data.unitRumbleSpecial}, "
                "${Data.unitRumbleAbility}, ${Data.unitLastCheckedData}, ${Data.unitDataDownloaded} "
                "FROM ${Data.unitTable} U "
                "JOIN ${Data.aliasTable} A ON U.${Data.unitId}=A.${Data.aliasUnitId} "
                "WHERE (U.${Data.unitName} LIKE ? OR A.${Data.aliasName} LIKE ? OR U.${Data.unitId} LIKE ?) AND ${Data.unitType}=? AND ${Data.unitMaxLevel} == ? "
                "AND ${Data.unitSupportLevel} == ? AND ${Data.unitSpecialLevel} == ? "
                "AND ${Data.unitLimitBreak} == ? AND ${Data.unitCC} == ? AND ${Data.unitEvolution} == ? "
                "AND ${Data.unitSkills} == ? AND ${Data.unitPotential} == ? AND ${Data.unitRumbleSpecial} == ? "
                "AND ${Data.unitRumbleAbility} == ? ORDER BY U.${Data.unitId}",
            ["%$query%", "%$query%", "%$query%", type, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
      }
      if (resUnits != null && resAlias != null) {
        List<Unit> units = generateUnitList(resUnits);
        List<Unit> aliases = generateUnitList(resAlias);
        units.addAll(aliases);
        final Set<String> ids = units.map((e) => e.id).toSet();
        units.retainWhere((unit) => ids.remove(unit.id));
        return units;
      }
      return [];
    }
    return [];
  }

  Future<List<Unit>> getUnitsAccordingToName(String query, String type) async {
    if (_database != null) {
      List<Map<String, dynamic>>? resUnits = [];
      List<Map<String, dynamic>>? resAlias = [];

      if (type == Data.allType) {
        resUnits = await _database?.rawQuery("SELECT DISTINCT * FROM ${Data.unitTable} "
            "WHERE ${Data.unitName} LIKE ? OR ${Data.unitId} LIKE ? ORDER BY ${Data.unitId}", ["%$query%", "%$query%"]);

        resAlias = await _database?.rawQuery("SELECT DISTINCT "
            "U.${Data.unitId}, U.${Data.unitName}, ${Data.unitType}, ${Data.unitUrl}, ${Data.unitTaps}, ${Data.unitMaxLevel}, ${Data.unitSkills}, ${Data.unitSpecialLevel}, "
            "${Data.unitCC}, ${Data.unitSupportLevel}, ${Data.unitPotential}, ${Data.unitEvolution}, ${Data.unitLimitBreak}, ${Data.unitAvailable},"
            "${Data.unitRumbleSpecial}, ${Data.unitRumbleAbility}, ${Data.unitLastCheckedData}, ${Data.unitDataDownloaded} "
            "FROM ${Data.unitTable} U "
            "JOIN ${Data.aliasTable} A ON U.${Data.unitId}=A.${Data.aliasUnitId} "
            "WHERE U.${Data.unitName} LIKE ? OR A.${Data.aliasName} LIKE ? OR U.${Data.unitId} LIKE ? ORDER BY U.${Data.unitId}", ["%$query%", "%$query%", "%$query%"]);
      }  else {
        resUnits = await _database?.rawQuery("SELECT DISTINCT * FROM ${Data.unitTable} "
            "WHERE (${Data.unitName} LIKE ? OR ${Data.unitId} LIKE ?) AND ${Data.unitType}=? ORDER BY ${Data.unitId}", ["%$query%", "%$query%", type]);

        resAlias = await _database?.rawQuery("SELECT DISTINCT "
            "U.${Data.unitId}, U.${Data.unitName}, ${Data.unitType}, ${Data.unitUrl}, ${Data.unitTaps}, ${Data.unitMaxLevel}, ${Data.unitSkills}, ${Data.unitSpecialLevel}, "
            "${Data.unitCC}, ${Data.unitSupportLevel}, ${Data.unitPotential}, ${Data.unitEvolution}, ${Data.unitLimitBreak}, ${Data.unitAvailable},"
            "${Data.unitRumbleSpecial}, ${Data.unitRumbleAbility}, ${Data.unitLastCheckedData}, ${Data.unitDataDownloaded} "
            "FROM ${Data.unitTable} U "
            "JOIN ${Data.aliasTable} A ON U.${Data.unitId}=A.${Data.aliasUnitId} "
            "WHERE (U.${Data.unitName} LIKE ? OR A.${Data.aliasName} LIKE ? OR U.${Data.unitId} LIKE ?) AND ${Data.unitType}=? ORDER BY U.${Data.unitId}",
            ["%$query%", "%$query%", "%$query%", type]);
      }
      if (resUnits != null && resAlias != null) {
        List<Unit> units = generateUnitList(resUnits);
        List<Unit> aliases = generateUnitList(resAlias);
        units.addAll(aliases);
        final Set<String> ids = units.map((e) => e.id).toSet();
        units.retainWhere((unit) => ids.remove(unit.id));
        return units;
      }
      else return [];
    }
    return [];
  }

  Future<List<Unit>> getMostUsedUnits() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(
          Data.unitTable,
          where: "${Data.unitTaps}>?",
          whereArgs: [0],
          orderBy: "${Data.unitTaps} DESC",
          limit: 18
      );
      if (res != null) return generateUnitList(res);
      else return [];
    }
    return [];
  }

  Future<bool> updateUnit(Unit unit) async {
    if (_database != null) {
      await _database?.update(Data.unitTable, unit.toJson(), where: "${Data.unitId}=?", whereArgs: [unit.id]);
    }
    return true;
  }

  Future<List<String>> getUnitsOfTeam(String name) async {
    if (_database != null) {
      List<Map<String, dynamic>>? units = await _database?.rawQuery(
          "SELECT ${Data.relUnitUnit} FROM ${Data.relUnitTable} R INNER JOIN ${Data.teamTable} T ON R.${Data.relUnitTeam}=T.${Data.teamName} "
              "WHERE T.${Data.teamName}=?",
          [name]
      );
      if (units != null)
        return List.generate(units.length, (i) { return units[i][Data.relUnitUnit]; });
      else
        return [];
    }
    return [];
  }

  Future<List<String>> getUnitsOfRumbleTeam(String name) async {
    if (_database != null) {
      List<Map<String, dynamic>>? units = await _database?.rawQuery(
          "SELECT ${Data.relRumbleUnitUnit} FROM ${Data.relRumbleUnitTable} R INNER JOIN ${Data.rumbleTeamTable} T "
              "ON R.${Data.relRumbleUnitTeam}=T.${Data.rumbleTeamName} WHERE T.${Data.rumbleTeamName}=?",
          [name]
      );
      if (units != null)
        return List.generate(units.length, (i) { return units[i][Data.relRumbleUnitUnit]; });
      else
        return [];
    }
    return [];
  }

  Future<int> getNumberOfToBeMaxedUnits() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.rawQuery("SELECT ${Data.unitId} FROM ${Data.unitTable} "
          "WHERE ${Data.unitMaxLevel} == ? OR ${Data.unitSupportLevel} == ? OR ${Data.unitSpecialLevel} == ? "
          "OR ${Data.unitLimitBreak} == ? OR ${Data.unitCC} == ? OR ${Data.unitEvolution} == ? "
          "OR ${Data.unitSkills} == ? OR ${Data.unitPotential} == ? OR ${Data.unitRumbleSpecial} == ? "
          "OR ${Data.unitRumbleAbility} == ?", [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
      if (res != null)
        return List.generate(res.length, (i) {return res[i][Data.unitId];}).length;
      else
        return 0;
    } else {
      return -1;
    }
  }

  List<Unit> generateUnitList(List<Map<String, dynamic>> res) {
    return List.generate(res.length, (i) {
      return Unit(id: res[i][Data.unitId],
          name: res[i][Data.unitName],
          type: res[i][Data.unitType],
          taps: res[i][Data.unitTaps],
          url: res[i][Data.unitUrl],
          maxLevel: res[i][Data.unitMaxLevel],
          skills: res[i][Data.unitSkills],
          specialLevel: res[i][Data.unitSpecialLevel],
          cottonCandy: res[i][Data.unitCC],
          supportLevel: res[i][Data.unitSupportLevel],
          potentialAbility: res[i][Data.unitPotential],
          evolution: res[i][Data.unitEvolution],
          limitBreak: res[i][Data.unitLimitBreak],
          available: res[i][Data.unitAvailable],
          rumbleSpecial: res[i][Data.unitRumbleSpecial],
          rumbleAbility: res[i][Data.unitRumbleAbility],
          lastCheckedData: res[i][Data.unitLastCheckedData],
          downloaded: res[i][Data.unitDataDownloaded]
      );
    });
  }
}