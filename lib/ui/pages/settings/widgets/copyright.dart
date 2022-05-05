import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CopyrightTile extends StatelessWidget {
  const CopyrightTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8),
        child: Text("contributorsOwners".tr(), style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
