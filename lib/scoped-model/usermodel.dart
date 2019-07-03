
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../model/user.dart';
import '../model/auth.dart';
import '../model/community.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CommunityModel extends Model{
  List<Community> communties = [];

  List<Community> get allCommunities{
    return this.communties;
  }
}

class UserModel extends Model{
  User _authenticatedUser;

  bool isLoading = false;
  notifyListeners();
  void login(String email, String password){
    _authenticatedUser = User(id:'asdfghjkl' ,email:email, token: password);
  }

  Future<Map<String,dynamic>> authenticate(String email,String password,[AuthMode mode = AuthMode.Login])async{
    final Map<String,dynamic> authData = {
        'email':email,
        'password':password,
        'returSecureToken':true,
    };
    isLoading = true;
    notifyListeners();
    http.Response response;
    if(mode == AuthMode.Login){
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyB2Z3675IBuJmiu9PHK-BoC7G80xEo2gJs', 
      body: json.encode(authData),
      headers: {'Content-Type':'application/json'}); 
    }
    else{
      response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyB2Z3675IBuJmiu9PHK-BoC7G80xEo2gJs',
    body:json.encode(authData),
    headers: {'Content-Type':'application/json'});
    } 
    bool hasError = true;
    var message = 'Something wents wrong.';
    final responseData = json.decode(response.body);

    if(responseData.containsKey('idToken')){
      hasError = false;
      message = 'Authentication Succeeded';
      _authenticatedUser = User(id: responseData['localId'],email: responseData['email'],token:responseData['idToken']);
      final SharedPreferences prem =await SharedPreferences.getInstance();
      prem.setString('token',responseData['tokenId']);
    }
    else if(responseData['error']['message'] == 'EMAIL_EXISTS'){
      message = 'This email already exists';
      hasError = true;
    }else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    isLoading = false;
    notifyListeners();
    print(json.decode(response.body));
    return {'success':!hasError ,'message': message};
    

  } 
}