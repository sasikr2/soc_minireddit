import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';


class CommentPage extends StatefulWidget{
  MainModel model = MainModel();
  CommentPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _CommentPage();
  }
}

class _CommentPage extends State<CommentPage>{
@override
  void initState() {
    widget.model.fetchComment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context,Widget child ,MainModel model){
        return Scaffold(
          appBar: AppBar(
            title:Text('Comment')
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                    ListTile(
                      title: Text(model.allPosts[model.selectedPostIndex].comments[index].content),
                      //subtitle: Text(model.allPosts[model.selectedPostIndex].comments[index].content),
                    ),
                    Divider(),
                  ],
              ),
              );
            },
            itemCount: model.allPosts[model.selectedPostIndex].comments.length,
            ),
            bottomNavigationBar: BottomAppBar(
              child:RaisedButton(onPressed: () { },
                child: Text('Fixed Send'))
            ),
          );
      });
  }
}