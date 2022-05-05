import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:optcteams/core/firebase/firebase.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/pages/user_management/utils/enum_user_mode.dart';

class AuthQueries {
  final String _collection = "users";
  FirebaseFirestore? _ref;
  FirebaseAuth? _auth;

  AuthQueries._() {
    _ref = FirebaseUtils.instance.dbRef;
    _auth = FirebaseUtils.instance.authRef;
  }

  static final AuthQueries _instance = AuthQueries._();

  /// Singleton instance of [AuthQueries]
  static AuthQueries get instance => _instance;

  Future<User?> handleEmailSignIn(BuildContext context, UserMode mode,
      String email, String password) async {
    User? user;
    User? isAlreadySignedIn = _auth?.currentUser;

    if (isAlreadySignedIn != null) {
      user = _auth?.currentUser;
    } else {
      try {
        if (mode == UserMode.logIn) {
          UserCredential? credential = await _auth?.createUserWithEmailAndPassword(
              email: email, password: password);
          UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.signInPwd);

          user = credential?.user;
          if (user != null) user.sendEmailVerification();
        } else {
          UserCredential? credential = await _auth?.signInWithEmailAndPassword(
              email: email, password: password);
              UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.logInPwd);
          user = credential?.user;
        }
      } catch(err) {
        UI.showSnackBar(context, err.toString());
      }
    }
    return user;
  }

  Future<User?> handleGoogleSignIn(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    User? user;

    try {
      bool isSignedIn = await _googleSignIn.isSignedIn();

      if (isSignedIn) _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );
        user = (await _auth?.signInWithCredential(credential))?.user;
        UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.logInGoogle);

        return user;
      }
    } catch (err) {
      UI.showSnackBar(context, err.toString() + " " + "errTryAgain".tr());
    }
    return null;
  }

  String getCurrentUserEmail(BuildContext context)  {
    User? user = _auth?.currentUser;
    if (user != null) {
      user.reload();
      return (user.email ?? "");
    } else {
      return "errNotLogged".tr();
    }
  }

  String? getCurrentUserID() {
    User? user = _auth?.currentUser;
    if (user != null) {
      user.reload();
      return user.uid;
    } else {
      return null;
    }
  }

  User? getCurrentUser() => _auth?.currentUser;

  bool getCurrentUserEmailVerified() {
    User? user = _auth?.currentUser;
    if (user != null) {
      user.reload();
      return user.emailVerified;
    } else {
      return false;
    }
  }

  Future<void> closeSession() async {
    await _auth?.signOut();
    await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.closeSessionPwd);
  }

  Future<void> closeGoogleSession() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.closeSessionGoogle);
  }

  /// Firebase Authentication Modifications

  Future<bool> changePassword(BuildContext context, String previousPassword, String newPassword) async {
    try {
      User? user = _auth?.currentUser;

      if (user != null) {
        // Signs In again before operation ONLY WITH EMAIL
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: previousPassword);
        User? reUser = (await user.reauthenticateWithCredential(credential)).user;

        if (reUser != null && reUser.uid == user.uid && reUser.email == user.email){
          await user.updatePassword(newPassword);
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.changePassword);
          return true;
        }
        else {
          UI.showSnackBar(context, "errChangePassword".tr());
          return false;
        }
      } else {
        return false;
      }
    } catch (err) {
      UI.showSnackBar(context, "errChangePassword".tr());
      return false;
    }
  }

  Future<bool> deleteAccount(BuildContext context, String password) async {
    try {
      User? user = _auth?.currentUser;

      if (user != null && user.providerData[0].providerId == "password") {
        // Signs In again before operation
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: password);
        User? reUser = (await user.reauthenticateWithCredential(credential)).user;

        if (reUser != null && reUser.uid == user.uid && reUser.email == user.email) {
          await _ref?.collection(_collection).doc(user.uid).delete();
          await user.delete();
          await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteAccountPwd);
          return true;
        }
        else {
          UI.showSnackBar(context, "errDeleteAccount".tr());
          return false;
        }
      } else {
        return false;
      }
    } catch (err) {
      UI.showSnackBar(context, "errDeleteAccount".tr());
      return false;
    }
  }

  Future<bool> deleteGoogleAccount(BuildContext context) async {
    try {
      User? user = _auth?.currentUser;

      // Checks provider ID. If user is logged in with Google, then proceed
      if (user != null && user.providerData[0].providerId == "google.com") {
        // Signs In again before operation
        GoogleSignIn _googleSignIn = GoogleSignIn();
        bool isSignedIn = await _googleSignIn.isSignedIn();

        if (isSignedIn) {
          // If user is signed in (CURRENT USER == GOOGLE USER):
          // Sign in again and get the credential to validate
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser != null) {
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken
            );
            User? reUser = (await user.reauthenticateWithCredential(credential)).user;

            // If recently signed in user has same uid and email, then proceed to delete
            if (reUser != null && reUser.uid == user.uid && reUser.email == user.email) {
              await FirebaseFirestore.instance.collection(_collection).doc(user.uid).delete();
              await user.delete();
              await UpdateQueries.instance.registerAnalyticsEvent(AnalyticsEvents.deleteAccountGoogle);
              return true;
            } else {
              UI.showSnackBar(context, "errDeleteAccount".tr());
              return false;
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        UI.showSnackBar(context, "errNoGoogleAccount".tr());
        return false;
      }
    } catch (err) {
      UI.showSnackBar(context, "errDeleteAccount".tr());
      return false;
    }
  }
}