import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/ui/widgets/BottomSheetChoices.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:easy_localization/easy_localization.dart';

class MainUtils {
  static MainUtils instance = MainUtils();

  showDialogForMenuManage(BuildContext context, {required Function() onAccepted,
    required Function() clearHistory, required Function() removeData}) {
    Scrollbar child = Scrollbar(
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              if (index == 0) {
                showDialog(context: context, barrierDismissible: true, builder: (context) {
                  return UIAlert(
                    title: "clearHistoryTitle".tr(),
                    acceptButton: "yes".tr(),
                    cancel: true,
                    dialogContext: context,
                    onAccepted: () async {
                      Navigator.of(context).pop();
                      await clearHistory();
                    },
                  );
                });
              } else if (index == 1) {
                showDialog(context: context, barrierDismissible: true, builder: (context) {
                  return UIAlert(
                    title: "deleteTitleAlert".tr(),
                    acceptButton: "deleteLabel".tr(),
                    dialogContext: context,
                    onAccepted: () async {
                      Navigator.of(context).pop();
                      await removeData();
                    },
                  );
                });
              } else {
                if (StorageUtils.readData(StorageUtils.downloadedLegends, false)) {
                  UI.showSnackBar(context, "legendsDone".tr());
                } else {
                  showDialog(context: context, barrierDismissible: true, builder: (context) {
                    return UIAlert(
                      title: "downloadLegendsTitle".tr(),
                      content: Text("disclaimerOnLegends".tr()),
                      acceptButton: "yes".tr(),
                      cancel: true,
                      dialogContext: context,
                      onAccepted: () async {
                        Navigator.of(context).pop();
                        onAccepted();
                      },
                    );
                  });
                }
              }
            },
            title: index != 2
                ? Text(index == 0 ? "clear".tr() : "deleteDownloads".tr(),
                overflow: TextOverflow.ellipsis)
                : Row(children: [
              Text("menuDownloadLegends".tr(), overflow: TextOverflow.ellipsis),
              Image.asset("res/icons/legends.png", scale: 7)
            ]),
          );
        }
      ),
    );
    ChoiceBottomSheet.callModalSheet(context, "options".tr(), child, height: 3.5);
  }
}