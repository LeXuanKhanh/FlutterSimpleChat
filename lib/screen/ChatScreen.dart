import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_chat_final/screen/MessageSearchScreen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:flutter_chat_final/widgets/ChatMessageListItem.dart';

class ChatScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();

  String _roomName;

  ChatScreen(String roomName){
    _roomName = roomName;
  }
}

class _MyState extends State<ChatScreen> {
  TextEditingController _chatController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // hộp thoại nhập thời gian các tin nhắn cần tìm
  searchMessageDialog(MainSModel model){

    DateTime _date = DateTime.now();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
       builder: (context,setState){
         return new AlertDialog(
           title: new Text('Hãy nhập thời gian để tìm'),
           content: Wrap(
             children: <Widget>[
               Center(
                 child: new RaisedButton(
                   onPressed: () async {
                     final DateTime picked = await showDatePicker(
                         context: context,
                         initialDate: _date,
                         firstDate: new DateTime(2018),
                         lastDate: new DateTime(9999)
                     );

                     if (picked != null && picked != _date){
                       setState(() {
                         _date = picked;
                         print('line 56 ChatScreen searchMessageDialog: date selected' + _date.toIso8601String());
                       });
                     }
                   },
                   child: new Text(_date.day.toString() + "/" +_date.month.toString() +"/" +_date.year.toString()),
                 ),
               ),
             ],
           ),
           actions: <Widget>[
             new FlatButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 Navigator.push(context, MaterialPageRoute(builder: (context) => MessageSearchScreen(_date)));
               },
               child: new Text('Đồng Ý'),
             ),
             new FlatButton(
               onPressed: () => Navigator.of(context).pop(),
               child: new Text('Hủy'),
             ),
           ],
         );
       }
      )
    ) ?? false;
  }

  //hộp thoại nhập thời gian và nội dung thông báo cuộc hẹn
  notificationConfigDialog(MainSModel model){
    DateTime _date = DateTime.now();
    TimeOfDay _time = new TimeOfDay.now();
    DateTime _result;
    TextEditingController _contentController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context,setState){
              return new AlertDialog(
                title: new Text('Thiết lập thông báo'),
                content: Wrap(
                  children: <Widget>[
                    Center(
                      child: new RaisedButton(
                        onPressed: () async {
                          final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: new DateTime(2018),
                              lastDate: new DateTime(9999)
                          );

                          if (picked != null && picked != _date){
                            setState(() {
                              _date = picked;
                              print('line 56 ChatScreen notificationConfigDialog: date selected: ' + _date.toIso8601String());
                            });
                          }
                        },
                        child: new Text(_date.day.toString() + "/" +_date.month.toString() +"/" +_date.year.toString()),
                      ),
                    ),

                    Center(
                      child: new RaisedButton(
                        onPressed: () async {
                          final TimeOfDay picked = await showTimePicker(
                              context: context,
                              initialTime: _time);

                          if (picked != null && picked != _time){
                            print('line 125 ChatScreen notificationConfigDialog: Time Selected: ${_time.hour} : ${_time.minute}');
                            setState((){
                              _time = picked;
                            });
                          }
                        },
                        child: new Text(_time.hour.toString() + ":" +_time.minute.toString()),
                      ),
                    ),

                    Center(
                      child: TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                            hintText: 'Mời nhập tin nhắn thông báo'
                        ),
                        maxLines: null,
                      )
                    ),
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      _result = DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute);
                      print('line 150 ChatScreen notificationConfigDialog: DateTime Result: ' + _result.millisecondsSinceEpoch.toString());
                      print('line 151 ChatScreen notificationConfigDialog: Content Result: ' + _contentController.text);
                      model.addNotificationMessage(_result,_contentController.text);
                      Navigator.of(context).pop();
                    },
                    child: new Text('Đồng Ý'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('Hủy'),
                  ),
                ],
              );
            }
        )
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainSModel>(

        builder: (BuildContext context, Widget child, MainSModel model) {
            return Scaffold(
              resizeToAvoidBottomPadding: true,
              appBar: AppBar(
                title: Text(widget._roomName),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () => notificationConfigDialog(model),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => searchMessageDialog(model),
                  ),
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () => model.showRoomInfo(context,widget._roomName),
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Đăng nhập với tên ${model.user.username}'),
                    Expanded(
                        child: FirebaseAnimatedList(
                          defaultChild: Center(child: CircularProgressIndicator()),
                          query: model.refChat,
                          padding: const EdgeInsets.all(5.0),
                          reverse: true,
                          sort: (a,b) => b.key.compareTo(a.key),
                          itemBuilder: (BuildContext context, DataSnapshot messageSnapshot, Animation<double> animation, int index){
                            return new ChatMessageListItem(
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                              currentUserName: model.user.username,);
                          },
                        )
                    ),
                    Divider(height: 1.0),
                    ListTile(
                      title: TextField(
                        controller: _chatController,
                        decoration: InputDecoration(
                            hintText: 'mời nhập tin nhắn'
                        ),
                        maxLines: null,
                      ),
                      trailing: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            setState(() {
                              if(_chatController.text.isNotEmpty){
                                model.addChatMessage(context,_chatController.text);
                                _chatController.clear();
                              }
                            });
                          }),
                    ),
                  ],
                ),
              ),
            );
        }
    );
  }
}