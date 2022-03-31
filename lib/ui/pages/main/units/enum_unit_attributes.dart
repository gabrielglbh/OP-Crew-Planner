import 'package:easy_localization/easy_localization.dart';

enum UnitAttributeToMax {
  maxLevel, skills, special, cottonCandy, support, potential, evolution,
  limitBreak, rumbleSpecial, rumbleAbility
}

extension UnitAttributeToMaxExt on UnitAttributeToMax {
  String get label {
    switch (this) {
      case UnitAttributeToMax.maxLevel:
        return "filterMaxLevel".tr();
      case UnitAttributeToMax.skills:
        return "filterSkills".tr();
      case UnitAttributeToMax.special:
        return "filterSpecial".tr();
      case UnitAttributeToMax.cottonCandy:
        return "filterCotton".tr();
      case UnitAttributeToMax.support:
        return "filterSupport".tr();
      case UnitAttributeToMax.potential:
        return "filterPotential".tr();
      case UnitAttributeToMax.evolution:
        return "filterEvolution".tr();
      case UnitAttributeToMax.limitBreak:
        return "filterLimitBreak".tr();
      case UnitAttributeToMax.rumbleSpecial:
        return "filterRumbleSpecial".tr();
      case UnitAttributeToMax.rumbleAbility:
        return "filterRumbleAbility".tr();
    }
  }

  String get asset {
    switch (this) {
      case UnitAttributeToMax.maxLevel:
        return "res/maxed/maxLevel.png";
      case UnitAttributeToMax.skills:
        return "res/maxed/skills.png";
      case UnitAttributeToMax.special:
        return "res/maxed/specialLevel.png";
      case UnitAttributeToMax.cottonCandy:
        return "res/maxed/cottonCandy.png";
      case UnitAttributeToMax.support:
        return "res/maxed/support.png";
      case UnitAttributeToMax.potential:
        return "res/maxed/potentialLevel.png";
      case UnitAttributeToMax.evolution:
        return "res/maxed/evolution.png";
      case UnitAttributeToMax.limitBreak:
        return "res/maxed/limitBreak.png";
      case UnitAttributeToMax.rumbleSpecial:
        return "res/maxed/rumble_special.png";
      case UnitAttributeToMax.rumbleAbility:
        return "res/maxed/rumble_ability.png";
    }
  }
}