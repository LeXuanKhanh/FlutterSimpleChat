import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_chat_final/scoped_model/CoreSModel.dart';
import 'package:flutter_chat_final/firebaseQuery/AppQuery.dart';

//các chức năng ở LoginScreen
mixin LoginSModel on CoreSModel {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser fUser;

  // tiếp tục đăng nhập khi vào ứng dụng
   void keepLogin() async {
     fUser = await _auth.currentUser();

     if (_auth.currentUser() != null) {
       setCurrentUser(fUser.displayName, fUser.email, fUser.photoUrl);
     }
     else {
       setCurrentUser('unknown user', 'unknown email', 'userAvatarUrl');
     }
   }

   //đăng nhập
  void signIn(BuildContext context) async {

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
        fUser = await _auth.signInWithCredential(credential);
    }
    catch ( err ){
      print('error in Sign In: ' + err.toString());
    }
    finally{

      if ( fUser != null){

        print('before setCurrentUser email: using substring ' + fUser.email.replaceAll(RegExp('\\.'), ','));
        setCurrentUser(fUser.displayName, fUser.email.replaceAll(RegExp('\\.'), ','), fUser.photoUrl);

        //thêm người dùng vào database
        checkUser( FirebaseDatabase.instance.reference().child('UserInfo'), fUser);

        print('line 50 LoginSModel signIn: Login Successfull ' + fUser.displayName + ' ' + fUser.email + ' ' + fUser.photoUrl + ' ');

        Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text('Login Successfull'), backgroundColor: Theme.of(context).primaryColor,),
        );

      }
      else{
        print('line 58 LoginSModel signIn: Login Failed');
        Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text('Login Failed, please try again '), backgroundColor: Theme.of(context).primaryColor,),
        );
      }
      
    }
  }

  // thêm người dùng vào database
  void checkUser(DatabaseReference userRef,FirebaseUser fUser) {
    // TODO: implement addUser
//    String email = fUser.email.substring(0,fUser.email.lastIndexOf('@'));
    String email = fUser.email.replaceAll(RegExp('\\.'), ',');
    print('test email: ' + fUser.email.replaceAll(RegExp('\\.'), ','));

    //tìm người dùng trong node UserInfo
    userRef.child(email)
        .once()
        .then((DataSnapshot snapshot) {
      //print('line 38 AppQuery checkUser value: ' + snapshot.value);
      print('line 39 AppQuery checkUser key: ' + snapshot.key);

      //nếu không tìm thấy
      if (snapshot.value == null) {
        print('line 41 AppQuery user not in database: ' + snapshot.key);
        FirebaseDatabase.instance.reference()
            .child('UserInfo')
            .child(email)
            .set({
          'name': fUser.displayName,
          'avatar': fUser.photoUrl,
          'email': fUser.email,
          'status': 'online',
          'messages':{
            'all' : 0,
            'month':{
              DateTime.now().month.toString() + '-' + DateTime.now().year.toString():{
                'count': 0,
              }
            }
          }
        });
      }
      //nếu tìm thấy
      else{
        print('line 53 AppQuery user already in database');
        FirebaseDatabase.instance.reference()
            .child('UserInfo')
            .child(prefs.get('userEmail')).update({
          'status':'onine'
        });
      }
    });
  }

  //đăng xuất
  void signOut(BuildContext context) {
    AppQuery.Instance().setStatus('offline');

    _googleSignIn.signOut();

    setCurrentUser('unknown user', 'unknown email', '');

    print('line 74 LoginSModel signOut : user signed out');

    Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text('Logout Successfull'),
          backgroundColor: Theme.of(context).primaryColor,
        )
    );
  }

  //ghi thông tin người dùng vào bộ nhớ đệm
  void setCurrentUser(String userDislayName,String userEmail, String userAvatarUrl) {

      user.username = userDislayName;
      user.email = userEmail;
      user.avatar = userAvatarUrl;

      print('line 94 setCurrentUser email: ' + userEmail);

      prefs.setString('userDisplayName',userDislayName);
      prefs.setString('userEmail',userEmail);
      prefs.setString('userAvatarUrl',userAvatarUrl);

      refUser = refUser.parent().child(user.email);

      notifyListeners();
  }

}
