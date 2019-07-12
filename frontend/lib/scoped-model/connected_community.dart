import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_random_choice/dart_random_choice.dart';

import 'dart:convert';
import '../model/community.dart';
import '../model/post.dart';
import '../model/user.dart';
import '../model/auth.dart';
import '../model/comment.dart';

class ConnectedCommunityModel extends Model{
  List<Community> _communities = [];
  List<Post> _posts = [];

  List<String> _userchatId = [];
  User _authenticatedUser;
  String _selectCommunityId;
  String _selectPostId = "";  
  bool _isLoading = false;
} 

class CommunityModel extends ConnectedCommunityModel{
  List<Community> get allCommunities{
    return List.from(_communities);
  }
  List<Post> get allPosts{
    return List.from(_posts);
  }
  String get selectedCommunityId {
    return _selectCommunityId;
  }

  int get selectedCommunityIndex {
    return _communities.indexWhere((Community community) {
      return community.id == _selectCommunityId;
    });
  }
  Community get selectedCommunity {
    if (selectedCommunityId == null) {
      return null;
    }
    return _communities.firstWhere((Community community) {
      return community.id == _selectCommunityId;
    });
  }

  Future<bool> addCommunity(String name, String about, int numofMemb, bool join,List<Post> posts)async{
    _isLoading = true;
    notifyListeners();
    final Map<String,dynamic> CommunityData={
      'name':name,
      'about':about,
      'numofMemb':numofMemb,
      //'join':join,
      'userId': _authenticatedUser.id,
      //'posts':posts
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
        //posts: posts
      );
      _communities.add(newCommunity);
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


  /////////////
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
          //posts: data['posts'],
          );
          fetchedCommunties.add(community);
      });
      _communities=fetchedCommunties;
      _isLoading = false;
      notifyListeners();

    }    
      catch(error){
        _isLoading=false;
        notifyListeners();
        return;
      }  
    }
    void selectCommunity(String communityId) {
        _selectCommunityId = communityId;
        notifyListeners();
    }

  
}



  
  
////////////////////////////////////////////////////////////
class PostModel extends ConnectedCommunityModel{

   List<Post> get allPosts{
    return List.from(_posts);
  }

  String get selectedPostId {
    return _selectPostId;
  }

  int get selectedPostIndex {
    return _posts.indexWhere((Post post) {
      return post.id == _selectPostId;
    });
  }
 Post get selectedPost {
    if (selectedPostId == null) {
      return null;
    }
    return _posts.firstWhere((Post post) {
      return post.id == _selectPostId;
    });
  }

  Future<bool> addPost(String id, String post_name, String post_content)async {
    _isLoading = true;
    notifyListeners();
    
    final Map<String, dynamic> postData = {
        'comments':[],
        'community_id':id,
        'title': post_name,
        'content': post_content,
        'vote': 0,
        
    };
    try{
      final http.Response response = await http.post('https://minireddit-1803c.firebaseio.com/posts.json',
      body: json.encode(postData));

      if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading=false;
        notifyListeners();
        return false;
      }

      Map<String, dynamic> responseData = json.decode(response.body);
      final Post newPost= Post(
        communityid: id,
        id:responseData['name'],
        title: post_name,
        content:post_content,
        vote: 0,
        comments:[],
      );
      _posts.add(newPost);
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
  ///////////
  
  Future<Null> fetchPost ()async{
  _isLoading = true;
  notifyListeners();
  try{
    final http.Response response =await http.get('https://minireddit-1803c.firebaseio.com/posts.json');
    final List<Post> fetchedPosts = [];
    final Map<String,dynamic> postListData = json.decode(response.body);
    if(postListData == null){
      _isLoading = false;
      notifyListeners();
      return ;
    }
    postListData.forEach((String postId,dynamic data){   
      final Post post = Post(
        id: postId,
        title: data['title'],
        content: data['content'],
        vote:data['vote'],
        communityid: data['community_id'],
        );
        fetchedPosts.add(post);
    });
    _posts=fetchedPosts;
    _isLoading = false;
    notifyListeners();
  }    
    catch(error){
      _isLoading=false;
      notifyListeners();
      return;
    }  
  }

  Future<bool> updateVote(int updatedVote, int index)async{

    if(updatedVote <= 0) updatedVote = 0;

    final Map<String,int> voteData = {
      'vote' : updatedVote,
    };
    print('post vote .........');
    print(_posts[index].id);

    final http.Response response =await http.patch('https://minireddit-1803c.firebaseio.com/posts/${_posts[index].id}.json',
    body:json.encode(voteData));

    print(json.decode(response.body));
    if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading=false;
        notifyListeners();
        return false;
    }

    _posts[index].vote= (json.decode(response.body))['vote'] ;
    
    notifyListeners();

    return true;   
  }

  Future<Null> updateComment (String content,int index)async{

    final Map<String,dynamic> data = {
      'content':content,
      'vote':0,
      'reply':"[]"
    };
    print('comment post start');
    try{
      final http.Response response = await http.post('https://minireddit-1803c.firebaseio.com/posts/${_posts[index].id}/comments.json',
     body:json.encode(data));
     print(json.decode(response.body));
     if(response.statusCode != 200 && response.statusCode != 201){
        _isLoading=false;
        notifyListeners();
        return ;
      }
    final Map<String,dynamic> commentListData = json.decode(response.body);
    if(commentListData == null){
      notifyListeners();
        return ;
    }
      final Comment comment = Comment(
        content: content,
        vote:0,
        );
        print('comment .........');
        print(comment);
    _posts[index].comments.add(comment);
    notifyListeners();
    return;
    }catch(error){
        notifyListeners();
        return;
    }
  }

 

