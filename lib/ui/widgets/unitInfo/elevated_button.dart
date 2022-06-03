import 'package:flutter/material.dart';

class UnitInfoElevatedButton extends StatelessWidget {
  final Function() onPressed;
  final Color? color;
  final Widget child;
  const UnitInfoElevatedButton(
      {Key? key,
      required this.child,
      required this.color,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          primary: color),
      child: Container(
          height: 40,
          margin: const EdgeInsets.only(top: 2, bottom: 2),
          child: Align(alignment: Alignment.center, child: child)),
    );
  }
}
