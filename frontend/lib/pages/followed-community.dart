import 'package:flutter/material.dart';
import 'package:Incognichat/scoped-model/main.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/community.dart';
import '../scoped-model/main.dart';

class CommunityFollowPage extends StatefulWidget{

  MainModel model;
  CommunityFollowPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CommunityFollowPage();
  }
}

class _CommunityFollowPage extends State<CommunityFollowPage>{

  @override
  void initState() {
    widget.model.fetchCommunity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child ,MainModel model){
      model.isLoading = false;
      return Scaffold(
        appBar: AppBar(
          title: Text('All Community'),
        ),
        body:ListView.builder(
        itemBuilder: (BuildContext context, int index){
           return Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(children: <Widget>[
                ListTile(
                  title:Row(children: <Widget>[Text(model.allCommunities[index].name,)
                  ,FlatButton(onPressed: (){},
                  child:Text('follow'),)]),
                  subtitle: Text(model.allCommunities[index].about),
                ),
                Divider(),
              ],
          ),
           );
        },
        itemCount: model.allCommunities.length,
      ));
    });
  }
}


