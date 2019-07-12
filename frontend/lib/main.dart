import 'package:Incognichat/pages/home_page_community.dart';
import 'package:Incognichat/pages/posts-list.dart';
import 'package:flutter/material.dart';
import 'package:Incognichat/pages/create-post.dart';
import 'package:Incognichat/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/auth_page.dart';
import './scoped-model/main.dart';
import './pages/home_page_chats.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{
  final MainModel _model = MainModel();
  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return ScopedModel<MainModel>(
      model:_model,
      child: MaterialApp(
      //home:AuthenPage(),
      
      routes:{
        '/':(BuildContext context) =>(_model.user == null) ? AuthenPage() : HomePage(_model),
        '/home':(BuildContext context) => HomePage(_model),
        '/post':(BuildContext context) => PostCreatePage(_model),
        '/community_home': (BuildContext context) => CommunityHomePage(_model),
        '/chat_home': (BuildContext context) => ChatHomePage(_model),
        '/Postlist': (BuildContext context) => PostListPage(_model)
      } 
    )  
    );
   
  }

}