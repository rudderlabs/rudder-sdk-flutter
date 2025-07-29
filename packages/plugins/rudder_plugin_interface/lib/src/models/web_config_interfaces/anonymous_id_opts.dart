class AutoCapture {
  final bool? enabled;
  final String? source;

  AutoCapture({
    this.enabled,
    this.source,
  });

  // Method to convert AutoCapture object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'source': source,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class AnonymousIdOptions {
  final AutoCapture? autoCapture;

  AnonymousIdOptions({this.autoCapture});

  // Method to convert AnonymousIdOptions object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'autoCapture':
          autoCapture?.toMap(), // Convert autoCapture to a map if not null
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
