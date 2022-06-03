import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optcteams/core/database/database.dart';
import 'package:optcteams/core/firebase/queries/update_queries.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'check_updates_event.dart';
part 'check_updates_state.dart';

class CheckUpdatesBloc extends Bloc<CheckUpdatesEvent, CheckUpdatesState> {
  CheckUpdatesBloc() : super(const CheckUpdatesLoadingState()) {
    on<CheckUpdatesInstallEvent>((event, emit) async {
      /// Check if there is a new version
      String v = await UpdateQueries.instance.getVersion(event.context);
      PackageInfo pi = await PackageInfo.fromPlatform();
      if (v != pi.version && v.isNotEmpty) {
        emit(CheckUpdatesNewVersionState(version: v));
      } else {
        /// Check the saved locale
        String loadedLocale = StorageUtils.readData(StorageUtils.language, "");
        if (loadedLocale != "") {
          OPCrewPlanner.setLocale(event.context, Locale(loadedLocale));
        }

        /// Open the database
        await CustomDatabase.instance.open(onUpdate: (String message) {
          emit(CheckUpdatesLoadingState(message: message));
        }).catchError((err) {
          emit(CheckUpdatesFailureState(message: err.toString()));
        });

        /// Check if there are any new units, aliases or ships
        await UpdateQueries.instance.getAllUnitsAndAliasesFromFireStore(
            onUpdate: (message, progress) {
          emit(CheckUpdatesLoadingState(message: message, progress: progress));
        }).catchError((err) {
          emit(CheckUpdatesFailureState(message: err.toString()));
        });

        emit(CheckUpdatesDoneState());
      }
    });

    on<CheckUpdatesResumeInstallEvent>((event, emit) async {
      /// Check the saved locale
      String loadedLocale = StorageUtils.readData(StorageUtils.language, "");
      if (loadedLocale != "") {
        OPCrewPlanner.setLocale(event.context, Locale(loadedLocale));
      }

      /// Open the database
      await CustomDatabase.instance.open(onUpdate: (String message) {
        emit(CheckUpdatesLoadingState(message: message));
      }).catchError((err) {
        emit(CheckUpdatesFailureState(message: err.toString()));
      });

      /// Check if there are any new units, aliases or ships
      await UpdateQueries.instance.getAllUnitsAndAliasesFromFireStore(
          onUpdate: (message, progress) {
        emit(CheckUpdatesLoadingState(message: message, progress: progress));
      }).catchError((err) {
        emit(CheckUpdatesFailureState(message: err.toString()));
      });

      emit(CheckUpdatesDoneState());
    });
  }
}
