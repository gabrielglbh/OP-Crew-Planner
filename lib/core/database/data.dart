import 'dart:io';

class Data {
  static const int maxTeams = 60;
  static const int maxRumbleTeams = 60;
  static const int maxUnits = 100;

  static String get storeLink {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.gabr.garc.optcteams";
    } else if (Platform.isIOS) {
      return "https://apps.apple.com/us/app/op-crew-planner/id1553879484";
    } else {
      return "";
    }
  }

  static const String unitPath = "UNITS";
  static const String aliasPath = "ALIASES";
  static const String shipsPath = "SHIPS";

  static const String unitKey = "pk";
  static const String shipKey = "pk";
  static const String aliasKey = "id";

  static const String unitTable = "UNIT";
  static const String unitName = "name";
  static const String unitType = "type";
  static const String unitId = "id";
  static const String unitUrl = "url";
  static const String unitTaps = "taps";
  static const String unitCC = "cottonCandy";
  static const String unitSpecialLevel = "specialLevel";
  static const String unitLimitBreak = "limitBreak";
  static const String unitMaxLevel = "maxLevel";
  static const String unitMaxLevelLimitBreak = "unitMaxLevelLimitBreak";
  static const String unitSupportLevel = "supportLevel";
  static const String unitEvolution = "evolution";
  static const String unitSkills = "skills";
  static const String unitPotential = "potentialAbility";
  static const String unitAvailable = "available";
  static const String unitRumbleSpecial = "rumbleSpecial";
  static const String unitRumbleAbility = "rumbleAbility";
  static const String unitLastCheckedData = "lastCheckedData";
  static const String unitDataDownloaded = "downloaded";

  static const String aliasTable = "ALIASES";
  static const String aliasId = "id";
  static const String aliasUnitId = "unitId";
  static const String aliasName = "alias";

  static const String shipTable = "SHIP";
  static const String shipId = "id";
  static const String shipName = "name";
  static const String shipUrl = "url";

  static const String relUnitTable = "TEAM_UNIT";
  static const String relUnitId = "id";
  static const String relUnitTeam = "teamId";
  static const String relUnitUnit = "unitId";

  static const String relSupportTable = "TEAM_SUPPORT_UNIT";
  static const String relSupportId = "id";
  static const String relSupportTeam = "teamId";
  static const String relSupportUnit = "unitId";

  static const String relShipTable = "TEAM_SHIP";
  static const String relShipId = "id";
  static const String relShipTeam = "teamId";
  static const String relShipShip = "shipId";

  static const String teamTable = "TEAM";
  static const String teamName = "name";
  static const String teamDescription = "description";
  static const String teamMaxed = "maxed";
  static const String teamUpdated = "updated";

  static const String rumbleTeamTable = "RUMBLE_TEAM";
  static const String rumbleTeamName = "name";
  static const String rumbleTeamDescription = "description";
  static const String rumbleTeamUpdated = "updated";
  static const String rumbleTeamMode = "mode";

  static const String relRumbleUnitTable = "RUMBLE_TEAM_UNIT";
  static const String relRumbleUnitId = "id";
  static const String relRumbleUnitTeam = "teamId";
  static const String relRumbleUnitUnit = "unitId";

  static const String skillsTable = "SKILLS";
  static const String skillsId = "id";
  static const String skillsTeam = "team";
  static const String skillsDamage = "damageReduction";
  static const String skillsSpecials = "chargeSpecials";
  static const String skillsBind = "bindResistance";
  static const String skillsDespair = "despairResistance";
  static const String skillsHeal = "autoHeal";
  static const String skillsRcv = "rcvBoost";
  static const String skillsSlot = "slotsBoost";
  static const String skillsMap = "mapResistance";
  static const String skillsPoison = "poisonResistance";
  static const String skillsResilience = "resilience";

  static const String dataTable = "DATA";
  static const String dataUnitId = "unitId";
  static const String sailorBase = "sailorBase";
  static const String llbSailorBase = "llbSailorBase";
  static const String sailorLevel1 = "sailorLevel1";
  static const String llbSailorLevel1 = "llbSailorLevel1";
  static const String sailorLevel2 = "sailorLevel2";
  static const String llbSailorLevel2 = "llbSailorLevel2";
  static const String sailorCombined = "sailorCombined";
  static const String llbSailorCombined = "llbSailorCombined";
  static const String sailorCharacter1 = "sailorCharacter1";
  static const String llbSailorCharacter1 = "llbSailorCharacter1";
  static const String sailorCharacter2 = "sailorCharacter2";
  static const String llbSailorCharacter2 = "llbSailorCharacter2";
  static const String special = "special";
  static const String llbSpecial = "llbSpecial";
  static const String specialName = "specialName";
  static const String captain = "captain";
  static const String llbCaptain = "llbCaptain";
  static const String swap = "swap";
  static const String potentialOne = "potentialOne";
  static const String potentialTwo = "potentialTwo";
  static const String potentialThree = "potentialThree";
  static const String festAbility = "festAbility";
  static const String festSpecial = "festSpecial";
  static const String festResistance = "festResistance";
  static const String llbFestAbility = "llbFestAbility";
  static const String llbFestSpecial = "llbFestSpecial";
  static const String llbFestResistance = "llbFestResistance";
  static const String supportCharacters = "supportCharacters";
  static const String supportDescription = "supportDescription";
  static const String superSpecial = "superSpecial";
  static const String superSpecialCriteria = "superSpecialCriteria";
  static const String vsCondition = "vsCondition";
  static const String vsSpecial = "vsSpecial";
  static const String art = "art";
  static const String lastTapCondition = "lastTapCondition";
  static const String lastTapDescription = "lastTapDescription";
  static const String superTandemCondition = "superTandemCondition";
  static const String superTandemDescription = "superTandemDescription";
  static const String gpStatsBurst = "gpBurst";
  static const String gpStatsBurstCondition = "gpBurstCondition";
  static const String gpStatsLeaderSkill = "gpLeaderSkill";
  static const String rushCondition = "rushCondition";
  static const String rushDescription = "rushDescription";
  static const String rushStats = "rushStats";

  static const String allType = "ALL";
  static const String strType = "STR";
  static const String qckType = "QCK";
  static const String dexType = "DEX";
  static const String psyType = "PSY";
  static const String intType = "INT";
}
