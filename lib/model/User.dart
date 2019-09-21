class User {
  String _username;
  String _avatar;
  String _email;

  String get username => _username;
  set username(String value) {
    _username = value;
  }

  String get avatar => _avatar;
  set avatar(String value) {
    _avatar = value;
  }

  String get email => _email;
  set email(String value) {
    _email = value;
  }
  User(this._username, this._avatar, this._email);
}

