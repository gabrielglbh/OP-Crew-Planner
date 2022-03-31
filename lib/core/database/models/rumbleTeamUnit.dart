import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'rumbleTeamUnit.g.dart';

@JsonSerializable()
class RumbleTeamUnit {
  @JsonKey(name: Data.relRumbleUnitTeam)
  String teamId;
  @JsonKey(name: Data.relRumbleUnitUnit)
  String unitId;

  RumbleTeamUnit({required this.teamId, required this.unitId});

  factory RumbleTeamUnit.fromJson(Map<String, dynamic> json) => _$RumbleTeamUnitFromJson(json);
  Map<String, dynamic> toJson() => _$RumbleTeamUnitToJson(this);
}