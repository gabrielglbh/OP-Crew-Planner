import 'package:easy_localization/easy_localization.dart';

enum Attribute {
  maxLevel,
  skills,
  special,
  cotton,
  support,
  potential,
  evolution,
  limitBreak,
  rumbleSpecial,
  rumbleAbility,
  maxLevelLimitBreak
}

extension AttributeExt on Attribute {
  String get asset {
    switch (this) {
      case Attribute.maxLevel:
        return "res/maxed/maxLevel.png";
      case Attribute.skills:
        return "res/maxed/skills.png";
      case Attribute.special:
        return "res/maxed/specialLevel.png";
      case Attribute.cotton:
        return "res/maxed/cottonCandy.png";
      case Attribute.support:
        return "res/maxed/support.png";
      case Attribute.potential:
        return "res/maxed/potentialLevel.png";
      case Attribute.evolution:
        return "res/maxed/evolution.png";
      case Attribute.limitBreak:
        return "res/maxed/limitBreak.png";
      case Attribute.rumbleSpecial:
        return "res/maxed/rumble_special.png";
      case Attribute.rumbleAbility:
        return "res/maxed/rumble_ability.png";
      case Attribute.maxLevelLimitBreak:
        return "res/maxed/levelLimitBreak.png";
    }
  }

  String get name {
    switch (this) {
      case Attribute.maxLevel:
        return "filterMaxLevel".tr();
      case Attribute.skills:
        return "filterSkills".tr();
      case Attribute.special:
        return "filterSpecial".tr();
      case Attribute.cotton:
        return "filterCotton".tr();
      case Attribute.support:
        return "filterSupport".tr();
      case Attribute.potential:
        return "filterPotential".tr();
      case Attribute.evolution:
        return "filterEvolution".tr();
      case Attribute.limitBreak:
        return "filterLimitBreak".tr();
      case Attribute.rumbleSpecial:
        return "filterRumbleSpecial".tr();
      case Attribute.rumbleAbility:
        return "filterRumbleAbility".tr();
      case Attribute.maxLevelLimitBreak:
        return "filterLLB".tr();
    }
  }

  double get scale {
    switch (this) {
      case Attribute.maxLevel:
        return 9.5;
      case Attribute.skills:
        return 9;
      case Attribute.special:
        return 1.2;
      case Attribute.cotton:
        return 7;
      case Attribute.support:
        return 10;
      case Attribute.potential:
        return 2.5;
      case Attribute.evolution:
        return 10;
      case Attribute.limitBreak:
        return 4.8;
      case Attribute.rumbleSpecial:
        return 5;
      case Attribute.rumbleAbility:
        return 4.5;
      case Attribute.maxLevelLimitBreak:
        return 4;
    }
  }
}
