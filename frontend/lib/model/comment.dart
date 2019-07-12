import 'package:flutter/material.dart';

class Comment{
  String id;
  String content;
  int vote;
  List<String> reply = [] ;
  String postId;
  Comment({ this.reply,@required this.vote,@required this.content, this.id,this.postId});
}