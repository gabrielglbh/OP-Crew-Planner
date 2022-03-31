import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  const ActionButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        onTap: () async => await onTap(),
        child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: child
        )
      ),
    );
  }
}
