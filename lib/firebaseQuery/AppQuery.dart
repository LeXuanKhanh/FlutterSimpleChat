import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';

class AppQuery extends CoreSModel{
  static AppQuery _instance;

  static AppQuery Instance(){
    if (_instance == null){
      _instance = new AppQuery();
    }
    return _instance;
  }

  // Đổi trạng thái người dùng
  void setStatus(String status) async {
    if (prefs != null){
      if ( (prefs.get('userDisplayName').toString() != 'unknown user') ){
        print('line 63 AppQuery setStatus user: ' + prefs.get('userDisplayName') + ' | status: ' + status);
        print('line 64 AppQuery setStatus email: ' + prefs.get('userEmail'));
        FirebaseDatabase.instance.reference()
            .child('UserInfo')
            .child(prefs.get('userEmail')).update({
          'status':status
        });
      }
    }
    else
      print('line 73 AppQuery setStatus user: user still null');
  }
}

