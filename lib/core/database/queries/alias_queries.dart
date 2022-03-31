import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/alias.dart';
import 'package:sqflite/sqflite.dart';

class AliasQueries {
  Database? _database;

  AliasQueries._() {
    _database = CustomDatabase.instance.database;
  }

  static final AliasQueries _instance = AliasQueries._();

  /// Singleton instance of [AliasQueries]
  static AliasQueries get instance => _instance;

  Future<int> getAllAliasesCount() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.aliasTable, columns: [Data.aliasId]);
      return (res?.length ?? 0);
    }
    return -1;
  }

  Future<int> insertAlias(String id, String alias) async {
    if (_database != null) {
      try {
        await _database?.insert(Data.aliasTable, Alias(unitId: id, alias: alias).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        return 0;
      } catch (err) {
        print("insertAlias: ${err.toString()}");
        return -1;
      }
    } else return -2;
  }
}