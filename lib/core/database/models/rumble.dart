import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/unit.dart';

part 'rumble.g.dart';

@JsonSerializable()
class RumbleTeam {
  @JsonKey(name: Data.rumbleTeamName)
  String name;
  @JsonKey(name: Data.rumbleTeamDescription)
  String description;
  @JsonKey(name: 'units')
  List<Unit> units;
  @JsonKey(name: Data.rumbleTeamUpdated)
  String? updated;
  @JsonKey(name: Data.rumbleTeamMode)
  int mode;

  RumbleTeam({required this.name, required this.description, this.units = const [],
    this.updated, required this.mode});

  factory RumbleTeam.empty() => RumbleTeam(name: "", description: "", mode: 0);
  factory RumbleTeam.fromJson(Map<String, dynamic> json) => _$RumbleTeamFromJson(json);
  Map<String, dynamic> toJson() => _$RumbleTeamToJson(this);

  /// Rumble team helper methods

  void setUpdated(String updated) { this.updated = updated; }

  Map<String, dynamic> toMap() {
    return {
      Data.rumbleTeamName: name,
      Data.rumbleTeamDescription: description,
      Data.rumbleTeamUpdated: updated,
      Data.rumbleTeamMode: mode
    };
  }

  bool compare(RumbleTeam b) {
    int result = 0;
    int units = 0;

    if (this.name == b.name) result++;
    if (this.description == b.description) result++;
    if (this.mode == b.mode) result++;

    for (int v = 0; v < this.units.length; v++) {
      if (this.units[v].compare(b.units[v],true)) units++;
    }

    return result == 3 && units == 8;
  }
}