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
        child: UnitInfoUtils.instance.simpleSection(
            context, "res/info/captain.png", "captain".tr(), info.captain,
            needsSubsection: hasLLB,
            isLLB: hasLLB,
            subsectionText: info.llbCaptain));
  }
}

class SpecialAbility extends StatelessWidget {
  final UnitInfo info;
  const SpecialAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLB = info.llbSpecial != null && info.llbSpecial != "";
    return Visibility(
        visible: (info.specialName != null &&
                info.special != null &&
                info.specialName != "" &&
                info.special != "") ||
            hasLLB,
        child: UnitInfoUtils.instance.simpleSection(context,
            "res/maxed/specialLevel.png", info.specialName, info.special,
            italic: true,
            isLLB: hasLLB,
            needsSubsection: hasLLB,
            subsectionText: info.llbSpecial));
  }
}

class SwapAbility extends StatelessWidget {
  final UnitInfo info;
  const SwapAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: info.swap != null && info.swap != "",
        child: UnitInfoUtils.instance.simpleSection(
            context, "res/info/swap.png", "swap".tr(), info.swap));
  }
}

class VersusAbility extends StatelessWidget {
  final UnitInfo info;
  const VersusAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: info.vsSpecial != null &&
            info.vsSpecial != "" &&
            info.vsCondition != null &&
            info.vsCondition != "",
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UnitInfoUtils.instance
              .headerOfSection("res/info/versus.png", "Versus"),
          UnitInfoUtils.instance
              .richText3Ways(context, "stCriteria".tr(), info.vsCondition),
          UnitInfoUtils.instance
              .richText3Ways(context, "special".tr(), info.vsSpecial),
          UnitInfoUtils.instance.divider()
        ]));
  }
}

class SuperTypeAbility extends StatelessWidget {
  final UnitInfo info;
  const SuperTypeAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: info.superSpecial != null &&
            info.superSpecial != "" &&
            info.superSpecialCriteria != null &&
            info.superSpecialCriteria != "",
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UnitInfoUtils.instance
              .headerOfSection("res/info/supertype.png", "superType".tr()),
          UnitInfoUtils.instance.richText3Ways(
              context, "stCriteria".tr(), info.superSpecialCriteria),
          UnitInfoUtils.instance
              .richText3Ways(context, "special".tr(), info.superSpecial),
          UnitInfoUtils.instance.divider()
        ]));
  }
}

class SupportAbility extends StatelessWidget {
  final UnitInfo info;
  const SupportAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.support != null &&
          info.support?.keys.contains(UnitInfo.fSupChars) == true &&
          info.support?.keys.contains(UnitInfo.fSupDescription) == true &&
          info.support?[UnitInfo.fSupChars] != "" &&
          info.support?[UnitInfo.fSupDescription] != "",
      child: UnitInfoUtils.instance.simpleSection(
          context,
          "res/maxed/support.png",
          "supportAbility".tr(),
          "For ${info.support?[UnitInfo.fSupChars]}",
          needsSubsection: true,
          subsectionText: info.support?[UnitInfo.fSupDescription]),
    );
  }
}

class LastTapAbility extends StatelessWidget {
  final UnitInfo info;
  const LastTapAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: info.lastTapCondition != null &&
            info.lastTapCondition != "" &&
            info.lastTapDescription != null &&
            info.lastTapDescription != "",
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UnitInfoUtils.instance
              .headerOfSection("res/info/lastTap.png", "lastTap".tr()),
          UnitInfoUtils.instance
              .richText3Ways(context, "stCriteria".tr(), info.lastTapCondition),
          UnitInfoUtils.instance
              .richText3Ways(context, "special".tr(), info.lastTapDescription),
          UnitInfoUtils.instance.divider()
        ]));
  }
}

class SuperTNDAbility extends StatelessWidget {
  final UnitInfo info;
  const SuperTNDAbility({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: info.superTandemCondition != null &&
            info.superTandemCondition != "" &&
            info.superTandemDescription != null &&
            info.superTandemDescription != "",
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UnitInfoUtils.instance
              .headerOfSection("res/info/superTND.png", "superTND".tr()),
          UnitInfoUtils.instance.richText3Ways(
              context, "stCriteria".tr(), info.superTandemCondition),
          UnitInfoUtils.instance.richText3Ways(
              context, "special".tr(), info.superTandemDescription),
          UnitInfoUtils.instance.divider()
        ]));
  }
}

