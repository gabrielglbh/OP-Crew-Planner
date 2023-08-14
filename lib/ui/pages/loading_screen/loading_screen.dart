import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/pages/loading_screen/bloc/check_updates_bloc.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:user_messaging_platform/user_messaging_platform.dart';

class LoadingScreenPage extends StatefulWidget {
  const LoadingScreenPage({Key? key}) : super(key: key);

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  Future<void> _versionDialog(BuildContext context, String newVersion) async {
    List<String> notes = await UpdateQueries.instance.getVersionNotes(context);
    Text child = const Text("");
    String versionNotes = "";
    if (notes.isNotEmpty) {
      for (var note in notes) {
        versionNotes = "$versionNotes$note\n";
      }
      child = Text(versionNotes);
    }
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return UIAlert(
          title: "newVersionTitle".tr(),
          dialogContext: context,
          content: Wrap(
            children: [Text("${"versionNotes".tr()}: $newVersion\n"), child],
          ),
          acceptButton: "goToStore".tr(),
          cancel: false,
          onAccepted: () async {
            await UI.launch(context, Data.storeLink);
          },
        );
      },
    ).then((_) => context.read<CheckUpdatesBloc>()
      ..add(CheckUpdatesResumeInstallEvent(context: context)));
  }

  Future<void> _updateConsent(BuildContext context) async {
    try {
      var info =
          await UserMessagingPlatform.instance.requestConsentInfoUpdate();
      if (info.consentStatus == ConsentStatus.required) {
        info = await UserMessagingPlatform.instance.showConsentForm();
      }
      if (!mounted) return;
      context
          .read<CheckUpdatesBloc>()
          .add(CheckUpdatesResumeVersionEvent(context: context));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: BlocProvider<CheckUpdatesBloc>(
                create: (_) => CheckUpdatesBloc()
                  ..add(CheckUpdatesInstallEvent(context: context)),
                child: BlocListener<CheckUpdatesBloc, CheckUpdatesState>(
                  listener: (context, state) async {
                    if (state is CheckUpdatesNewVersionState) {
                      await _versionDialog(context, state.version);
                    } else if (state is CheckUpdatesConsentState) {
                      await _updateConsent(context);
                    } else if (state is CheckUpdatesDoneState) {
                      Navigator.of(context).pushReplacementNamed(
                          OPCrewPlannerPages.navigationPageName);
                    }
                  },
                  child: BlocBuilder<CheckUpdatesBloc, CheckUpdatesState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.asset("res/icons/license_icon.png"),
                          ),
                          _decideOnState(state)
                        ],
                      );
                    },
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _decideOnState(CheckUpdatesState state) {
    if (state is CheckUpdatesFailureState) {
      return _contentFailure(state);
    } else if (state is CheckUpdatesLoadingState) {
      return _contentLoading(state);
    } else {
      return Container();
    }
  }

  Widget _contentFailure(CheckUpdatesState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Error\nPotential Fix: Clean cache memory and try again",
              style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("lostUpdates".tr(),
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text((state as CheckUpdatesFailureState).message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _contentLoading(CheckUpdatesState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Center(
              child: LinearProgressIndicator(
            value: (state as CheckUpdatesLoadingState).progress,
            backgroundColor: Colors.orange[100],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(state.message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("lostUpdates".tr(),
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center),
        )
      ],
    );
  }
}
