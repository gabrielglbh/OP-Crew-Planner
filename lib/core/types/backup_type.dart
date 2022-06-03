import 'package:easy_localization/easy_localization.dart';

enum BackupMode { create, download, delete }

extension BackupModeExt on BackupMode {
  String get title {
    switch (this) {
      case BackupMode.create:
        return "createBackUpDialogTitle".tr();
      case BackupMode.download:
        return "downloadBackUpDialogTitle".tr();
      case BackupMode.delete:
        return "deleteBackUpDialogTitle".tr();
    }
  }

  String get content {
    switch (this) {
      case BackupMode.create:
        return "createBackUpDialogContent".tr();
      case BackupMode.download:
        return "downloadBackUpDialogContent".tr();
      case BackupMode.delete:
        return "deleteBackUpDialogContent".tr();
    }
  }

  String get submit {
    switch (this) {
      case BackupMode.create:
        return "createBackUpDialogButton".tr();
      case BackupMode.download:
        return "downloadBackUpDialogButton".tr();
      case BackupMode.delete:
        return "deleteBackUpDialogButton".tr();
    }
  }
}
