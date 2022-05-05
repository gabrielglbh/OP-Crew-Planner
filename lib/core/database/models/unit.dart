import 'package:json_annotation/json_annotation.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/utils/ui_utils.dart';

part 'unit.g.dart';

@JsonSerializable()
class Unit {
  @JsonKey(name: Data.unitName)
  String name;
  @JsonKey(name: Data.unitType)
  String type;
  @JsonKey(name: Data.unitId)
  String id;
  @JsonKey(name: Data.unitUrl)
  String? url;
  @JsonKey(name: Data.unitTaps)
  int taps;
  @JsonKey(name: Data.unitMaxLevel)
  int maxLevel;
  @JsonKey(name: Data.unitMaxLevelLimitBreak)
  int maxLevelLimitBreak;
  @JsonKey(name: Data.unitSkills)
  int skills;
  @JsonKey(name: Data.unitSpecialLevel)
  int specialLevel;
  @JsonKey(name: Data.unitCC)
  int cottonCandy;
  @JsonKey(name: Data.unitSupportLevel)
  int supportLevel;
  @JsonKey(name: Data.unitPotential)
  int potentialAbility;
  @JsonKey(name: Data.unitEvolution)
  int evolution;
  @JsonKey(name: Data.unitLimitBreak)
  int limitBreak;
  @JsonKey(name: Data.unitAvailable)
  int available;
  @JsonKey(name: Data.unitRumbleSpecial)
  int rumbleSpecial;
  @JsonKey(name: Data.unitRumbleAbility)
  int rumbleAbility;
  @JsonKey(name: Data.unitLastCheckedData)
  int? lastCheckedData;
  @JsonKey(name: Data.unitDataDownloaded)
  int? downloaded;

  Unit({required this.id, required this.name, required this.type, this.url, this.taps = 0,
    this.maxLevel = 0, this.skills = 0, this.specialLevel = 0, this.cottonCandy = 0,
    this.supportLevel = 0, this.potentialAbility = 0, this.evolution = 0, this.limitBreak = 0,
    this.available = 0, this.rumbleSpecial = 0, this.rumbleAbility = 0, this.lastCheckedData = 0,
    this.downloaded = 0, this.maxLevelLimitBreak = 0
  });

  factory Unit.empty() => Unit(id: "noimage", name: "", type: "", url: "res/units/noimage.png");
  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);

  /// Unit helper methods

  void setTaps(int taps) { this.taps = taps; }
  void setLastCheckedData(int lastCheckedData) { this.lastCheckedData = lastCheckedData; }
  void setAttributes(int maxLevel, int skills, int specialLevel,
      int cottonCandy, int supportLevel, int potentialAbility, int evolution, int limitBreak,
      int available, int rumbleSpecial, int rumbleAbility, int maxLevelLimitBreak) {
    this.maxLevel = maxLevel;
    this.maxLevelLimitBreak = maxLevelLimitBreak;
    this.skills = skills;
    this.specialLevel = specialLevel;
    this.cottonCandy = cottonCandy;
    this.supportLevel = supportLevel;
    this.potentialAbility = potentialAbility;
    this.evolution = evolution;
    this.limitBreak = limitBreak;
    this.available = available;
    this.rumbleSpecial = rumbleSpecial;
    this.rumbleAbility = rumbleAbility;
  }

  bool compare(Unit b, bool team) {
    int result = 0;

    if (name == b.name) result++;
    if (type == b.type) result++;
    if (id == b.id) result++;

    if (team) {
      return result == 3;
    } else {
      if (limitBreak == b.limitBreak) result++;
      if (cottonCandy == b.cottonCandy) result++;
      if (maxLevel == b.maxLevel) result++;
      if (maxLevelLimitBreak == b.maxLevelLimitBreak) result++;
      if (specialLevel == b.specialLevel) result++;
      if (supportLevel == b.supportLevel) result++;
      if (evolution == b.evolution) result++;
      if (skills == b.skills) result++;
      if (potentialAbility == b.potentialAbility) result++;
      if (available == b.available) result++;
      if (rumbleSpecial == b.rumbleSpecial) result++;
      if (rumbleAbility == b.rumbleAbility) result++;
      return result == 15;
    }
  }

  /// Follows the architecture of Firebase Storage:
  ///
  /// : units
  ///   -> 0 (first digit of the id)
  ///       -> 000 (last 3 digits)
  ///       -> 100
  ///   -> 1
  ///       ...
  String getUrlOfUnitImage() {
    const String res = "res/units/";
    switch (id) {
      case 'noimage': return res + 'noimage.png';
      case 'str_none': return res + 'str_none.png';
      case 'dex_none': return res + 'dex_none.png';
      case 'qck_none': return res + 'qck_none.png';
      case 'psy_none': return res + 'psy_none.png';
      case 'int_none': return res + 'int_none.png';
      default:
        return UI.getThumbnail(id);
    }
  }
}