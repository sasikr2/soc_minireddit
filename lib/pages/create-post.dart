import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';
import './community-select.dart';
import '../model/community.dart';


class PostCreatePage extends StatefulWidget{
  final MainModel model;
  PostCreatePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PostCreatePage();
  }
}

class _PostCreatePage extends State<PostCreatePage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String community_name = 'Choose a community';
  Community selCommunity;

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

  void _sumbitForm(Function addPost){
    if(!_formKey.currentState.validate()){
      return ;
    }
    _formKey.currentState.save();
    
      addPost(
        selCommunity.id,
      _formData['title'],
      _formData['content'])
      .then((bool success){
      if( success)
          Navigator.pushReplacementNamed(context, '/home');
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
    
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        leading:IconButton(
          icon : Icon(Icons.cancel),
          onPressed: (){
              showDialog(context: context,
              builder:(BuildContext context){
              return AlertDialog(
                title: Text('Confirmation'),
                  content: Text('Are you want to '),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Dicard'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    ),
                    FlatButton(
                      child: Text('Stay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    )]
            ); 
        
      }
       );   
            //Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>CommunityCreatePage()));
          },
        ),
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
                child:Row(children: <Widget>[Text(community_name),Icon(Icons.arrow_drop_down)],),
                onPressed:(){
                  Navigator.push<Community>(context,MaterialPageRoute(builder: (BuildContext context) => CommunitySelectPage(widget.model)))
                  .then((Community community){
                    print(community.id);
                    //print(index);
                    setState(() {
                      selCommunity = community;
                      community_name = community.name;
                    });   
                  });  
                },),
                SizedBox(height:10.0),
                _buildTitleTextField(),
                _buildContentTextField(),
                SizedBox(height: 10.0,),
                ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
                  return model.isLoading ? Center(child: CircularProgressIndicator()) :
                  RaisedButton(
                  child:Text('Post'),
                  textColor: Colors.blueAccent,
                  
                  onPressed:() {
                    model.selectCommunity(selCommunity.id);
                    _sumbitForm(model.addPost);
                  } ,
                );
                }),        
              ],
            ),] 
          ) ,  
      ),
    ));
}
}