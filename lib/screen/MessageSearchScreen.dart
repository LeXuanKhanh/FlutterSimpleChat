import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:flutter_chat_final/widgets/ChatMessageListItem.dart';

class MessageSearchScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();

  DateTime _requiredDate;
  MessageSearchScreen(this._requiredDate);
}

class _MyState extends State<MessageSearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainSModel>(

        builder: (BuildContext context, Widget child, MainSModel model) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Search Result'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('messages in ' + widget._requiredDate.day.toString() +
                      "/" + widget._requiredDate.month.toString() +"/"
                      + widget._requiredDate.year.toString()),
                  Expanded(
                      child: FirebaseAnimatedList(
                        defaultChild: Center(child: CircularProgressIndicator()),
                        query: model.refChat,
                        padding: const EdgeInsets.all(5.0),
                        reverse: true,
                        sort: (a,b) => b.key.compareTo(a.key),
                        itemBuilder: (BuildContext context,
                            DataSnapshot messageSnapshot, Animation<double> animation, int index){
                          DateTime temp = DateTime
                              .fromMillisecondsSinceEpoch(int.parse(messageSnapshot.value['date']));
                          if ( (temp.day == widget._requiredDate.day) &&
                              (temp.month == widget._requiredDate.month) &&
                              (temp.year == widget._requiredDate.year) )
                            return new ChatMessageListItem(
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                              currentUserName: model.user.username,);
                          else
                            return Container();
                        },
                      )
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}