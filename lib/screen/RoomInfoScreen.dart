import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/model/User.dart';

class RoomInfoScreen extends StatefulWidget {
  @override
  _RoomInfoResultState createState() => _RoomInfoResultState();

  DataSnapshot snapshot;
  String roomName;

  RoomInfoScreen({this.snapshot,this.roomName}) {}
}

class _RoomInfoResultState extends State<RoomInfoScreen> {
  List<User> list = new List<User>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<dynamic, dynamic> value = widget.snapshot.value['joined'];
    if (value != null){
      value.forEach((key, value) {
        //print(key.toString() + ' ' + value['name'].toString());
        User t = new User(value['name'], value['avatar'], '');
        list.add(t);
      });
    }
//    list.forEach((f) => print(f));
  }

  Widget listItem(User user) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: user.avatar != '' ?
            new NetworkImage(user.avatar) : new AssetImage('assets/avatar.png'),
          ),
          title: Text(user.username),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Phòng'),
      ),
      body: Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: new Text('Tên Phòng: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: new Text(widget.roomName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: new Text('Chủ Phòng: ', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: widget.snapshot.value['owner'] != null ?
                new Text(widget.snapshot.value['owner']) : new Text(''),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return listItem(list.elementAt(index));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
