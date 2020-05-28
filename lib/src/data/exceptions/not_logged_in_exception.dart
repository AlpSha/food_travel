class NotLoggedInException implements Exception {
  final _message;

  NotLoggedInException(this._message);

  get message => _message;
}