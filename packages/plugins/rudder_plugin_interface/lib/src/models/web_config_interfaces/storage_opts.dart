// Define the StorageType enum
enum StorageType {
  cookieStorage,
  localStorage,
  memoryStorage,
  sessionStorage,
  none,
}

enum UserSessionKey {
  userId,
  userTraits,
  anonymousId,
  groupId,
  groupTraits,
  initialReferrer,
  initialReferringDomain,
  sessionInfo,
  authToken,
}

enum StorageEncryptionVersion {
  legacy,
  v3,
}

// Define the LoadOptionStorageEntry class
class LoadOptionStorageEntry {
  final StorageType type;

  LoadOptionStorageEntry({required this.type});

  // Method to convert the LoadOptionStorageEntry object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
    };
  }
}

// Define the StorageEncryption class
class StorageEncryption {
  final StorageEncryptionVersion version;

  StorageEncryption({required this.version});

  // Method to convert the StorageEncryption object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'version': version.toString().split('.').last,
    };
  }
}

class CookieOptions {
  final int? maxage;
  final DateTime? expires;
  final String? path;
  final String? domain;
  final String? samesite;
  final bool? secure;

  CookieOptions({
    this.maxage,
    this.expires,
    this.path,
    this.domain,
    this.samesite,
    this.secure,
  });

  // Method to convert the CookieOptions object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'maxage': maxage,
      'expires': expires?.toIso8601String(),
      'path': path,
      'domain': domain,
      'samesite': samesite,
      'secure': secure,
    };
  }
}

// Define the StorageOpts class
class StorageOpts {
  final StorageEncryption? encryption;
  final bool? migrate;
  final StorageType? type;
  final CookieOptions? cookie;
  final Map<UserSessionKey, LoadOptionStorageEntry>? entries;

  StorageOpts({
    this.encryption,
    this.migrate,
    this.type,
    this.cookie,
    this.entries,
  });

  // Method to convert the StorageOpts object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'encryption': encryption?.toMap(),
      'migrate': migrate,
      'type': type?.toString().split('.').last, // Convert enum to string
      'cookie': cookie?.toMap(),
      'entries': entries?.map((key, value) =>
          MapEntry(key.toString().split('.').last, value.toMap())),
    };
  }
}
