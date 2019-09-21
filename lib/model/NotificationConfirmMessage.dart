import 'package:flutter/foundation.dart';
import 'UserMessage.dart';

class NotificationComfirmMessage extends UserMessage{
  String _notiDefaultContent;
  String _notiTime;
  String _type;

  NotificationComfirmMessage({@required String avatar,
    @required String username,
    @required String notiTime,
    @required String email})
  : super(avatar: avatar,
      username: username,
      content: '',
      email: email){

    this._notiDefaultContent = username +
        ' đã đồng ý với cuộc hẹn của bạn lúc: ';
    this._notiTime = notiTime;
    this._type = 'notificationComfirm';
  }

  Map toJson(){
    Map map = super.toJson();

    map['notiDefaultContent'] = _notiDefaultContent;
    map['notiTime'] = _notiTime;
    map['type'] = _type;
    return map;
  }
}