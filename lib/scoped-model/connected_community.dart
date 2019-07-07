import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/community.dart';
import '../model/post.dart';
import '../model/user.dart';
import '../model/auth.dart';

class ConnectedCommunityModel extends Model{
  List<Community> _communties = [];
  User _authenticatedUser;
  bool _isLoading = false;
} 

class CommunityModel extends ConnectedCommunityModel{
  List<Community> get allCommunities{
    return List.from(_communties);
  }

  Future<bool> addCommunity(String name, String about, int numofMemb, bool join,List<Post> posts)async{
    _isLoading = true;
    notifyListeners();
    final Map<String,dynamic> CommunityData={
      'name':name,
      'about':about,
      'numofMemb':numofMemb,
      'join':join,
      'userId': _authenticatedUser.id
    };
    try{
      final http.Response response = await http.post('https://minireddit-1803c.firebaseio.com/community.json',
      body: json.encode(CommunityData));

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading=false;
        notifyListeners();
        return false;
      }

      Map<String, dynamic> responseData = json.decode(response.body);
      final Community newCommunity = Community(
        id:responseData['name'],
        name: name,
        about:about,
        numofMemb: numofMemb,
        join: join,
        posts: posts
      );
      _communties.add(newCommunity);
      print(json.decode(response.body));
      _isLoading = false;
      notifyListeners();
      return true;  
    }
    catch(error){
      print(error);
      _isLoading= false;
      notifyListeners();
      return false;
    } 
  }
Future<Null> fetchCommunity ()async{
  _isLoading = true;
  notifyListeners();
  try{
    final http.Response response =await http.get('https://minireddit-1803c.firebaseio.com/community.json');
    final List<Community> fetchedCommunties = [];
    final Map<String,dynamic> communityListData = json.decode(response.body);
    if(communityListData == null){
      _isLoading = false;
      notifyListeners();
      return ;
    }

    communityListData.forEach((String communityId,dynamic data){
      
      final Community community = Community(
        id: communityId,
        name: data['name'],
        about: data['about'],
        numofMemb: data['numofMemb'],
        join:data['join'],
        posts: data['posts'],
        );
        fetchedCommunties.add(community);
    });
    _communties=fetchedCommunties;
    _isLoading = false;
    notifyListeners();

  }    
    catch(error){
      _isLoading=false;
      notifyListeners();
      return;
    }  
  }
}



class UserModel extends ConnectedCommunityModel{
  User get user {
    return _authenticatedUser;
  }

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
      _authenticatedUser = User(
        id: responseData['localId'],
        email: responseData['email'],
        token:responseData['idToken']);
      final SharedPreferences prem = await SharedPreferences.getInstance();
      prem.setString('token',responseData['tokenId']);
      prem.setString('userEmail',email);
      prem.setString('userId',responseData['localId']);
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
    return {'success':!hasError,'message': message};
  } 
  void autoAuthenticate() async{
    final SharedPreferences prem = await SharedPreferences.getInstance();
    final String token = prem.getString('token');
    if(token != null){
      final String userEmail = prem.getString('userEmail');
      final String userId = prem.getString('userId');
      _authenticatedUser = User( id: userId,email: userEmail, token: token);
      notifyListeners();
    }
  }

  void logout()async{
    print(logout);
    _authenticatedUser = null;
    final SharedPreferences prem = await SharedPreferences.getInstance();
    prem.remove('token');
    prem.remove('userEmail');
    prem.remove('userId');
  }

}