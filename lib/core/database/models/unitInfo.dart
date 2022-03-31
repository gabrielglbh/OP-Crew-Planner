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
  // Only for Device's Database
  String? unitId;

  // Fields for consistency
  static const String fCaptain = "captain";
  static const String fSpecial = "special";
  static const String fSpecialName = "specialName";
  static const String fSailor = "sailor";
  static const String fSailorBase = "base";
  static const String fSailorLevel1 = "level1";
  static const String fSailorLevel2 = "level2";
  static const String fSailorCombined = "combined";
  static const String fSailorChar1 = "character1";
  static const String fSailorChar2 = "character2";
  static const String fSwap = "swap";
  static const String fFestAbility = "festAbility";
  static const String fFestSpecial = "festSpecial";
  static const String fFestResist = "festResistance";
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

  UnitInfo({this.sailor, this.special, this.specialName, this.captain, this.swap,
      this.potential = const [], this.festAbility, this.festSpecial, this.festResistance,
      this.support, this.superSpecial, this.superSpecialCriteria, this.vsSpecial,
      this.vsCondition, this.art, this.unitId, this.lastTapCondition, this.lastTapDescription
  });

  bool isEqualTo(UnitInfo b) {
    return this.sailor?.length == b.sailor?.length && this.special == b.special &&
        this.specialName == b.specialName && this.captain == b.captain && this.swap == b.swap &&
        this.potential.length == b.potential.length && this.festAbility == b.festAbility &&
        this.festSpecial == b.festSpecial && this.festResistance == b.festResistance &&
        this.support?.length == b.support?.length && this.superSpecial == b.superSpecial &&
        this.superSpecialCriteria == b.superSpecialCriteria && this.vsCondition == b.vsCondition &&
        this.vsSpecial == b.vsSpecial && this.art == b.art && this.lastTapCondition == b.lastTapCondition &&
        this.lastTapDescription == b.lastTapDescription && this.unitId == b.unitId;
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
      lastTapDescription: ""
  );
  factory UnitInfo.fromJson(Map<String, dynamic> json) {
    return UnitInfo(
      sailor: json[fSailor] == null ? {} : json[fSailor],
      special: json[fSpecial] == null ? "" : json[fSpecial],
      specialName: json[fSpecialName] == null ? "" : json[fSpecialName],
      captain: json[fCaptain] == null ? "" : json[fCaptain],
      swap: json[fSwap] == null ? "" : json[fSwap],
      potential: json[fPotential] == null ? [] : json[fPotential].cast<String>(),
      festAbility: json[fFestAbility] == null ? "" : json[fFestAbility],
      festResistance: json[fFestResist] == null ? "" : json[fFestResist],
      festSpecial: json[fFestSpecial] == null ? "" : json[fFestSpecial],
      support: json[fSupport] == null ? {} : json[fSupport][0],
      superSpecial: json[fSuperSpecial] == null ? "" : json[fSuperSpecial],
      superSpecialCriteria: json[fSuperCriteria] == null ? "" : json[fSuperCriteria],
      vsCondition: json[fVSCondition] == null ? "" : json[fVSCondition],
      vsSpecial: json[fVSSpecial] == null ? "" : json[fVSSpecial],
      art: json[fArt] == null ? "" : json[fArt],
      lastTapCondition: json[fLastTapCondition] == null ? "" : json[fLastTapCondition],
      lastTapDescription: json[fLastTapDescription] == null ? "" : json[fLastTapDescription]
    );
  }

  // Only for Device's Database
  Map<String, dynamic> toJson() {
    if (potential.length == 0) {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] == null ? "" : sailor![fSailorBase],
        Data.sailorLevel1: sailor?[fSailorLevel1] == null ? "" : sailor![fSailorLevel1],
        Data.sailorLevel2: sailor?[fSailorLevel2] == null ? "" : sailor![fSailorLevel2],
        Data.sailorCombined: sailor?[fSailorCombined] == null ? "" : sailor![fSailorCombined],
        Data.sailorCharacter1: sailor?[fSailorChar1] == null ? "" : sailor![fSailorChar1],
        Data.sailorCharacter2: sailor?[fSailorChar2] == null ? "" : sailor![fSailorChar2],
        Data.special: special == null ? "" : special,
        Data.specialName: specialName == null ? "" : specialName,
        Data.captain: captain == null ? "" : captain,
        Data.swap: swap == null ? "" : swap,
        Data.potentialOne: "",
        Data.potentialTwo: "",
        Data.potentialThree: "",
        Data.festAbility: festAbility == null ? "" : festAbility,
        Data.festResistance: festResistance == null ? "" : festResistance,
        Data.festSpecial: festSpecial == null ? "" : festSpecial,
        Data.supportCharacters: support?[fSupChars] == null ? "" : support![fSupChars],
        Data.supportDescription: support?[fSupDescription] == null ? "" : support![fSupDescription],
        Data.superSpecial: superSpecial == null ? "" : superSpecial,
        Data.superSpecialCriteria: superSpecialCriteria == null ? "" : superSpecialCriteria,
        Data.vsCondition: vsCondition == null ? "" : vsCondition,
        Data.vsSpecial: vsSpecial == null ? "" : vsSpecial,
        Data.art: art == null ? "" : art,
        Data.lastTapCondition: lastTapCondition == null ? "" : lastTapCondition,
        Data.lastTapDescription: lastTapDescription == null ? "" : lastTapDescription,
      };
    }
    else if (potential[0] != "" && potential[1] == "" && potential[2] == "") {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] == null ? "" : sailor![fSailorBase],
        Data.sailorLevel1: sailor?[fSailorLevel1] == null ? "" : sailor![fSailorLevel1],
        Data.sailorLevel2: sailor?[fSailorLevel2] == null ? "" : sailor![fSailorLevel2],
        Data.sailorCombined: sailor?[fSailorCombined] == null ? "" : sailor![fSailorCombined],
        Data.sailorCharacter1: sailor?[fSailorChar1] == null ? "" : sailor![fSailorChar1],
        Data.sailorCharacter2: sailor?[fSailorChar2] == null ? "" : sailor![fSailorChar2],
        Data.special: special == null ? "" : special,
        Data.specialName: specialName == null ? "" : specialName,
        Data.captain: captain == null ? "" : captain,
        Data.swap: swap == null ? "" : swap,
        Data.potentialOne: potential[0],
        Data.potentialTwo: "",
        Data.potentialThree: "",
        Data.festAbility: festAbility == null ? "" : festAbility,
        Data.festResistance: festResistance == null ? "" : festResistance,
        Data.festSpecial: festSpecial == null ? "" : festSpecial,
        Data.supportCharacters: support?[fSupChars] == null ? "" : support![fSupChars],
        Data.supportDescription: support?[fSupDescription] == null ? "" : support![fSupDescription],
        Data.superSpecial: superSpecial == null ? "" : superSpecial,
        Data.superSpecialCriteria: superSpecialCriteria == null ? "" : superSpecialCriteria,
        Data.vsCondition: vsCondition == null ? "" : vsCondition,
        Data.vsSpecial: vsSpecial == null ? "" : vsSpecial,
        Data.art: art == null ? "" : art,
        Data.lastTapCondition: lastTapCondition == null ? "" : lastTapCondition,
        Data.lastTapDescription: lastTapDescription == null ? "" : lastTapDescription,
      };
    } else if (potential[0] != "" && potential[1] != "" && potential[2] == "") {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] == null ? "" : sailor![fSailorBase],
        Data.sailorLevel1: sailor?[fSailorLevel1] == null ? "" : sailor![fSailorLevel1],
        Data.sailorLevel2: sailor?[fSailorLevel2] == null ? "" : sailor![fSailorLevel2],
        Data.sailorCombined: sailor?[fSailorCombined] == null ? "" : sailor![fSailorCombined],
        Data.sailorCharacter1: sailor?[fSailorChar1] == null ? "" : sailor![fSailorChar1],
        Data.sailorCharacter2: sailor?[fSailorChar2] == null ? "" : sailor![fSailorChar2],
        Data.special: special == null ? "" : special,
        Data.specialName: specialName == null ? "" : specialName,
        Data.captain: captain == null ? "" : captain,
        Data.swap: swap == null ? "" : swap,
        Data.potentialOne: potential[0],
        Data.potentialTwo: potential[1],
        Data.potentialThree: "",
        Data.festAbility: festAbility == null ? "" : festAbility,
        Data.festResistance: festResistance == null ? "" : festResistance,
        Data.festSpecial: festSpecial == null ? "" : festSpecial,
        Data.supportCharacters: support?[fSupChars] == null ? "" : support![fSupChars],
        Data.supportDescription: support?[fSupDescription] == null ? "" : support![fSupDescription],
        Data.superSpecial: superSpecial == null ? "" : superSpecial,
        Data.superSpecialCriteria: superSpecialCriteria == null ? "" : superSpecialCriteria,
        Data.vsCondition: vsCondition == null ? "" : vsCondition,
        Data.vsSpecial: vsSpecial == null ? "" : vsSpecial,
        Data.art: art == null ? "" : art,
        Data.lastTapCondition: lastTapCondition == null ? "" : lastTapCondition,
        Data.lastTapDescription: lastTapDescription == null ? "" : lastTapDescription,
      };
    } else {
      return {
        Data.dataUnitId: unitId,
        Data.sailorBase: sailor?[fSailorBase] == null ? "" : sailor![fSailorBase],
        Data.sailorLevel1: sailor?[fSailorLevel1] == null ? "" : sailor![fSailorLevel1],
        Data.sailorLevel2: sailor?[fSailorLevel2] == null ? "" : sailor![fSailorLevel2],
        Data.sailorCombined: sailor?[fSailorCombined] == null ? "" : sailor![fSailorCombined],
        Data.sailorCharacter1: sailor?[fSailorChar1] == null ? "" : sailor![fSailorChar1],
        Data.sailorCharacter2: sailor?[fSailorChar2] == null ? "" : sailor![fSailorChar2],
        Data.special: special == null ? "" : special,
        Data.specialName: specialName == null ? "" : specialName,
        Data.captain: captain == null ? "" : captain,
        Data.swap: swap == null ? "" : swap,
        Data.potentialOne: potential[0],
        Data.potentialTwo: potential[1],
        Data.potentialThree: potential[2],
        Data.festAbility: festAbility == null ? "" : festAbility,
        Data.festResistance: festResistance == null ? "" : festResistance,
        Data.festSpecial: festSpecial == null ? "" : festSpecial,
        Data.supportCharacters: support?[fSupChars] == null ? "" : support![fSupChars],
        Data.supportDescription: support?[fSupDescription] == null ? "" : support![fSupDescription],
        Data.superSpecial: superSpecial == null ? "" : superSpecial,
        Data.superSpecialCriteria: superSpecialCriteria == null ? "" : superSpecialCriteria,
        Data.vsCondition: vsCondition == null ? "" : vsCondition,
        Data.vsSpecial: vsSpecial == null ? "" : vsSpecial,
        Data.art: art == null ? "" : art,
        Data.lastTapCondition: lastTapCondition == null ? "" : lastTapCondition,
        Data.lastTapDescription: lastTapDescription == null ? "" : lastTapDescription,
      };
    }
  }
}
