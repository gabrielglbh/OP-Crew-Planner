import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/routing/arguments.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/ui/pages/settings/widgets/SettingTile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/pages/userManagement/utils/enum_user_mode.dart';

class AccountSettings extends StatefulWidget {
  final String? uid;
  const AccountSettings({required this.uid});

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String _userEmail = "";
  String? _uid;
  bool _verified = false;

  @override
  void initState() {
    setState(() => _uid = widget.uid);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getEmail();
    _getUid();
    _getEmailVerified();
    super.didChangeDependencies();
  }

  _getEmail() {
    String email = AuthQueries.instance.getCurrentUserEmail(context);
    setState(() => _userEmail = email);
  }

  _getEmailVerified() {
    bool verified = AuthQueries.instance.getCurrentUserEmailVerified();
    setState(() => _verified = verified);
  }

  _getUid() {
    String? uid = AuthQueries.instance.getCurrentUserID();
    setState(() => _uid = uid);
  }

  _decideNavigateToSignInPage(UserMode mode, {bool deleteAccount = false}) {
    Navigator.of(context).pushNamed(OPCrewPlannerPages.userManagementPage, arguments:
      ArgumentsManageAccount(mode: mode, delete: deleteAccount)).then((value) {
        _getEmail();
        _getUid();
        _getEmailVerified();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingHeader(
          title: "accountTab".tr(),
          subtitle: _userEmail + (_uid == null ? ""
              : (_verified ? "emailVerified".tr() : "verifyEmailDisclaimer".tr())),
          isAccountTabAndNotLoggedIn: !_verified && _uid != null
        ),
        Visibility(
          visible: _uid == null,
          child: SettingTile(
            title: Text(UserMode.signIn.label), icon: Icon(Icons.email),
            onTap: () => _decideNavigateToSignInPage(UserMode.signIn))
        ),
        Visibility(
          visible: _uid == null,
          child: SettingTile(
            title: Text(UserMode.logIn.label),
            icon: Padding(
              padding: EdgeInsets.only(left: 2, top: 2),
              child: FaIcon(FontAwesomeIcons.rightToBracket, size: 20),
            ),
            onTap: () => _decideNavigateToSignInPage(UserMode.logIn))
        ),
        Visibility(
          visible: _uid != null,
          child: SettingTile(
            title: Text("logOut".tr()),
            icon: Padding(
              padding: EdgeInsets.only(left: 4, top: 2),
              child: FaIcon(FontAwesomeIcons.rightFromBracket, size: 20),
            ),
            onTap: () {
              AuthQueries.instance.closeSession().then((value) {
                _getUid();
                _getEmail();
                _getEmailVerified();
              });
            })
        ),
        Visibility(
          visible: _uid != null,
          child: SettingHeader(title: "managementTab".tr()),
        ),
        Visibility(
          visible: _uid != null,
          child: SettingTile(
            title: Text("titleChangePassword".tr()),
            icon: Icon(Icons.lock),
            onTap: () async {
              User? user = AuthQueries.instance.getCurrentUser();
              // Checks provider ID. If user is logged in with Email/Password, then proceed
              if (user != null && user.providerData[0].providerId == "password") {
                _decideNavigateToSignInPage(UserMode.passwordChange);
              } else {
                UI.showSnackBar(context, "errGoogleNotAllowed".tr());
              }
            })
        ),
        Visibility(
          visible: _uid != null,
          child: SettingTile(
            title: Text("titleDeleteAccount".tr(), style: TextStyle(color: Colors.red[700])),
            icon: Icon(Icons.person_remove_alt_1),
            onTap: () => _decideNavigateToSignInPage(UserMode.logIn, deleteAccount: true))
        ),
      ],
    );
  }
}