  /////////////
  ///
  Future<Null> fetchComment (int index)async{
  _isLoading = true;
  notifyListeners();
  try{
    final http.Response response =await http.get('https://minireddit-1803c.firebaseio.com/posts/${_posts[index].id}/comments.json');
    final List<Comment> fetchedComments = [];
    final Map<String,dynamic> commentListData = json.decode(response.body);
    if(commentListData == null){
      _isLoading = false;
      notifyListeners();
      return ;
    }

    commentListData.forEach((String commentId,dynamic data){    
      final Comment comment = Comment(
        id: commentId,
        content: data['content'],
        vote:data['vote'],
        postId: selectedPostId,
        );
        fetchedComments.add(comment);
    });
    _posts[index].comments=(fetchedComments);
    _isLoading = false;
    notifyListeners();
  }    
    catch(error){
      _isLoading=false;
      notifyListeners();
      return;
    }  
  } 

   void selectPost(String PostId) {
      _selectPostId = PostId;
      notifyListeners();
    }
} 

 

////////////////////////////////////////////////////////////
class ChatModel extends ConnectedCommunityModel{
  List<String> _messages = [];
  String userId;

  List<String> get allMessages{
    return List.from(_messages);
  }

  Future<Null> sendMessage(String message)async{
      final Map<String, String> msgData={
          'message': message,
      };
      print('test');
      print(message);
      http.Response response;
      response =  await http.post('https://minireddit-1803c.firebaseio.com/users/${_authenticatedUser.usercreatedId}/message.json',
      body:json.encode(msgData));
      if(response.statusCode != 200 && response.statusCode != 201){
          _isLoading=false;
          notifyListeners();
          return;
      }

      Map<String,dynamic> messageListData = json.decode(response.body);
      _messages.add(message);
      //print(json.decode(response.body));
      //List<String> localuserchatId = _userchatId.where((value) => value != _authenticatedUser.usercreatedId);
        print('Hell ..........');
       String value = randomChoice(_userchatId);
       while(value == _authenticatedUser.usercreatedId){
         value = randomChoice(_userchatId);
       }
      response = await http.post('https://minireddit-1803c.firebaseio.com/users/${value}/message.json',
      body:json.encode(msgData));
      if(response.statusCode != 200 && response.statusCode != 201){
          _isLoading=false;
          notifyListeners();
          return;
      }

      notifyListeners();

  }

  ///////////
  Future<Null> fetchMessage()async{
     _isLoading = true;
  notifyListeners();
  try{
    final http.Response response = await http.get('https://minireddit-1803c.firebaseio.com/users/${_authenticatedUser.usercreatedId}/message.json');
    final List<String> fetchedMessages = [];
     final Map<String,dynamic> messageListData = json.decode(response.body);
     print(messageListData);
    if(messageListData == null){
      _isLoading = false;
      notifyListeners();
      return ;
    }

    messageListData.forEach((String msgId,dynamic data){
      final String message = data['message'];
      fetchedMessages.add(message);
    });
    _messages = fetchedMessages;
    notifyListeners();
    print('message');
    print(_messages);
    } 
    catch(error){
      _isLoading=false;
      notifyListeners();
      return;
    }  
  }


}

///////////////////////////////////////////////////////////


class UserModel extends ConnectedCommunityModel{

  User get user {
    return _authenticatedUser;
  }

  bool isLoading = false;
  notifyListeners();

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
    final responseData = json.decode(response.body);

    bool hasError = true;
    var message = 'Something wents wrong.';
    
    if(responseData.containsKey('idToken')){
      hasError = false;
      message = 'Authentication Succeeded';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: responseData['email'],
          token:responseData['idToken']);

        ////store userdata when we signup
        String value;
        if(mode == AuthMode.Signup){
          final Map<String,dynamic> userData = {
            'userId': responseData['localId'].substring(0,8),
            'id':responseData['localId'],
          };
          print('user  Id ............');

          print(userData['userId']);
          final http.Response response =await http.post("https://minireddit-1803c.firebaseio.com/users.json",
          body:json.encode(userData));
          final Map<String,dynamic> ListData = json.decode(response.body);
          _userchatId.add(ListData['name']);
             _authenticatedUser = User(
                  usercreatedId: ListData['name'],
                  id: responseData['localId'],
                  email: responseData['email'],
                  token:responseData['idToken'],
                  randId :responseData['localId'].substring(0,8)); 
                    
          print(json.decode(response.body));
        }

        else if(mode == AuthMode.Login){
          final http.Response response = await http.get("https://minireddit-1803c.firebaseio.com/users.json",);
          final Map<String,dynamic> userListData = json.decode(response.body);
          if(userListData!= null ){
              userListData.forEach((String usercreatedId, dynamic data){
              _userchatId.add(usercreatedId);
              if(responseData['localId'] == data['id']){value = usercreatedId; }
              });
          }
        }

        _authenticatedUser = User(
                  usercreatedId: value,
                  id: responseData['localId'],
                  email: responseData['email'],
                  token:responseData['idToken'],
                  randId :responseData['localId'].substring(0,8)); 
       // _userchatId.indexWhere((String value){

        print('chat id');
          print(_userchatId );
          print(_authenticatedUser.usercreatedId);

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

  void logout() async{
    print('logout');
    _authenticatedUser = null;
    final SharedPreferences prem = await SharedPreferences.getInstance();
    _userchatId = [];
    prem.remove('token');
    prem.remove('userEmail');
    prem.remove('userId');
  }

  void setAuthTimeout(int time){
    Timer(Duration(seconds: time),(){
      logout();
    });
  }
}