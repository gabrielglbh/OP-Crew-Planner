import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class DeveloperTile extends StatelessWidget {
  const DeveloperTile();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.only(top: 8),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.handyman),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text("Gabriel García", style: TextStyle(fontSize: 14)),
              )
            ],
          ),
          InkWell(
            onTap: () {launch("https://github.com/gabrielglbh");},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("res/icons/github.png", scale: 20),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Text("@gabrielglbh", style: TextStyle(fontSize: 14)),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.bug_report),
              Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "bugsLabel".tr(), style: TextStyle(
                              color: (!StorageUtils.readData(StorageUtils.darkMode, false)
                                  ? Colors.black87 : null), fontSize: 14)
                          ),
                          TextSpan(
                            text: "devgglop@gmail.com",
                            style: TextStyle(color: Colors.orange[400],
                                decoration: TextDecoration.underline, fontSize: 14
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final Uri _emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'devgglop@gmail.com',
                                  queryParameters: {
                                    'subject': "mailSubject".tr(),
                                  }
                                );
                                String url = _emailLaunchUri.toString().replaceAll("+", "%20");
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  UI.showSnackBar(context, "errOnLaunch".tr());
                                }
                              },
                          ),
                        ]
                      ),
                    ),
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}
