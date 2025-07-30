# RudderStack DB Encryption Plugin Example

This example demonstrates how to use the `rudder_plugin_db_encryption` plugin with the RudderStack Flutter SDK.

## Usage

The DB Encryption plugin allows you to encrypt the local database used by RudderStack SDK to store events before they are sent to analytics destinations.

### Basic Implementation

```dart
import 'package:rudder_plugin_db_encryption/rudder_plugin_db_encryption.dart';
import 'package:rudder_sdk_flutter/RudderController.dart';

// Create DB Encryption configuration
final dbEncryption = RudderDBEncryption(true, 'your-encryption-key');

// Add to mobile configuration
final mobileConfig = MobileConfig(
  dbEncryption: dbEncryption,
  // ... other configuration options
);

// Initialize RudderStack SDK with encryption
final rudderClient = RudderController.instance;
rudderClient.initialize(
  'YOUR_WRITE_KEY',
  config: RudderConfigBuilder()
    .withMobileConfig(mobileConfig)
    .withDataPlaneUrl('YOUR_DATA_PLANE_URL')
    .build()
);
```

### Important Notes

1. **Web Platform**: Database encryption is only available for mobile platforms (iOS and Android). The web platform doesn't support local database encryption.

2. **Encryption Key**: Store your encryption key securely. If the key is lost, the encrypted data cannot be recovered.

3. **Performance**: Enabling encryption may have a slight impact on performance due to the encryption/decryption overhead.

### Example Code Location

See the complete implementation in `lib/home_screen.dart` lines 59-66, which shows:
- Checking if the platform is web (encryption is skipped for web)
- Creating the `RudderDBEncryption` instance
- Adding it to the `MobileConfig`
- Initializing the SDK with encryption enabled

### Running the Example

1. Add your RudderStack Write Key and Data Plane URL to the `.env` file
2. Run `flutter pub get`
3. Run the example app: `flutter run`

The app will initialize RudderStack SDK with database encryption enabled on mobile platforms.