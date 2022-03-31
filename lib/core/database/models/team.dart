import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/ship.dart';
import 'package:optcteams/core/database/models/skills.dart';
import 'package:optcteams/core/database/models/unit.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  @JsonKey(name: Data.teamName)
  String name;
  @JsonKey(name: Data.teamDescription)
  String description;
  @JsonKey(name: 'units')
  List<Unit> units;
  @JsonKey(name: 'supports')
  List<Unit> supports;
  @JsonKey(name: 'ship')
  Ship ship;
  @JsonKey(name: 'skills')
  Skills skills;
  @JsonKey(name: Data.teamMaxed)
  int? maxed;
  @JsonKey(name: Data.teamUpdated)
  String? updated;

  Team({required this.name, required this.description, this.units = const [],
    this.supports = const [], this.ship = Ship.empty, this.skills = Skills.empty,
    this.maxed, this.updated});

  /// Team Json methods

  factory Team.empty() => Team(name: "", description: "");
  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);

  /// Team helper methods

  void setMaxed(int isMaxed) { this.maxed = isMaxed; }
  void setUpdated(String updated) { this.updated = updated; }

  Map<String, dynamic> toMap() {
    return {
      Data.teamName: name,
      Data.teamDescription: description,
      Data.teamMaxed: maxed,
      Data.teamUpdated: updated
    };
  }

  bool compare(Team b) {
    int result = 0;
    int units = 0;

    if (this.name == b.name) result++;
    if (this.description == b.description) result++;
    if (this.ship.compare(b.ship)) result++;
    if (this.skills.compare(b.skills)) result++;

    for (int v = 0; v < this.units.length; v++) {
      if (this.units[v].compare(b.units[v],true)) units++;
      if (this.supports[v].compare(b.supports[v], true)) units++;
    }

    return result == 4 && units == 12;
  }
}