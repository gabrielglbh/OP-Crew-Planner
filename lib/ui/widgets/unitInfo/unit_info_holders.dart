import 'package:flutter/material.dart';
import 'package:optcteams/core/database/models/unitInfo.dart';
import 'package:optcteams/ui/widgets/unitInfo/unit_info_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CaptainAbility extends StatelessWidget {
  final UnitInfo info;
  const CaptainAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.captain != null && info.captain != "",
      child: UnitInfoUtils.instance.simpleSection("res/info/captain.png", "captain".tr(), info.captain)
    );
  }
}

class SpecialAbility extends StatelessWidget {
  final UnitInfo info;
  const SpecialAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.specialName != null && info.special != null &&
          info.specialName != "" && info.special != "",
      child: UnitInfoUtils.instance.simpleSection("res/maxed/specialLevel.png",
          info.specialName, info.special, italic: true)
    );
  }
}

class SwapAbility extends StatelessWidget {
  final UnitInfo info;
  const SwapAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.swap != null && info.swap != "",
      child: UnitInfoUtils.instance.simpleSection("res/info/swap.png", "swap".tr(), info.swap)
    );
  }
}

class VersusAbility extends StatelessWidget {
  final UnitInfo info;
  const VersusAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.vsSpecial != null && info.vsSpecial != ""
          && info.vsCondition != null && info.vsCondition != "",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitInfoUtils.instance.headerOfSection("res/info/versus.png", "Versus"),
          UnitInfoUtils.instance.richText3Ways("stCriteria".tr(), info.vsCondition),
          UnitInfoUtils.instance.richText3Ways("special".tr(), info.vsSpecial),
          UnitInfoUtils.instance.divider()
        ]
      )
    );
  }
}

class SuperTypeAbility extends StatelessWidget {
  final UnitInfo info;
  const SuperTypeAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.superSpecial != null && info.superSpecial != ""
          && info.superSpecialCriteria != null && info.superSpecialCriteria != "",
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UnitInfoUtils.instance.headerOfSection("res/info/supertype.png", "Super Type"),
            UnitInfoUtils.instance.richText3Ways("stCriteria".tr(), info.superSpecialCriteria),
            UnitInfoUtils.instance.richText3Ways("special".tr(), info.superSpecial),
            UnitInfoUtils.instance.divider()
          ]
      )
    );
  }
}

class SupportAbility extends StatelessWidget {
  final UnitInfo info;
  const SupportAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.support != null && info.support?.keys.contains(UnitInfo.fSupChars) == true
          && info.support?.keys.contains(UnitInfo.fSupDescription) == true
          && info.support?[UnitInfo.fSupChars] != ""
          && info.support?[UnitInfo.fSupDescription] != "",
      child: UnitInfoUtils.instance.simpleSection("res/maxed/support.png", "supportAbility".tr(),
          "For ${info.support?[UnitInfo.fSupChars]}", support: true, unitInfo: info),
    );
  }
}

class LastTapAbility extends StatelessWidget {
  final UnitInfo info;
  const LastTapAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.lastTapCondition != null && info.lastTapCondition != ""
          && info.lastTapDescription != null && info.lastTapDescription != "",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitInfoUtils.instance.headerOfSection("res/info/lastTap.png", "Last Tap Action"),
          UnitInfoUtils.instance.richText3Ways("stCriteria".tr(), info.lastTapCondition),
          UnitInfoUtils.instance.richText3Ways("special".tr(), info.lastTapDescription),
          UnitInfoUtils.instance.divider()
        ]
      )
    );
  }
}

class RumbleAbility extends StatelessWidget {
  final UnitInfo info;
  const RumbleAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.festAbility != null && info.festAbility != "",
      child: UnitInfoUtils.instance.simpleSection("res/maxed/rumble_ability.png",
          "fAbility".tr(), info.festAbility)
    );
  }
}

class RumbleSpecial extends StatelessWidget {
  final UnitInfo info;
  const RumbleSpecial({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.festSpecial != null && info.festSpecial != "",
      child: UnitInfoUtils.instance.simpleSection("res/maxed/rumble_special.png",
          "fSpecial".tr(), info.festSpecial)
    );
  }
}

class RumbleResistance extends StatelessWidget {
  final UnitInfo info;
  const RumbleResistance({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.festResistance != null && info.festResistance != "",
      child: UnitInfoUtils.instance.simpleSection("res/info/resistance.png",
          "fResistance".tr(), info.festResistance)
    );
  }
}

class PotentialAbility extends StatelessWidget {
  final UnitInfo info;
  const PotentialAbility({required this.info});

