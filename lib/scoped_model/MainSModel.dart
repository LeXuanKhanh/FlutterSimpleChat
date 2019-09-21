import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter_chat_final/scoped_model/ChatSModel.dart';
import 'package:flutter_chat_final/scoped_model/LoginSModel.dart';
import 'package:flutter_chat_final/scoped_model/AllRoomSModel.dart';
import 'package:flutter_chat_final/scoped_model/UserRoomSModel.dart';
import 'package:flutter_chat_final/scoped_model/JoinedRoomSModel.dart';
import 'package:flutter_chat_final/scoped_model/CurrentUserSModel.dart';
import 'package:flutter_chat_final/scoped_model/FriendRoomSModel.dart';

import 'package:flutter_chat_final/model/User.dart';


class MainSModel extends CoreSModel
    with  ChatSModel, LoginSModel, AllRoomSModel, UserRoomSModel, JoinedRoomSModel, CurrentUserSModel, FriendRoomSModel{

  MainSModel() {
    user = new User('loading username','','loading email');
    setPref();
    print('line 19 MainSModel this is mainsmodel constructor');
  }

}
