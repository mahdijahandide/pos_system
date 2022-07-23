import 'package:flutter/material.dart';
import 'dart:async';

import '../services/model/string_with_string.dart';

class TextFieldSearch extends StatefulWidget {
  /// A default list of values that can be used for an initial list of elements to select from
  final List? initialList;

  /// A string used for display of the selectable elements
  final String label;

  /// A controller for an editable text field
  final TextEditingController controller;
  final bool hasKeyboard;

  /// An optional future or async function that should return a list of selectable elements
  final Function? future;

  /// The value selected on tap of an element within the list
  final Function? getSelectedValue;

  /// Used for customizing the display of the TextField
  final InputDecoration? decoration;

  /// Used for customizing the style of the text within the TextField
  final TextStyle? textStyle;

  /// The minimum length of characters to be entered into the TextField before executing a search
  final int minStringLength;

  final FocusNode focusNode;

  /// Creates a TextFieldSearch for displaying selected elements and retrieving a selected element
  const TextFieldSearch(
      {Key? key,
      this.initialList,
      required this.focusNode,
      required this.label,
      required this.controller,
      required this.hasKeyboard,
      this.textStyle,
      this.future,
      this.getSelectedValue,
      this.decoration,
      this.minStringLength = 2})
      : super(key: key);

  @override
  _TextFieldSearchState createState() => _TextFieldSearchState();
}

class _TextFieldSearchState extends State<TextFieldSearch> {
  late OverlayEntry _overlayEntry = _createOverlayEntry();

  // FocusNode _focusNode = FocusNode();

  final LayerLink _layerLink = LayerLink();
  List? filteredList = <StringWithString>[];
  bool hasFuture = false;
  bool loading = false;
  final _debouncer = Debouncer(milliseconds: 1000);
  bool? itemsFound;

  void resetList() {
    List tempList = <StringWithString>[];
    setState(() {
      // after loop is done, set the filteredList state from the tempList
      filteredList = tempList;
      loading = false;
    });
    // mark that the overlay widget needs to be rebuilt
    _overlayEntry.markNeedsBuild();
  }

  // void setLoading() {
  //   if (!loading) {
  //     setState(() {
  //       loading = true;
  //     });
  //   }
  // }

  void resetState(List tempList) {
    // setState(() {
    // after loop is done, set the filteredList state from the tempList
    filteredList = tempList;
    loading = false;
    // if no items are found, add message none found
    itemsFound =
        tempList.isEmpty && widget.controller.text.isNotEmpty ? false : true;
    // });
    // mark that the overlay widget needs to be rebuilt so results can show
    _overlayEntry.markNeedsBuild();
  }

  void updateGetItems() {
    // mark that the overlay widget needs to be rebuilt
    // so loader can show
    _overlayEntry.markNeedsBuild();
    if (widget.controller.text.length > widget.minStringLength) {
      // setLoading();
      widget.future!().then((value) {
        filteredList = value;
        // create an empty temp list
        List tempList = <StringWithString>[];
        // loop through each item in filtered items
        for (int i = 0; i < filteredList!.length; i++) {
          // lowercase the item and see if the item contains the string of text from the lowercase search
          if (widget.getSelectedValue != null) {
            if (filteredList![i]
                    .name
                    .label
                    .toLowerCase()
                    .contains(widget.controller.text.toLowerCase()) ||
                filteredList![i]
                    .num
                    .label
                    .toLowerCase()
                    .contains(widget.controller.text.toLowerCase())) {
              // if there is a match, add to the temp list
              tempList.add(filteredList![i].name);
            }
          } else {
            if (filteredList![i]
                    .name
                    .toLowerCase()
                    .contains(widget.controller.text.toLowerCase()) ||
                filteredList![i]
                    .num
                    .toLowerCase()
                    .contains(widget.controller.text.toLowerCase())) {
              // if there is a match, add to the temp list
              tempList.add(filteredList![i].name);
            }
          }
        }
        // helper function to set tempList and other state props
        resetState(tempList);
      });
    } else {
      // reset the list if we ever have less than 2 characters
      resetList();
    }
  }

  void updateList() {
    // widget.focusNode.requestFocus();
    // setLoading();
    // set the filtered list using the initial list
    filteredList = widget.initialList;
    // create an empty temp list
    List tempList = <StringWithString>[];
    // loop through each item in filtered items
    for (int i = 0; i < filteredList!.length; i++) {
      // lowercase the item and see if the item contains the string of text from the lowercase search
      if (filteredList![i]
              .name
              .toLowerCase()
              .contains(widget.controller.text.toLowerCase()) ||
          filteredList![i]
              .num
              .toLowerCase()
              .contains(widget.controller.text.toLowerCase())) {
        // if there is a match, add to the temp list
        tempList.add(StringWithString(
            mName: filteredList![i].name, mNum: filteredList![i].num));
      }
    }
    // helper function to set tempList and other state props
    resetState(tempList);
  }

