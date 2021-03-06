import 'package:checklist/src/mobilediskwriter.dart';
import 'package:checklist/ui/navigationpage.dart';
import 'package:checklist/ui/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:checklist/src/bookio.dart';
import 'package:checklist/ui/templates.dart';

class Landing extends NavigationPage {
  Landing(String path, Function themeChangeCallback)
      : super(
          title: Strings.appTitle,
          path: path,
          themeChangeCallback: themeChangeCallback,
        );

  _LandingState createState() => new _LandingState();
}

class _LandingState extends NavigationPageState {
  var books = new List<Widget>();
  BookIo io;

  initState() {
    super.initState();

    io = new BookIo(writer: new MobileDiskWriter())
      ..initializeFileList().then((_) {
        setState(() {
          for (var id in io.files.keys) {
            books.add(
              new Container(
                height: 48.0,
                child: new Row(
                  children: <Widget>[
                    Expanded(child: ListItem1TextRow(io.files[id])),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: navigateTo("/$id"),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: navigateTo("/$id/use"),
                    ),
                  ],
                ),
              ),
            );
          }
        });
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        actions: [
          IconButton(
            icon: Icon(Icons.format_paint),
            color: ThemeColors.isRed ? primaryGreen : primaryRed,
            onPressed: ()=> super.setState(widget.themeChangeCallback),
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            color: ThemeColors.primary,
            //onPressed: FirebaseAuth.instance.signOut,
            onPressed: doSomething,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateTo("/newBook"),
        child: new Icon(Icons.add),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: listTBPad),
          child: _buildListview(context)),
    );
  }

  Widget _buildListview(BuildContext context) {
    if (books.length == 0) {
      return new ListView();
    } else {
      return new ListView.builder(
        itemBuilder: (context, index) {
          return books[index];
        },
        itemCount: books.length,
      );
    }
  }

  Future doSomething() async {
    var user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection("users").document(user.uid).setData({
      "email": user.email,
      "displayName": user.displayName,
    },
      merge: true,
    );

  }
}
