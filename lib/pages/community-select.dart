import 'package:flutter/material.dart';
import '../scoped-model/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/usermodel.dart';
import '../model/community.dart';

class CommunitySelectPage extends StatefulWidget{
  final MainModel model;
  CommunitySelectPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _CommunitySelectPage();
  }
}

class _CommunitySelectPage extends State<CommunitySelectPage>{
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
          title: Text('Select Community'),
        ),
        body:ListView.builder(
        itemBuilder: (BuildContext context, int index){
           return Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(children: <Widget>[
                GestureDetector(child: Text(model.allCommunities[index].name),
                onTap: (){
                    Navigator.pop(context,model.allCommunities[index]);
                },),
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