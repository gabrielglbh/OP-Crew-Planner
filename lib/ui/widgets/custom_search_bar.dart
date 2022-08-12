import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optcteams/ui/utils.dart';
import 'package:optcteams/core/database/data.dart';
import 'package:optcteams/core/database/models/unit.dart';

enum SearchMode { unitTab, dataTab, teamTab, rumbleTab, regularUnitSearch }

class CustomSearchBar extends StatefulWidget {
  static const double normalHeight = 50;
  static const double filterHeight = 102;

  /// Action to perform when the query is ready to be searched on the db
  final Function(String, String) onQuery;

  /// Action to perform when the user exits the search, usually load all lists
  final Function onExitSearch;

  /// Hint text to show on the search bar when not used
  final String hint;

  /// [FocusNode] of the search bar created in the parent widget
  final FocusNode? focus;
  final TextEditingController? controller;
  final SearchMode mode;
  const CustomSearchBar(
      {Key? key,
      required this.hint,
      required this.focus,
      required this.mode,
      required this.onQuery,
      required this.controller,
      required this.onExitSearch})
      : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final List<Unit> _filteredList = [];
  bool _hasFocus = false;
  bool _showCursor = false;
  String _type = Data.allType;

  @override
  void initState() {
    _hasFocus = false;
    _showCursor = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showFilter = (widget.controller?.text.length ?? 0) >= 3 &&
        (widget.mode == SearchMode.dataTab ||
            widget.mode == SearchMode.regularUnitSearch);
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: showFilter
            ? CustomSearchBar.filterHeight
            : CustomSearchBar.normalHeight,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: <Widget>[
            searchBar(),
            Expanded(
              child: Visibility(
                visible: showFilter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      typeFilter(Data.allType, Colors.grey,
                          gradient: LinearGradient(
                              colors: [
                                UI.strT,
                                UI.qckT,
                                UI.dexT,
                                UI.psyT,
                                UI.intT
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      typeFilter(Data.strType, UI.strT),
                      typeFilter(Data.qckType, UI.qckT),
                      typeFilter(Data.dexType, UI.dexT),
                      typeFilter(Data.psyType, UI.psyT),
                      typeFilter(Data.intType, UI.intT)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Stack searchBar() {
    return Stack(
      children: <Widget>[
        TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          focusNode: widget.focus,
          textCapitalization: TextCapitalization.sentences,
          showCursor: _showCursor,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.all(15.0),
            prefixIcon: Icon(Icons.search,
                color:
                    UI.isDarkTheme(context) ? Colors.grey[800] : Colors.white),
          ),
          onTap: () {
            setState(() {
              _hasFocus = true;
              _showCursor = true;
            });
          },
          onEditingComplete: () {
            _filterValues(widget.controller?.text, _type);
            _hideKeyboard();
            setState(() {
              _showCursor = false;
            });
          },
          onChanged: (query) {
            // Filter units and teams on the fly when there are more than 3 letters in search bar
            if (query.length >= 3) {
              _filterValues(widget.controller?.text, _type);
              setState(() => _showCursor = false);
            } else {
              setState(() => _filteredList.clear());
            }
          },
        ),
        Positioned(bottom: 0, left: 0, child: back()),
        Visibility(
          visible: _hasFocus,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: clear(),
          ),
        ),
      ],
    );
  }

  SizedBox back() {
    return SizedBox(
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () {
            if (_hasFocus) {
              widget.onExitSearch();
              widget.focus?.unfocus();
              setState(() {
                _clearSearch();
                _hasFocus = false;
              });
            }
          },
          child: _hasFocus
              ? const Icon(Icons.arrow_left)
              : const Icon(Icons.search),
        ));
  }

  InkWell typeFilter(String type, Color color, {LinearGradient? gradient}) {
    return InkWell(
        onTap: () {
          setState(() {
            _type = type;
          });
          _filterValues((widget.controller?.text ?? ""), _type);
          _hideKeyboard();
        },
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                color: gradient != null ? null : color,
                gradient: gradient,
                border: _type == type
                    ? Border.all(
                        color: UI.isDarkTheme(context)
                            ? Colors.white
                            : Colors.black,
                        width: 2)
                    : null),
            child: Text(type, style: const TextStyle(color: Colors.white)),
          ),
        ));
  }

  SizedBox clear() {
    return SizedBox(
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () {
            setState(() {
              _clearSearch();
            });
          },
          child: const Icon(Icons.clear),
        ));
  }

  _clearSearch({bool onCreatingSomething = true}) {
    widget.controller?.clear();
    if (!onCreatingSomething) {
      widget.focus?.unfocus();
      setState(() => _hasFocus = false);
    }
  }

  _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _filterValues(String? q, String type) async {
    if (q != null && q.trim().isNotEmpty) widget.onQuery(q, type);
  }
}
