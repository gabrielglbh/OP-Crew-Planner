import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/database/models/unitInfo.dart';
import 'package:optcteams/core/database/queries/backup_queries.dart';
import 'package:optcteams/core/database/queries/rumble_team_queries.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/database/queries/unit_queries.dart';
import 'package:optcteams/core/firebase/firebase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/firebase/models/objectify.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/ui/pages/main/units/enum_unit_filters.dart';

class BackUpRecords {
  final String _collection = "users";
  FirebaseFirestore? _ref;
  FirebaseAuth? _auth;

  BackUpRecords._() {
    _ref = FirebaseUtils.instance.dbRef;
    _auth = FirebaseUtils.instance.authRef;
  }

  static final BackUpRecords _instance = BackUpRecords._();

  /// Singleton instance of [BackUpRecords]
  static BackUpRecords get instance => _instance;

  Future<void> uploadToFireStore(BuildContext context, Function(String) updateUI) async {
    User? _user = _auth?.currentUser;
    await _user?.reload();
    if (_user != null) {
      if (_user.emailVerified) {
        DateTime parser = DateTime.parse(DateTime.now().toString());
        String minute = parser.minute < 10 ? "0${parser.minute}" : parser.minute.toString();
        String hour = parser.hour < 10 ? "0${parser.hour}" : parser.hour.toString();
        String date = "$hour:$minute - ${parser.day}/${parser.month}/${parser.year}";

        List<Team> teams = await TeamQueries.instance.getAllTeams();
        List<RumbleTeam> rumble = await RumbleTeamQueries.instance.getAllRumbleTeams();
        List<Unit> units = await UnitQueries.instance.getUnitsToBeMaxedOut(UnitFilter.all);
        List<Unit> history = await UnitQueries.instance.getMostRecentSearchedUnits();

        if (teams.isEmpty && rumble.isEmpty && units.isEmpty && history.isEmpty) {
          UI.showSnackBar(context, "errDataEmpty".tr());
        } else {
          Objectify obj = Objectify(teams: teams, rumbleTeams: rumble,
            units: units, history: history, lastUpdated: date.toString());

          try {
            await _ref?.collection(_collection).doc(_user.uid).set(obj.toJson());
            await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.createdBackUp);
            updateUI(date);
            UI.showSnackBar(context, "dataCreated".tr());
          } catch (e) {
            UI.showSnackBar(context, "errGeneral".tr());
          }
        }
      } else {
        UI.showSnackBar(context, "errEmailNotVerified".tr());
      }
    }
  }

  Future<void> getFromFireStore(BuildContext context) async {
    User? _user = _auth?.currentUser;
    if (_user != null) {
      if (_user.emailVerified) {
        List<Team> teams = await TeamQueries.instance.getAllTeams();
        List<RumbleTeam> rumbleTeams = await RumbleTeamQueries.instance.getAllRumbleTeams();
        List<Unit> units = await UnitQueries.instance.getUnitsToBeMaxedOut(UnitFilter.all);
        List<Unit> history = await UnitQueries.instance.getMostRecentSearchedUnits();

        try {
          await _ref?.collection(_collection).doc(_user.uid).get().then((snapshot) async {
            Map<String, dynamic>? backup = snapshot.data();
            if (backup != null) {
              Objectify obj = Objectify();
              List<Unit> backupUnits = obj.fromJsonUnits(backup);
              List<Unit> backupHistory = [];
              List<Team> backupTeams = obj.fromJsonTeams(backup);
              List<RumbleTeam> backupRumbleTeams = [];
              // If users have no data of rumble teams on the backup, the insert empty data
              try {
                backupRumbleTeams = obj.fromJsonRumbleTeams(backup);
              } catch (err) {
                print("getFromFireStore 1: ${err.toString()}");
                print("No rumble teams on backup, creating empty rumble teams array");
              }
              // Update 3.0.0: Generating empty downloaded and lastCheckedData fields
              try {
                backupHistory = obj.fromJsonHistory(backup);
              } catch (err) {
                print("getFromFireStore 2: ${err.toString()}");
                print("No history available, creating empty history array");
              }
              // If units saved on to-be-maxed list are on history, keep them
              backupUnits.forEach((unit) {
                unit.lastCheckedData = unit.lastCheckedData == null ? 0 : unit.lastCheckedData;
                unit.downloaded = unit.downloaded == null ? 0 : unit.downloaded;
              });

              await BackUpQueries.instance.insertDataFromBackup(units, teams, rumbleTeams, history,
                  backupUnits, backupTeams, backupRumbleTeams, backupHistory).then((successful) async {
                if (successful) {
                  await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.downloadedBackUp);
                  UI.showSnackBar(context, "dataDownloaded".tr());
                } else {
                  UI.showSnackBar(context, "errGeneral".tr());
                }
              });
            } else {
              UI.showSnackBar(context, "errGeneral".tr());
            }
          });
        } catch (err) {
          UI.showSnackBar(context, "errGeneral".tr());
        }
      } else {
        UI.showSnackBar(context, "errEmailNotVerified".tr());
      }
    }
  }

  Future<void> deleteBackUp(BuildContext context) async {
    User? _user = _auth?.currentUser;
    if (_user != null) {
      if (_user.emailVerified) {
        try {
          await _ref?.collection(_collection).doc(_user.uid).delete();
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deletedBackUp);
          UI.showSnackBar(context, "dataDeleted".tr());
        } catch (e) {
          UI.showSnackBar(context, "errGeneral".tr());
        }
      } else {
        UI.showSnackBar(context, "errEmailNotVerified".tr());
      }
    }
  }

  Future<void> getLastBackupTime(Function(String) updateUI) async {
    User? _user = _auth?.currentUser;
    if (_user != null) {
      await _ref?.collection(_collection).doc(_user.uid).get().then((snapshot) {
        Map<String, dynamic>? backup = snapshot.data();
        Objectify obj = Objectify();
        String date = obj.fromJsonUpdated(backup);
        updateUI(date);
      });
    }
  }

  Future<UnitInfo?> getUnitAdditionalInfo(String uid) async {
    UnitInfo? info;
    try {
      await _ref?.collection("details").doc(uid).get().then((snapshot) async {
        if (snapshot.exists && snapshot.data() != null) info = UnitInfo.fromJson(snapshot.data()!);
      });
      return info;
    } catch (err) {
      print("getUnitAdditionalInfo: ${err.toString()}");
      return null;
    }
  }
}