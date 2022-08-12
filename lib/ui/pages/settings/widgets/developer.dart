import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class DeveloperTile extends StatelessWidget {
  const DeveloperTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.only(top: 8),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.handyman),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text("Gabriel García", style: TextStyle(fontSize: 14)),
              )
            ],
          ),
          InkWell(
            onTap: () {
              launchUrl(Uri.parse("https://github.com/gabrielglbh"));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("res/icons/github.png", scale: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Text("@gabrielglbh", style: TextStyle(fontSize: 14)),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.bug_report),
              Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "bugsLabel".tr(),
                            style: TextStyle(
                                color: (!UI.isDarkTheme(context)
                                    ? Colors.black87
                                    : null),
                                fontSize: 14)),
                        TextSpan(
                          text: "devgglop@gmail.com",
                          style: TextStyle(
                              color: Colors.orange[400],
                              decoration: TextDecoration.underline,
                              fontSize: 14),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'devgglop@gmail.com',
                                  queryParameters: {
                                    'subject': "mailSubject".tr(),
                                  });
                              String url = emailLaunchUri
                                  .toString()
                                  .replaceAll("+", "%20");
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                UI.showSnackBar(context, "errOnLaunch".tr());
                              }
                            },
                        ),
                      ]),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
