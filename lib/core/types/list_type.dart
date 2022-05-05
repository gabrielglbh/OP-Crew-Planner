import 'package:easy_localization/easy_localization.dart';

enum TypeList {
  unit, data, team, rumble
}

extension TypeListExt on TypeList {
  String get label {
    switch (this) {
      case TypeList.unit:
        return "unitsTab".tr();
      case TypeList.data:
        return "databaseTab".tr();
      case TypeList.team:
        return "teamsTab".tr();
      case TypeList.rumble:
        return "rumbleTab".tr();
    }
  }

  String get asset {
    switch (this) {
      case TypeList.unit:
        return "res/icons/units.png";
      case TypeList.data:
        return "res/icons/data.png";
      case TypeList.team:
        return "res/icons/teams.png";
      case TypeList.rumble:
        return "res/icons/rumble.png";
    }
  }

  double get scale {
    switch (this) {
      case TypeList.unit:
        return 2.7;
      case TypeList.data:
        return 4.2;
      case TypeList.team:
        return 2.9;
      case TypeList.rumble:
        return 2.95;
    }
  }
}