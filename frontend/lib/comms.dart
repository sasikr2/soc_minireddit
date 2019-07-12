import 'package:Incognichat/main.dart';
import 'package:flutter/material.dart';
import "login.dart";
class CommScreen extends StatelessWidget {
  final UserInfo info;
  final PassInfo pass;
    CommScreen({this.info, this.pass});
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Communities",
            textAlign: TextAlign.center,
            ),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  info.user,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                  ),
                accountEmail: Text(pass.pass),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    info.user[0],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              ListTile(
                title: Text("New Chat"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => CommScreen())
                  );
                },
              ),
              ListTile(
                title: Text("Logout"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyLoginPage() )
                  );
                },
              )
            ],
          )
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyLoginPage() )
                  );
                },
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage("assets/logo.png"),
                ),
              ),
              Text("LogOut"),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyLoginPage() )
                  );
                },
                child: CircleAvatar(
                  backgroundImage: ExactAssetImage("assets/logo.png"),
                ),
              ),
              Text("LogOut"),
            ],
          ),
        ),
      );
    }
  }