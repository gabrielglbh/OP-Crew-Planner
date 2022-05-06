import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackIcon extends StatelessWidget {
  final Function() onTap;
  const BackIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await onTap(),
      icon: const Icon(Icons.chevron_left),
    );
  }
}

class RegularIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const RegularIcon({Key? key, required this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await onTap(),
      icon: Icon(icon),
    );
  }
}

class FaviconIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const FaviconIcon({Key? key, required this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await onTap(),
      icon: FaIcon(icon, size: 20),
    );
  }
}
