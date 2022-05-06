import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/queries/alias_queries.dart';
import 'package:optcteams/core/database/queries/ship_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/firebase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';

export 'package:optcteams/core/firebase/analytics_data.dart';

class UpdateQueries {
  final String _versionCollection = "version";
  FirebaseFirestore? _ref;

  UpdateQueries._() {
    _ref = FirebaseUtils.instance.dbRef;
  }

  static final UpdateQueries _instance = UpdateQueries._();

  /// Singleton instance of [UpdateQueries]
  static UpdateQueries get instance => _instance;

  Future<void> registerAnalyticsEvent(String event) async {
    if (!AdManager.test) await FirebaseAnalytics.instance.logEvent(name: event, parameters: null);
  }

  Future<String> getVersion(BuildContext context) async {
    String latestVersion = "";

    try {
      final Future<DocumentSnapshot>? ref = _ref?.collection(_versionCollection).doc("actual_version").get();
      await ref?.then((snapshot) {
        latestVersion = snapshot.get("version");
      });
    } catch (err) {
      return latestVersion;
    }
    return latestVersion;
  }

  Future<List<String>> getVersionNotes(BuildContext context) async {
    List<String> notes = [];

    try {
      final Future<DocumentSnapshot>? ref = _ref?.collection(_versionCollection).doc("notes").get();
      await ref?.then((snapshot) {
        notes = snapshot.get(Localizations.localeOf(context).languageCode).cast<String>();
      });
    } catch (err) {
      UI.showSnackBar(context, "errGeneral".tr());
    }
    return notes;
  }

  /// Firebase Units and Aliases Retrieval and Insertion

  Future<List<String>> getRecentUnits() async {
    try {
      DocumentSnapshot? r = await _ref?.collection("RECENT").doc("recent_units").get();
      List<String>? s = r?.get("units").cast<String>();
      if (s != null) {
        return s.reversed.toList();
      } else {
        return [];
      }
    } catch (err) {
      print("getRecentUnits: ${err.toString()}");
      return [];
    }
  }

  /// Update new units and aliases to Firebase
  ///
  /// If update of units, do it by hand on Firebase and manually on the next update
  /// of the app in here with the following code:
  ///
  ///    Unit u = await CustomDatabase.getUnit("ID");
  ///    // Change unit
  ///    await CustomDatabase.updateUnit(u);
  ///    See db > migration.dart
  Future<void> uploadNewData() async {
    Map<String, dynamic> units = {

    };

    List<String> unitsKeys = units.keys.toList();
    for (int x = 0; x < unitsKeys.length; x++) {
      await FirebaseFirestore.instance.collection(Data.unitPath).doc(unitsKeys[x]).set(units[unitsKeys[x]]);
    }

    Map<String, dynamic> aliases = {

    };

    List<String> aliasKeys = aliases.keys.toList();
    for (int x = 0; x < aliasKeys.length; x++) {
      await FirebaseFirestore.instance.collection(Data.aliasPath).doc(aliasKeys[x]).set(aliases[aliasKeys[x]]);
    }
  }

