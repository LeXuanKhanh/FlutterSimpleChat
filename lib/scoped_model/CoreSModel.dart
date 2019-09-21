import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_final/model/User.dart';
import 'package:flutter_chat_final/firebaseQuery/AppQuery.dart';

// chứa các biến và các phương thức cần gọi khi ứng dụng bắt đầu
class CoreSModel extends Model {

  String roomName = "lobby";

  // truy vấn lên qua tới node Room
  DatabaseReference refRoom = FirebaseDatabase.instance.reference()
      .child('Room')
      .child('lobby');

  // truy vấn lên quan tới node Chat
  DatabaseReference refChat = FirebaseDatabase.instance.reference()
      .child('Chat')
      .child('lobby');

  // truy vấn lên qua tới node UserInfo
  DatabaseReference refUser = FirebaseDatabase.instance.reference().child('UserInfo');

  //bộ nhớ đệm SharedPreferences
  static SharedPreferences _prefs;

  // người dùng
  User _user;

  //getter
  SharedPreferences get prefs {
    return _prefs;
  }

  User get user{
    return _user;
  }

  //setter

  //lấy thông tin người dùng phiên trước từ bộ nhớ đệm
  //init shared user data in SharedPreferences if empty
  void setPref() async{
    _prefs = await SharedPreferences.getInstance();

    //nếu bộ nhớ đệm chưa được ghi vào máy
    if (prefs.getString('userDisplayName') == null){
      print("line 47 CoreSModel initing share preferences");
      prefs.setString('userDisplayName', 'unknown user');
      prefs.setString('userEmail', 'unknown email');
      prefs.setString('userAvatarUrl', '');
      print("line 51 CoreSModel init completed");
    }
    //bộ nhớ đệm đã ghi vào máy
    else{
      AppQuery.Instance().setStatus('online');
      print('line 54 CoreSModel share preferences already inited');
    }

    _user.username = _prefs.get('userDisplayName');
    _user.email = _prefs.get('userEmail');
    _user.avatar = _prefs.get('userAvatarUrl');

    refUser = refUser.child(_user.email);

    notifyListeners();
  }

  set user(User user){
    _user = user;
    notifyListeners();
  }
}