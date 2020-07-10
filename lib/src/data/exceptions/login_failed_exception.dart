class LoginFailedException implements Exception {
  final _message;
  LoginFailedException(this._message);

  get message => _message;
}