import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../model/community.dart';

class CommunityModel extends Model{
  List<Community> _communties = [];
  bool isLoading = false;

  List<Community> get allCommunities{
    return List.from(_communties);
  }

  void addCommunity(Community community ){
    isLoading = true;
    _communties.add(community);
  }

}