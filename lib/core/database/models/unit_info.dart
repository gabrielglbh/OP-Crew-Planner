import 'package:optcteams/core/database/data.dart';

class UnitInfo {
  Map<String, dynamic>? sailor;
  String? special;
  String? specialName;
  String? captain;
  String? swap;
  List<String> potential;
  String? festAbility;
  String? festSpecial;
  String? festResistance;
  Map<String, dynamic>? support;
  String? superSpecial;
  String? superSpecialCriteria;
  String? vsCondition;
  String? vsSpecial;
  String? art;
  String? lastTapCondition;
  String? lastTapDescription;
  String? superTandemCondition;
  String? superTandemDescription;
  // Level Limit Break
  String? llbCaptain;
  String? llbSpecial;
  String? llbFestAbility;
  String? llbFestSpecial;
  String? llbFestResistance;
  // GP Stats
  Map<String, dynamic>? gpStats;
  // GP Stats
  Map<String, dynamic>? rush;
  // Only for Device's Database
  String? unitId;

  // Fields for consistency
  static const String fCaptain = "captain";
  static const String fLLBCaptain = "llbCaptain";
  static const String fSpecial = "special";
  static const String fLLBSpecial = "llbSpecial";
  static const String fSpecialName = "specialName";
  static const String fSailor = "sailor";
  static const String fSailorBase = "base";
  static const String fLLBSailorBase = "llbBase";
  static const String fSailorLevel1 = "level1";
  static const String fLLBSailorLevel1 = "llbLevel1";
  static const String fSailorLevel2 = "level2";
  static const String fLLBSailorLevel2 = "llbLevel2";
  static const String fSailorCombined = "combined";
  static const String fLLBSailorCombined = "llbCombined";
  static const String fSailorChar1 = "character1";
  static const String fLLBSailorCharacter1 = "llbCharacter1";
  static const String fSailorChar2 = "character2";
  static const String fLLBSailorCharacter2 = "llbCharacter2";
  static const String fSwap = "swap";
  static const String fFestAbility = "festAbility";
  static const String fFestSpecial = "festSpecial";
  static const String fFestResist = "festResistance";
  static const String fLLBFestAbility = "llbFestAbility";
  static const String fLLBFestSpecial = "llbFestSpecial";
  static const String fLLBFestResist = "llbFestResistance";
  static const String fPotential = "potential";
  static const String fSupport = "support";
  static const String fSupChars = "Characters";
  static const String fSupDescription = "description";
  static const String fSuperSpecial = "superSpecial";
  static const String fSuperCriteria = "superSpecialCriteria";
  static const String fVSCondition = "VSCondition";
  static const String fVSSpecial = "VSSpecial";
  static const String fArt = "art";
  static const String fLastTapCondition = "lastTapCondition";
  static const String fLastTapDescription = "lastTapDescription";
  static const String fSuperTandemCondition = "superTandemCondition";
  static const String fSuperTandemDescription = "superTandemDescription";
  static const String fGPStats = "gpStats";
  static const String fGPStatsBurst = "gpBurst";
  static const String fGPStatsBurstCondition = "gpBurstCondition";
  static const String fGPStatsLeaderSkill = "gpLeaderSkill";
  static const String fRush = "rush";
  static const String fRushDescription = "rushDescription";
  static const String fRushCondition = "rushCondition";
  static const String fRushStats = "rushStats";

  UnitInfo({
    this.sailor,
    this.special,
    this.specialName,
    this.captain,
    this.swap,
    this.potential = const [],
    this.festAbility,
    this.festSpecial,
    this.festResistance,
    this.support,
    this.superSpecial,
    this.superSpecialCriteria,
    this.vsSpecial,
    this.vsCondition,
    this.art,
    this.unitId,
    this.lastTapCondition,
    this.lastTapDescription,
    this.llbCaptain,
    this.llbSpecial,
    this.llbFestSpecial,
    this.llbFestAbility,
    this.llbFestResistance,
    this.superTandemCondition,
    this.superTandemDescription,
    this.gpStats,
    this.rush,
  });

