import 'package:flutter/material.dart';


class User {
  final String id ;
  final String email;
  final String token;
  final String randId;
  final usercreatedId;


  User({@required this.id, @required this.email, @required this.token,  this.randId, this.usercreatedId});
}
