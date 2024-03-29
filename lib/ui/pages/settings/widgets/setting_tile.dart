import 'package:flutter/material.dart';
import 'package:optcteams/ui/utils.dart';

class SettingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isAccountTabAndNotLoggedIn;
  const SettingHeader(
      {Key? key,
      required this.title,
      this.subtitle = "",
      this.isAccountTabAndNotLoggedIn = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: subtitle.isEmpty
          ? 65
          : isAccountTabAndNotLoggedIn
              ? 120
              : 90,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Visibility(
            visible: subtitle.isNotEmpty,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 2),
                child: Text(subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic)),
              ),
            ),
          ),
          Divider(
            color:
                UI.isDarkTheme(context) ? Colors.grey[350] : Colors.grey[800],
            thickness: 0.2,
          )
        ],
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Function() onTap;
  const SettingTile(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(width: 25, height: 25, child: icon),
          ),
          Expanded(child: title)
        ],
      ),
      onTap: () async => onTap(),
    );
  }
}
