import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat_final/widgets/CurrentUserDetail.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<LoginScreen> {

  void _keepLogin() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await _auth.currentUser();
    print(firebaseUser);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _keepLogin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          children: <Widget>[
            CurrentUserDetail(),
            ScopedModelDescendant<MainSModel>(
                builder: (BuildContext context, Widget child, MainSModel model){
                    return Column(
                      children: <Widget>[
                        RaisedButton(
                          child: new Text('Đăng Nhập'),
                           onPressed: (){
                             model.signIn(context);
                           },
                        ),
                        RaisedButton(
                          child: new Text('Đăng Xuất'),
                          onPressed: (){
                            model.signOut(context);
                          },
                        ),
                      ],
                    );
                }
            ),

          ],
        ),
      ),
    );
  }
}