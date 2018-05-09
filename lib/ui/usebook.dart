import 'dart:async';

import 'package:checklist/src/book.dart';
import 'package:checklist/src/checklist.dart';
import 'package:checklist/src/parsepath.dart';
import 'package:checklist/ui/strings.dart';
import 'package:checklist/ui/templates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checklist/src/navigator.dart' as nav;

class UseBook extends StatefulWidget {
  UseBook(this.path);

  final String path;

  @override
  State<StatefulWidget> createState() => new UseBookState();
}

class UseBookState extends State<UseBook> {
  UseBookState();

  bool isLoading = true;
  bool errorLoading = false;
  Book book;
  nav.Navigator navigator;
  double opacity = 1.0;
  final int fadeDelay = 85;
  final smallScale = 1.8;
  final largeScale = 2.5;
  final midScale = 2.0;

  @override
  void initState() {
    super.initState();

    ParsePath.parse(widget.path).then<ParsedItems>((items) {
      if (mounted) {
        setState(() {
          if (items.result == ParseResult.UseBook) book = items.book;
          navigator = new nav.Navigator(book);
          isLoading = false;
        });
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorLoading = true;
        });
      }
    });
  }

  Future<bool> willPop() {
    if (navigator.canGoBack) {
      fadeTransition(() => navigator.goBack())();
      return new Future<bool>.value(false);
    }
    return new Future<bool>.value(true);
  }

  Widget _body() {
    var current = navigator.currentItem;
    if (current == null) {
      if (_isFinished()) {
        return Text("Done");
      } else {
        return _selectNextList();
      }
    } else if (current.isBranch) {
      return _questionItem();
    } else {
      return _checkItem();
    }
  }

  bool _isFinished() {
    var list = navigator.currentList;
    if (list == null ||
        (list.nextPrimary == null && list.nextAlternatives.length == 0))
      return true;
    else
      return false;
  }

  Widget _selectNextList() {
    var list = navigator.currentList;
    var widgets = <Widget>[];

    if (list.nextPrimary != null) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Next checklist:",
            textScaleFactor: smallScale,
          ),
        ),
      );
      widgets.add(Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: _button(
                child: Text(
                  list.nextPrimary.name,
                  textScaleFactor: midScale,
                ),
                onPressed: setNextList(list.nextPrimary),
              ),
            ),
          )
        ],
      ));
    }

    if (list.nextAlternatives.length > 0) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Text(
            "Alternatives:",
            textScaleFactor: smallScale,
          ),
        ),
      );
      widgets.add(
        Expanded(
          child: ListView.builder(
            itemCount: list.nextAlternatives.length,
            itemBuilder: (_, index) {
              var newList = list.nextAlternatives[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: _button(
                  child: Text(
                    newList.name,
                    textScaleFactor: midScale,
                  ),
                  onPressed: setNextList(newList),
                ),
              );
            },
          ),
        ),
      );
    }

    return Column(
      children: widgets,
    );
  }

  Widget _questionItem() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              navigator.currentItem.toCheck,
              textScaleFactor: largeScale,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: _yesNoButton(true),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: _yesNoButton(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _yesNoButton(bool branch) {
    return _button(
      child: Text(
        branch ? Strings.yes : Strings.no,
        textScaleFactor: smallScale,
      ),
      onPressed: setMoveNext(branch),
    );
  }

  Widget _button(
      {Widget child, double width, double height = 80.0, Function onPressed}) {
    return Container(
      height: height,
      width: width,
      color: ThemeColors.black,
      child: OutlineButton(
        child: child,
        onPressed: onPressed,
        textColor: ThemeColors.primary,
        shape: StadiumBorder(),
        disabledBorderColor: ThemeColors.primary,
        highlightedBorderColor: ThemeColors.primary,
        borderSide: BorderSide(color: ThemeColors.primary, width: 5.0),
        color: ThemeColors.primary,
      ),
    );
  }

  Widget _checkItem() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 48.0),
                child: Center(
                  child: Text(
                    navigator.currentItem.toCheck,
                    textScaleFactor: largeScale,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 48.0, 8.0, 8.0),
                child: Center(
                  child: Text(
                    navigator.currentItem.action,
                    textScaleFactor: largeScale,
                  ),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            color: ThemeColors.primary,
            height: 3.0,
          ),
        ),
        Center(
          child: _button(
            child: Icon(Icons.check, size: 40.0),
            width: 80.0,
            onPressed: setMoveNext(),
          ),
        ),
      ],
    );
  }

  Function setNextList(Checklist list) {
    return fadeTransition(() => navigator.changeList(list));
  }

  Function setMoveNext([bool branch]) {
    return fadeTransition(() => navigator.moveNext(branch: branch));
  }

  Function fadeTransition(Function stateChangeAction) {
    return () async {
      setState(() {
        opacity = 0.0;
      });
      await Future.delayed(
          Duration(milliseconds: fadeDelay), stateChangeAction);
      setState(() {
        opacity = 1.0;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return new CupertinoActivityIndicator();
    else if (errorLoading)
      return new Text("Error");
    else {
      String title;
      if (navigator.currentList == null) {
        title = navigator.book.name;
      } else {
        title = navigator.currentList.name;
      }
      return new WillPopScope(
        onWillPop: willPop,
        child: Scaffold(
          appBar: new AppBar(title: new Text(title)),
          body: AnimatedOpacity(
            duration: Duration(milliseconds: fadeDelay),
            opacity: opacity,
            child: _body(),
          ),
        ),
      );
    }
  }
}
