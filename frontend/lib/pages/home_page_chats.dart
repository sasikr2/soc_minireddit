import 'package:Incognichat/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import '../scoped-model/main.dart';
class ChatHomePage extends StatelessWidget {
  final MainModel model;
  ChatHomePage(this.model);

  Widget _buildActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => ChatScreen(model) ));
      },
      icon: Icon(Icons.add),
      label: Text("New Chat"),
    );
  }
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
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
            leading: Icon(Icons.arrow_back),
            title: Text("Return to Main Page"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Text("Chats"),
      ),
      floatingActionButton: _buildActionButton(context),
      drawer: _buildSideDrawer(context),
    );
  }
}