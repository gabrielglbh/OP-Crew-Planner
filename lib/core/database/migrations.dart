import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/ship.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:sqflite/sqflite.dart';

class Migrations {
  // GP STATS EXPANSION
  static Future<void> version40to41(Database db) async {
    try {
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.gpStatsBurst} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.gpStatsBurstCondition} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.gpStatsLeaderSkill} TEXT");
    } catch (err) {
      print(err);
    }
  }

  // SUPER TANDEM EXPANSION
  static Future<void> version39to40(Database db) async {
    try {
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.superTandemCondition} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.superTandemDescription} TEXT");
    } catch (err) {
      print(err);
    }
  }

  // LEVEL LIMIT BREAK UPDATE
  static Future<void> version38to39(Database db) async {
    try {
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbCaptain} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSpecial} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorBase} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorLevel1} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorLevel2} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorCharacter1} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorCharacter2} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbSailorCombined} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbFestSpecial} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbFestAbility} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.llbFestResistance} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.unitTable} ADD COLUMN ${Data.unitMaxLevelLimitBreak} INTEGER NOT NULL DEFAULT 0");
    } catch (err) {
      print(err);
    }
  }

  // Bandai removed the hosted images on their web, had to migrate to Firebase
  static Future<void> version37to38(Database db) async {
    try {
      List<Map<String, dynamic>>? res = await db.query(Data.unitTable);
      List<Unit> all = UnitQueries.generateUnitList(res);

      final batch = db.batch();
      for (int u = 0; u < all.length; u++) {
        batch.update(Data.unitTable, {Data.unitUrl: all[u].getUrlOfUnitImage()},
            where: "${Data.unitId}=?", whereArgs: [all[u].id]);
      }
      await batch.commit();
    } catch (err) {
      print(err);
    }
  }

  static Future<void> version36to37(Database db) async {
    try {
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.lastTapCondition} TEXT");
      await db.rawQuery(
          "ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.lastTapDescription} TEXT");
    } catch (err) {
      print(err);
    }

    // Contrast with the names too in order to not overlap the actual units with the oldIds
    List<String> oldIds = [
      "3381",
      "3370",
      "3333",
      "3334",
      "3347",
      "3348",
      "3349",
      "3350",
      "3360",
      "3361",
      "3371",
      "3372",
      "3373",
      "3374",
      "3382",
      "3383"
    ];
    List<String> oldNamesIds = [
      "Law & Chopper, Dynamic Doctor Duo",
      "Usopp & Chopper, Ex-Weakling Duo",
      "Monkey D. Luffy, Kung Fu Training",
      "Monkey D. Luffy, To Become a True Kung Fu Master",
      "Nefertari Vivi, Wake of an Endless Dream - Princess of Alabasta",
      "Nefertari Vivi, Wake of an Endless Dream - Pirate Queen",
      "Portgas D. Ace, Wake of an Endless Dream - Whitebeard Pirates",
      "Portgas D. Ace, Wake of an Endless Dream - High Seas Pirate",
      "Charlotte Pudding, White Summer Sweets",
      "Charlotte Pudding, Devilish White Swimsuit",
      "Coby [EX], Navy HQ Petty Officer",
      "War Hero Coby [EX], Navy HQ Petty Officer",
      "Sergeant Helmeppo [EX]",
      "Sengoku, Fatherly Buddha",
      "Local Sea Monster, Man-Eating Monster",
      "Makino, Proprietor of a Relaxed Tavern"
    ];
    List<String> newIds = [
      "3330",
      "3331",
      "4986",
      "4987",
      "4988",
      "4989",
      "4990",
      "4991",
      "4992",
      "4993",
      "4994",
      "4995",
      "4996",
      "4997",
      "4998",
      "4999"
    ];

    for (int x = 0; x < oldIds.length; x++) {
      await db.update(Data.unitTable, {Data.unitId: newIds[x]},
          where: "${Data.unitId}=? AND ${Data.unitName}=?",
          whereArgs: [oldIds[x], oldNamesIds[x]]);
    }
  }

  static Future<void> version35to36(Database db) async {
    await db
        .rawQuery("ALTER TABLE ${Data.dataTable} ADD COLUMN ${Data.art} TEXT");
    await db.update(
        Data.unitTable,
        {
          Data.unitUrl:
              "https://firebasestorage.googleapis.com/v0/b/optc-teams-96a76.appspot.com/o/character_11400_t1.png?alt=media&token=2550aac4-d906-400f-8630-a99945d1cf15"
        },
        where: "${Data.unitId}=?",
        whereArgs: ["3156"]);

    // Contrast with the names too in order to not overlap the actual units with the oldIds
    List<String> oldIds = [
      "3351",
      "3352",
      "3353",
      "3354",
      "3356",
      "3357",
      "3358",
      "3359",
      "3366",
      "3367",
      "3368",
      "3375",
      "3376",
      "3380",
      "3339",
      "3340"
    ];
    List<String> oldNamesIds = [
      "Emporio Ivankov [Neo]",
      "Emporio Ivankov [Neo], Queen of Kamabakka Queendom (Retired)",
      "Edward Newgate [Neo], Rival of the Pirate King",
      "Edward Newgate [Neo], Grand Pirate Whitebeard",
      "Monkey D. Luffy [Neo], Star of Hope",
      "Nightmare Luffy [Neo], Warrior of Hope",
      "Demon Bamboo Vergo [Neo]",
      "Demon Bamboo Vergo [Neo], Donquiote Family Senior Executive",
      "Iron Mask Duval [Neo]",
      "Duval [Neo], Flying Fish Riders Leader",
      "Duval [Neo], Rosy Life Riders Leader",
      "Heracles-un [Neo]",
      "Heracles-un [Neo], Hero of the Forest",
      "Condoriano",
      "Monkey D. Garp [Neo]",
      "Garp the Fist [Neo]"
    ];
    List<String> newIds = [
      "3314",
      "3315",
      "3316",
      "3317",
      "3321",
      "3322",
      "3323",
      "3324",
      "3318",
      "3319",
      "3320",
      "3325",
      "3326",
      "3327",
      "3312",
      "3313"
    ];

    for (int x = 0; x < oldIds.length; x++) {
      await db.update(Data.unitTable, {Data.unitId: newIds[x]},
          where: "${Data.unitId}=? AND ${Data.unitName}=?",
          whereArgs: [oldIds[x], oldNamesIds[x]]);
    }
  }

  static Future<void> version34to35(Database db) async {
    try {
      await db.rawQuery(
          "ALTER TABLE ${Data.teamTable} ADD COLUMN ${Data.teamUpdated} TEXT");
    } catch (err) {
      print(err);
    }
    await db.rawQuery(
        "ALTER TABLE ${Data.unitTable} ADD COLUMN ${Data.unitUrl} TEXT");
    List<Map<String, dynamic>> u = await db.query(Data.unitTable);
    List<Unit> units = List.generate(u.length, (i) {
      return Unit(
          id: u[i][Data.unitId],
          name: u[i][Data.unitName],
          type: u[i][Data.unitType],
          taps: u[i][Data.unitTaps],
          url: u[i][Data.unitUrl],
          maxLevel: u[i][Data.unitMaxLevel],
          skills: u[i][Data.unitSkills],
          specialLevel: u[i][Data.unitSpecialLevel],
          cottonCandy: u[i][Data.unitCC],
          supportLevel: u[i][Data.unitSupportLevel],
          potentialAbility: u[i][Data.unitPotential],
          evolution: u[i][Data.unitEvolution],
          limitBreak: u[i][Data.unitLimitBreak],
          available: u[i][Data.unitAvailable],
          rumbleSpecial: u[i][Data.unitRumbleSpecial],
          rumbleAbility: u[i][Data.unitRumbleAbility],
          lastCheckedData: u[i][Data.unitLastCheckedData],
          downloaded: u[i][Data.unitDataDownloaded]);
    });
    for (int t = 0; t < units.length; t++) {
      String id = units[t].id;
      String img = units[t].getUrlOfUnitImage();
      await db.update(Data.unitTable, {Data.unitUrl: img},
          where: "${Data.unitId}=?", whereArgs: [id]);
    }

    await db.rawQuery(
        "ALTER TABLE ${Data.shipTable} ADD COLUMN ${Data.shipUrl} TEXT");
    List<Map<String, dynamic>> s = await db.query(Data.shipTable);
    List<Ship> ship = List.generate(s.length, (i) {
      return Ship(
          id: s[i][Data.shipId],
          name: s[i][Data.shipName],
          url: s[i][Data.shipUrl]);
    });
    for (int t = 0; t < ship.length; t++) {
      String id = ship[t].id;
      String img = ship[t].getUrlFromShipImg();
      await db.update(Data.shipTable, {Data.shipUrl: img},
          where: "${Data.shipId}=?", whereArgs: [id]);
    }
  }
}
