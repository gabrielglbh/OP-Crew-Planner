import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UIAlert extends StatefulWidget {
  final String title;
  final double textSize;
  final Widget? content;
  final String acceptButton;
  final BuildContext dialogContext;
  final Function onAccepted;
  final bool cancel;
  const UIAlert(
      {Key? key,
      required this.title,
      this.textSize = 18,
      this.content,
      required this.acceptButton,
      required this.dialogContext,
      required this.onAccepted,
      this.cancel = true})
      : super(key: key);

  @override
  State<UIAlert> createState() => _UIAlertState();
}

class _UIAlertState extends State<UIAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(widget.title, style: TextStyle(fontSize: widget.textSize)),
        content: widget.content,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        actions: <Widget>[
          Visibility(
            visible: widget.cancel,
            child: TextButton(
              child: Text("cancelLabel".tr()),
              onPressed: () {
                Navigator.of(widget.dialogContext).pop();
              },
            ),
          ),
          TextButton(
            child: Text(widget.acceptButton,
                style: const TextStyle(color: Colors.red)),
            onPressed: () {
              widget.onAccepted();
            },
          )
        ]);
  }
}
