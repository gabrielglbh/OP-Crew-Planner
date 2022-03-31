import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'teamShip.g.dart';

@JsonSerializable()
class TeamShip {
  @JsonKey(name: Data.relShipTeam)
  String teamId;
  @JsonKey(name: Data.relShipShip)
  String shipId;

  TeamShip({required this.teamId, required this.shipId});

  factory TeamShip.fromJson(Map<String, dynamic> json) => _$TeamShipFromJson(json);
  Map<String, dynamic> toJson() => _$TeamShipToJson(this);
}