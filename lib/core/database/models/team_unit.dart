import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'team_unit.g.dart';

@JsonSerializable()
class TeamUnit {
  @JsonKey(name: Data.relUnitTeam)
  String teamId;
  @JsonKey(name: Data.relUnitUnit)
  String unitId;

  TeamUnit({required this.teamId, required this.unitId});

  factory TeamUnit.fromJson(Map<String, dynamic> json) =>
      _$TeamUnitFromJson(json);
  Map<String, dynamic> toJson() => _$TeamUnitToJson(this);
}
