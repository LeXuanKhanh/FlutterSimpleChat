import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';

// các chức năng riêng cho màn hình JoinedRoomScreen
mixin JoinedRoomSModel on CoreSModel {
  // hộp thoại xác nhận rời phòng
  ComfirmLeaveRoomDialog(String key,BuildContext contextRoot){
    return showDialog(
      context: contextRoot,
      builder: (context) => new AlertDialog(
        title: new Text('Rời phòng'),
        content: new Text('Bạn có muốn rời khỏi phòng không ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              FirebaseDatabase.instance.reference().child('Room')
                  .child(key).child('joined').child(user.email).remove();

              Scaffold.of(contextRoot).showSnackBar(
                  new SnackBar(duration: Duration(seconds: 1),
                    content: new Text('Đã rời phòng'),
                    backgroundColor: Theme.of(context).primaryColor,));
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