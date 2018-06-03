import 'package:checklist/src/note.dart';
import 'package:checklist/ui/strings.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

typedef void ThemeChangeCallback(bool makeRed);

const double defaultPad = 16.0;
const double listTBPad = 8.0;
var listTB = const EdgeInsets.only(top: listTBPad,bottom: listTBPad);
var defaultLR = const EdgeInsets.fromLTRB(defaultPad, 0.0, defaultPad, 0.0);
var defaultT = const EdgeInsets.fromLTRB(0.0, defaultPad, 0.0, 0.0);
var defaultLRB =
    const EdgeInsets.fromLTRB(defaultPad, 0.0, defaultPad, defaultPad);
var defaultLTRB = const EdgeInsets.all(defaultPad);
var defaultL = const EdgeInsets.only(left: defaultPad);
var maxNameLen = 40;
var maxToCheckLen = 40;
var maxActionLen = 30;
var maxNoteLen = 100;

const Color primaryRed50 = const Color(0xFFFFE6E6);
const Color primaryRed100 = const Color(0xFFFFCCCC);
const Color primaryRed200 = const Color(0xFFFF9999);
const Color primaryRed300 = const Color(0xFFFF6666);
const Color primaryRed400 = const Color(0xFFFF3333);
const Color primaryRed = const Color(0xFFFF0000);
const Color primaryRedTransparent = const Color(0x44FF0000);
const Color primaryRed600 = const Color(0xFFCC0000);
const Color primaryRed700 = const Color(0xFF990000);
const Color primaryRed800 = const Color(0xFF660000);
const Color primaryRed900 = const Color(0xFF330000);
const Color primaryRed950 = const Color(0xFF1A0000);
const Color blackRed = const Color(0xFF0A0000);

const Color primaryGreen50 = const Color(0xFFE6FFE6);
const Color primaryGreen100 = const Color(0xFFCCFFCC);
const Color primaryGreen200 = const Color(0xFF99FF99);
const Color primaryGreen300 = const Color(0xFF66FF66);
const Color primaryGreen400 = const Color(0xFF33FF33);
const Color primaryGreen = const Color(0xFF00FF00);
const Color primaryGreenTransparent = const Color(0x4400FF00);
const Color primaryGreen600 = const Color(0xFF00CC00);
const Color primaryGreen700 = const Color(0xFF009900);
const Color primaryGreen800 = const Color(0xFF006600);
const Color primaryGreen900 = const Color(0xFF003300);
const Color primaryGreen950 = const Color(0xFF001A00);
const Color blackGreen = const Color(0xFF000000);

class ThemeColors {
  static Color primary50 = primaryRed50;
  static Color primary100 = primaryRed100;
  static Color primary200 = primaryRed200;
  static Color primary300 = primaryRed300;
  static Color primary400 = primaryRed400;
  static Color primary = primaryRed;
  static Color primaryTransparent = primaryRedTransparent;
  static Color primary600 = primaryRed600;
  static Color primary700 = primaryRed700;
  static Color primary800 = primaryRed800;
  static Color primary900 = primaryRed900;
  static Color primary950 = primaryRed950;
  static Color black = blackRed;
  static bool isRed = true;
  static ThemeData theme = getTheme();

  static ThemeData getTheme() {
    var textTheme = getThemeTextTheme();
    return new ThemeData(
      brightness: Brightness.dark,
      primarySwatch: new MaterialColor(
        black.hashCode,
        {
          50: black,
          100: black,
          200: black,
          300: black,
          400: black,
          500: black,
          600: black,
          700: black,
          800: black,
          900: black,
        },
      ),
      primaryColorBrightness: Brightness.dark,
      dialogBackgroundColor: primary950,
      accentColor: primary800,
      accentColorBrightness: Brightness.light,
      canvasColor: black,
      scaffoldBackgroundColor: ThemeColors.black,
      cardColor: black,
      dividerColor: primary800,
      backgroundColor: black,
      highlightColor: primary700,
      splashColor: primary600,
      iconTheme: getThemeIconTheme(),
      textTheme: textTheme,
      accentTextTheme: textTheme,
      primaryTextTheme: textTheme,
      errorColor: isRed ? primaryGreen : primaryRed,
      textSelectionColor: isRed ? primaryGreen : primaryRed,
      textSelectionHandleColor: isRed ? primaryGreen : primaryRed,
      indicatorColor: isRed ? primaryGreen : primaryRed,
    );
  }

