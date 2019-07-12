import '../model/community.dart';
import '../widgets/ui_elements/title_default.dart';
import '../pages/posts-list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'create-community.dart';
import '../scoped-model/main.dart';
import 'community-list.dart';
import 'create-post.dart';
import '../pages/followed-community.dart';
import '../pages/comment.dart';

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
          onTap: (){

            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>CommunityFollowPage(widget.model)));
          },
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
        body:ScopedModelDescendant(builder:(BuildContext context, Widget child,MainModel model){
          return ListView.builder(
          itemBuilder: (BuildContext context,int index){
            
            return Card(
              child:Column(children: <Widget>[
                TitleDefault(model.allPosts[index].title),
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