import 'package:flutter/material.dart';

class ChoiceBottomSheet extends StatefulWidget {
  final String title;
  final Widget child;
  final double height;
  ChoiceBottomSheet({required this.title, required this.child, required this.height});

  @override
  _ChoiceBottomSheetState createState() => _ChoiceBottomSheetState();

  static Future<void> callModalSheet(BuildContext context, String title, Widget child,
      {required double height}) async {
    await showModalBottomSheet(context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => ChoiceBottomSheet(title: title, child: child, height: height)
    );
  }
}

class _ChoiceBottomSheetState extends State<ChoiceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () => {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
        topRight: Radius.circular(18), topLeft: Radius.circular(18))
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / widget.height,
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 90, height: 5,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.grey[300]),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(widget.title, textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                )
              ),
              Expanded(child: widget.child)
            ],
          ),
        );
      }
    );
  }
}