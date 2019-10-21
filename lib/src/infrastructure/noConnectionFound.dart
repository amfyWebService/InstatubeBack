class NoConnectionFound extends Error {
  String _reason = "No mongodb connection instance found";
  String get reason => _reason;
}