  bool isEqualTo(UnitInfo b) {
    return sailor?.length == b.sailor?.length &&
        special == b.special &&
        specialName == b.specialName &&
        captain == b.captain &&
        swap == b.swap &&
        potential.length == b.potential.length &&
        festAbility == b.festAbility &&
        festSpecial == b.festSpecial &&
        festResistance == b.festResistance &&
        support?.length == b.support?.length &&
        superSpecial == b.superSpecial &&
        superSpecialCriteria == b.superSpecialCriteria &&
        vsCondition == b.vsCondition &&
        vsSpecial == b.vsSpecial &&
        art == b.art &&
        lastTapCondition == b.lastTapCondition &&
        lastTapDescription == b.lastTapDescription &&
        unitId == b.unitId &&
        llbCaptain == b.llbCaptain &&
        llbSpecial == b.llbSpecial &&
        llbFestSpecial == b.llbFestSpecial &&
        llbFestAbility == b.llbFestAbility &&
        llbFestResistance == b.llbFestResistance &&
        superTandemCondition == b.superTandemCondition &&
        superTandemDescription == b.superTandemDescription &&
        gpStats?.length == b.gpStats?.length &&
        rush?.length == b.rush?.length;
  }

  factory UnitInfo.empty() => UnitInfo(
        sailor: {},
        special: "",
        specialName: "",
        captain: "",
        swap: "",
        potential: [],
        festAbility: "",
        festResistance: "",
        festSpecial: "",
        support: {},
        superSpecial: "",
        superSpecialCriteria: "",
        vsCondition: "",
        vsSpecial: "",
        art: "",
        lastTapCondition: "",
        lastTapDescription: "",
        llbCaptain: "",
        llbSpecial: "",
        llbFestSpecial: "",
        llbFestAbility: "",
        llbFestResistance: "",
        superTandemCondition: "",
        superTandemDescription: "",
        gpStats: {},
        rush: {},
      );

  factory UnitInfo.fromJson(Map<String, dynamic> json) {
    return UnitInfo(
      sailor: json[fSailor] ?? {},
      special: json[fSpecial] ?? "",
      specialName: json[fSpecialName] ?? "",
      captain: json[fCaptain] ?? "",
      swap: json[fSwap] ?? "",
      potential:
          json[fPotential] == null ? [] : json[fPotential].cast<String>(),
      festAbility: json[fFestAbility] ?? "",
      festResistance: json[fFestResist] ?? "",
      festSpecial: json[fFestSpecial] ?? "",
      support: json[fSupport] == null ? {} : json[fSupport][0],
      superSpecial: json[fSuperSpecial] ?? "",
      superSpecialCriteria: json[fSuperCriteria] ?? "",
      vsCondition: json[fVSCondition] ?? "",
      vsSpecial: json[fVSSpecial] ?? "",
      art: json[fArt] ?? "",
      lastTapCondition: json[fLastTapCondition] ?? "",
      lastTapDescription: json[fLastTapDescription] ?? "",
      llbCaptain: json[fLLBCaptain] ?? "",
      llbSpecial: json[fLLBSpecial] ?? "",
      llbFestAbility: json[fLLBFestAbility] ?? "",
      llbFestResistance: json[fLLBFestResist] ?? "",
      llbFestSpecial: json[fLLBFestSpecial] ?? "",
      superTandemCondition: json[fSuperTandemCondition] ?? "",
      superTandemDescription: json[fSuperTandemDescription] ?? "",
      gpStats: json[fGPStats] ?? {},
      rush: json[fRush] ?? {},
    );
  }

