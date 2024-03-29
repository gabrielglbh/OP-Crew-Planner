import 'package:flutter/material.dart';
import 'package:optcteams/core/firebase/ads.dart';
import 'package:optcteams/core/firebase/queries/authentication.dart';
import 'package:optcteams/core/firebase/queries/backup_queries.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/types/backup_type.dart';
import 'package:optcteams/ui/pages/settings/widgets/setting_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';

class BackUpSettings extends StatefulWidget {
  final Function(bool) loading;
  final String? uid;
  const BackUpSettings({
    Key? key,
    required this.uid,
    required this.loading,
  }) : super(key: key);

  @override
  State<BackUpSettings> createState() => _BackUpSettingsState();
}

class _BackUpSettingsState extends State<BackUpSettings> {
  String _lastUpdated = "";
  String? _uid;

  BackupMode _operationId = BackupMode.create;
  bool _isAdReady = false;

  @override
  void initState() {
    setState(() => _uid = widget.uid);
    AdManager.createInterstitial(
        onLoaded: _onInterstitialLoaded,
        onFailed: _onInterstitialFailedOrExit,
        onClosed: _onInterstitialClosed);
    super.initState();
  }

  @override
  void dispose() {
    AdManager.disposeInterstitial();
    super.dispose();
  }

  _onInterstitialLoaded() => setState(() => _isAdReady = true);
  _onInterstitialFailedOrExit() => setState(() => _isAdReady = false);
  _onInterstitialClosed() {
    _isAdReady = false;
    _onAcceptedOperationDialog(_operationId);
  }

  @override
  void didChangeDependencies() {
    if (_uid == null) {
      _setStateDateBackup("errNoData".tr());
    } else {
      BackUpRecords.instance
          .getLastBackupTime((date) => _setStateDateBackup(date));
    }
    super.didChangeDependencies();
  }

  _getUid() {
    String? uid = AuthQueries.instance.getCurrentUserID();
    setState(() => _uid = uid);
  }

  _checkOnBackUpOperation(BuildContext context, BackupMode mode) {
    _getUid();
    if (_uid == null) {
      UI.showSnackBar(context, "errNotLoggedIn".tr());
    } else {
      _disclaimerBackUpDialog(mode);
    }
  }

  _disclaimerBackUpDialog(BackupMode mode) {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
              title: mode.title,
              content: Text(mode.content),
              acceptButton: mode.submit,
              dialogContext: dialogContext,
              onAccepted: () {
                Navigator.of(dialogContext).pop();
                _operationId = mode;
                if (_isAdReady) {
                  AdManager.showInterstitial(
                      onLoaded: _onInterstitialLoaded,
                      onFailed: _onInterstitialFailedOrExit,
                      onClosed: _onInterstitialClosed);
                } else {
                  _onAcceptedOperationDialog(mode);
                }
              });
        });
  }

  Future<void> _onAcceptedOperationDialog(BackupMode mode) async {
    widget.loading(true);
    switch (mode) {
      case BackupMode.create:
        await BackUpRecords.instance
            .uploadToFireStore(context, (date) => _setStateDateBackup(date))
            .then((value) => widget.loading(false));
        break;
      case BackupMode.download:
        await BackUpRecords.instance
            .getFromFireStore(context)
            .then((value) => widget.loading(false));
        break;
      case BackupMode.delete:
        await BackUpRecords.instance
            .deleteBackUp(context)
            .then((value) => widget.loading(false));
        break;
    }
  }

  _setStateDateBackup(String date) => setState(() => _lastUpdated = date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingHeader(
            title: "backUpTab".tr(),
            subtitle: "lastUpdated".tr() + _lastUpdated),
        SettingTile(
            title: Text("createBackup".tr()),
            icon: const Icon(Icons.cloud_upload, size: 20),
            onTap: () => _checkOnBackUpOperation(context, BackupMode.create)),
        SettingTile(
            title: Text("downloadBackup".tr()),
            icon: const Icon(Icons.cloud_download, size: 20),
            onTap: () => _checkOnBackUpOperation(context, BackupMode.download)),
        SettingTile(
            title: Text("deleteBackup".tr(),
                style: TextStyle(color: Colors.red[700])),
            icon: const Icon(Icons.cloud_off, size: 20),
            onTap: () => _checkOnBackUpOperation(context, BackupMode.delete)),
      ],
    );
  }
}
