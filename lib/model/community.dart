import 'package:flutter/material.dart';
import './post.dart';

class Community {
  String name;
  String about;
  bool join;
  var numofMemb ;
  List<Post> posts = [];
  Community({@required this.name, @required this.about,@required this.numofMemb,this.join,@required this.posts});
}
