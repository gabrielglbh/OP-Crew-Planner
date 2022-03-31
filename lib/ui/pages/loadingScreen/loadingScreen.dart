import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/pages/loadingScreen/bloc/check_updates_bloc.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class LoadingScreenPage extends StatefulWidget {
  @override
  _LoadingScreenPageState createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  Future<void> _versionDialog(BuildContext context, String newVersion) async {
    List<String> notes = await UpdateQueries.instance.getVersionNotes(context);
    Text child = Text("");
    String versionNotes = "";
    if (notes.isNotEmpty) {
      notes.forEach((note) => versionNotes = versionNotes + "$note\n");
      child = Text(versionNotes);
    }
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return UIAlert(
          title: "newVersionTitle".tr(),
          dialogContext: context,
          content: Wrap(
            children: [
              Text("${"versionNotes".tr()}: $newVersion\n"),
              child
            ],
          ),
          acceptButton: "goToStore".tr(),
          cancel: false,
          onAccepted: () async {
            if (await canLaunch(Data.storeLink)) await launch(Data.storeLink);
          },
        );
      },
    ).then((_) => context.read<CheckUpdatesBloc>()..add(CheckUpdatesResumeInstallEvent(
      context: context
    )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: BlocProvider<CheckUpdatesBloc>(
              create: (_) =>
                CheckUpdatesBloc()..add(CheckUpdatesInstallEvent(context: context)),
              child: BlocListener<CheckUpdatesBloc, CheckUpdatesState>(
                listener: (context, state) async {
                  if (state is CheckUpdatesNewVersionState)
                    await _versionDialog(context, state.version);
                  else if (state is CheckUpdatesDoneState)
                    Navigator.of(context).pushReplacementNamed(OPCrewPlannerPages.navigationPageName);
                },
                child: BlocBuilder<CheckUpdatesBloc, CheckUpdatesState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200, height: 200,
                          child: Image.asset("res/icons/license_icon.png"),
                        ),
                        _decideOnState(state)
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _decideOnState(CheckUpdatesState state) {
    if (state is CheckUpdatesFailureState)
      return _contentFailure(state);
    else if (state is CheckUpdatesLoadingState)
      return _contentLoading(state);
    else
      return Container();
  }

  Widget _contentFailure(CheckUpdatesState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text("Error\nPotential Fix: Clean cache memory and try again",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text("lostUpdates".tr(), style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text((state as CheckUpdatesFailureState).message,
            style: TextStyle(fontSize: 16),
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
          padding: EdgeInsets.all(16),
          child: Center(
            child: LinearProgressIndicator(
              value: (state as CheckUpdatesLoadingState).progress,
              backgroundColor: Colors.orange[100],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(state.message,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Text("lostUpdates".tr(), style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center),
        )
      ],
    );
  }
}
