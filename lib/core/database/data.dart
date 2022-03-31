import 'dart:io';

class Data {
  static const int maxTeams = 60;
  static const int maxRumbleTeams = 60;
  static const int maxUnits = 100;

  static String get storeLink {
    if (Platform.isAndroid) return "https://play.google.com/store/apps/details?id=com.gabr.garc.optcteams";
    else if (Platform.isIOS) return "https://apps.apple.com/us/app/op-crew-planner/id1553879484";
    else return "";
  }

  static const List<String> legends = [
    "0261", "0367", "0416", "0459", "0530", "0562", "0578", "0649",
    "0669", "0718", "0720", "0748", "0870", "0935",
    "1001", "1035", "1045", "1085", "1121", "1123", "1192", "1240",
    "1268", "1314", "1362", "1391", "1404", "1413", "1434", "1445", "1473", "1492",
    "1532", "1543", "1571", "1588", "1593", "1610", "1619", "1652", "1663", "1698",
    "1707", "1747", "1751", "1763", "1764", "1794", "1816", "1832", "1847", "1869",
    "1880", "1881", "1883", "1910", "1921", "1922", "1927", "1928", "1935", "1951",
    "1985", "2001", "2007", "2023", "2025", "2034", "2035", "2066", "2074", "2076",
    "2099", "2113", "2138", "2148", "2159", "2181", "2195", "2201", "2232", "2234",
    "2236", "2245", "2251", "2265", "2300", "2302", "2330", "2338", "2357", "2363",
    "2365", "2372", "2373", "2418", "2433", "2434", "2441", "2444", "2446", "2465",
    "2475", "2477", "2500", "2505", "2534", "2536", "2561", "2577", "2578", "2588",
    "2601", "2603", "2631", "2651", "2672", "2681", "2686", "2700", "2739", "2741",
    "2774", "2776", "2784", "2797", "2802", "2804", "2814", "2830", "2835", "2837",
    "2860", "2862", "2868", "2895", "2897", "2909", "2930", "2954", "2958", "2960",
    "2962", "2964", "2980", "2982", "2991", "3007", "3009", "3018", "3027",
    "3038", "3048", "3065", "3071", "3073", "3079", "3100", "3102", "3118", "3135",
    "3154", "3157", "3164", "3166", "3175", "3177", "3202", "3204", "3211", "3225",
    "3227", "3240", "3245", "3253", "3278", "3280", "3282", "3334", "3336", "3338",
    "3349", "3346", "3350", "3355", "3357", "3376", "3378", "3391", "3393", "3403",
    "3405"
  ];

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
  static const String sailorLevel1 = "sailorLevel1";
  static const String sailorLevel2 = "sailorLevel2";
  static const String sailorCombined = "sailorCombined";
  static const String sailorCharacter1 = "sailorCharacter1";
  static const String sailorCharacter2 = "sailorCharacter2";
  static const String special = "special";
  static const String specialName = "specialName";
  static const String captain = "captain";
  static const String swap = "swap";
  static const String potentialOne = "potentialOne";
  static const String potentialTwo = "potentialTwo";
  static const String potentialThree = "potentialThree";
  static const String festAbility = "festAbility";
  static const String festSpecial = "festSpecial";
  static const String festResistance = "festResistance";
  static const String supportCharacters = "supportCharacters";
  static const String supportDescription = "supportDescription";
  static const String superSpecial = "superSpecial";
  static const String superSpecialCriteria = "superSpecialCriteria";
  static const String vsCondition = "vsCondition";
  static const String vsSpecial = "vsSpecial";
  static const String art = "art";
  static const String lastTapCondition = "lastTapCondition";
  static const String lastTapDescription = "lastTapDescription";

  static const String allType = "ALL";
  static const String strType = "STR";
  static const String qckType = "QCK";
  static const String dexType = "DEX";
  static const String psyType = "PSY";
  static const String intType = "INT";
}