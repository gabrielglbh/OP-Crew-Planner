import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'dart:core';
import 'package:optcteams/ui/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/types/user_login_mode.dart';
import 'package:optcteams/ui/pages/user_management/widgets/login_button.dart';
import 'package:optcteams/ui/widgets/loading_widget.dart';

class UserManagementPage extends StatefulWidget {
  // Mode 0 --> Log In
  // Mode 1 --> Sign In
  // Mode 2 --> Change password
  final UserMode mode;
  final bool deleteAccount;
  const UserManagementPage({Key? key, required this.mode, this.deleteAccount = false}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {

  GlobalKey<FormState>? _formKey;
  TextEditingController? _firstFieldController;
  TextEditingController? _secondFieldController;
  FocusNode? _firstFieldFocus;
  FocusNode? _secondFieldFocus;

  bool _wasSubmitted = false;
  bool _currentlyLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _firstFieldController = TextEditingController();
    _secondFieldController = TextEditingController();
    _firstFieldFocus = FocusNode();
    _secondFieldFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _firstFieldController?.dispose();
    _secondFieldController?.dispose();
    _firstFieldFocus?.dispose();
    _secondFieldFocus?.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop({bool fromLeading = false}) async {
    bool _hasFocus = ((_firstFieldFocus?.hasFocus ?? false) || (_secondFieldFocus?.hasFocus ?? false));
    if (_hasFocus || _currentlyLoading) {
      _firstFieldFocus?.unfocus();
      _secondFieldFocus?.unfocus();
      return false;
    } else {
      if (fromLeading) Navigator.pop(context);
      return true;
    }
  }

  String? _validateCredentials(String hint, String term) {
    if (hint == "hintEmail".tr()) {
      if (!EmailValidator.validate(term) || term.isEmpty) {
        return "errEmailNotValid".tr();
      }
    }
    if (hint == "hintPassword".tr() || hint == "hintActualPassword".tr()
        || hint == "hintNewPassword".tr()) {
      if (term.length < 8 || term.isEmpty) {
        if (hint == "hintPassword".tr()) {
          return "errPasswordNotValid".tr();
        } else if (hint == "hintActualPassword".tr()) {
          return "errActualPasswordNotValid".tr();
        } else if (hint == "hintNewPassword".tr()) {
          return "errNewPasswordNotValid".tr();
        }
      }
    }
    return null;
  }

  _focusRequest(String hint) {
    if (hint == "hintEmail".tr() || hint == "hintActualPassword".tr()) {
      _firstFieldFocus?.unfocus();
      _secondFieldFocus?.requestFocus();
    } else {
      _secondFieldFocus?.unfocus();
      _submit(widget.mode);
    }
  }

  _loseFocus() {
    _firstFieldFocus?.unfocus();
    _secondFieldFocus?.unfocus();
  }

  _submit(UserMode mode) {
    setState(() => _currentlyLoading = true);
    _loseFocus();
    if ((_formKey?.currentState?.validate() ?? false)) {
      if (widget.mode != UserMode.passwordChange) {
        if (widget.deleteAccount) {
          AuthQueries.instance.deleteAccount(context, (_secondFieldController?.text ?? "")).then((bool success) {
            setState(() => _currentlyLoading = false);
            if (success) Navigator.of(context).pop();
          });
        } else {
          AuthQueries.instance.handleEmailSignIn(context, mode, (_firstFieldController?.text ?? ""),
              (_secondFieldController?.text ?? "")).then((user) {
            setState(() => _currentlyLoading = false);
            if (user != null) Navigator.of(context).pop();
          });
        }
      } else {
        if (_firstFieldController?.text == _secondFieldController?.text) {
          setState(() => _currentlyLoading = false);
          UI.showSnackBar(context, "errSamePassword".tr());
        } else {
          AuthQueries.instance.changePassword(context, (_firstFieldController?.text ?? ""),
              (_secondFieldController?.text ?? "")).then((bool success) {
            setState(() => _currentlyLoading = false);
            if (success) Navigator.of(context).pop();
          });
        }
      }
    } else {
      setState(() => _currentlyLoading = false);
      _firstFieldController?.clear();
      _secondFieldController?.clear();
      setState(() => _wasSubmitted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.deleteAccount ? "titleDeleteAccount".tr() : widget.mode.label),
              automaticallyImplyLeading: false,
              leading: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                onTap: () { _onWillPop(fromLeading: true); },
                child: const Icon(Icons.chevron_left, size: 40),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Form(key: _formKey, child: _loginForm()),
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      child: _actionButtons()
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        FullScreenLoadingWidget(isLoading: _currentlyLoading)
      ],
    );
  }

  Column _loginForm() {
    return Column(
      children: [
        Visibility(
          visible: widget.deleteAccount,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("infoOnDeleteAccount".tr(), textAlign: TextAlign.justify),
          )
        ),
        _formElement(widget.mode != UserMode.passwordChange ? "hintEmail".tr() : "hintActualPassword".tr()),
        _formElement(widget.mode != UserMode.passwordChange ? "hintPassword".tr() : "hintNewPassword".tr()),
        LoginButton(
          color: Colors.red[700]!,
          content: Text("titleLogIn".tr() + "googleSignIn".tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),),
          visible: widget.deleteAccount,
          submit: () {
            _loseFocus();
            setState(() => _currentlyLoading = true);
            AuthQueries.instance.deleteGoogleAccount(context).then((bool success) {
              setState(() => _currentlyLoading = false);
              if (success) Navigator.of(context).pop();
            });
          }
        )
      ],
    );
  }

  Widget _formElement(String hint) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: (hint == "hintEmail".tr()
            || hint == "hintActualPassword".tr()) ? _firstFieldController : _secondFieldController,
        obscureText: (hint == "hintEmail".tr()) ? false : true,
        textInputAction: (hint == "hintEmail".tr()
            || hint == "hintActualPassword".tr()) ? TextInputAction.next : TextInputAction.done,
        focusNode: (hint == "hintEmail".tr()
            || hint == "hintActualPassword".tr()) ? _firstFieldFocus : _secondFieldFocus,
        onFieldSubmitted: (term) {
          _focusRequest(hint);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          filled: false,
          hintText: hint
        ),
        validator: (term) {
          if (term != null) return _validateCredentials(hint, term);
          return null;
        },
        onTap: () {
          if (_wasSubmitted) {
            _formKey?.currentState?.reset();
            setState(() {
              _wasSubmitted = false;
            });
          }
        },
      ),
    );
  }

  Row _actionButtons() {
    return Row(
      mainAxisAlignment: (widget.mode != UserMode.passwordChange && !widget.deleteAccount)
          ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
      children: [
        LoginButton(
          color: Colors.red[700]!,
          content: Text((widget.mode.label) + "googleSignIn".tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          visible: (widget.mode != UserMode.passwordChange && !widget.deleteAccount) ? true : false,
          submit: () {
            _loseFocus();
            setState(() => _currentlyLoading = true);
            AuthQueries.instance.handleGoogleSignIn(context).then((user) {
              setState(() => _currentlyLoading = false);
              if (user != null) Navigator.of(context).pop();
            });
          }
        ),
        LoginButton(
          color: Colors.orange,
          content: Text(widget.deleteAccount ? "titleDeleteAccount".tr() : widget.mode.label,
            style: const TextStyle(color: Colors.white)),
          visible: true,
          submit: () { _submit(widget.mode); }
        ),
      ],
    );
  }
}