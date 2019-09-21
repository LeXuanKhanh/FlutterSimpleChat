import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:scoped_model/scoped_model.dart';

class FriendRoomScreen extends StatefulWidget{
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<FriendRoomScreen> with AutomaticKeepAliveClientMixin<FriendRoomScreen>{
  @override
  bool get wantKeepAlive => true;

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener((){
      setState(() {});
    });
  }

  Widget _RoomListItem({BuildContext context, DataSnapshot messageSnapshot, Animation animation, MainSModel model}){
    String _id = '';
    String _title = '';
    String _avatar = '';

    if (messageSnapshot.value['userID1'] != model.user.email){
      _id = messageSnapshot.value['userID1'];
    }
    else {
      _id = messageSnapshot.value['userID2'];
    }

    //print('line 40 RoomListItem FriendRoomScreen print friend id: ' +_id);
    _title = messageSnapshot.value['joined'][_id]['name'];
    _avatar = messageSnapshot.value['joined'][_id]['avatar'];



    if (_title.toString().contains(_searchController.text)  || _searchController.text == ''){
      if ( (messageSnapshot.value['userID1'].toString() == model.user.email) || (messageSnapshot.value['userID2'].toString() == model.user.email) ){
        return new SizeTransition(
          sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.decelerate),
          child: Column(
            children: <Widget>[
              new Divider(height: 10.0),
              new ListTile(
                title: new Text(_title, style: new TextStyle(fontSize: 20.0)),
                leading: CircleAvatar(backgroundImage: NetworkImage(_avatar)),
                onTap: () async {
                  model.enterFriendRoom(context, messageSnapshot, _title);
                },
                trailing: Column(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () => model.ComfirmRemoveFriendDialog(messageSnapshot.key, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
    return Container();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: ScopedModelDescendant<MainSModel>(

          builder: (BuildContext context, Widget child, MainSModel model){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'mời nhập tên'
                    ),
                    maxLines: null,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: null
                  ),
                ),
                Expanded(
                    child: FirebaseAnimatedList(
                        defaultChild: Center(child: CircularProgressIndicator()),
                        query: FirebaseDatabase.instance.reference().child('FriendRoom'),
                        itemBuilder: (BuildContext context, DataSnapshot messageSnapshot, Animation<double> animation, int index){
                          return _RoomListItem(
                              context: context,
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                              model: model
                          );
                        }
                    )
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}