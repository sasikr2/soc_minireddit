import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'home_page_community.dart';
import 'home_page_chats.dart';
import '../scoped-model/main.dart';
class HomePage extends StatelessWidget {
    final MainModel model;
    HomePage(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Incognichat",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              model.logout();
              Navigator.pushReplacementNamed(context, ('/'));
              
            }
          )  
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
          UserAccountsDrawerHeader(
                accountName: Text(
                  model.user.id,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                  ),
                accountEmail: Text(model.user.email),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    model.user.email[0],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
          ),
          ListTile(
                title: Text("Communities"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => CommunityHomePage(model))
                  );
                },
              ),
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => CommunityHomePage(model)));
                },          
                child: Container(
                  color: Colors.transparent,
                  width: 390,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.green,
                      borderRadius: new BorderRadius.circular(300),
                    ),
                    child: Row(
                    
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/authcover.jpg'),
                          minRadius: 50,
                        ),
                        Text(
                          "  Communities",
                          style: new TextStyle(
                            fontSize: 30
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ),
            GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => ChatHomePage(model)));
                },          
                child: Container(
                  color: Colors.transparent,
                  width: 390,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: new BorderRadius.circular(300),
                    ),
                    child: Row(
                    
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/authcover.jpg'),
                          minRadius: 50,
                        ),
                        Text(
                          "  Personal Chats",
                          style: new TextStyle(
                            fontSize: 30
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ),
            GestureDetector(
              onTap: () {
                },          
                child: Container(
                  color: Colors.transparent,
                  width: 390,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.circular(300),
                    ),
                    child: Row(
                    
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/authcover.jpg'),
                          minRadius: 50,
                        ),
                        Text(
                          "  Chat With CS",
                          style: new TextStyle(
                            fontSize: 30
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}