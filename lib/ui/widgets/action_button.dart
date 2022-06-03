import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  const ActionButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          onTap: () async => await onTap(),
          child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: child)),
    );
  }
}
