import '../model/community.dart';
import '../pages/community-select.dart';
import '../pages/posts-list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'create-community.dart';
import '../scoped-model/main.dart';
import 'community-list.dart';
import 'create-post.dart';

class CommunityHomePage extends StatefulWidget{
    final MainModel model;
    CommunityHomePage(this.model);

    @override
    State<StatefulWidget> createState() {
      return _CommunityHomePage();
    }
}

class _CommunityHomePage extends State<CommunityHomePage> {
  @override
  void initState() {
    widget.model.fetchPost();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context){
    return Drawer(child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
                accountName: Text(
                  widget.model.user.id,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.right,
                  ),
                accountEmail: Text(widget.model.user.email),
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    widget.model.user.email[0],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
          ),
        ListTile(
          leading: Icon(Icons.pages),
          title:Text('Your Communities'),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder:(BuildContext context)=> CommunityListPage(widget.model)));
          },  
        ),
        ListTile(
          leading: Icon(Icons.save_alt),
          title:Text('Recent Posts'),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PostListPage(widget.model)));
          },
        ),
        ListTile(
          leading: Icon(Icons.edit),
          title:Text('Create Post'),
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => PostCreatePage(widget.model)));
          },
        ),
        /*ListTile(
          leading: Icon(Icons.bookmark),
          title:Text('Saved Posts'),
          onTap: (){},
        ),*/
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
        ListTile(
          leading: Icon(Icons.arrow_back),
          title: Text("Return to Main Page"),
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          },
        )
      ],
    ),);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title:Text('Community Dashboard'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              tooltip: 'Search',
              icon:Icon(Icons.search),
              onPressed: (){},
            ),
          ], 
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => CommunityCreatePage(widget.model) ));
      },
          icon: Icon(Icons.add),
          label: Text("New Community"),
        ),
        body:ListView.builder(
        itemBuilder: (BuildContext context, int index){
           return Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(children: <Widget>[
                GestureDetector(child: Text(widget.model.allCommunities[index].name),
                onTap: (){
                    Navigator.pop(context,widget.model.allCommunities[index]);
                },),
                Divider(),
              ],
          ),
           );
        },
        itemCount: widget.model.allCommunities.length,
      )
        );
  }
}