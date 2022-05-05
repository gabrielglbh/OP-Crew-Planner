import 'package:flutter/material.dart';
import 'package:optcteams/core/database/models/unit_info.dart';
import 'package:optcteams/ui/widgets/unitInfo/unit_info_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class CaptainAbility extends StatelessWidget {
  final UnitInfo info;
  const CaptainAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbCaptain != null && info.llbCaptain != "";
    return Visibility(
        visible: (info.captain != null && info.captain != "") || hasLLB,
        child: UnitInfoUtils.instance.simpleSection("res/info/captain.png", "captain".tr(),
            info.captain, needsSubsection: hasLLB, isLLB: hasLLB, subsectionText: info.llbCaptain)
    );
  }
}

class SpecialAbility extends StatelessWidget {
  final UnitInfo info;
  const SpecialAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbSpecial != null && info.llbSpecial != "";
    return Visibility(
        visible: (info.specialName != null && info.special != null &&
            info.specialName != "" && info.special != "") || hasLLB,
        child: UnitInfoUtils.instance.simpleSection("res/maxed/specialLevel.png",
            info.specialName, info.special, italic: true, isLLB: hasLLB,
            needsSubsection: hasLLB, subsectionText: info.llbSpecial)
    );
  }
}

class SwapAbility extends StatelessWidget {
  final UnitInfo info;
  const SwapAbility({Key? key, required this.info}) : super(key: key);

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
  const VersusAbility({Key? key, required this.info}) : super(key: key);

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
  const SuperTypeAbility({Key? key, required this.info}) : super(key: key);

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
  const SupportAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.support != null && info.support?.keys.contains(UnitInfo.fSupChars) == true
          && info.support?.keys.contains(UnitInfo.fSupDescription) == true
          && info.support?[UnitInfo.fSupChars] != ""
          && info.support?[UnitInfo.fSupDescription] != "",
      child: UnitInfoUtils.instance.simpleSection("res/maxed/support.png", "supportAbility".tr(),
          "For ${info.support?[UnitInfo.fSupChars]}",
          needsSubsection: true, subsectionText: info.support?[UnitInfo.fSupDescription]),
    );
  }
}

class LastTapAbility extends StatelessWidget {
  final UnitInfo info;
  const LastTapAbility({Key? key, required this.info}) : super(key: key);

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
  const RumbleAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbFestAbility != null && info.llbFestAbility != "";
    return Visibility(
        visible: (info.festAbility != null && info.festAbility != "") || hasLLB,
        child: UnitInfoUtils.instance.simpleSection("res/maxed/rumble_ability.png",
            "fAbility".tr(), info.festAbility, needsSubsection: hasLLB, isLLB: hasLLB,
            subsectionText: info.llbFestAbility)
    );
  }
}

class RumbleSpecial extends StatelessWidget {
  final UnitInfo info;
  const RumbleSpecial({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbFestSpecial != null && info.llbFestSpecial != "";
    return Visibility(
        visible: (info.festSpecial != null && info.festSpecial != "") || hasLLB,
        child: UnitInfoUtils.instance.simpleSection("res/maxed/rumble_special.png",
            "fSpecial".tr(), info.festSpecial, needsSubsection: hasLLB, isLLB: hasLLB,
            subsectionText: info.llbFestSpecial)
    );
  }
}

class RumbleResistance extends StatelessWidget {
  final UnitInfo info;
  const RumbleResistance({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbFestResistance != null && info.llbFestResistance != "";
    return Visibility(
        visible: (info.festResistance != null && info.festResistance != "") || hasLLB,
        child: UnitInfoUtils.instance.simpleSection("res/info/resistance.png",
            "fResistance".tr(), info.festResistance, needsSubsection: hasLLB, isLLB: hasLLB,
            subsectionText: info.llbFestResistance)
    );
  }
}

class PotentialAbility extends StatelessWidget {
  final UnitInfo info;
  const PotentialAbility({Key? key, required this.info}) : super(key: key);

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
    "last tap": "res/potential_abilities/lastTap.png"
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> potentials = [];
    if (info.potential.isNotEmpty && info.potential.isNotEmpty) {
      potentials.add(UnitInfoUtils.instance
          .headerOfSection("res/maxed/potentialLevel.png", "potential".tr()));
      for (var ability in info.potential) {
        if (ability != "") {
          potentials.add(
            Row(children: [
              const Text("• ", textAlign: TextAlign.start),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(width: 30, height: 30,
                  padding: _cPotentials.contains(ability.toLowerCase()) ? const EdgeInsets.all(1) : null,
                  child: Image.asset((_potentialImages[ability.toLowerCase()] ?? "")),
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: UnitInfoUtils.instance.generateColorKeysForTextSpan(
                      ability, parsePotential: true)
                ),
              )
            ])
          );
        }
      }
      potentials.add(const Text("")); // Extra padding at the end of the Potential Section
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
  const SailorAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = (info.sailor?.keys.contains(UnitInfo.fLLBSailorBase) == true
        && info.sailor?[UnitInfo.fLLBSailorBase] != "")
        || (info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel1) == true
            && info.sailor?[UnitInfo.fLLBSailorLevel1] != "")
        || (info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel2) == true
            && info.sailor?[UnitInfo.fLLBSailorLevel2] != "")
        || (info.sailor?.keys.contains(UnitInfo.fLLBSailorCombined) == true
            && info.sailor?[UnitInfo.fLLBSailorCombined] != "")
        || (info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter1) == true
            && info.sailor?[UnitInfo.fLLBSailorCharacter1] != "")
        || (info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter2) == true
            && info.sailor?[UnitInfo.fLLBSailorCharacter2] != "");

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
            && info.sailor?[UnitInfo.fSailorChar2] != "")
        || hasLLB),
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
          Visibility(
            visible: hasLLB,
            child: UnitInfoUtils.instance.withLevelLimitBreakHeader(),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorBase) == true
                && info.sailor?[UnitInfo.fLLBSailorBase] != "",
            child: UnitInfoUtils.instance.richText3Ways("base".tr(),
                info.sailor?[UnitInfo.fLLBSailorBase]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel1) == true
                && info.sailor?[UnitInfo.fLLBSailorLevel1] != "",
            child: UnitInfoUtils.instance.richText3Ways("l1".tr(),
                info.sailor?[UnitInfo.fLLBSailorLevel1]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel2) == true
                && info.sailor?[UnitInfo.fLLBSailorLevel2] != "",
            child: UnitInfoUtils.instance.richText3Ways("l2".tr(),
                info.sailor?[UnitInfo.fLLBSailorLevel2]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorCombined) == true
                && info.sailor?[UnitInfo.fLLBSailorCombined] != "",
            child: UnitInfoUtils.instance.richText3Ways("combined".tr(),
                info.sailor?[UnitInfo.fLLBSailorCombined]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter1) == true
                && info.sailor?[UnitInfo.fLLBSailorCharacter1] != "",
            child: UnitInfoUtils.instance.richText3Ways("c1".tr(),
                info.sailor?[UnitInfo.fLLBSailorCharacter1]),
          ),
          Visibility(
            visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter2) == true
                && info.sailor?[UnitInfo.fLLBSailorCharacter2] != "",
            child: UnitInfoUtils.instance.richText3Ways("c2".tr(),
                info.sailor?[UnitInfo.fLLBSailorCharacter2]),
          ),
          UnitInfoUtils.instance.divider()
        ]
      ),
    );
  }
}
