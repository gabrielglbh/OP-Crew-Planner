import 'package:flutter/material.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/pages/main/units/enum_unit_attributes.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/core/routing/arguments.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:easy_localization/easy_localization.dart';

class MaxedUnitElement extends StatefulWidget {
  final Unit unit;
  final List<bool> toBeMaxed;
  // Only for lose focus when click while searching
  final Function onSelected;
  final Function onTappedImage;
  final Function onDelete;
  MaxedUnitElement({required this.unit, required this.onSelected,
    required this.onDelete, required this.onTappedImage,
    required this.toBeMaxed});

  @override
  _MaxedUnitElementState createState() => _MaxedUnitElementState();
}

class _MaxedUnitElementState extends State<MaxedUnitElement> {
  @override
  Stack build(BuildContext context){
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => widget.onTappedImage(),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: UI.placeholderImageWhileLoadingUnit(widget.unit),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        widget.onSelected();
                          Navigator.of(context).pushNamed(OPCrewPlannerPages.buildMaxedUnitPageName,
                            arguments: UnitBuild(unit: widget.unit, update: true));
                      },
                      onLongPress: () { _showDeleteDialog(); },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: widget.unit.available == 1,
                                child: Container(
                                  width: 40,
                                  height: 20,
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[400],
                                    borderRadius: BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("readyBubble".tr(),
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                                  )
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 4, right: 4, bottom: 8),
                                  child: Text(widget.unit.name, overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 41,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: UnitAttributeToMax.values.length,
                                itemBuilder: (context, index) {
                                  return attrOnUnit(UnitAttributeToMax.values[index], widget.toBeMaxed[index]);
                                }
                              ),
                            )
                          )
                        ],
                      ),
                    )
                  )
                ],
              )
            ),
            Divider(thickness: 0.1, color: StorageUtils.readData(StorageUtils.darkMode, false)
                ? Colors.grey[350] : Colors.grey[800])
          ],
        )
      ],
    );
  }

  Visibility attrOnUnit(UnitAttributeToMax f, bool visible) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.only(right: 2, left: 2),
        child: Image.asset(f.asset, scale: f == UnitAttributeToMax.support ? 9 : null),
      )
    );
  }

  _showDeleteDialog() {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
            title: "onDeleteMaxedUnit".tr(),
            acceptButton: "deleteLabel".tr(),
            dialogContext: dialogContext,
            onAccepted: () {
              widget.onDelete();
            },
          );
        }
    );
  }
}