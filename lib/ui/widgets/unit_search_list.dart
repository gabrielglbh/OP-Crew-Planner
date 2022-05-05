import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/core/utils/ui_utils.dart';

class UnitSearchList extends StatelessWidget {
  final List<Unit> units;
  final Function(String) onTap;
  const UnitSearchList({Key? key, required this.units, required this.onTap}) : super(key: key);

  bool _onScrolling(ScrollNotification sn) {
    if (sn is ScrollStartNotification || sn is ScrollUpdateNotification) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          return _onScrolling(notification);
        },
        child: Scrollbar(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: units.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onTap(units[index].id),
                  child: UI.placeholderImageWhileLoadingUnit(units[index])
                );
              }
          ),
        ),
      ),
    );
  }
}
