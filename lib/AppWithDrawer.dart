import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/screen/SummaryScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';

import 'package:flutter_chat_final/screen/LoginScreen.dart';
import 'package:flutter_chat_final/screen/CurrentUsersScreen.dart';
import 'package:flutter_chat_final/screen/RoomTabScreen.dart';

import 'package:flutter_chat_final/widgets/CurrentUserDetail.dart';

import 'package:flutter_chat_final/firebaseQuery/AppQuery.dart';


class AppWithDrawer extends StatefulWidget{
  @override
  _MyState createState() => new _MyState();
}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title,this.icon);
}

class _MyState extends State<AppWithDrawer> with WidgetsBindingObserver {

  String title = ' Phòng Trò Chuyện';
  String mode;

  int _selectedDrawerIndex = 0;
  final drawerItems = [
    new DrawerItem('Phòng Trò Chuyện',Icons.chat),
    new DrawerItem('Đăng Nhập',Icons.account_circle),
    new DrawerItem('Mọi Người',Icons.supervised_user_circle),
    new DrawerItem('Thống Kê',Icons.show_chart),
  ];

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      title = drawerItems[index].title;
    });
    Navigator.of(context).pop();
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new RoomTabScreen();
      case 1:
        return new LoginScreen();
      case 2:
        return new CurrentUsersScreen();
      case 3:
        return new SummaryScreen();
      default:
        return new Text("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppQuery.Instance().setStatus('online');
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    AppQuery.Instance().setStatus('offline');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      print('state change: ' + state.toString());
      if (state == AppLifecycleState.resumed) {
        AppQuery.Instance().setStatus('online');
      }
      else
//        if (state == AppLifecycleState.suspending){
//          AppQuery.Instance().setStatus('offline');
//        }
//        else
//          if (state == AppLifecycleState.paused){
//            AppQuery.Instance().setStatus('offline');
//          }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Xác Nhận'),
        content: new Text('Bạn có muốn thoát ứng dụng không ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              AppQuery.Instance().setStatus('offline');
              Navigator.of(context).pop(true);
            },
            child: new Text('Có'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Không'),
          ),
        ],
      ),
    ) ?? false;
  }

  Widget mainContent(MainSModel model){
    if (model.user.username == 'unknown user')
      return LoginScreen();
    else
    if (model.user.username == 'loading username')
      return Container(child: Center(child: CircularProgressIndicator()));
    else
      return _getDrawerItemWidget(_selectedDrawerIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark)
      mode = 'Nền Tối';
    else
      mode = 'Nền Sáng';

    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
          new ListTile(
            title: new Text(d.title),
            leading: new Icon(d.icon),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: ScopedModelDescendant<MainSModel> (
        builder: (BuildContext context, Widget child, MainSModel model){
          return new Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(
              title: new Text(title),
              actions: <Widget>[
                GestureDetector(
                  child: SizedBox(
                    width: 55,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                        (model.user.username != 'unknown user') && (model.user.username != 'loading username') ?
                        new NetworkImage(model.user.avatar) : new AssetImage('assets/avatar.png'),
                      ),
                    ),
                  ),
                  onTap: () => setState(() {
                    _selectedDrawerIndex = 1;
                    title = drawerItems[1].title;
                  }),
                ),
              ],
            ),
            drawer: new Drawer(
              child: Column(
                children: <Widget>[
                  CurrentUserDetail(),
                  //Divider(height: 5.0,color: Colors.black,),
                  Column(
                    children: drawerOptions,
                  ),
                  RaisedButton(
                    child: Text(mode),
                    color: Theme.of(context).copyWith().primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      setState((){
                        if (Theme.of(context).brightness == Brightness.dark){
                          DynamicTheme.of(context).setThemeData(new ThemeData(
                            brightness:  Brightness.light,
                            primarySwatch: Colors.red,
                            primaryColor: Colors.red,
                          ));
                          mode = 'Nền Sáng';
                        }
                        else{
                          DynamicTheme.of(context).setThemeData(new ThemeData(
                            brightness:  Brightness.dark,
                          ));
                          mode = 'Nền Tối';
                        }

                      });
                    },
                  ),
                ],
              ),
            ),
            body:  mainContent(model),
          );
        },
      ),
    );

  }
}