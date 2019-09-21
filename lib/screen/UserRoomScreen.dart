import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';


class UserRoomScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<UserRoomScreen> with AutomaticKeepAliveClientMixin<UserRoomScreen>{
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
                  SizedBox(width: 20,),
                  messageSnapshot.value['password'] != null
                      ? new Text(messageSnapshot.value['password'],style: TextStyle(fontSize: 18),)
                      : new Text(''),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 5.0),
//                  IconButton(
//                      icon: new Icon(Icons.edit),
//                      onPressed: () => Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Dummy Edit'), backgroundColor: Theme.of(context).primaryColor,))
//                  ),
                  IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () {
                      model.ComfirmDeleteDialog(messageSnapshot.key,context);
                    },
                  ),
                ],
              ),
              onTap: () async {
                model.enterRoom(context, messageSnapshot);
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainSModel>(
      builder: (BuildContext context, Widget child, MainSModel model){

        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Center(
            child: Column(
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
                        query: FirebaseDatabase.instance.reference().child('Room').orderByChild('owner').equalTo(model.user.username),
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
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed : () => model.CreateRoomDialog(context),
            tooltip: 'Add A Room',
            child: Icon(Icons.add),
          ),
        );

      },
    );
  }
}