  static TextStyle getThemeTextStyle() {
    return new TextStyle(
      color: primary,
    );
  }

  static TextTheme getThemeTextTheme() {
    var style = getThemeTextStyle();
    return new TextTheme(
      display1: style,
      display2: style,
      display3: style,
      display4: style,
      headline: style,
      title: style,
      subhead: style,
      body1: style,
      body2: style,
      caption: style,
      button: style,
    );
  }

  static IconThemeData getThemeIconTheme() {
    return new IconThemeData(
      color: primary,
    );
  }

  static void setRed() {
    primary50 = primaryRed50;
    primary100 = primaryRed100;
    primary200 = primaryRed200;
    primary300 = primaryRed300;
    primary400 = primaryRed400;
    primary = primaryRed;
    primaryTransparent = primaryRedTransparent;
    primary600 = primaryRed600;
    primary700 = primaryRed700;
    primary800 = primaryRed800;
    primary900 = primaryRed900;
    primary950 = primaryRed950;
    black = blackRed;
    isRed = true;
    theme = getTheme();
  }

  static void setGreen() {
    primary50 = primaryGreen50;
    primary100 = primaryGreen100;
    primary200 = primaryGreen200;
    primary300 = primaryGreen300;
    primary400 = primaryGreen400;
    primary = primaryGreen;
    primaryTransparent = primaryGreenTransparent;
    primary600 = primaryGreen600;
    primary700 = primaryGreen700;
    primary800 = primaryGreen800;
    primary900 = primaryGreen900;
    primary950 = primaryGreen950;
    black = blackGreen;
    isRed = false;
    theme = getTheme();
  }
}

RaisedButton themeRaisedButton({Widget child, void onPressed()}) {
  return new RaisedButton(
    padding: EdgeInsets.all(0.0),
    disabledColor: ThemeColors.black,
    color: ThemeColors.black,
    textColor: ThemeColors.primary,
    disabledTextColor: ThemeColors.primary900,
    onPressed: onPressed,
    child: child,
  );
}

RaisedButton themeRaisedButtonReversed({Widget child, void onPressed()}) {
  return new RaisedButton(
    disabledColor: ThemeColors.primary600,
    color: ThemeColors.primary600,
    textColor: ThemeColors.black,
    disabledTextColor: ThemeColors.primary400,
    onPressed: onPressed,
    child: child,
  );
}

FlatButton themeFlatButton({Widget child, void onPressed()}) {
  return new FlatButton(
    disabledColor: ThemeColors.black,
    textColor: ThemeColors.primary,
    disabledTextColor: ThemeColors.primary900,
    onPressed: onPressed,
    child: child,
  );
}

Widget editorElementPadding({Widget child}) {
  return new Padding(
    padding: defaultT,
    child: child,
  );
}

Widget overflowText(String text,[TextStyle style]) {
  return new Text(
    text,
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    style: style,
  );
}

class ThemeDialog extends StatelessWidget {
  ThemeDialog({@required this.child,this.cancelButton});

  final Widget child;
  final Widget cancelButton;

  build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.black,
          border: Border.all(color: ThemeColors.primary),
        ),
        child: Column(
          children: <Widget>[
           Expanded(child: child),
           Row(
             children: <Widget>[
               Expanded(
                 child: cancelButton != null ? cancelButton :

                 themeRaisedButton(
                     onPressed: () => Navigator.of(context).pop(null),
                     child: Text(
                       Strings.cancel,
                     ),
                 ),
               ),
             ],
           ),
          ],
        ),
      ),
    );
  }
}

class ListItem1TextRow extends StatelessWidget {
  ListItem1TextRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultL,
      child: Align(
        alignment: Alignment.centerLeft,
        child: overflowText(
          text,
          TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

class ListItem2TextRows extends StatelessWidget {
  ListItem2TextRows({this.line1,this.line2});

  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultL,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: overflowText(
                  line1,
                TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  line2,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<DropdownMenuItem<Priority>> getPriorities() {
  var priorities = new List<DropdownMenuItem<Priority>>();
  for (var priority in Priority.values) {
    priorities.add(DropdownMenuItem<Priority>(
      value: priority,
      child: Text(Strings.priorityToString(priority)),
    ));
  }
  return priorities;
}
