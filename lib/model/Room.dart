import 'package:flutter_chat_final/model/User.dart';

class Room{
  String _name;
  String _owner;
  String _password;
  User _user;

  Room(this._name, this._owner, this._user, this._password);

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map = new Map<String,dynamic>.from({
      _name:{
        'owner': _owner,
        'joined':{
          _user.email:{
            'name': _user.username,
            'avatar': _user.avatar,
          }
        }
      }
    });

    //optional for normal room
    if (_password != '')
      map[_name]['password']= _password;

    return map;
  }
}