import 'package:flutter/foundation.dart';
import 'UserMessage.dart';

class NotificationMessage extends UserMessage{
  String _notiDefaultContent;
  String _notiTime;
  String _type;

  NotificationMessage({@required String avatar,
    @required String username ,
    @required String content,
    @required String notiTime,
    @required String email})
  : super(avatar: avatar,
      username: username,
      content: content,
      email: email){

    this._notiDefaultContent = username +
        ' muốn có cuộc hẹn ở: ';
    this._notiTime = notiTime ;
    this._type= 'notification';
  }

  Map toJson(){
    Map map = super.toJson();

    map['notiDefaultContent'] = _notiDefaultContent;
    map['notiTime'] = _notiTime;
    map['type'] = _type;
    return map;
  }
}