  // Only for Device's Database
  Map<String, dynamic> toJson() {
    if (potential.isEmpty) {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] ?? "",
        Data.llbSailorBase: sailor?[fLLBSailorBase] ?? "",
        Data.sailorLevel1: sailor?[fSailorLevel1] ?? "",
        Data.llbSailorLevel1: sailor?[fLLBSailorLevel1] ?? "",
        Data.sailorLevel2: sailor?[fSailorLevel2] ?? "",
        Data.llbSailorLevel2: sailor?[fLLBSailorLevel2] ?? "",
        Data.sailorCombined: sailor?[fSailorCombined] ?? "",
        Data.llbSailorCombined: sailor?[fLLBSailorCombined] ?? "",
        Data.sailorCharacter1: sailor?[fSailorChar1] ?? "",
        Data.llbSailorCharacter1: sailor?[fLLBSailorCharacter1] ?? "",
        Data.sailorCharacter2: sailor?[fSailorChar2] ?? "",
        Data.llbSailorCharacter2: sailor?[fLLBSailorCharacter2] ?? "",
        Data.special: special ?? "",
        Data.llbSpecial: llbSpecial ?? "",
        Data.specialName: specialName ?? "",
        Data.captain: captain ?? "",
        Data.llbCaptain: llbCaptain ?? "",
        Data.swap: swap ?? "",
        Data.potentialOne: "",
        Data.potentialTwo: "",
        Data.potentialThree: "",
        Data.festAbility: festAbility ?? "",
        Data.festResistance: festResistance ?? "",
        Data.festSpecial: festSpecial ?? "",
        Data.supportCharacters: support?[fSupChars] ?? "",
        Data.supportDescription: support?[fSupDescription] ?? "",
        Data.superSpecial: superSpecial ?? "",
        Data.superSpecialCriteria: superSpecialCriteria ?? "",
        Data.vsCondition: vsCondition ?? "",
        Data.vsSpecial: vsSpecial ?? "",
        Data.art: art ?? "",
        Data.lastTapCondition: lastTapCondition ?? "",
        Data.lastTapDescription: lastTapDescription ?? "",
        Data.llbFestAbility: llbFestAbility ?? "",
        Data.llbFestResistance: llbFestResistance ?? "",
        Data.llbFestSpecial: llbFestSpecial ?? "",
        Data.superTandemCondition: superTandemCondition ?? "",
        Data.superTandemDescription: superTandemDescription ?? "",
        Data.gpStatsBurst: gpStats?[fGPStatsBurst] ?? "",
        Data.gpStatsBurstCondition: gpStats?[fGPStatsBurstCondition] ?? "",
        Data.gpStatsLeaderSkill: gpStats?[fGPStatsLeaderSkill] ?? "",
        Data.rushCondition: gpStats?[fRushCondition] ?? "",
        Data.rushDescription: gpStats?[fRushDescription] ?? "",
        Data.rushStats: gpStats?[fRushStats] ?? "",
      };
    } else if (potential[0] != "" && potential[1] == "" && potential[2] == "") {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] ?? "",
        Data.llbSailorBase: sailor?[fLLBSailorBase] ?? "",
        Data.sailorLevel1: sailor?[fSailorLevel1] ?? "",
        Data.llbSailorLevel1: sailor?[fLLBSailorLevel1] ?? "",
        Data.sailorLevel2: sailor?[fSailorLevel2] ?? "",
        Data.llbSailorLevel2: sailor?[fLLBSailorLevel2] ?? "",
        Data.sailorCombined: sailor?[fSailorCombined] ?? "",
        Data.llbSailorCombined: sailor?[fLLBSailorCombined] ?? "",
        Data.sailorCharacter1: sailor?[fSailorChar1] ?? "",
        Data.llbSailorCharacter1: sailor?[fLLBSailorCharacter1] ?? "",
        Data.sailorCharacter2: sailor?[fSailorChar2] ?? "",
        Data.llbSailorCharacter2: sailor?[fLLBSailorCharacter2] ?? "",
        Data.special: special ?? "",
        Data.llbSpecial: llbSpecial ?? "",
        Data.specialName: specialName ?? "",
        Data.captain: captain ?? "",
        Data.llbCaptain: llbCaptain ?? "",
        Data.swap: swap ?? "",
        Data.potentialOne: potential[0],
        Data.potentialTwo: "",
        Data.potentialThree: "",
        Data.festAbility: festAbility ?? "",
        Data.festResistance: festResistance ?? "",
        Data.festSpecial: festSpecial ?? "",
        Data.supportCharacters: support?[fSupChars] ?? "",
        Data.supportDescription: support?[fSupDescription] ?? "",
        Data.superSpecial: superSpecial ?? "",
        Data.superSpecialCriteria: superSpecialCriteria ?? "",
        Data.vsCondition: vsCondition ?? "",
        Data.vsSpecial: vsSpecial ?? "",
        Data.art: art ?? "",
        Data.lastTapCondition: lastTapCondition ?? "",
        Data.lastTapDescription: lastTapDescription ?? "",
        Data.llbFestAbility: llbFestAbility ?? "",
        Data.llbFestResistance: llbFestResistance ?? "",
        Data.llbFestSpecial: llbFestSpecial ?? "",
        Data.superTandemCondition: superTandemCondition ?? "",
        Data.superTandemDescription: superTandemDescription ?? "",
        Data.gpStatsBurst: gpStats?[fGPStatsBurst] ?? "",
        Data.gpStatsBurstCondition: gpStats?[fGPStatsBurstCondition] ?? "",
        Data.gpStatsLeaderSkill: gpStats?[fGPStatsLeaderSkill] ?? "",
        Data.rushCondition: gpStats?[fRushCondition] ?? "",
        Data.rushDescription: gpStats?[fRushDescription] ?? "",
        Data.rushStats: gpStats?[fRushStats] ?? "",
      };
    } else if (potential[0] != "" && potential[1] != "" && potential[2] == "") {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] ?? "",
        Data.llbSailorBase: sailor?[fLLBSailorBase] ?? "",
        Data.sailorLevel1: sailor?[fSailorLevel1] ?? "",
        Data.llbSailorLevel1: sailor?[fLLBSailorLevel1] ?? "",
        Data.sailorLevel2: sailor?[fSailorLevel2] ?? "",
        Data.llbSailorLevel2: sailor?[fLLBSailorLevel2] ?? "",
        Data.sailorCombined: sailor?[fSailorCombined] ?? "",
        Data.llbSailorCombined: sailor?[fLLBSailorCombined] ?? "",
        Data.sailorCharacter1: sailor?[fSailorChar1] ?? "",
        Data.llbSailorCharacter1: sailor?[fLLBSailorCharacter1] ?? "",
        Data.sailorCharacter2: sailor?[fSailorChar2] ?? "",
        Data.llbSailorCharacter2: sailor?[fLLBSailorCharacter2] ?? "",
        Data.special: special ?? "",
        Data.llbSpecial: llbSpecial ?? "",
        Data.specialName: specialName ?? "",
        Data.captain: captain ?? "",
        Data.llbCaptain: llbCaptain ?? "",
        Data.swap: swap ?? "",
        Data.potentialOne: potential[0],
        Data.potentialTwo: potential[1],
        Data.potentialThree: "",
        Data.festAbility: festAbility ?? "",
        Data.festResistance: festResistance ?? "",
        Data.festSpecial: festSpecial ?? "",
        Data.supportCharacters: support?[fSupChars] ?? "",
        Data.supportDescription: support?[fSupDescription] ?? "",
        Data.superSpecial: superSpecial ?? "",
        Data.superSpecialCriteria: superSpecialCriteria ?? "",
        Data.vsCondition: vsCondition ?? "",
        Data.vsSpecial: vsSpecial ?? "",
        Data.art: art ?? "",
        Data.lastTapCondition: lastTapCondition ?? "",
        Data.lastTapDescription: lastTapDescription ?? "",
        Data.llbFestAbility: llbFestAbility ?? "",
        Data.llbFestResistance: llbFestResistance ?? "",
        Data.llbFestSpecial: llbFestSpecial ?? "",
        Data.superTandemCondition: superTandemCondition ?? "",
        Data.superTandemDescription: superTandemDescription ?? "",
        Data.gpStatsBurst: gpStats?[fGPStatsBurst] ?? "",
        Data.gpStatsBurstCondition: gpStats?[fGPStatsBurstCondition] ?? "",
        Data.gpStatsLeaderSkill: gpStats?[fGPStatsLeaderSkill] ?? "",
        Data.rushCondition: gpStats?[fRushCondition] ?? "",
        Data.rushDescription: gpStats?[fRushDescription] ?? "",
        Data.rushStats: gpStats?[fRushStats] ?? "",
      };
    } else {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] ?? "",
        Data.llbSailorBase: sailor?[fLLBSailorBase] ?? "",
        Data.sailorLevel1: sailor?[fSailorLevel1] ?? "",
        Data.llbSailorLevel1: sailor?[fLLBSailorLevel1] ?? "",
        Data.sailorLevel2: sailor?[fSailorLevel2] ?? "",
        Data.llbSailorLevel2: sailor?[fLLBSailorLevel2] ?? "",
        Data.sailorCombined: sailor?[fSailorCombined] ?? "",
        Data.llbSailorCombined: sailor?[fLLBSailorCombined] ?? "",
        Data.sailorCharacter1: sailor?[fSailorChar1] ?? "",
        Data.llbSailorCharacter1: sailor?[fLLBSailorCharacter1] ?? "",
        Data.sailorCharacter2: sailor?[fSailorChar2] ?? "",
        Data.llbSailorCharacter2: sailor?[fLLBSailorCharacter2] ?? "",
        Data.special: special ?? "",
        Data.llbSpecial: llbSpecial ?? "",
        Data.specialName: specialName ?? "",
        Data.captain: captain ?? "",
        Data.llbCaptain: llbCaptain ?? "",
        Data.swap: swap ?? "",
        Data.potentialOne: potential[0],
        Data.potentialTwo: potential[1],
        Data.potentialThree: potential[2],
        Data.festAbility: festAbility ?? "",
        Data.festResistance: festResistance ?? "",
        Data.festSpecial: festSpecial ?? "",
        Data.supportCharacters: support?[fSupChars] ?? "",
        Data.supportDescription: support?[fSupDescription] ?? "",
        Data.superSpecial: superSpecial ?? "",
        Data.superSpecialCriteria: superSpecialCriteria ?? "",
        Data.vsCondition: vsCondition ?? "",
        Data.vsSpecial: vsSpecial ?? "",
        Data.art: art ?? "",
        Data.lastTapCondition: lastTapCondition ?? "",
        Data.lastTapDescription: lastTapDescription ?? "",
        Data.llbFestAbility: llbFestAbility ?? "",
        Data.llbFestResistance: llbFestResistance ?? "",
        Data.llbFestSpecial: llbFestSpecial ?? "",
        Data.superTandemCondition: superTandemCondition ?? "",
        Data.superTandemDescription: superTandemDescription ?? "",
        Data.gpStatsBurst: gpStats?[fGPStatsBurst] ?? "",
        Data.gpStatsBurstCondition: gpStats?[fGPStatsBurstCondition] ?? "",
        Data.gpStatsLeaderSkill: gpStats?[fGPStatsLeaderSkill] ?? "",
        Data.rushCondition: gpStats?[fRushCondition] ?? "",
        Data.rushDescription: gpStats?[fRushDescription] ?? "",
        Data.rushStats: gpStats?[fRushStats] ?? "",
      };
    }
  }
}
