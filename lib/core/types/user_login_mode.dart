import 'package:easy_localization/easy_localization.dart';

enum UserMode { signIn, logIn, passwordChange }

extension UserModeExt on UserMode {
  String get label {
    switch (this) {
      case UserMode.signIn:
        return "titleSignIn".tr();
      case UserMode.logIn:
        return "titleLogIn".tr();
      case UserMode.passwordChange:
        return "titleChangePassword".tr();
    }
  }
}
