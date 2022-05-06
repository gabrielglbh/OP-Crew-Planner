import 'package:flutter/material.dart';
import 'package:optcteams/core/database/models/rumble.dart';
import 'package:optcteams/core/routing/arguments.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/models/unit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/ui/widgets/custom_alert.dart';

class RumbleElement extends StatefulWidget {
  final RumbleTeam team;
  final int index;
  // Only for lose focus when click while searching
  final Function onSelected;
  final Function onDelete;
  const RumbleElement({Key? key, required this.team, required this.index,
    required this.onSelected, required this.onDelete}) : super(key: key);

  @override
  _RumbleElementState createState() => _RumbleElementState();
}

class _RumbleElementState extends State<RumbleElement> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 129,
          child: InkWell(
            onTap: () {
              widget.onSelected();
              Navigator.of(context).pushNamed(OPCrewPlannerPages.buildRumbleTeamPageName,
                  arguments: RumbleBuild(team: widget.team, update: true));
            },
            onLongPress: () { _showDeleteDialog(); },
            child: Column(children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.team.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                  ),
                ),
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  physics: const ScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, unitIndex) {
                    return unitImage(widget.index, unitIndex);
                  }
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: Text("lastUpdated".tr() + (widget.team.updated ?? "")),
                ),
              )
            ],
            ),
          )
        ),
        Divider(thickness: 0.1, color: StorageUtils.readData(StorageUtils.darkMode, false)
            ? Colors.grey[350] : Colors.grey[800])
      ],
    );
  }

  Container unitImage(int teamsIndex, int unitIndex) {
    Unit unit = widget.team.units[unitIndex];
    return Container(
      padding: unitIndex > 4 ? null : const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: unitIndex > 4 ? Border.all(color: Colors.blue[700]!, width: 3) : null,
      ),
      child: UI.placeholderImageWhileLoadingUnit(unit, little: true)
    );
  }

  void _showDeleteDialog() {
    BuildContext dialogContext;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          dialogContext = context;
          return UIAlert(
            title: "onDeleteTeam".tr() + widget.team.name + "?",
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