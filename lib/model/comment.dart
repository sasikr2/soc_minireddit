import 'package:flutter/material.dart';

class Comment{
  num vote;
  List<String> reply = [] ;
  Comment({@required this.reply,@required this.vote});
}