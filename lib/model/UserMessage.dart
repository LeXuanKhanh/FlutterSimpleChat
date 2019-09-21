import 'package:flutter/foundation.dart';

class UserMessage  {
  String avatar;
  String content;
  String date;
  String username;
  String userID;

  UserMessage({@required String avatar,
    @required String username ,
    @required String content,
    @required String email}){


    this.avatar = avatar ;
    this.username = username;

    this.content = content ;

    this.date = DateTime.now()
        .millisecondsSinceEpoch.toString();
    this.userID = email;
  }

  Map toJson(){
    Map map = new Map();
    map['avatar'] = avatar;
    map['content'] = content;
    map['date'] = date;
    map['username'] = username;
    map['userID'] = userID;
    return map;
  }
}