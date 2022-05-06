import 'dart:io';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/migrations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomDatabase {
  CustomDatabase._();

  static final CustomDatabase _instance = CustomDatabase._();

  /// Singleton instance of [CustomDatabase]
  static CustomDatabase get instance => _instance;

  /// Database to perform all the queries on
  static Database? _database;

  Database? get database => _database;

  /// Opens up the db and configures all of it
  Future<void> open({Function(String)? onUpdate}) async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "optc-teams.db");

    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    _database = await openDatabase(
        path,
        version: 39,
        singleInstance: true,
        onCreate: (Database db, int version) async {
          if (onUpdate != null) onUpdate("creatingDB".tr());
          await db.execute("CREATE TABLE ${Data.unitTable}("
              "${Data.unitId} TEXT PRIMARY KEY NOT NULL, "
              "${Data.unitName} TEXT NOT NULL, "
              "${Data.unitType} TEXT NOT NULL, "
              "${Data.unitUrl} TEXT, "
              "${Data.unitTaps} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitCC} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitSpecialLevel} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitMaxLevel} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitMaxLevelLimitBreak} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitLimitBreak} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitSupportLevel} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitEvolution} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitSkills} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitPotential} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitAvailable} INTEGER NOT NULL DEFAULT 0, "
              "${Data.teamUpdated} TEXT, "
              "${Data.unitRumbleSpecial} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitRumbleAbility} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitLastCheckedData} INTEGER NOT NULL DEFAULT 0, "
              "${Data.unitDataDownloaded} INTEGER NOT NULL DEFAULT 0)");

          await db.execute("CREATE TABLE ${Data.shipTable}("
              "${Data.shipId} TEXT PRIMARY KEY NOT NULL, "
              "${Data.shipName} TEXT NOT NULL, "
              "${Data.shipUrl} TEXT)");

          await db.execute("CREATE TABLE ${Data.teamTable}("
              "${Data.teamName} TEXT PRIMARY KEY NOT NULL, "
              "${Data.teamDescription} TEXT NOT NULL, "
              "${Data.teamMaxed} INTEGER NOT NULL DEFAULT 0, "
              "${Data.teamUpdated} TEXT)");

          await db.execute("CREATE TABLE ${Data.relUnitTable}("
              "${Data.relUnitId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.relUnitTeam} TEXT, "
              "${Data.relUnitUnit} TEXT, "
              "FOREIGN KEY (${Data.relUnitTeam}) REFERENCES ${Data.teamTable}(${Data.teamName}) ON DELETE CASCADE ON UPDATE CASCADE, "
              "FOREIGN KEY (${Data.relUnitUnit}) REFERENCES ${Data.unitTable}(${Data.unitId}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("CREATE TABLE ${Data.relShipTable}("
              "${Data.relShipId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.relShipTeam} TEXT, "
              "${Data.relShipShip} TEXT, "
              "FOREIGN KEY (${Data.relShipTeam}) REFERENCES ${Data.teamTable}(${Data.teamName}) ON DELETE CASCADE ON UPDATE CASCADE, "
              "FOREIGN KEY (${Data.relShipShip}) REFERENCES ${Data.shipTable}(${Data.shipId}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("CREATE TABLE ${Data.skillsTable}("
              "${Data.skillsId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.skillsTeam} TEXT NOT NULL, "
              "${Data.skillsDamage} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsSpecials} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsBind} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsDespair} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsHeal} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsRcv} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsSlot} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsMap} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsPoison} INTEGER NOT NULL DEFAULT 0, "
              "${Data.skillsResilience} INTEGER NOT NULL DEFAULT 0, "
              "FOREIGN KEY (${Data.skillsTeam}) REFERENCES ${Data.teamTable}(${Data.teamName}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("CREATE TABLE ${Data.relSupportTable}("
              "${Data.relSupportId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.relSupportTeam} TEXT, "
              "${Data.relSupportUnit} TEXT, "
              "FOREIGN KEY (${Data.relSupportTeam}) REFERENCES ${Data.teamTable}(${Data.teamName}) ON DELETE CASCADE ON UPDATE CASCADE, "
              "FOREIGN KEY (${Data.relSupportUnit}) REFERENCES ${Data.unitTable}(${Data.unitId}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("CREATE TABLE ${Data.rumbleTeamTable}("
              "${Data.rumbleTeamName} TEXT PRIMARY KEY NOT NULL, "
              "${Data.rumbleTeamDescription} TEXT NOT NULL, "
              "${Data.rumbleTeamUpdated} TEXT, "
              "${Data.rumbleTeamMode} INTEGER NOT NULL DEFAULT 0)");

          await db.execute("CREATE TABLE ${Data.relRumbleUnitTable}("
              "${Data.relRumbleUnitId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.relRumbleUnitTeam} TEXT, "
              "${Data.relRumbleUnitUnit} TEXT, "
              "FOREIGN KEY (${Data.relRumbleUnitTeam}) REFERENCES ${Data.rumbleTeamTable}(${Data.rumbleTeamName}) ON DELETE CASCADE ON UPDATE CASCADE, "
              "FOREIGN KEY (${Data.relRumbleUnitUnit}) REFERENCES ${Data.unitTable}(${Data.unitId}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("DROP TABLE IF EXISTS ${Data.aliasTable}");
          await db.execute("CREATE TABLE ${Data.aliasTable}("
              "${Data.aliasId} INTEGER PRIMARY KEY AUTOINCREMENT, "
              "${Data.aliasName} TEXT NOT NULL, "
              "${Data.aliasUnitId} TEXT NOT NULL, "
              "FOREIGN KEY (${Data.aliasUnitId}) REFERENCES ${Data.unitTable}(${Data.unitId}) ON DELETE CASCADE ON UPDATE CASCADE)");

          await db.execute("CREATE TABLE ${Data.dataTable}("
              "${Data.dataUnitId} TEXT NOT NULL PRIMARY KEY, "
              "${Data.sailorBase} TEXT NOT NULL, "
              "${Data.llbSailorBase} TEXT NOT NULL, "
              "${Data.sailorLevel1} TEXT NOT NULL, "
              "${Data.llbSailorLevel1} TEXT NOT NULL, "
              "${Data.sailorLevel2} TEXT NOT NULL, "
              "${Data.llbSailorLevel2} TEXT NOT NULL, "
              "${Data.sailorCombined} TEXT NOT NULL, "
              "${Data.llbSailorCombined} TEXT NOT NULL, "
              "${Data.sailorCharacter1} TEXT NOT NULL, "
              "${Data.llbSailorCharacter1} TEXT NOT NULL, "
              "${Data.sailorCharacter2} TEXT NOT NULL, "
              "${Data.llbSailorCharacter2} TEXT NOT NULL, "
              "${Data.special} TEXT NOT NULL, "
              "${Data.llbSpecial} TEXT NOT NULL, "
              "${Data.specialName} TEXT NOT NULL, "
              "${Data.captain} TEXT NOT NULL, "
              "${Data.llbCaptain} TEXT NOT NULL, "
              "${Data.swap} TEXT NOT NULL, "
              "${Data.potentialOne} TEXT NOT NULL, "
              "${Data.potentialTwo} TEXT NOT NULL, "
              "${Data.potentialThree} TEXT NOT NULL, "
              "${Data.festAbility} TEXT NOT NULL, "
              "${Data.festSpecial} TEXT NOT NULL, "
              "${Data.festResistance} TEXT NOT NULL, "
              "${Data.llbFestAbility} TEXT NOT NULL, "
              "${Data.llbFestSpecial} TEXT NOT NULL, "
              "${Data.llbFestResistance} TEXT NOT NULL, "
              "${Data.supportCharacters} TEXT NOT NULL, "
              "${Data.supportDescription} TEXT NOT NULL, "
              "${Data.superSpecial} TEXT NOT NULL, "
              "${Data.superSpecialCriteria} TEXT NOT NULL, "
              "${Data.vsCondition} TEXT NOT NULL, "
              "${Data.vsSpecial} TEXT NOT NULL, "
              "${Data.art} TEXT, "
              "${Data.lastTapCondition} TEXT, "
              "${Data.lastTapDescription} TEXT)");
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) {
          // Change it to whatever to debug new versions of DB
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (onUpdate != null) onUpdate("archUpdates".tr());
          await _onUpgrade(db, oldVersion, newVersion);
        },
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        }
    );
  }

  /// Function to manage migrations on whenever an update is needed.
  /// Whenever the update to the DB, automatically put it on the onCreate DB
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion <= 34) await Migrations.version34to35(db);
    if (oldVersion <= 35) await Migrations.version35to36(db);
    if (oldVersion <= 36) await Migrations.version36to37(db);
    if (oldVersion <= 37) await Migrations.version37to38(db);
    if (oldVersion <= 38) await Migrations.version38to39(db);
  }

  /// Closes up the current database.
  Future<void> close() async => await _database?.close();
}