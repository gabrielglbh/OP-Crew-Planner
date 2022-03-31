class AnalyticsEvents {
  static const String createdBackUp = "backup_created";
  static const String downloadedBackUp = "backup_downloaded";
  static const String deletedBackUp = "backup_deleted";
  static const String closeSessionPwd = "session_closed_pwd";
  static const String closeSessionGoogle = "session_closed_google";
  static const String changePassword = "password_changed";
  static const String deleteAccountPwd = "account_deleted_pwd";
  static const String deleteAccountGoogle = "account_deleted_google";
  static const String logInPwd = "log_in_pwd";
  static const String signInPwd = "sign_in_pwd";
  static const String logInGoogle = "log_in_google";
  static const String changeLanguage = "change_language";
  static const String openVersionNotes = "open_version_notes";

  static const String changedTheme = "changed_theme";
  static const String writeReview = "write_a_review";
  static const String developerDialog = "developer_dialog_opened";
  static const String ackDialog = "acknowledgements_dialog_opened";

  static const String changedFiltersOnUnits = "changed_unit_list_filter";
  static const String openUnitDataFromHistory = "view_unit_data_from_history";
  static const String openUnitDataFromSearch = "view_unit_data_from_search";
  static const String deleteDataUnit = "deleted_single_unit_data";
  static const String deleteAllDataUnit = "deleted_all_unit_data";
  static const String clearHistory = "cleared_history";
  static const String deleteUnit = "deleted_unit";
  static const String deleteTeam = "deleted_team";
  static const String deleteRumbleTeam = "deleted_rumble_team";
  static const String openUnitDataFromUnitList = "view_unit_data_from_unit_list";
  static const String openUnitDataFromRecentList = "view_unit_data_from_recent_list";
  static const String unitReadyFilter = "filtered_units_by_rdy";
  static const String teamMaxFilter = "filtered_teams_by_maxed";
  static const String rumbleTeamModeFilter = "filtered_rumble_teams_by_mode";
  static const String closeRecentList = "recent_list_closed";
  static const String downloadLegends = "download_legends";

  static const String downloadUnitData = "downloaded_unit_data";
  static const String redirectToOPTCDB = "redirect_to_OPTC_DB";
  static const String redirectToPRDB = "redirect_to_Pirate_Rumble_DB";
  static const String showFullArt = "show_full_art";

  static const String openUnitDataFromUnit = "view_unit_data_from_build_unit";
  static const String openUnitDataFromUnitInfoButton = "view_unit_data_from_build_unit_info";
  static const String createdUnitToBeMaxed = "created_to_be_maxed_unit";
  static const String updatedUnitToBeMaxed = "updated_to_be_maxed_unit";

  static const String resetTeam = "empty_team_on_creation";
  static const String redirectToOPTCCalc = "redirect_to_OPTC_calc";
  static const String createdTeam = "created_team";
  static const String updatedTeam = "updated_team";
  static const String removeUnitFromTeam = "remove_unit_from_team_on_creation";
  static const String openUnitDataFromUnitOnTeam = "view_unit_data_from_unit_on_team";

  static const String resetRumbleTeam = "empty_rumble_team_on_creation";
  static const String createdRumbleTeam = "created_rumble_team";
  static const String updatedRumbleTeam = "updated_rumble_team";
  static const String removeUnitFromRumbleTeam = "remove_unit_from_rumble_team_on_creation";
  static const String openUnitDataFromUnitOnRumbleTeam = "view_unit_data_from_unit_on_rumble_team";
}