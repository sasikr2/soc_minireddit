import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{


  Widget _buildSideDrawer(BuildContext context){
    return Drawer(child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('DashBoard'),
        ),
        ListTile(
          leading: Icon(Icons.pages),
          title:Text('Community'),
          onTap: (){},  
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title:Text('Saved Posts'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title:Text('Edit Profile'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.search),
          title:Text('Find Community to follow'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.feedback),
          title:Text('Feedback'),
          onTap: (){},
        ),

      ],
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
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
          bottom:TabBar(
            tabs: <Widget>[
              Tab(
                icon:Icon(Icons.list),
                text:'Community'
              ),
              Tab(
                icon:Icon(Icons.create),
                text:'Create Community'
              )
            ],
            
            unselectedLabelColor: null,
          )  
        ),
        body:TabBarView(
          children: <Widget>[
            Center(child: Text('All Community'),),
            Center(child: Text('Create Community'),)
          ],
        )
      ),
    );
  }
}