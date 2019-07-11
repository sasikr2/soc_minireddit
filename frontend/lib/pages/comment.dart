import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';


class CommentPage extends StatefulWidget{
  final int postIndex;
  MainModel model = MainModel();
  CommentPage(this.model,this.postIndex);
  @override
  State<StatefulWidget> createState() {
    return _CommentPage();
  }
}

class _CommentPage extends State<CommentPage>{
@override
  void initState() {
    widget.model.fetchComment(widget.postIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return 
       Scaffold(
          appBar: AppBar(
            title:Text('Comment')
          ),
          body:ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child ,MainModel model){
            if( model.allPosts[widget.postIndex].comments == null){
              return Center(child: Text('No Comment'),);
            }
            return ListView.builder(
            itemBuilder: (BuildContext context, int index){       
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                    ListTile(
                      title: Text(model.allPosts[widget.postIndex].comments[index].content),
                      //subtitle: Text(model.allPosts[model.selectedPostIndex].comments[index].content),
                    ),
                    Divider(),
                  ],
              ),
              );},
            itemCount: model.allPosts[widget.postIndex].comments.length);}),
            bottomNavigationBar: BottomAppBar(
              child:RaisedButton(onPressed: () {
                widget.model.updateComment('Hello comment',widget.postIndex);
               },
                child: Text('Fixed Send'))
            ),
          );
    }
}