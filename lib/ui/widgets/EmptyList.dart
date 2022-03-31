import 'package:flutter/material.dart';
import 'package:optcteams/ui/pages/main/enum_lists.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptyList extends StatelessWidget {
  final TypeList type;
  final Function() onRefresh;
  const EmptyList({required this.onRefresh, required this.type});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(type == TypeList.team || type == TypeList.rumble
                  ? "emptyTeamList".tr()
                  : type == TypeList.unit
                  ? "emptyUnitList".tr()
                  : "findUnits".tr(), textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                child: Text(type != TypeList.data
                    ? "emptyListSuggestion".tr()
                    : "suggestion".tr(), textAlign: TextAlign.center),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange[400]!,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text("tryAgain".tr()),
                onPressed: onRefresh,
              ),
            ],
          )
        ),
      ),
    );
  }
}
