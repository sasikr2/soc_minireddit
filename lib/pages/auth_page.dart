import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-model/main.dart';
import '../model/auth.dart';
class AuthenPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AuthenPage();
  }

}
class _AuthenPage extends State<AuthenPage>{

  final Map<String,dynamic> _formData = {
    'email': null,
    'password': null,
  };
   

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authmode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/com.mw.uc.i3d.jpg.png'),
    );
  }

  void _submitForm(Function authenticate) async{
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    Map<String,dynamic> successInformation;
    successInformation =await authenticate(_formData['email'],_formData['password'], _authmode);
    if(successInformation['success'])
      Navigator.pushReplacementNamed(context, '/home');
    else{
       showDialog(context: context,
        builder:(BuildContext context){
         return AlertDialog(
           title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),

                onPressed: () {
                  Navigator.of(context).pop();
                }
              ),]
         ); 
        
      }
       );   
    }
 
    
    
  }


  Widget _buildEmailTextfield(){
    return TextFormField(
      decoration:InputDecoration(
        labelText: 'E-Mail', filled:true,fillColor:Colors.white),
        keyboardType: TextInputType.emailAddress,
        validator: (String value){
          if(value.isEmpty || 
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)){
                return 'Please enter a valid email';
              }
        },
        onSaved: (String value){
            _formData['email'] = value;
        },
    );
  }


  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Password do not match';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:Container(
        decoration:BoxDecoration(
          image:_buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child:Center(
          child:SingleChildScrollView(
            child:Container(
              width:targetWidth,
              child:Form(
                key: _formkey,
                child: Column(children: <Widget>[
                  _buildEmailTextfield(),
                  SizedBox(
                    height: 10.0,
                  ),
                _buildPasswordTextField(),
                  SizedBox(
                      height: 10.0,
                  ),
                  _authmode == AuthMode.Signup ? _buildConfirmPasswordTextField() : Container(),
                  SizedBox(
                      height: 10.0,
                  ),
                  FlatButton(child: Text('Switch to ${_authmode == AuthMode.Login ? 'Signup' : 'Login'}'),
                  onPressed: (){
                    setState((){
                      _authmode = _authmode == AuthMode.Login 
                          ? AuthMode.Signup : AuthMode.Login;
                    });
                  },),
                  ScopedModelDescendant<MainModel>(builder : (BuildContext context,Widget child, MainModel model){
                    return model.isLoading
                            ? CircularProgressIndicator():RaisedButton(
                    textColor:Colors.lightGreen,
                    child:Text(_authmode == AuthMode.Login ? 'Login' : 'Signup'),
                    onPressed: () => _submitForm(model.authenticate),
                  );
                  })
                  ],),),
            )
          )
          

        )
        
      )
      );
  }
}