import 'package:flutter/material.dart';
import 'package:minireddit/pages/community-list.dart';
import 'package:scoped_model/scoped_model.dart';
import './create-community.dart';
import './community-list.dart';
import '../widgets/ui_elements/title_default.dart';
import '../scoped-model/main.dart';

class HomePage extends StatefulWidget{
  final MainModel model;
  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage>{
  @override
  void initState() {
    widget.model.fetchCommunity();
    super.initState();
  }
  
  Widget _buildSideDrawer(BuildContext context){
    return Drawer(child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('DashBoard'),
        ),
        ListTile(
          leading: Icon(Icons.pages),
          title:Text('Create Community'),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => CommunityCreatePage()));
          },  
        ),
        ListTile(
          leading: Icon(Icons.save_alt),
          title:Text('Saved'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title:Text('Edit Profile'),
          onTap: (){

          },
        ),
      
        ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model){
            return ListTile(
              leading: Icon(Icons.exit_to_app),
              title:Text('Logout'),
              onTap: (){
                model.logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
            );
          }
        ),

      ],
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:1,
      child:Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title:Text('Feed'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Search',
              icon:Icon(Icons.search),
              onPressed: (){},
            ),
          ],
        ),
         body:ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child,MainModel model){
          return Container(child: 
          ListView.builder(
            itemBuilder: (BuildContext context,int index){
              return Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TitleDefault(model.allCommunities[index].name),
                    SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              );
            },
            itemCount: model.allCommunities.length,
          ),);
          },) 
        )
    );
  }
}