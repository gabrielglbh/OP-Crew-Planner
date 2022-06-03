import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/skills.dart';
import 'package:sqflite/sqflite.dart';

class SkillsQueries {
  Database? _database;

  SkillsQueries._() {
    _database = CustomDatabase.instance.database;
  }

  static final SkillsQueries _instance = SkillsQueries._();

  /// Singleton instance of [SkillsQueries]
  static SkillsQueries get instance => _instance;

  Future<Skills> getSkills(String name) async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.skillsTable,
          where: "${Data.skillsTeam}=?", whereArgs: [name]);
      if (res != null) {
        return Skills(
            team: res[0][Data.skillsTeam],
            damageReduction: res[0][Data.skillsDamage],
            chargeSpecials: res[0][Data.skillsSpecials],
            bindResistance: res[0][Data.skillsBind],
            despairResistance: res[0][Data.skillsDespair],
            autoHeal: res[0][Data.skillsHeal],
            rcvBoost: res[0][Data.skillsRcv],
            slotsBoost: res[0][Data.skillsSlot],
            mapResistance: res[0][Data.skillsMap],
            poisonResistance: res[0][Data.skillsPoison],
            resilience: res[0][Data.skillsResilience]);
      } else {
        return Skills.empty;
      }
    }
    return Skills.empty;
  }
}
