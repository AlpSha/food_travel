class ListUpdateFailedException implements Exception {
  final String _message;

  ListUpdateFailedException(this._message);

  String get message => _message;
}