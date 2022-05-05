import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UnitInfoUtils {
  static UnitInfoUtils instance = UnitInfoUtils();

  Future<void> onTappedOnExternalLink(bool optcdb, {String? uid}) async {
    if (optcdb) {
      String url = "https://optc-db.github.io/characters/#/view/$uid";
      if (await canLaunch(url)) {
        await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.redirectToOPTCDB);
        await launch(url);
      }
    } else {
      String url = "https://thepiebandit.github.io/optc-pirate-rumble-db/";
      if (await canLaunch(url)) {
        await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.redirectToPRDB);
        await launch(url);
      }
    }
  }

  Divider divider() => const Divider(thickness: 2);

  List<TextSpan> generateColorKeysForTextSpan(String? primalContent,
      {String? underlined, bool simple = true, bool parsePotential = false}) {
    List<String> parted = [];
    List<TextSpan> texts = [];
    Color? color = (!StorageUtils.readData(StorageUtils.darkMode, false)
        ? Colors.black87 : null);
    Color tColor = Colors.white;
    // Extract the _keys
    if (primalContent != null) parted = primalContent.split(" ");

    // Draw the widget tree of TextSpans
    if (!parsePotential) {
      if (!simple) {
        texts.add(TextSpan(text: "• ", style: TextStyle(color: color)));
        texts.add(TextSpan(text: "$underlined: ", style: TextStyle(decoration: TextDecoration.underline, color: color)));
      } else {
        texts.add(TextSpan(text: "• ", style: TextStyle(color: color)));
      }
    }
    for (var text in parted) {
      texts.add(const TextSpan(text: " "));
      switch (text) {
        case "[STR]":
          texts.add(TextSpan(text: " STR ", style: TextStyle(color: tColor, backgroundColor: UI.strT)));
          break;
        case "[QCK]":
          texts.add(TextSpan(text: " QCK ", style: TextStyle(color: tColor, backgroundColor: UI.qckT)));
          break;
        case "[DEX]":
          texts.add(TextSpan(text: " DEX ", style: TextStyle(color: tColor, backgroundColor: UI.dexT)));
          break;
        case "[PSY]":
          texts.add(TextSpan(text: " PSY ", style: TextStyle(color: tColor, backgroundColor: UI.psyT)));
          break;
        case "[INT]":
          texts.add(TextSpan(text: " INT ", style: TextStyle(color: tColor, backgroundColor: UI.intT)));
          break;
        case "[EMPTY]":
          texts.add(TextSpan(text: " EMPTY ", style: TextStyle(color: color)));
          break;
        case "[BLOCK]":
          texts.add(TextSpan(text: " BLOCK ", style: TextStyle(color: tColor, backgroundColor: UI.blockT)));
          break;
        case "[TND]":
          texts.add(TextSpan(text: " TND ", style: TextStyle(color: tColor, backgroundColor: UI.tndT)));
          break;
        case "[RCV]":
          texts.add(TextSpan(text: " RCV ", style: TextStyle(color: tColor, backgroundColor: UI.rcvT)));
          break;
        case "[SEMLA]":
          texts.add(TextSpan(text: " SEMLA ", style: TextStyle(color: tColor, backgroundColor: UI.semlaT)));
          break;
        case "[WANO]":
          texts.add(TextSpan(text: " WANO ", style: TextStyle(color: tColor, backgroundColor: UI.wanoT)));
          break;
        case "[BOMB]":
          texts.add(TextSpan(text: " BOMB ", style: TextStyle(color: tColor, backgroundColor: UI.bombT)));
          break;
        case "[G]":
          texts.add(TextSpan(text: " G ", style: TextStyle(color: tColor, backgroundColor: UI.gT)));
          break;
        case "[STR],":
          texts.add(TextSpan(text: " STR ", style: TextStyle(color: tColor, backgroundColor: UI.strT)));
          break;
        case "[QCK],":
          texts.add(TextSpan(text: " QCK ", style: TextStyle(color: tColor, backgroundColor: UI.qckT)));
          break;
        case "[DEX],":
          texts.add(TextSpan(text: " DEX ", style: TextStyle(color: tColor, backgroundColor: UI.dexT)));
          break;
        case "[PSY],":
          texts.add(TextSpan(text: " PSY ", style: TextStyle(color: tColor, backgroundColor: UI.psyT)));
          break;
        case "[INT],":
          texts.add(TextSpan(text: " INT ", style: TextStyle(color: tColor, backgroundColor: UI.intT)));
          break;
        case "[EMPTY],":
          texts.add(TextSpan(text: " EMPTY ", style: TextStyle(color: color)));
          break;
        case "[BLOCK],":
          texts.add(TextSpan(text: " BLOCK ", style: TextStyle(color: tColor, backgroundColor: UI.blockT)));
          break;
        case "[TND],":
          texts.add(TextSpan(text: " TND ", style: TextStyle(color: tColor, backgroundColor: UI.tndT)));
          break;
        case "[RCV],":
          texts.add(TextSpan(text: " RCV ", style: TextStyle(color: tColor, backgroundColor: UI.rcvT)));
          break;
        case "[SEMLA],":
          texts.add(TextSpan(text: " SEMLA ", style: TextStyle(color: tColor, backgroundColor: UI.semlaT)));
          break;
        case "[WANO],":
          texts.add(TextSpan(text: " WANO ", style: TextStyle(color: tColor, backgroundColor: UI.wanoT)));
          break;
        case "[BOMB],":
          texts.add(TextSpan(text: " BOMB ", style: TextStyle(color: tColor, backgroundColor: UI.bombT)));
          break;
        case "[G],":
          texts.add(TextSpan(text: " G ", style: TextStyle(color: tColor, backgroundColor: UI.gT)));
          break;
        default:
          texts.add(TextSpan(text: text, style: TextStyle(color: color)));
      }
    }
    if (!parsePotential) texts.add(const TextSpan(text: "\n"));
    return texts;
  }

  RichText richText3Ways(String? underlined, String? content) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
          children: generateColorKeysForTextSpan(content, underlined: underlined, simple: false)
      ),
    );
  }

  Column simpleSection(String asset, String? title, String? information,
      {bool italic = false, bool isLLB = false, bool needsSubsection = false,
        String? subsectionText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerOfSection(asset, title, italic: italic),
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: information?.isEmpty == true ? [] : generateColorKeysForTextSpan(information),
          ),
        ),
        Visibility(
          visible: isLLB,
          child: withLevelLimitBreakHeader()
        ),
        Visibility(
          visible: needsSubsection,
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: generateColorKeysForTextSpan(subsectionText),
            ),
          ),
        ),
        divider()
      ],
    );
  }

  Row headerOfSection(String asset, String? title, {bool italic = false}) {
    return Row(children: [
      Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SizedBox(width: 40, height: 40,
            child: Image.asset(asset),
          )
      ),
      Expanded(child: Text("\n$title:\n", style: TextStyle(fontWeight: FontWeight.bold,
          fontStyle: italic ? FontStyle.italic : null, fontSize: 18)))
    ],
    );
  }

  Widget withLevelLimitBreakHeader() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.red.shade600,
          Colors.orange.shade600,
          Colors.yellow.shade600
        ]),
        borderRadius: const BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text("withLLB".tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}