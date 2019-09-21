import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_final/screen/ChatScreen.dart';

//các chức năng liên quan đến FriendRoomScreen
mixin FriendRoomSModel on CoreSModel{

  //vào phòng
  void enterFriendRoom(BuildContext context, DataSnapshot messageSnapshot, String title){
    refChat = FirebaseDatabase.instance.reference().child('FriendRoom').child(messageSnapshot.key).child('chat');

    refRoom = FirebaseDatabase.instance.reference().child('FriendRoom').child(messageSnapshot.key);
    refChat = FirebaseDatabase.instance.reference().child('Chat').child(messageSnapshot.key);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(title)));
  }

  // hộp thoại xác nhận xóa phòng/ hủy kết bạn
  ComfirmRemoveFriendDialog(String key,BuildContext contextRoot){
    return showDialog(
      context: contextRoot,
      builder: (context) => new AlertDialog(
        title: new Text('Hủy Kết Bạn'),
        content: new Text('Bạn có muốn hủy kết bạn với người này ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              FirebaseDatabase.instance.reference()
                  .child('FriendRoom').child(key).remove();
              FirebaseDatabase.instance.reference()
                  .child('Chat').child(key).remove();

              Scaffold.of(contextRoot).showSnackBar(
                  new SnackBar(duration: Duration(seconds: 1),
                    content: new Text('Đã Hủy kết Bạn'),
                    backgroundColor: Theme.of(context).primaryColor,)
              );
              Navigator.of(context).pop();
            },
            child: new Text('Có'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: new Text('Không'),
          ),
        ],
      ),
    );
  }
}