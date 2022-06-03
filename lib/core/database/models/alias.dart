import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'alias.g.dart';

@JsonSerializable()
class Alias {
  @JsonKey(name: Data.aliasUnitId)
  String unitId;
  @JsonKey(name: Data.aliasName)
  String alias;

  Alias({required this.unitId, required this.alias});

  factory Alias.fromJson(Map<String, dynamic> json) => _$AliasFromJson(json);
  Map<String, dynamic> toJson() => _$AliasToJson(this);
}
