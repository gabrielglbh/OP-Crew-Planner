import 'package:flutter/material.dart';
import 'package:optcteams/ui/widgets/bottom_sheet_choices.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:easy_localization/easy_localization.dart';

class MainUtils {
  static MainUtils instance = MainUtils();

  showDialogForMenuManage(BuildContext context,
      {required Function() clearHistory, required Function() removeData}) {
    Scrollbar child = Scrollbar(
      child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                if (index == 0) {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
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
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
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
                }
              },
              title: Text(index == 0 ? "clear".tr() : "deleteDownloads".tr(),
                  overflow: TextOverflow.ellipsis),
            );
          }),
    );
    ChoiceBottomSheet.callModalSheet(context, "options".tr(), child,
        height: 4.5);
  }
}