  @override
  void initState() {
    super.initState();
    Timer? _timer;
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => updateList());

    // throw error if we don't have an initial list or a future
    if (widget.initialList == null && widget.future == null) {
      throw ('Error: Missing required initial list or future that returns list');
    }
    if (widget.future != null) {
      setState(() {
        hasFuture = true;
      });
    }
    // add event listener to the focus node and only give an overlay if an entry
    // has focus and insert the overlay into Overlay context otherwise remove it
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
        // check to see if itemsFound is false, if it is clear the input
        // check to see if we are currently loading items when keyboard exists, and clear the input
        if (itemsFound == false || loading == true) {
          // reset the list so it's empty and not visible
          resetList();
          widget.controller.clear();
        }
        // if we have a list of items, make sure the text input matches one of them
        // if not, clear the input
        if (filteredList!.isNotEmpty) {
          bool textMatchesItem = false;
          if (widget.getSelectedValue != null) {
            // try to match the label against what is set on controller
            textMatchesItem = filteredList!
                .any((item) => item.label == widget.controller.text);
          } else {
            textMatchesItem = filteredList!.contains(widget.controller.text);
          }
          //if (textMatchesItem == false) widget.controller.clear();
          resetList();
        }
      }
    });
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   widget.controller.dispose();
  //   super.dispose();
  // }

  ListView _listViewBuilder(context) {
    if (itemsFound == false) {
      return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // clear the text field controller to reset it
              widget.controller.clear();
              setState(() {
                itemsFound = false;
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: const ListTile(
              title: Text('No matching items.'),
              trailing: Icon(Icons.cancel),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: filteredList!.length,
      itemBuilder: (context, i) {
        return InkWell(
            onTap: () {
              // set the controller value to what was selected
              setState(() {
                // if we have a label property, and getSelectedValue function
                // send getSelectedValue to parent widget using the label property
                if (widget.getSelectedValue != null) {
                  widget.controller.text = filteredList![i].name;
                  widget.getSelectedValue!(filteredList![i].name);
                } else {
                  widget.controller.text = filteredList![i].name.toString();
                }
              });
              // reset the list so it's empty and not visible
              resetList();
              // remove the focus node so we aren't editing the text
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(filteredList![i].name),
                  Text(filteredList![i].num),
                  const Divider()
                ],
              ),
            ));
      },
      padding: EdgeInsets.zero,
      shrinkWrap: true,
    );
  }

  /// A default loading indicator to display when executing a Future
  Widget _loadingIndicator() {
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }

  Widget? _listViewContainer(context) {
    if (itemsFound == true && filteredList!.isNotEmpty ||
        itemsFound == false && widget.controller.text.isNotEmpty) {
      double _height =
          itemsFound == true && filteredList!.length > 1 ? 110 : 55;
      return SizedBox(
        height: _height,
        child: _listViewBuilder(context),
      );
    }
    return null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size overlaySize = renderBox.size;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return OverlayEntry(
        builder: (context) => Positioned(
              width: overlaySize.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, overlaySize.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth,
                        maxWidth: screenWidth,
                        minHeight: 0,
                        // max height set to 150
                        maxHeight: itemsFound == true ? 110 : 55,
                      ),
                      child: loading
                          ? _loadingIndicator()
                          : _listViewContainer(context)),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // Timer timer;
    // timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
    //   _debouncer.run(() {
    //     setState(() {
    //       updateGetItems();
    //       if (hasFuture) {
    //         updateGetItems();
    //       } else {
    //         updateList();
    //       }
    //     });
    //   });
    // });
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        children: [
          TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration:
                widget.decoration ?? InputDecoration(labelText: widget.label),
            style: widget.textStyle,
            onChanged: (String value) {
              // every time we make a change to the input, update the list
              _debouncer.run(() {
                setState(() {
                  if (hasFuture) {
                    updateGetItems();
                  } else {
                    updateList();
                  }
                });
              });
            },
          ),
        ],
      ),
    );
  }
}

class Debouncer {
  /// A length of time in milliseconds used to delay a function call
  final int? milliseconds;

  /// A callback function to execute
  VoidCallback? action;

  /// A count-down timer that can be configured to fire once or repeatedly.
  Timer? _timer;

  /// Creates a Debouncer that executes a function after a certain length of time in milliseconds
  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
