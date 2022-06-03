import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';

part 'skills.g.dart';

@JsonSerializable()
class Skills {
  @JsonKey(name: Data.skillsTeam)
  final String team;
  @JsonKey(name: Data.skillsDamage)
  final int damageReduction;
  @JsonKey(name: Data.skillsSpecials)
  final int chargeSpecials;
  @JsonKey(name: Data.skillsBind)
  final int bindResistance;
  @JsonKey(name: Data.skillsDespair)
  final int despairResistance;
  @JsonKey(name: Data.skillsHeal)
  final int autoHeal;
  @JsonKey(name: Data.skillsRcv)
  final int rcvBoost;
  @JsonKey(name: Data.skillsSlot)
  final int slotsBoost;
  @JsonKey(name: Data.skillsMap)
  final int mapResistance;
  @JsonKey(name: Data.skillsPoison)
  final int poisonResistance;
  @JsonKey(name: Data.skillsResilience)
  final int resilience;

  const Skills(
      {this.team = "",
      this.damageReduction = 0,
      this.chargeSpecials = 0,
      this.bindResistance = 0,
      this.despairResistance = 0,
      this.autoHeal = 0,
      this.rcvBoost = 0,
      this.slotsBoost = 0,
      this.mapResistance = 0,
      this.poisonResistance = 0,
      this.resilience = 0});

  static const Skills empty = Skills(team: "");
  factory Skills.fromJson(Map<String, dynamic> json) => _$SkillsFromJson(json);
  Map<String, dynamic> toJson() => _$SkillsToJson(this);

  /// Skills helper methods

  static List<double> mapSkillsMax() {
    return [3, 2, 3, 3, 5, 5, 3, 2, 3, 3];
  }

  List<double> toList() {
    return [
      damageReduction.toDouble(),
      chargeSpecials.toDouble(),
      bindResistance.toDouble(),
      despairResistance.toDouble(),
      autoHeal.toDouble(),
      rcvBoost.toDouble(),
      slotsBoost.toDouble(),
      mapResistance.toDouble(),
      poisonResistance.toDouble(),
      resilience.toDouble()
    ];
  }

  bool compare(Skills b) {
    int result = 0;

    if (team == b.team) result++;
    if (damageReduction == b.damageReduction) result++;
    if (chargeSpecials == b.chargeSpecials) result++;
    if (bindResistance == b.bindResistance) result++;
    if (despairResistance == b.despairResistance) result++;
    if (autoHeal == b.autoHeal) result++;
    if (rcvBoost == b.rcvBoost) result++;
    if (slotsBoost == b.slotsBoost) result++;
    if (mapResistance == b.mapResistance) result++;
    if (poisonResistance == b.poisonResistance) result++;
    if (resilience == b.resilience) result++;

    return result == 11;
  }
}
