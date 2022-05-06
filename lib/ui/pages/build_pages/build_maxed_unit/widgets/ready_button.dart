import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ReadyButton extends StatelessWidget {
  final Function() onTap;
  final Color? color;
  const ReadyButton({Key? key, required this.onTap, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          height: 30,
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: Colors.grey[600]!, width: 1),
            color: color
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text("readyLabel".tr(), style: TextStyle(fontSize: 12,
                fontWeight: FontWeight.bold, color: Colors.red[700])),
          )
        ),
      )
    );
  }
}
