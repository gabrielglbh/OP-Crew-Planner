import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginButton extends StatelessWidget {
  final Color? color;
  final Widget content;
  final bool visible;
  final Function() submit;
  const LoginButton({
    Key? key,
    required this.color, required this.content, required this.visible,
    required this.submit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        child: FittedBox(
          fit: BoxFit.contain,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: color,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: content,
            onPressed: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              submit();
            },
          ),
        )
      ),
    );
  }
}
