import 'package:flutter/material.dart';
import './community-list.dart';

class PostCreatePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PostCreatePage();
  }
}

class _PostCreatePage extends State<PostCreatePage>{
  
  final Map<String,dynamic> _formData = {
    'title':null,
    'content':null,
  };

  Widget _buildTitleTextField(){
    return TextFormField(
      decoration:InputDecoration(labelText: 'An Interseting Title',),
      keyboardType:TextInputType.text,
      validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long.';
          }
      },
      onSaved: (String value){
        _formData['title'] = value;
      },  
    );
  }

  Widget _buildContentTextField(){
    return TextFormField(
      decoration:InputDecoration(labelText: 'Your Text post(optional)',),
      keyboardType:TextInputType.text,
      onSaved: (String value){
        _formData['content'] = value;
      },  
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    String value='Choose a community';
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        leading:IconButton(
          icon : Icon(Icons.cancel),
          onPressed: (){},
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Post'),
            onPressed:(){}
          )
        ],
      ),
      body:Container(
        margin: EdgeInsets.all(19.0),
        child:
          Form(
            key:_formKey,
            child:ListView(
              padding: EdgeInsets.symmetric(horizontal:targetPadding/2),
              children: <Widget>[
                Column(children:<Widget>[
                FlatButton(
                child:Row(children: <Widget>[Text(value),Icon(Icons.arrow_drop_down)],),
                onPressed:(){
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => CommunityListPage()));  
                },),
                SizedBox(height:10.0),
                _buildTitleTextField(),
                _buildContentTextField(),
                SizedBox(height: 10.0,),   
              ],
            ),] 
          ) ,  
      ),
    ));
  }
}