import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:sqflite/sqflite.dart';

class SupportQueries {
  Database? _database;

  /// Singleton instance of [SupportQueries]
  static SupportQueries instance = SupportQueries();

  SupportQueries() {
    _database = CustomDatabase.instance.database;
  }

  Future<List<String>> getSupportUnitFromTeam(String name) async {
    if (_database != null) {
      List<Map<String, dynamic>>? units = await _database?.rawQuery(
          "SELECT ${Data.relSupportUnit} FROM ${Data.relSupportTable} R INNER JOIN "
              "${Data.teamTable} T ON R.${Data.relSupportTeam}=T.${Data.teamName} "
              "WHERE T.${Data.teamName}=?",
          [name]
      );
      if (units != null)
        return List.generate(units.length, (i) { return units[i][Data.relSupportUnit]; });
      else return [];
    }
    return [];
  }
}