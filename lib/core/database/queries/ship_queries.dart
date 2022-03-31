import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/database/models/ship.dart';
import 'package:sqflite/sqflite.dart';

class ShipQueries {
  Database? _database;

  ShipQueries._() {
    _database = CustomDatabase.instance.database;
  }

  static final ShipQueries _instance = ShipQueries._();

  /// Singleton instance of [ShipQueries]
  static ShipQueries get instance => _instance;

  Future<int> getAllShipsCount() async {
    if (_database != null) {
      List<Map<String, dynamic>> ?res = await _database?.query(Data.shipTable, columns: [Data.shipId]);
      return (res?.length ?? 0);
    }
    return -1;
  }

  Future<int> insertShip(String id, String name, String url) async {
    if (_database != null) {
      try {
        await _database?.insert(Data.shipTable, Ship(id: id, name: name, url: url).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
        return 0;
      } catch (err) {
        print("insertShip: ${err.toString()}");
        return -1;
      }
    } else return -2;
  }

  Future<Ship> getShip(String id) async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.shipTable, where: "${Data.shipId}=?", whereArgs: [id]);
      if (res != null)
        return Ship(id: res[0][Data.shipId], name: res[0][Data.shipName], url: res[0][Data.shipUrl]);
      else
        return Ship.empty;
    }
    return Ship.empty;
  }

  Future<List<Ship>> getShips() async {
    if (_database != null) {
      List<Map<String, dynamic>>? res = await _database?.query(Data.shipTable, orderBy: Data.shipId);
      if (res != null) return generateShipList(res);
      else return [];
    }
    return [];
  }

  Future<String> getShipOfTeam(String name) async {
    if (_database != null) {
      List<Map<String, dynamic>>? ship = await _database?.rawQuery(
          "SELECT ${Data.relShipShip} FROM ${Data.relShipTable} R INNER JOIN ${Data.teamTable} T ON R.${Data.relShipTeam}=T.${Data.teamName} "
              "WHERE T.${Data.teamName}=?",
          [name]
      );
      if (ship != null) return ship[0][Data.relShipShip];
      else return "";
    }
    return "";
  }

  static List<Ship> generateShipList(List<Map<String, dynamic>> res) {
    return List.generate(res.length, (i) {
      return Ship(id: res[i][Data.shipId], name: res[i][Data.shipName], url: res[i][Data.shipUrl]);
    });
  }
}