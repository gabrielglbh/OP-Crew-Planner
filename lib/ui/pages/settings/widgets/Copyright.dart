import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CopyrightTile extends StatelessWidget {
  const CopyrightTile();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8),
        child: Text("contributorsOwners".tr(), style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
