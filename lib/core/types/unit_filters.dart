import 'package:easy_localization/easy_localization.dart';

enum UnitFilter {
  all,
  maxLevel,
  skills,
  special,
  cottonCandy,
  support,
  potential,
  evolution,
  limitBreak,
  rumbleSpecial,
  rumbleAbility,
  maxLevelLimitBreak
}

extension UnitFilterExt on UnitFilter {
  String get label {
    switch (this) {
      case UnitFilter.all:
        return "filterAll".tr();
      case UnitFilter.maxLevel:
        return "filterMaxLevel".tr();
      case UnitFilter.skills:
        return "filterSkills".tr();
      case UnitFilter.special:
        return "filterSpecial".tr();
      case UnitFilter.cottonCandy:
        return "filterCotton".tr();
      case UnitFilter.support:
        return "filterSupport".tr();
      case UnitFilter.potential:
        return "filterPotential".tr();
      case UnitFilter.evolution:
        return "filterEvolution".tr();
      case UnitFilter.limitBreak:
        return "filterLimitBreak".tr();
      case UnitFilter.rumbleSpecial:
        return "filterRumbleSpecial".tr();
      case UnitFilter.rumbleAbility:
        return "filterRumbleAbility".tr();
      case UnitFilter.maxLevelLimitBreak:
        return "filterLLB".tr();
    }
  }

  String get asset {
    switch (this) {
      case UnitFilter.all:
        return "";
      case UnitFilter.maxLevel:
        return "res/maxed/maxLevel.png";
      case UnitFilter.skills:
        return "res/maxed/skills.png";
      case UnitFilter.special:
        return "res/maxed/specialLevel.png";
      case UnitFilter.cottonCandy:
        return "res/maxed/cottonCandy.png";
      case UnitFilter.support:
        return "res/maxed/support.png";
      case UnitFilter.potential:
        return "res/maxed/potentialLevel.png";
      case UnitFilter.evolution:
        return "res/maxed/evolution.png";
      case UnitFilter.limitBreak:
        return "res/maxed/limitBreak.png";
      case UnitFilter.rumbleSpecial:
        return "res/maxed/rumble_special.png";
      case UnitFilter.rumbleAbility:
        return "res/maxed/rumble_ability.png";
      case UnitFilter.maxLevelLimitBreak:
        return "res/maxed/levelLimitBreak.png";
    }
  }
}
