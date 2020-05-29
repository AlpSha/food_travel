class InitializeFailedException implements Exception {
  final String _message;

  InitializeFailedException(this._message);

  String get message => _message;
}