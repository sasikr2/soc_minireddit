import 'package:flutter/material.dart';
import 'package:Incognichat/scoped-model/main.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/community.dart';
import '../scoped-model/main.dart';

class CommunityListPage extends StatefulWidget{

  final MainModel model;
  CommunityListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _CommunityListPage();
  }
}

class _CommunityListPage extends State<CommunityListPage>{

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
                  title: Text(model.allCommunities[index].name),
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


