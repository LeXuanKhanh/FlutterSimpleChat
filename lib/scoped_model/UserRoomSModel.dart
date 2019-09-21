import 'package:flutter_chat_final/model/Room.dart';
import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// các chức năng riêng cho màn hình UserRoomScreen
mixin UserRoomSModel on CoreSModel {

  //hộp thoại xác nhận xóa phòng
  ComfirmDeleteDialog(String key,BuildContext contextRoot){
    return showDialog(
      context: contextRoot,
      builder: (context) => new AlertDialog(
        title: new Text('Xác Nhận Xóa Phòng'),
        content: new Text('Bạn có muốn xóa phòng này không ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {

              FirebaseDatabase.instance.reference()
                  .child('Room').child(key).remove();
              FirebaseDatabase.instance.reference()
                  .child('Chat').child(key).remove();

              Scaffold.of(contextRoot).showSnackBar(
                  new SnackBar(duration: Duration(seconds: 1),
                    content: new Text('Đã Xóa'),
                    backgroundColor: Theme.of(context).primaryColor,
                  )
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

  //hộp thoại nhập tên và mật khẩu cho phòng mới
  CreateRoomDialog(BuildContext contextRoot){
    TextEditingController nameController = new TextEditingController(text: '');
    TextEditingController passwordController = new TextEditingController(text: '');
    return showDialog(
      context: contextRoot,
      builder: (context) => new AlertDialog(
          title: new Text('Tạo Phòng'),
          content: Wrap(
            children: <Widget>[
              new Text('Tên Phòng: '),
              new TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Mới nhập tên phòng",
                ),
              ),
              new Text('Mật Khẩu (tùy chọn) : '),
              new TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    hintText: "Mới nhập mật khẩu phòng"
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {

                Room room = Room(
                    nameController.text,
                    user.username, user,
                    passwordController.text);

                FirebaseDatabase.instance.reference()
                    .child('Room').update(room.toJson());

                Scaffold.of(contextRoot).showSnackBar(
                    new SnackBar(duration: Duration(seconds: 1),
                      content: new Text('Created A Room'),
                      backgroundColor: Theme.of(context).primaryColor,));
                Navigator.of(context).pop();
              },
              child: new Text('OK'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('Cancel'),
            ),
          ]
      ),
    );
  }

}