import 'package:flutter/material.dart';
import './comment.dart';

class Post {
  final String id; 
  final String communityid;
  String  title;
  var content;
  num vote;
  List<Comment> comments = [];
  
  Post({ this.id,@required this.communityid,@required this.title,@required this.content,@required this.vote, this.comments});
}