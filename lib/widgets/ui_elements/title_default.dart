import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
     if(title == null) return Container();
        else{
         return  Text(
            title,
            style: TextStyle(
                fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
                );
        }
  }
}
