import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CurrentUsersScreen extends StatefulWidget {
  @override
  _MyState createState() => new _MyState();
}

class _MyState extends State<CurrentUsersScreen> {
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener((){
      setState(() {});
    });
  }

  UserInfoDialog(MainSModel model, DataSnapshot messageSnapshot,BuildContext contextRoot){
    return showDialog(
      context: contextRoot,
      builder: (context){
        return AlertDialog(
          content: Wrap(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
                    padding: EdgeInsets.all(10.0),
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          new CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: new NetworkImage(messageSnapshot.value['avatar']),
                            radius: 50.0,
                          ),
                          new Text(messageSnapshot.value['name'],style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white)),
                          new Text(messageSnapshot.value['email'],style: new TextStyle(fontSize: 15.0,color: Colors.white)),
                          RaisedButton(
                            child: Text('Kết Bạn'),
                            color: Theme.of(context).copyWith().primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              model.checkFriendRoom(contextRoot, messageSnapshot.value['email'], messageSnapshot.value['name']);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget _UserItem({DataSnapshot messageSnapshot, Animation animation, MainSModel model}){
    if (messageSnapshot.value['name'].toString().contains(_searchController.text)  || _searchController.text == ''){
      if (messageSnapshot.value['name'] != model.user.username)
        return GestureDetector(
          child: new SizeTransition(
            sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.decelerate),
            child: new Container(
              padding: EdgeInsets.all(5.0),
              child: new Row(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: new CircleAvatar(
                            backgroundImage:
                            new NetworkImage(messageSnapshot.value['avatar']),
                          )),
                    ],
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(messageSnapshot.value['name'], style: new TextStyle(fontWeight: FontWeight.bold)),
                        new Text(messageSnapshot.value['email']),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          messageSnapshot.value['status'] == 'online'
                              ? new CircleAvatar(radius: 10.0,backgroundColor: Colors.green)
                              : new SizedBox(),
                          IconButton(
                            icon: Icon(Icons.person_add),
                            onPressed: () => model.checkFriendRoom(context, messageSnapshot.value['email'], messageSnapshot.value['name']),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
          onTap: (){
            UserInfoDialog(model,messageSnapshot,context);
          },
        );
    }
    return Container();

  }

  @override
  Widget build(BuildContext context) {
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
            ScopedModelDescendant<MainSModel>(
              builder: (BuildContext context, Widget child, MainSModel model){
                return  Expanded(
                    child: FirebaseAnimatedList(
                        defaultChild: Center(child: CircularProgressIndicator()),
                        query: FirebaseDatabase.instance.reference().child('UserInfo'),
                        itemBuilder: (BuildContext context, DataSnapshot messageSnapshot, Animation<double> animation, int index){
                          return _UserItem(
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                              model: model);
                        }
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}