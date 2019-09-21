import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';

import 'package:flutter_chat_final/screen/ChatScreen.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// các chức năng chung cho các phòng ở 4 màn hình trong RoomTabScreen ( AllRoomScreen, UserRoomScreen, JoinedRoomScreen, FriendRoomScreen )
mixin AllRoomSModel on CoreSModel{

  //vào phòng
  void enterRoom(BuildContext context, DataSnapshot messageSnapshot) async {

    // kiểm tra có password không ?
    if ( messageSnapshot.value['password'] == null ){

      refRoom = FirebaseDatabase.instance.reference().child('Room').child(messageSnapshot.key);
      refChat = FirebaseDatabase.instance.reference().child('Chat').child(messageSnapshot.key);

      FirebaseDatabase.instance.reference().child('Room')
          .child(messageSnapshot.key).child('joined').child(user.email).update({
        'name': user.username,
        'avatar': user.avatar
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(messageSnapshot.key)));

    }

    else
    {
      //mở hộp thoại nhập mật khẩu
      bool checkPass = await _EnterPasswordDialog(messageSnapshot.value['password'].toString(),context );

      //mật khẩu đúng
      if (checkPass == true ){

        refRoom = FirebaseDatabase.instance.reference().child('Room').child(messageSnapshot.key);
        refChat = FirebaseDatabase.instance.reference().child('Chat').child(messageSnapshot.key);

        FirebaseDatabase.instance.reference()
            .child('Room').child(messageSnapshot.key).child('joined').child(user.email).update({
          'name': user.username,
          'avatar': user.avatar
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(messageSnapshot.key)));
      }
      //mật khẩu sai
      else{
        Scaffold.of(context).showSnackBar(
            new SnackBar(duration: Duration(seconds: 1),
                content: new Text('Sai Mật Khẩu'),
                backgroundColor: Theme.of(context).primaryColor)
        );
      }
    }
  }


  //hộp thoại nhập mật khẩu
  Future<bool>_EnterPasswordDialog(String s,BuildContext context) {
    TextEditingController controller = new TextEditingController(text: '');
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Nhập Mật Khẩu'),
        content: Wrap(
          children: <Widget>[
            new Text('Bạn phải có mật khẩu để vào được phòng này'),
            new TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Hãy Nhập Mật Khẩu'
              ),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              if ( controller.text == s ){
                Navigator.of(context).pop(true);
              }
              else{
                Navigator.of(context).pop(false);
              }
            },
            child: new Text('Xác Nhận'),
          ),
        ],
      ),
    );
  }

}

