import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_elements/title_default.dart';


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

  TextEditingController message = new TextEditingController();
  

  Widget _bar(BuildContext context) {
    return AppBar(
        title: new Text(
          widget.model.selectedCommunity.name,
        ),
        centerTitle: true,
      );
  }
  Widget buildList() {
    return Flexible(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding:  const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(widget.model.allPosts[widget.postIndex].comments[index].content),
                Divider(),
              ],
            ),
          );
        },
        itemCount: widget.model.allPosts[widget.postIndex].comments.length,
        reverse: true,
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                controller: message,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter Comment'
                ),
              ),
            ),
          ),
          FlatButton(
            child: Icon(Icons.send),
            onPressed: () {
            widget.model.updateComment(message.text, widget.postIndex);
            message.clear();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
      child: Column(
        children: <Widget>[
          _bar(context),
          buildList(),
          buildInput(),
        ],
      )
      
            ),
    );
  }
}
                widget.model.updateComment('Hello comment',widget.postIndex);
               },
                child: Text('Fixed Send'))
            ),
          );
    }
}
