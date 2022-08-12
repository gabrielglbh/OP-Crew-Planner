import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/theme/theme_manager.dart';

class ChangeAppTheme extends StatefulWidget {
  const ChangeAppTheme({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        builder: (context) => const ChangeAppTheme());
  }

  @override
  State<ChangeAppTheme> createState() => _ChangeAppThemeState();
}

class _ChangeAppThemeState extends State<ChangeAppTheme> {
  late ThemeMode _mode;

  @override
  void initState() {
    _mode = ThemeManager.instance.themeMode ?? ThemeMode.system;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
            title: Text("settings_theme_system".tr()),
            value: ThemeMode.system,
            groupValue: _mode,
            activeColor: Colors.orange[400],
            onChanged: _onTileSelected),
        RadioListTile<ThemeMode>(
            title: Text("settings_theme_light".tr()),
            value: ThemeMode.light,
            groupValue: _mode,
            activeColor: Colors.orange[400],
            onChanged: _onTileSelected),
        RadioListTile<ThemeMode>(
            title: Text("settings_theme_dark".tr()),
            value: ThemeMode.dark,
            groupValue: _mode,
            activeColor: Colors.orange[400],
            onChanged: _onTileSelected),
      ],
    );
  }

  _onTileSelected(ThemeMode? val) {
    setState(() => _mode = val ?? ThemeMode.system);
    ThemeManager.instance.switchMode(_mode);
    Navigator.of(context).pop();
  }
}
