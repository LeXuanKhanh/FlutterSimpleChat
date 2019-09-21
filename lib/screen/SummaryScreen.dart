import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_final/scoped_model/MainSModel.dart';
import 'package:scoped_model/scoped_model.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {

  String all = '';
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener((){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ScopedModelDescendant<MainSModel>(
          builder: (BuildContext context, Widget child, MainSModel model){
            model.refUser.child('messages').child('all').once().then((DataSnapshot snapshot){
              if (mounted){
                setState(() {
                  all = snapshot.value.toString();
                });
              }
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: new Text('Tất cả các tin nhắn: ',style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: new Text(all,style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 5.0,color: Colors.black45,),
                ListTile(
                  title: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: 'mời nhập thời gian'
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
                        query: model.refUser.child('messages').child('month'),
                        itemBuilder: (BuildContext context, DataSnapshot messageSnapshot, Animation<double> animation, int index){
                          if (messageSnapshot.key.toString().contains(_searchController.text)  || _searchController.text == ''){
                            return ListTile(
                              title: new Text(messageSnapshot.key.toString()),
                              trailing: new Text(messageSnapshot.value['count'].toString()),
                            );
                          }
                          else
                            return Container();
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

