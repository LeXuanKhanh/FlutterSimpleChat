import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:scoped_model/scoped_model.dart';

class JoinedRoomScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<JoinedRoomScreen> with AutomaticKeepAliveClientMixin<JoinedRoomScreen>{
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
    if (messageSnapshot.key.toString().contains(_searchController.text)  || _searchController.text == ''){
      if (messageSnapshot.value['joined'].toString().contains(model.user.username) == true){
        return new SizeTransition(
          sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.decelerate),
          child: Column(
            children: <Widget>[
              new Divider(height: 10.0),
              new ListTile(
                title: new Text(messageSnapshot.key, style: new TextStyle(fontSize: 20.0)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start ,
                  children: <Widget>[
                    messageSnapshot.value['password'] != null
                        ? new Icon(Icons.vpn_key,color: Colors.grey,)
                        : new SizedBox(),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () => model.ComfirmLeaveRoomDialog(messageSnapshot.key, context),
                ),
                onTap: () async {
                  model.enterRoom(context, messageSnapshot);
                },
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
                        query: FirebaseDatabase.instance.reference().child('Room'),
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