import 'package:flutter_chat_final/model/Room.dart';
import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

mixin CurrentUserSModel on CoreSModel{

  //kiểm tra xem có kết bạn chưa ( kiểm tra phòng giữa người dùng và bạn của người dùng có phòng chat chưa )
  checkFriendRoom(BuildContext context, String friendEmail, String friendName){

    // thiết lập key của phòng
    String _privateRoomName;
    switch(user.email.compareTo(friendEmail).toString()) {
      case "1": {
        _privateRoomName = user.email + '-' + friendEmail.replaceAll(RegExp('\\.'), ',');
      }
      break;

      case "-1": {
        _privateRoomName = friendEmail.replaceAll(RegExp('\\.'), ',')  + '-' + user.email;
      }
      break;

      case "0": {
        _privateRoomName = user.email + '-' + friendEmail.replaceAll(RegExp('\\.'), ',');
      }
      break;
    }

    print('line 27 CurrentUserSModel enterFriendRoom: finding private room name: ' + _privateRoomName);

    //tìm phòng có chứa key đó
    FirebaseDatabase.instance.reference().child('FriendRoom').child(_privateRoomName).once().then((DataSnapshot result) {

      //không tìm thấy phòng
      if (result.value == null){
        print('line 32 CurrentUserSModel enterFriendRoom: private havent created yet');

        String _friendAvatar;

        print('line 36 CurrentUserSModel enterFriendRoom: private room created');

        //tạo phòng mới giữa 2 người
        FirebaseDatabase.instance.reference()
            .child('UserInfo')
            .child(friendEmail.replaceAll(RegExp('\\.'), ',') )
            .child('avatar')
            .once()
            .then((DataSnapshot resultAvatar) {
              print(resultAvatar.value);
              _friendAvatar = resultAvatar.value;

              //User _friendUser = new User(friendName,_friendAvatar,friendEmail.replaceAll(RegExp('\\.'), ','));

              Room _room = Room(_privateRoomName, '', user, '');

              FirebaseDatabase.instance.reference()
                  .child('FriendRoom')
                  .update(_room.toJson());

              FirebaseDatabase.instance.reference()
                  .child('FriendRoom')
                  .child(_privateRoomName)
                  .update({
                'userID1': user.email,
                'userID2': friendEmail.replaceAll(RegExp('\\.'), ','),
              });

              FirebaseDatabase.instance.reference()
                  .child('FriendRoom')
                  .child(_privateRoomName).child('joined')
                  .update({
                friendEmail.replaceAll(RegExp('\\.'), ',') :{
                  'avatar': _friendAvatar,
                  'name': friendName,
                },
              });
        });

        Scaffold.of(context).showSnackBar(new SnackBar(duration: Duration(seconds: 1),content: new Text('Đã kết bạn'), backgroundColor: Theme.of(context).primaryColor));

      }
      // phòng đã tồn tại, đã kết bạn với người đó
      else {
        print('line 87 CurrentUserSModel private room already existed');

        Scaffold.of(context).showSnackBar(new SnackBar(duration: Duration(seconds: 1),content: new Text('Bạn đã kết bạn với người này rồi'), backgroundColor: Theme.of(context).primaryColor));

      }

    });



  }

}