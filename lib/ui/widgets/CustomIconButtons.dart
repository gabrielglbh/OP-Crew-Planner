import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackIcon extends StatelessWidget {
  final Function() onTap;
  const BackIcon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await onTap(),
      icon: Icon(Icons.chevron_left),
    );
  }
}

class RegularIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const RegularIcon({required this.onTap, required this.icon});

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
  const FaviconIcon({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await onTap(),
      icon: FaIcon(icon, size: 20),
    );
  }
}