class Rumble extends StatelessWidget {
  final UnitInfo info;
  const Rumble({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasLLBAbility =
        info.llbFestAbility != null && info.llbFestAbility != "";
    bool hasLLBSpecial =
        info.llbFestSpecial != null && info.llbFestSpecial != "";
    bool hasLLBResistance =
        info.llbFestResistance != null && info.llbFestResistance != "";

    return Visibility(
      visible: (info.festAbility != null && info.festAbility != "") &&
              (info.festSpecial != null && info.festSpecial != "") &&
              (info.festResistance != null && info.festResistance != "") ||
          hasLLBAbility ||
          hasLLBSpecial ||
          hasLLBResistance,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitInfoUtils.instance
              .headerOfSection("res/maxed/rumble_special.png", "PvP".tr()),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fSpecial".tr(),
            info.festSpecial,
            isLLB: false,
          ),
          Visibility(
            visible: hasLLBSpecial,
            child: UnitInfoUtils.instance.richText3Ways(
              context,
              "fSpecial".tr(),
              info.llbFestSpecial,
              isLLB: true,
            ),
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fAbility".tr(),
            info.festAbility,
            isLLB: false,
          ),
          Visibility(
            visible: hasLLBAbility,
            child: UnitInfoUtils.instance.richText3Ways(
              context,
              "fAbility".tr(),
              info.llbFestAbility,
              isLLB: true,
            ),
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fResistance".tr(),
            info.festResistance,
            isLLB: false,
          ),
          Visibility(
            visible: hasLLBResistance,
            child: UnitInfoUtils.instance.richText3Ways(
              context,
              "fResistance".tr(),
              info.llbFestResistance,
              isLLB: true,
            ),
          ),
          UnitInfoUtils.instance.divider()
        ],
      ),
    );
  }
}

class GPStats extends StatelessWidget {
  final UnitInfo info;
  const GPStats({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.gpStats != null &&
          (info.gpStats?.length ?? 1) >= 1 &&
          ((info.gpStats?.keys.contains(UnitInfo.fGPStatsBurst) == true &&
                  info.gpStats?[UnitInfo.fGPStatsBurst] != "") &&
              (info.gpStats?.keys.contains(UnitInfo.fGPStatsBurstCondition) ==
                      true &&
                  info.gpStats?[UnitInfo.fGPStatsBurstCondition] != "") &&
              (info.gpStats?.keys.contains(UnitInfo.fGPStatsLeaderSkill) ==
                      true &&
                  info.gpStats?[UnitInfo.fGPStatsLeaderSkill] != "")),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitInfoUtils.instance
              .headerOfSection("res/maxed/rumble_ability.png", "GP Stats".tr()),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fGPLeaderSkill".tr(),
            info.gpStats?[UnitInfo.fGPStatsLeaderSkill],
            isLLB: false,
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fGPBurstCondition".tr(),
            info.gpStats?[UnitInfo.fGPStatsBurstCondition],
            isLLB: false,
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "fGPBurst".tr(),
            info.gpStats?[UnitInfo.fGPStatsBurst],
            isLLB: false,
          ),
          UnitInfoUtils.instance.divider()
        ],
      ),
    );
  }
}

