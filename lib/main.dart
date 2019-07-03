import 'package:flutter/material.dart';
import 'package:minireddit/pages/home_page.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/auth_page.dart';
import './scoped-model/usermodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final model = UserModel();
    return ScopedModel<UserModel>(
      model:model,
      child: MaterialApp(
      //home:AuthenPage(),
      
      routes:{
        '/':(BuildContext context) => AuthenPage(),
        '/home':(BuildContext context) => HomePage(),
      } 
    )  
    );
   
  }
}