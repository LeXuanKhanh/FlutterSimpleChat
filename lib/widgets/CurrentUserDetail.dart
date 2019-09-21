import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';

class CurrentUserDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainSModel>(

      builder: (BuildContext context, Widget child, MainSModel model){
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              padding: EdgeInsets.all(10.0),
              child: new Center(
                child: new Column(
                  children: <Widget>[
                    new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                      (model.user.username != 'unknown user') && (model.user.username != 'loading username') ?
                      new NetworkImage(model.user.avatar) : new AssetImage('assets/avatar.png'),
                      radius: 50.0,
                    ),
                    new Text(model.user.username,style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white)),
                    new Text(model.user.email.replaceAll(RegExp(','), '.'),style: new TextStyle(fontSize: 15.0,color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        );
      }

    );
  }

}
