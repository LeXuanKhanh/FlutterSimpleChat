import 'package:flutter/material.dart';
import 'package:flutter_chat_final/screen/AllRoomScreen.dart';
import 'package:flutter_chat_final/screen/FriendRoomScreen.dart';
import 'package:flutter_chat_final/screen/UserRoomScreen.dart';
import 'package:flutter_chat_final/screen/JoinedRoomScreen.dart';

class RoomTabScreen extends StatefulWidget  {
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<RoomTabScreen> with SingleTickerProviderStateMixin {
  TabController controller;
  TextStyle _textStyle = TextStyle(fontSize: 14);

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new TabBarView(
        // Add tabs as widgets
        children: <Widget>[
          new AllRoomScreen(),
          new UserRoomScreen(),
          new JoinedRoomScreen(),
          new FriendRoomScreen(),
        ],
        // set the controller
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        // set the color of the bottom navigation bar
        color: Theme.of(context).primaryColor,
        // set the tab bar as the child of bottom navigation bar
        child: SafeArea(
          child: new TabBar(
            tabs: <Tab>[
              new Tab(
                child: Text('Tất Cả',style: _textStyle)
              ),
              new Tab(
                child: Text('Của Tôi',style: _textStyle)
              ),
              new Tab(
                child: Text('Đã Vào',style: _textStyle)
              ),
              new Tab(
                child: Text('Bạn Bè',style: _textStyle)
              )
            ],
            // setup the controller
            controller: controller,
          ),
        ),
      ),
    );
  }
}