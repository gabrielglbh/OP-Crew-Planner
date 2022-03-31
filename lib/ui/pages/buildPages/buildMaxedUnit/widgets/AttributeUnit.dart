import 'package:flutter/material.dart';
import 'package:optcteams/ui/pages/buildPages/buildMaxedUnit/utils/enum_attribute.dart';

class AttributeUnit extends StatelessWidget {
  final Attribute attribute;
  final bool isMaxedVisible;
  final Color? color;
  final Function() onTap;
  const AttributeUnit({
    required this.onTap, required this.color, required this.attribute,
    required this.isMaxedVisible
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          border: Border.all(color: Colors.grey[600]!, width: 1),
          color: color
        ),
        child: Stack(children: [
          Positioned(
            top: 0,
            bottom: 0,
            left: -15,
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(attribute.asset, scale: attribute.scale)
              ),
            )
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 3.7,
              padding: EdgeInsets.only(right: 2),
              alignment: Alignment.center,
              child: Text(attribute.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 2),
            )
          ),
          Visibility(
            visible: isMaxedVisible,
            child: Positioned(
              top: 4,
              right: 0,
              child: Container(
                width: 35,
                child: Text("MAX", style: TextStyle(color: Colors.red[700], fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ])
      )
    );
  }
}