  Future<void> getAllUnitsAndAliasesFromFireStore(
      {required Function(String, double) onUpdate}) async {
    /// When uploaded, remove the for loop, clear updates.json and include all
    /// uploaded units/aliases/ships to insertion.json (outside file)
    ///
    /// updates.json or the units to be uploaded. All units must be provided
    /// with all fields in order to be updated along with the aliases.

    /// UNCOMMENT THIS TO UPLOAD NEW UNITS AND ALIASES
    /// await uploadNewData();

    try {
      onUpdate("checkingForUpdates".tr(), 0);
      int units = 0;
      int aliases = 0;
      int ships = 0;
      await UnitQueries.instance.getAllUnitsCount().then((u) { if (u != -1) units = u; });
      await AliasQueries.instance.getAllAliasesCount().then((a) { if (a != -1) aliases = a; });
      await ShipQueries.instance.getAllShipsCount().then((s) { if (s != -1) ships = s; });

      // Retrieves the document with the highest PK to see how many units there are
      QuerySnapshot? u = await _ref?.collection(Data.unitPath).orderBy(Data.unitKey, descending: true).limit(1).get();
      int fUnits = u?.docs[0].get(Data.unitKey);

      // Retrieves the document with the highest ID to see how many aliases there are
      QuerySnapshot? a = await _ref?.collection(Data.aliasPath).orderBy(Data.aliasKey, descending: true).limit(1).get();
      int fAliases = a?.docs[0].get(Data.aliasKey);

      // Retrieves the document with the highest PK to see how many ships there are
      QuerySnapshot? s = await _ref?.collection(Data.shipsPath).orderBy(Data.shipKey, descending: true).limit(1).get();
      int fShips = s?.docs[0].get(Data.shipKey);

      // Check if there are any storage utils units for updating them
      // Get the keys of units that do not have the url put yet and update the unit on db
      // then remove the key form Shared Preferences
      List<String>? keys = StorageUtils?.getKeysForUnits();
      if (keys != null) {
        for (int un = 0; un < keys.length; un++) {
          DocumentSnapshot? unit = await _ref?.collection(Data.unitPath).doc(keys[un]).get();
          if (unit != null && unit.get(Data.unitUrl) != "") {
            onUpdate("${((un/keys.length)*100).toStringAsFixed(2)}% ${"unitUpdates".tr()} (${keys.length})", un/keys.length);
            String unitId = StorageUtils.readData(keys[un], "");
            Unit dbUnit = await UnitQueries.instance.getUnit(unitId);
            dbUnit.url = unit.get(Data.unitUrl);
            await UnitQueries.instance.updateUnit(dbUnit);
            StorageUtils.removeKeyForUnit(keys[un]);
          }
        }
      }

      // If there are any new units added on Firebase, insert them
      if (units < fUnits) {
        int newUnits = fUnits - units;
        onUpdate("${"unitInsertion".tr()} ($newUnits)", 0);
        QuerySnapshot? un = await _ref?.collection(Data.unitPath)
            .orderBy(Data.unitKey, descending: true).limit(newUnits).get();
        if (un != null) {
          for (int unit = 0; unit < un.size; unit++) {
            // If the image is not yet provided, put Shared Preference for keep tracking
            if (un.docs[unit].get(Data.unitUrl) == "") {
              StorageUtils?.saveData(un.docs[unit].get(Data.unitKey).toString(), un.docs[unit].get(Data.unitId));
            }
            onUpdate("${((unit/newUnits)*100).toStringAsFixed(2)}% ${"unitInsertion".tr()} ($newUnits)", unit/newUnits);
            await UnitQueries.instance.insertUnit(
                un.docs[unit].get(Data.unitId),
                un.docs[unit].get(Data.unitName),
                un.docs[unit].get(Data.unitType),
                un.docs[unit].get(Data.unitUrl)
            );
          }
        }
      }

      // If there are any new aliases added on Firebase, insert them
      if (aliases < fAliases) {
        int newAliases = fAliases - aliases;
        onUpdate("${"aliasInsertion".tr()} ($newAliases)", 0);
        QuerySnapshot? an = await _ref?.collection(Data.aliasPath)
            .orderBy(Data.aliasKey, descending: true).limit(newAliases).get();
        if (an != null) {
          for (int alias = 0; alias < an.size; alias++) {
            onUpdate("${((alias/newAliases)*100).toStringAsFixed(2)}% ${"aliasInsertion".tr()} ($newAliases)", alias/newAliases);
            await AliasQueries.instance.insertAlias(
              an.docs[alias].get(Data.aliasUnitId),
              an.docs[alias].get(Data.aliasName),
            );
          }
        }
      }

      // If there are any new aliases added on Firebase, insert them
      if (ships < fShips) {
        int newShips = fShips - ships;
        onUpdate("${"shipInsertion".tr()} ($newShips)", 0);
        QuerySnapshot? sn = await _ref?.collection(Data.shipsPath)
            .orderBy(Data.shipKey, descending: true).limit(newShips).get();
        if (sn != null) {
          for (int ship = 0; ship < sn.size; ship++) {
            onUpdate("${((ship/newShips)*100).toStringAsFixed(2)}% ${"shipInsertion".tr()} ($newShips)", ship/newShips);
            await ShipQueries.instance.insertShip(
              sn.docs[ship].get(Data.shipId),
              sn.docs[ship].get(Data.shipName),
              sn.docs[ship].get(Data.shipUrl),
            );
          }
        }
      }
    } catch (err) {
      print("getAllUnitsAndAliasesFromFireStore: ${err.toString()}");
    }
  }
}