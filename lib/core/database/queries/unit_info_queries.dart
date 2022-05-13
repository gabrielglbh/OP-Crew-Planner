import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/models/unit_info.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:sqflite/sqflite.dart';

class UnitInfoQueries {
  Database? _database;

  UnitInfoQueries._() {
    _database = CustomDatabase.instance.database;
  }

  static final UnitInfoQueries _instance = UnitInfoQueries._();

  /// Singleton instance of [UnitInfoQueries]
  static UnitInfoQueries get instance => _instance;

  Future<bool> insertUnitInfoIntoDatabase(UnitInfo u, Unit unit) async {
    try {
      if (_database != null) {
        if (u.potential.length == 1) {
          u.potential = [u.potential[0], "", ""];
        } else if (u.potential.length == 2) {
          u.potential = [u.potential[0], u.potential[1], ""];
        }
        await _database?.insert(Data.dataTable, u.toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        await _database?.update(Data.unitTable, unit.toJson(), where: "${Data.unitId}=?", whereArgs: [u.unitId]);
      }
    } catch (err) {
      print("insertUnitInfoIntoDatabase: ${err.toString()}");
      return false;
    }
    return true;
  }

  Future<bool> deleteSpecificUnitInfoFromDatabase(Unit unit) async {
    try {
      if (_database != null) {
        unit.downloaded = 0;
        await _database?.delete(Data.dataTable, where: "${Data.dataUnitId}=?", whereArgs: [unit.id]);
        await _database?.update(Data.unitTable, unit.toJson(), where: "${Data.unitId}=?", whereArgs: [unit.id]);
      }
    } catch (err) {
      return false;
    }
    return true;
  }

  Future<bool> deleteUnitInfoFromDatabase() async {
    try {
      if (_database != null) {
        await _database?.delete(Data.dataTable);
        List<Map<String, dynamic>>? res = await _database?.query(Data.unitTable,
            where: "${Data.unitDataDownloaded}=?", whereArgs: [1]);
        if (res != null) {
          List<Unit> units = UnitQueries.generateUnitList(res);
          for (var unit in units) {
            unit.downloaded = 0;
            await UnitQueries.instance.updateUnit(unit);
          }
          return true;
        }
        else {
          return false;
        }
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  Future<UnitInfo> getUnitInfoFromDatabase(String id) async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.dataTable, where: "${Data.dataUnitId}=?", whereArgs: [id]);
      if (res != null) {
        if (res.isEmpty) {
          return UnitInfo.empty();
        } else {
          return UnitInfo(
            sailor: {
              UnitInfo.fSailorBase: res[0][Data.sailorBase],
              UnitInfo.fSailorLevel1: res[0][Data.sailorLevel1],
              UnitInfo.fSailorLevel2: res[0][Data.sailorLevel2],
              UnitInfo.fSailorCombined: res[0][Data.sailorCombined],
              UnitInfo.fSailorChar1: res[0][Data.sailorCharacter1],
              UnitInfo.fSailorChar2: res[0][Data.sailorCharacter2],
              UnitInfo.fLLBSailorBase: res[0][Data.llbSailorBase],
              UnitInfo.fLLBSailorLevel1: res[0][Data.llbSailorLevel1],
              UnitInfo.fLLBSailorLevel2: res[0][Data.llbSailorLevel2],
              UnitInfo.fLLBSailorCombined: res[0][Data.llbSailorCombined],
              UnitInfo.fLLBSailorCharacter1: res[0][Data.llbSailorCharacter1],
              UnitInfo.fLLBSailorCharacter2: res[0][Data.llbSailorCharacter2]
            },
            special: res[0][Data.special],
            specialName: res[0][Data.specialName],
            captain: res[0][Data.captain],
            swap: res[0][Data.swap],
            potential: [
              res[0][Data.potentialOne],
              res[0][Data.potentialTwo],
              res[0][Data.potentialThree]
            ],
            festAbility: res[0][Data.festAbility],
            festResistance: res[0][Data.festResistance],
            festSpecial: res[0][Data.festSpecial],
            support: {
              UnitInfo.fSupChars: res[0][Data.supportCharacters],
              UnitInfo.fSupDescription: res[0][Data.supportDescription]
            },
            superSpecial: res[0][Data.superSpecial],
            superSpecialCriteria: res[0][Data.superSpecialCriteria],
            vsCondition: res[0][Data.vsCondition],
            vsSpecial: res[0][Data.vsSpecial],
            art: res[0][Data.art],
            lastTapCondition: res[0][Data.lastTapCondition],
            lastTapDescription: res[0][Data.lastTapDescription],
            superTandemCondition: res[0][Data.superTandemCondition],
            superTandemDescription: res[0][Data.superTandemDescription],
            llbCaptain: res[0][Data.llbCaptain],
            llbSpecial: res[0][Data.llbSpecial],
            llbFestAbility: res[0][Data.llbFestAbility],
            llbFestResistance: res[0][Data.llbFestResistance],
            llbFestSpecial: res[0][Data.llbFestSpecial],
          );
        }
      }
      else {
        return UnitInfo.empty();
      }
    }
    return UnitInfo.empty();
  }
}