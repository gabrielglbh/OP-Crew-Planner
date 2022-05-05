import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:optcteams/ui/pages/user_management/utils/enum_user_mode.dart';

class TeamBuild {
  Team team;
  bool update;

  TeamBuild({required this.team, required this.update});
}

class UnitBuild {
  Unit unit;
  bool update;

  UnitBuild({required this.unit, required this.update});
}

class RumbleBuild {
  RumbleTeam team;
  bool update;

  RumbleBuild({required this.team, required this.update});
}

class ArgumentsManageAccount {
  UserMode mode;
  bool delete;

  ArgumentsManageAccount({required this.mode, required this.delete});
}