import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';
import '../widgets/ui_elements/title_default.dart';
import './comment.dart';

class PostListPage extends StatefulWidget{
  
  final MainModel model;
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

  Widget _buildCommentButton(context,int index,Function updateComment){
    return ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model ){
      return FlatButton(
          child: Icon(Icons.insert_comment),
          onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=> CommentPage(model,index)));
          },
      );

      }
    );}

  Widget _buildVoteUpButton(context,int index,Function updateVote){
    return ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model ){
      model.selectPost(model.allPosts[index].id);
      return IconButton(
        onPressed: (){
           print('voteUp');
           print(model.allPosts[index].id);
          updateVote(
            model.allPosts[index].vote + 1,index)
            .then((bool success){
              if( success)
                {
                  widget.model.fetchPost();    
                }
              else{
              showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Something went wrong'),
                          content: Text('Please try again!'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Okay'),
                            )
                          ],
                        );
                });
              };
        });
        },
      icon:Icon(Icons.arrow_upward)
    );
    });
  }
  Widget _buildVoteDownButton(context,int index,Function updateVote){
    
    return ScopedModelDescendant(builder: (BuildContext context,Widget child,MainModel model ){
      return IconButton(
        onPressed: (){
          updateVote(
            model.allPosts[index].vote - 1,index)
            .then((bool success){
              if( success)
                { 
                }
              else{
              showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Something went wrong'),
                          content: Text('Please try again!'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Okay'),
                            )
                          ],
                        );
                });
    }
    });
        },
      icon:Icon(Icons.arrow_downward)
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          title:Text('Recent Posts')
        ),
        body:ScopedModelDescendant(builder:(BuildContext context, Widget child,MainModel model){
          return ListView.builder(
          itemBuilder: (BuildContext context,int index){            
            return Card(
              child:Column(children: <Widget>[
                TitleDefault(model.allPosts[index].title),
                Text(model.allPosts[index].content == null ? Container():model.allPosts[index].content),
                Container(
                  padding: EdgeInsets.only(top:10.0),
                  child:Row(children: <Widget>[
                    _buildVoteUpButton(context,index,model.updateVote),
                    Text(model.allPosts[index].vote.toString()),
                    _buildVoteDownButton(context, index, model.updateVote),
                    SizedBox(width:deviceWidth-226.9),
                    _buildCommentButton(context,index,model.updateComment),
                  ],)
                )
              ],)
            );
          },
          itemCount: model.allPosts.length,
        );
        })
      );
  }
}