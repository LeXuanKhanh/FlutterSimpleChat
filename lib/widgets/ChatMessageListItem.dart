import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';


class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  final String currentUserName;
  final DateFormat formatter = new DateFormat('EEEE, dd/MM/y , hh:mm a');

  var backgroundBubble;
  var textColor ;
  var align ;
  var btnColor;
  var btnTextColor;

  ChatMessageListItem({this.messageSnapshot, this.animation,this.currentUserName});

  bool isMe(){
    return currentUserName == messageSnapshot.value['username'];
  }

  @override
  Widget build(BuildContext context) {
    backgroundBubble = isMe() ? Colors.white : Theme.of(context).primaryColor;
    textColor = isMe() ? Colors.black : Colors.white;

    btnColor = isMe() ? Theme.of(context).primaryColor : Colors.white;
    btnTextColor = isMe() ? Colors.white : Colors.black ;

    align = isMe() ? CrossAxisAlignment.start : CrossAxisAlignment.end;

    return ScaleTransition(
      scale: animation,
      child: Tooltip(
        message: formatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageSnapshot.value['date']))),
        child: Column(
          crossAxisAlignment: align,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: <Widget>[
                  isMe() ?
                  Positioned(
                    left: 0,
                    child: new CircleAvatar(
                      backgroundImage:
                      new NetworkImage(messageSnapshot.value['avatar']),
                    ),
                  )
                  :
                  Positioned(
                    right: 0,
                    child: new CircleAvatar(
                      backgroundImage:
                      new NetworkImage(messageSnapshot.value['avatar']),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      right: isMe() ? 0 : 50.0,
                      left: isMe() ? 50.0 : 0,
                      bottom: 10.0,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(.12))
                      ],
                      color: backgroundBubble,
                      borderRadius: BorderRadius.all( Radius.circular(15.0) ),
                    ),
                    child: new Column(
                      crossAxisAlignment: align,
                      children: <Widget>[
                        Text(messageSnapshot.value['username'],
                            style: new TextStyle(
                                fontSize: 14.0,
                                color: textColor,
                                fontWeight: FontWeight.bold)),
                        MessageContentWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   Widget MessageContentWidget(){
    if ( messageSnapshot.value['type'] == null )
      return MessageWidget();
    else{
      if ( messageSnapshot.value['type'] == 'notification' )
        return NotificationMessageWidget();
      else
        return ComfirmMessageWidget();
    }
  }

  Widget MessageWidget(){
    return Column(
      children: <Widget>[
        new Text(messageSnapshot.value['content'],style: new TextStyle(color: textColor),),
      ],
    );
  }

  Widget NotificationMessageWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          messageSnapshot.value['notiDefaultContent'],
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        ),
        new Text(
          formatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageSnapshot.value['notiTime']))),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor
          ),
        ),
        new Container(
          margin: const EdgeInsets.only(top: 5.0),
          child: new Text(messageSnapshot.value['content'], style: TextStyle(color: textColor)),
        ),
        ScopedModelDescendant<MainSModel>(
          builder: (BuildContext context, Widget child, MainSModel model){
            return RaisedButton(
              color: btnColor,
              child: Text('AGREE',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: btnTextColor,
                  )
              ),
              onPressed: () {
                model.comfirmNotification(messageSnapshot.value['notiTime'],messageSnapshot.value['username'],messageSnapshot.value['content']);

                print('line 114 ChatScreen notificationConfigDialog: set notification at: '
                    + formatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageSnapshot.value['notiTime']))) );
              },
            );
          },
        )
      ],
    );
  }

  Widget ComfirmMessageWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text(
          messageSnapshot.value['notiDefaultContent'],
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        ),
        new Text(
          formatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageSnapshot.value['notiTime']))),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor
          ),
        ),
      ],
    );
  }
}