  final List<String> _cPotentials = const [
    "reduce sailor despair duration",
    "reduce ship bind duration",
    "nutrition/reduce hunger duration"
  ];
  final Map<String, String> _potentialImages = const {
    "reduce no healing duration": "res/potential_abilities/recovery.png",
    "pinch healing": "res/potential_abilities/pinchHealing.png",
    "enrage/reduce increase damage taken duration": "res/potential_abilities/enrage.png",
    "reduce slot bind duration": "res/potential_abilities/slotBlind.png",
    "critical hit": "res/potential_abilities/criticalHit.png",
    "[str] damage reduction": "res/potential_abilities/strDmgReduction.png",
    "[dex] damage reduction": "res/potential_abilities/dexDmgReduction.png",
    "[qck] damage reduction": "res/potential_abilities/qckDmgReduction.png",
    "[psy] damage reduction": "res/potential_abilities/psyDmgReduction.png",
    "[int] damage reduction": "res/potential_abilities/intDmgReduction.png",
    "cooldown reduction": "res/potential_abilities/cooldownReduction.png",
    "barrier penetration": "res/potential_abilities/barrierPierce.png",
    "double special activation": "res/potential_abilities/doubleSpecialActivation.png",
    "reduce sailor despair duration": "res/potential_abilities/sailorDespair.png",
    "reduce ship bind duration": "res/potential_abilities/shipBind.png",
    "nutrition/reduce hunger duration": "res/potential_abilities/reduceHunger.png",
    "last tap": "res/info/lastTap.png"
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> potentials = [];
    if (info.potential.isNotEmpty && info.potential.length >= 1) {
      potentials.add(UnitInfoUtils.instance
          .headerOfSection("res/maxed/potentialLevel.png", "potential".tr()));
      info.potential.forEach((ability) {
        if (ability != "") {
          potentials.add(
            Row(children: [
              Text("• ", textAlign: TextAlign.start),
              Padding(
                padding: EdgeInsets.only(right: 6),
                child: Container(width: 30, height: 30,
                  padding: _cPotentials.contains(ability.toLowerCase()) ? EdgeInsets.all(1) : null,
                  child: Image.asset((_potentialImages[ability.toLowerCase()] ?? "")),
                ),
              ),
              Text("$ability", textAlign: TextAlign.start),
            ])
          );
        }
      });
      potentials.add(Text("")); // Extra padding at the end of the Potential Section
      potentials.add(UnitInfoUtils.instance.divider());
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: potentials
      );
    } else {
      return Container();
    }
  }
}

class SailorAbility extends StatelessWidget {
  final UnitInfo info;
  const SailorAbility({required this.info});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.sailor != null && (info.sailor?.length ?? 1) >= 1
        && ((info.sailor?.keys.contains(UnitInfo.fSailorBase) == true
        && info.sailor?[UnitInfo.fSailorBase] != ""
        && info.sailor?[UnitInfo.fSailorBase] != "None")
        || (info.sailor?.keys.contains(UnitInfo.fSailorLevel1) == true
            && info.sailor?[UnitInfo.fSailorLevel1] != "")
        || (info.sailor?.keys.contains(UnitInfo.fSailorLevel2) == true
            && info.sailor?[UnitInfo.fSailorLevel2] != "")
        || (info.sailor?.keys.contains(UnitInfo.fSailorCombined) == true
            && info.sailor?[UnitInfo.fSailorCombined] != "")
        || (info.sailor?.keys.contains(UnitInfo.fSailorChar1) == true
            && info.sailor?[UnitInfo.fSailorChar1] != "")
        || (info.sailor?.keys.contains(UnitInfo.fSailorChar2) == true
            && info.sailor?[UnitInfo.fSailorChar2] != "")),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: (info.sailor?.length ?? 1) >= 1,
            child: UnitInfoUtils.instance.headerOfSection("res/info/sailor.png", "sailor".tr()),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorBase) == true
                && info.sailor?[UnitInfo.fSailorBase] != "None"
                && info.sailor?[UnitInfo.fSailorBase] != "",
            child: UnitInfoUtils.instance.richText3Ways("base".tr(),
                info.sailor?[UnitInfo.fSailorBase]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorLevel1) == true
                && info.sailor?[UnitInfo.fSailorLevel1] != "",
            child: UnitInfoUtils.instance.richText3Ways("l1".tr(),
                info.sailor?[UnitInfo.fSailorLevel1]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorLevel2) == true
                && info.sailor?[UnitInfo.fSailorLevel2] != "",
            child: UnitInfoUtils.instance.richText3Ways("l2".tr(),
                info.sailor?[UnitInfo.fSailorLevel2]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorCombined) == true
                && info.sailor?[UnitInfo.fSailorCombined] != "",
            child: UnitInfoUtils.instance.richText3Ways("combined".tr(),
                info.sailor?[UnitInfo.fSailorCombined]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorChar1) == true
                && info.sailor?[UnitInfo.fSailorChar1] != "",
            child: UnitInfoUtils.instance.richText3Ways("c1".tr(),
                info.sailor?[UnitInfo.fSailorChar1]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fSailorChar2) == true
                && info.sailor?[UnitInfo.fSailorChar2] != "",
            child: UnitInfoUtils.instance.richText3Ways("c2".tr(),
                info.sailor?[UnitInfo.fSailorChar2]),
          ),
          UnitInfoUtils.instance.divider()
        ]
      ),
    );
  }
}