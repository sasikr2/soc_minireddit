import 'package:flutter/material.dart';
import './comment.dart';

class Post {
  dynamic content;
  num vote;
  List<Comment> comments = [];
  
  Post({@required this.content,@required this.vote,@required this.comments});
}