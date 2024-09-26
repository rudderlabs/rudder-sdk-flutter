class SessionOpts {
  final bool? autoTrack;
  final int? timeout;

  SessionOpts({this.autoTrack, this.timeout});

  // Method to convert the SessionOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'autoTrack': autoTrack,
      'timeout': timeout,
    };
  }
}
