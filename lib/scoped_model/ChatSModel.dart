import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/model/NotificationConfirmMessage.dart';
import 'package:flutter_chat_final/model/NotificationMessage.dart';
import 'package:flutter_chat_final/model/UserMessage.dart';
import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter_chat_final/screen/ChatScreen.dart';
import 'package:flutter_chat_final/screen/RoomInfoScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

//các chức năng chung cho các phòng ở màn hình ChatScreen
mixin ChatSModel on CoreSModel {

  //Gửi tin nhắn
  void addChatMessage(BuildContext context,String content){
    UserMessage message = UserMessage(
      avatar: user.avatar,
      username: user.username,
      content: content,
      email: user.email,
    );

    //thêm tin nhắn trong phòng
    refChat.push().set(message.toJson());

    //tăng số lương tin nhắn trong tháng
    refUser.child('messages').once().then((DataSnapshot snapshot){
      String time = (DateTime.now().month).toString()  + '-'
          + DateTime.now().year.toString();

      //nếu tháng đó là tháng mới thì tạo mới
      if (snapshot.value['month'][time] == null){
        print('line 30 ChatSModel set new month');

        refUser.child('messages').update({
          'all' : snapshot.value['all'] + 1
        });
        refUser.child('messages').child('month').child(time).set({
          'count': 1,
        });
      }
      //nếu tháng đó là tháng cũ thì tăng số lượng tin nhắn tháng dó
      else{
        print('line 41 ChatSModel update old month');

        refUser.child('messages').update({
          'all' : snapshot.value['all'] + 1
        });
        refUser.child('messages').child('month').child(time).update({
          'count': snapshot.value['month'][time]['count'] + 1,
        });
      }
    });
  }

  //thêm tin nhắn thiết lập thông báo cuộc hẹn
  void addNotificationMessage(DateTime result, String content){
    NotificationMessage notificationMessage = NotificationMessage(
        avatar: user.avatar,
        username: user.username,
        content: content,
        notiTime: result.millisecondsSinceEpoch.toString(),
        email: user.email
    );

    refChat.push().set(notificationMessage.toJson());

  }

  //thêm tin nhắn sau khi người dùng đồng ý với cuộc hẹn
  void comfirmNotification(String time, String notiOwner, String content) {
    NotificationComfirmMessage notificationMessage = NotificationComfirmMessage(
        avatar: user.avatar,
        username: user.username,
        notiTime: time,
        email: user.email
    );

    refChat.push().set(notificationMessage.toJson());

    ScheduleNotification(time, notiOwner, content);

  }

  //thiết lập thông báo
  ScheduleNotification(String time, String notiOwner, String content) async {

    final DateFormat formatter = new DateFormat('EEEE, dd/MM/y , hh:mm');
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('app_icon');
    var iOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    //schedule and display notification

    var scheduledNotificationDateTime =
    DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    //new DateTime.now().add(new Duration(seconds: 5));
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('your other channel id 1',
        'schedule notification 1', 'schedule notification',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Bạn có cuộc hẹn với '  + notiOwner,
        content,
        scheduledNotificationDateTime,
        platformChannelSpecifics
    );
  }

  Future onSelectNotification(String payload) async {
    BuildContext context;
    //debugPrint("payload : $payload");
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen('test')));
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  //xem thông tin phòng
  showRoomInfo(BuildContext context,String roomName){
    refRoom.once().then((DataSnapshot snapshot){
      Navigator.push(context, MaterialPageRoute(builder: (context) => RoomInfoScreen(snapshot: snapshot,roomName: roomName)));
    });
  }
}