class Rush extends StatelessWidget {
  final UnitInfo info;
  const Rush({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: info.rush != null &&
          (info.rush?.length ?? 1) >= 1 &&
          ((info.rush?.keys.contains(UnitInfo.fRushCondition) == true &&
                  info.rush?[UnitInfo.fRushCondition] != "") &&
              (info.rush?.keys.contains(UnitInfo.fRushDescription) == true &&
                  info.rush?[UnitInfo.fRushDescription] != "") &&
              (info.rush?.keys.contains(UnitInfo.fRushStats) == true &&
                  info.rush?[UnitInfo.fRushStats] != "")),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnitInfoUtils.instance
              .headerOfSection("res/potential_abilities/rush.png", "Rush".tr()),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "special".tr(),
            info.rush?[UnitInfo.fRushDescription],
            isLLB: false,
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "stCriteria".tr(),
            info.rush?[UnitInfo.fRushCondition],
            isLLB: false,
          ),
          UnitInfoUtils.instance.richText3Ways(
            context,
            "Stats",
            info.rush?[UnitInfo.fRushStats],
            isLLB: false,
          ),
          UnitInfoUtils.instance.divider()
        ],
      ),
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
    "enrage/reduce increase damage taken duration":
        "res/potential_abilities/enrage.png",
    "reduce slot bind duration": "res/potential_abilities/slotBlind.png",
    "critical hit": "res/potential_abilities/criticalHit.png",
    "[str] damage reduction": "res/potential_abilities/strDmgReduction.png",
    "[dex] damage reduction": "res/potential_abilities/dexDmgReduction.png",
    "[qck] damage reduction": "res/potential_abilities/qckDmgReduction.png",
    "[psy] damage reduction": "res/potential_abilities/psyDmgReduction.png",
    "[int] damage reduction": "res/potential_abilities/intDmgReduction.png",
    "cooldown reduction": "res/potential_abilities/cooldownReduction.png",
    "barrier penetration": "res/potential_abilities/barrierPierce.png",
    "double special activation":
        "res/potential_abilities/doubleSpecialActivation.png",
    "reduce sailor despair duration":
        "res/potential_abilities/sailorDespair.png",
    "reduce ship bind duration": "res/potential_abilities/shipBind.png",
    "nutrition/reduce hunger duration":
        "res/potential_abilities/reduceHunger.png",
    "last tap": "res/potential_abilities/lastTap.png",
    "super tandem": "res/potential_abilities/superTND.png",
    "rush": "res/potential_abilities/rush.png"
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> potentials = [];
    if (info.potential.isNotEmpty && info.potential.isNotEmpty) {
      potentials.add(UnitInfoUtils.instance
          .headerOfSection("res/maxed/potentialLevel.png", "potential".tr()));
      for (var ability in info.potential) {
        if (ability != "") {
          potentials.add(Row(children: [
            const Text("• ", textAlign: TextAlign.start),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Container(
                width: 30,
                height: 30,
                padding: _cPotentials.contains(ability.toLowerCase())
                    ? const EdgeInsets.all(1)
                    : null,
                child: Image.asset(
                  (_potentialImages[ability.toLowerCase()] ?? ""),
                  errorBuilder: ((context, error, stackTrace) {
                    return Transform.rotate(
                        angle: 0.78,
                        child: const Icon(Icons.animation_rounded));
                  }),
                ),
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: UnitInfoUtils.instance.generateColorKeysForTextSpan(
                      context, ability,
                      parsePotential: true)),
            )
          ]));
        }
      }
      potentials.add(
          const Text("")); // Extra padding at the end of the Potential Section
      potentials.add(UnitInfoUtils.instance.divider());
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: potentials);
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
    bool hasLLB = (info.sailor?.keys.contains(UnitInfo.fLLBSailorBase) ==
                true &&
            info.sailor?[UnitInfo.fLLBSailorBase] != "") ||
        (info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel1) == true &&
            info.sailor?[UnitInfo.fLLBSailorLevel1] != "") ||
        (info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel2) == true &&
            info.sailor?[UnitInfo.fLLBSailorLevel2] != "") ||
        (info.sailor?.keys.contains(UnitInfo.fLLBSailorCombined) == true &&
            info.sailor?[UnitInfo.fLLBSailorCombined] != "") ||
        (info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter1) == true &&
            info.sailor?[UnitInfo.fLLBSailorCharacter1] != "") ||
        (info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter2) == true &&
            info.sailor?[UnitInfo.fLLBSailorCharacter2] != "");

    return Visibility(
      visible: info.sailor != null &&
          (info.sailor?.length ?? 1) >= 1 &&
          ((info.sailor?.keys.contains(UnitInfo.fSailorBase) == true &&
                  info.sailor?[UnitInfo.fSailorBase] != "" &&
                  info.sailor?[UnitInfo.fSailorBase] != "None") ||
              (info.sailor?.keys.contains(UnitInfo.fSailorLevel1) == true &&
                  info.sailor?[UnitInfo.fSailorLevel1] != "") ||
              (info.sailor?.keys.contains(UnitInfo.fSailorLevel2) == true &&
                  info.sailor?[UnitInfo.fSailorLevel2] != "") ||
              (info.sailor?.keys.contains(UnitInfo.fSailorCombined) == true &&
                  info.sailor?[UnitInfo.fSailorCombined] != "") ||
              (info.sailor?.keys.contains(UnitInfo.fSailorChar1) == true &&
                  info.sailor?[UnitInfo.fSailorChar1] != "") ||
              (info.sailor?.keys.contains(UnitInfo.fSailorChar2) == true &&
                  info.sailor?[UnitInfo.fSailorChar2] != "") ||
              hasLLB),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Visibility(
          visible: (info.sailor?.length ?? 1) >= 1,
          child: UnitInfoUtils.instance
              .headerOfSection("res/info/sailor.png", "sailor".tr()),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fSailorBase) == true &&
              info.sailor?[UnitInfo.fSailorBase] != "None" &&
              info.sailor?[UnitInfo.fSailorBase] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "base".tr(), info.sailor?[UnitInfo.fSailorBase]),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fSailorLevel1) == true &&
              info.sailor?[UnitInfo.fSailorLevel1] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "l1".tr(), info.sailor?[UnitInfo.fSailorLevel1]),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fSailorLevel2) == true &&
              info.sailor?[UnitInfo.fSailorLevel2] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "l2".tr(), info.sailor?[UnitInfo.fSailorLevel2]),
        ),
        Visibility(
          visible:
              info.sailor?.keys.contains(UnitInfo.fSailorCombined) == true &&
                  info.sailor?[UnitInfo.fSailorCombined] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "combined".tr(), info.sailor?[UnitInfo.fSailorCombined]),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fSailorChar1) == true &&
              info.sailor?[UnitInfo.fSailorChar1] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "c1".tr(), info.sailor?[UnitInfo.fSailorChar1]),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fSailorChar2) == true &&
              info.sailor?[UnitInfo.fSailorChar2] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "c2".tr(), info.sailor?[UnitInfo.fSailorChar2]),
        ),
        Visibility(
          visible:
              info.sailor?.keys.contains(UnitInfo.fLLBSailorBase) == true &&
                  info.sailor?[UnitInfo.fLLBSailorBase] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "base".tr(), info.sailor?[UnitInfo.fLLBSailorBase],
              isLLB: true),
        ),
        Visibility(
          visible:
              info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel1) == true &&
                  info.sailor?[UnitInfo.fLLBSailorLevel1] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "l1".tr(), info.sailor?[UnitInfo.fLLBSailorLevel1],
              isLLB: true),
        ),
        Visibility(
          visible:
              info.sailor?.keys.contains(UnitInfo.fLLBSailorLevel2) == true &&
                  info.sailor?[UnitInfo.fLLBSailorLevel2] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "l2".tr(), info.sailor?[UnitInfo.fLLBSailorLevel2],
              isLLB: true),
        ),
        Visibility(
          visible:
              info.sailor?.keys.contains(UnitInfo.fLLBSailorCombined) == true &&
                  info.sailor?[UnitInfo.fLLBSailorCombined] != "",
          child: UnitInfoUtils.instance.richText3Ways(context, "combined".tr(),
              info.sailor?[UnitInfo.fLLBSailorCombined],
              isLLB: true),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter1) ==
                  true &&
              info.sailor?[UnitInfo.fLLBSailorCharacter1] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "c1".tr(), info.sailor?[UnitInfo.fLLBSailorCharacter1],
              isLLB: true),
        ),
        Visibility(
          visible: info.sailor?.keys.contains(UnitInfo.fLLBSailorCharacter2) ==
                  true &&
              info.sailor?[UnitInfo.fLLBSailorCharacter2] != "",
          child: UnitInfoUtils.instance.richText3Ways(
              context, "c2".tr(), info.sailor?[UnitInfo.fLLBSailorCharacter2],
              isLLB: true),
        ),
        UnitInfoUtils.instance.divider()
      ]),
    );
  }
}
