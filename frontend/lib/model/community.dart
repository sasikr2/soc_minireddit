import 'package:flutter/material.dart';

class Community {
  String id;
  String name;
  String about;
  bool join;
  int numofMemb ;
  Community({@required this.id,@required this.name, @required this.about, this.numofMemb,this.join});
}
