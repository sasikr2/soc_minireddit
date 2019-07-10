import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Incognichat/model/comment.dart';
import 'package:Incognichat/pages/community-list.dart';
import '../scoped-model/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/community.dart';

class CommunityCreatePage extends StatefulWidget{
  final MainModel model;
  CommunityCreatePage(this.model);
  @override
  State<StatefulWidget> createState() {
    
    return _CommunityCreatePage();
  }
}
class _CommunityCreatePage extends State<CommunityCreatePage>{
  final Map<String,dynamic> _formData = {
    'name':null,
    'about':null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNameTextField(){
    return TextFormField(
      decoration:InputDecoration(labelText: 'Name'),
      keyboardType:TextInputType.text,
      validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long.';
          }
      },
      onSaved: (String value){
        _formData['name'] = value;
      },  
    );
  }

  Widget _buildAboutTextField(){
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(labelText: 'About'),
      keyboardType:TextInputType.text,
      validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long.';
          }
        },
      onSaved: (String value){
        _formData['about'] = value;
      }, 
    );
  }

  void _sumbitForm(Function addCommunity){
    if(!_formKey.currentState.validate()){
      return ;
    }
    _formKey.currentState.save();
        addCommunity(
      _formData['name'],
      _formData['about'],
      0,
      false,
      []
    ).then((bool success){
      if( success)
         Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => CommunityListPage(widget.model)));
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

  }
  
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),

      ),

      body:Container(
      margin: EdgeInsets.all(10.0),
      child:Form(
        key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal:targetPadding/2),
        children: <Widget>[
          _buildNameTextField(),
          _buildAboutTextField(),
          SizedBox(height: 10.0,), 
          ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
            return model.isLoading ? Center(child: CircularProgressIndicator()) :
             RaisedButton(
            child:Text('Save'),
            textColor: Colors.white,
            onPressed:() => _sumbitForm(model.addCommunity),
          );
          }),   
        ],
      ),
      )
      ));
  }
}