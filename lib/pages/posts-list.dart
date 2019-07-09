import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_elements/title_default.dart';

class PostListPage extends StatefulWidget{
  
  MainModel model = MainModel();
  PostListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PostListPage();
  }
} 

class _PostListPage extends State<PostListPage>{  
  @override
  void initState() {
    widget.model.fetchPost();
    super.initState();
  }

  Widget _buildCommentButton(context){
    return FlatButton(
        child: Icon(Icons.insert_comment),
        onPressed: (){},
    );

  }

  Widget _buildVoteButton(context, int index){
    return ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model ){
      return IconButton(
      icon:Icon(Icons.arrow_upward)
    );
    });
     

  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return ScopedModelDescendant(builder:(BuildContext context, Widget child,MainModel model){
      return Scaffold(
        appBar: AppBar(
          title:Text('Recent Posts')
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context,int index){
            return Card(
              child:Column(children: <Widget>[
                TitleDefault(model.allPosts[index].title),
                Container(
                  padding: EdgeInsets.only(top:10.0),
                  child:Row(children: <Widget>[
                    _buildVoteButton(context, index),
                    SizedBox(width:deviceWidth-180.0),
                    _buildCommentButton(context)
                  ],)
                )
              ],)
            );
          },
          itemCount: model.allPosts.length,
        )
      );
       

    });
    
  }
}