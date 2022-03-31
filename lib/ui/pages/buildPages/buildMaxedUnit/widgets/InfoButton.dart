import 'package:flutter/material.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';

class InfoButton extends StatelessWidget {
  final Function() onTap;
  const InfoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        margin: EdgeInsets.only(bottom: 8, top: 16),
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(color: Colors.grey[600]!, width: 1),
            color: StorageUtils.readData(StorageUtils.darkMode, false) ? Colors.grey[800] : Colors.white
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text("Info", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red[700])),
        )
      ),
    );
  }
}
