import 'package:flutter/material.dart';
import 'package:optcteams/core/database/queries/team_queries.dart';
import 'package:optcteams/core/routing/page_names.dart';
import 'package:optcteams/ui/widgets/CustomAlert.dart';
import 'package:optcteams/core/preferences/shared_preferences.dart';
import 'package:optcteams/core/utils/ui_utils.dart';
import 'package:optcteams/core/routing/arguments.dart';
import 'package:optcteams/core/database/models/team.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:optcteams/core/database/models/unit.dart';

class TeamElement extends StatefulWidget {
  final Team team;
  final int index;
  // Only for lose focus when click while searching
  final Function onSelected;
  final Function onDelete;
  TeamElement({required this.team, required this.index, required this.onSelected, required this.onDelete});

  @override
  _TeamElementState createState() => _TeamElementState();
}

class _TeamElementState extends State<TeamElement> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 135,
            child: InkWell(
              onTap: () {
                widget.onSelected();
                Navigator.of(context).pushNamed(OPCrewPlannerPages.buildTeamPageName,
                    arguments: TeamBuild(team: widget.team, update: true));
              },
              onLongPress: () { _showDeleteDialog(); },
              child: Column(children: <Widget>[
                Expanded(
                  child: Container(
                    child: Stack(children: [
                      Container (
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                value: widget.team.maxed == 0 ? true : false,
                                onChanged: (bool? v) {
                                  setState(() {
                                    widget.team.setMaxed((v ?? false) ? 0 : 1);
                                  });
                                  TeamQueries.instance.updateIsMaxed(widget.team);
                                },
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 115,
                                  child: Row(children: [
                                    Expanded(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width - 165,
                                        child: Text(widget.team.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                                        ),
                                      ),
                                    )
                                  ],
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: UI.placeholderImageWhileLoading(widget.team.ship.url),
                        ),
                      )
                    ],
                    ),
                  ),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                      physics: ScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, unitIndex) {
                        return unitImage(widget.index, unitIndex);
                      }
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16),
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

  Padding unitImage(int teamsIndex, int unitIndex) {
    Unit unit = widget.team.units[unitIndex];
    return Padding(
      padding: EdgeInsets.all(4),
      child: UI.placeholderImageWhileLoadingUnit(unit, little: true),
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