import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';

class SettingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isAccountTabAndNotLoggedIn;
  const SettingHeader({
    required this.title, this.subtitle = "", this.isAccountTabAndNotLoggedIn = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: subtitle.isEmpty ? 65 : isAccountTabAndNotLoggedIn ? 120 : 90,
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
          Visibility(
            visible: subtitle.isNotEmpty,
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 2),
                child: Text(subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              ),
            ),
          ),
          Divider(
            color: StorageUtils.readData(StorageUtils.darkMode, false)
                ? Colors.grey[350] : Colors.grey[800],
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
  const SettingTile({
    required this.icon, required this.title, required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(width: 25, height: 25, child: icon),
          ),
          Expanded(child: title)
        ],
      ),
      onTap: () async => onTap(),
    );
  }
}

