import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

class Objectify {
  List<Team> teams;
  List<RumbleTeam> rumbleTeams;
  List<Unit> units;
  List<Unit> history;
  String lastUpdated;

  Objectify({this.teams = const [], this.rumbleTeams = const [], this.units = const [],
    this.history = const [], this.lastUpdated = ""});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> arrayUnits = [];
    for(int y = 0; y < units.length; y++) arrayUnits.add(units[y].toJson());
    List<Map<String, dynamic>> arrayHistory = [];
    for(int y = 0; y < history.length; y++) arrayHistory.add(history[y].toJson());
    List<Map<String, dynamic>> arrayTeams = [];
    for(int y = 0; y < teams.length; y++) arrayTeams.add(teams[y].toJson());
    List<Map<String, dynamic>> arrayRumbleTeams = [];
    for(int y = 0; y < rumbleTeams.length; y++) arrayRumbleTeams.add(rumbleTeams[y].toJson());
    Map<String, dynamic> obj =  {
      'updated': lastUpdated,
      'units': arrayUnits,
      'teams': arrayTeams,
      'history': arrayHistory,
      'rumble': arrayRumbleTeams
    };
    // First, encode the map to a JSON String to format it and then decode it to a Map
    return json.decode(json.encode(obj));
  }

  List<Unit> fromJsonUnits(Map<String, dynamic> json) {
    List<dynamic> jsonUnits = json['units'];
    List<Unit> parsedUnits = [];
    for(int y = 0; y < jsonUnits.length; y++) parsedUnits.add(Unit.fromJson(jsonUnits[y]));
    return parsedUnits;
  }

  List<Unit> fromJsonHistory(Map<String, dynamic> json) {
    List<dynamic> jsonHistory = json['history'];
    List<Unit> parsedHistory = [];
    for(int y = 0; y < jsonHistory.length; y++) parsedHistory.add(Unit.fromJson(jsonHistory[y]));
    return parsedHistory;
  }

  List<Team> fromJsonTeams(Map<String, dynamic> json) {
    List<dynamic> jsonTeams = json['teams'];
    List<Team> parsedTeams = [];
    for(int y = 0; y < jsonTeams.length; y++) parsedTeams.add(Team.fromJson(jsonTeams[y]));
    return parsedTeams;
  }

  List<RumbleTeam> fromJsonRumbleTeams(Map<String, dynamic> json) {
    List<dynamic> jsonRumbleTeams = json['rumble'];
    List<RumbleTeam> parsedRumbleTeams = [];
    for(int y = 0; y < jsonRumbleTeams.length; y++) parsedRumbleTeams.add(RumbleTeam.fromJson(jsonRumbleTeams[y]));
    return parsedRumbleTeams;
  }

  String fromJsonUpdated(Map<String, dynamic>? json) {
    if (json == null) return "errNoData".tr();
    else return json['updated'].toString();
  }
}