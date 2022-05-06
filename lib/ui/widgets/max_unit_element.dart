import 'package:flutter/material.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/core/types/unit_attributes.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/utils.dart';
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
  const MaxedUnitElement({Key? key, required this.unit, required this.onSelected,
    required this.onDelete, required this.onTappedImage,
    required this.toBeMaxed}) : super(key: key);

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
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => widget.onTappedImage(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
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
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[400],
                                    borderRadius: const BorderRadius.all(Radius.circular(12))
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("readyBubble".tr(),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
                                  )
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                                  child: Text(widget.unit.name, overflow: TextOverflow.ellipsis),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 41,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: Attribute.values.length,
                                itemBuilder: (context, index) {
                                  return attrOnUnit(Attribute.values[index], widget.toBeMaxed[index]);
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

  Visibility attrOnUnit(Attribute f, bool visible) {
    return Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.only(right: 2, left: f == Attribute.maxLevelLimitBreak ? 12 : 2),
        child: Image.asset(f.asset, scale: f.scale),
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