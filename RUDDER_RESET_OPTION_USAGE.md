# RudderResetOption Usage Examples

The `RudderResetOption` class provides flexible control over what gets reset when calling the `reset()` method in Rudder SDK Flutter.

## Migration from Deprecated API

### Before (Deprecated - will be removed in v4.0.0)
```dart
// Legacyy
rudderClient.reset();
// Legacy usage - only supports clearing anonymous ID
rudderClient.reset(clearAnonymousId: true);
```

### After (Recommended)
```dart
// New usage with comprehensive reset options
rudderClient.reset(options: RudderResetOption(clearAnonymousId: true, resetDeviceState: false, resetIntegrationState: false));
```

## Constructor Usage Examples

### Basic Reset (equivalent to legacy clearAnonymousId)
```dart
// Clears only the anonymous ID, preserves device and integration state
rudderClient.reset(options: RudderResetOption(
  clearAnonymousId: true,
  resetDeviceState: false,
  resetIntegrationState: false,
));

// Custom anonymous ID behavior
rudderClient.reset(options: RudderResetOption(
  clearAnonymousId: false,
  resetDeviceState: false,
  resetIntegrationState: false,
));
```

### Session Reset
```dart
// Clears device and integration state but preserves anonymous ID
rudderClient.reset(options: RudderResetOption(
  clearAnonymousId: false,
  resetDeviceState: true,
  resetIntegrationState: true,
));
```

## Custom Configuration

```dart
// Fine-grained control over reset behavior
rudderClient.reset(
  options: RudderResetOption(
    clearAnonymousId: true,        // Generate new anonymous ID
    resetDeviceState: false,       // Keep user traits and external IDs
    resetIntegrationState: true,   // Clear integration-specific data
  ),
);
```

## Use Cases

### Session Boundary
```dart
// Reset session data while maintaining user identity
void startNewSession() {
  rudderClient.reset(options: RudderResetOption(
    clearAnonymousId: false,
    resetDeviceState: true,
    resetIntegrationState: true,
  ));
}
```

### Privacy Compliance
```dart
// Clear anonymous tracking while preserving app-level settings
void clearTrackingData() {
  rudderClient.reset(
    options: RudderResetOption(
      clearAnonymousId: true,
      resetDeviceState: true,
      resetIntegrationState: false, // Keep integration configs
    ),
  );
}
```

## Backward Compatibility

The SDK maintains full backward compatibility. Existing code using the deprecated parameter will continue to work:

```dart
// This still works but shows deprecation warning
rudderClient.reset(clearAnonymousId: true);

// Equivalent new usage
rudderClient.reset(options: RudderResetOption(clearAnonymousId: true, resetDeviceState: false, resetIntegrationState: false));
```

## Platform-Specific Behavior

### Mobile (Android/iOS)
All reset options are supported and passed to the native SDKs.

### Web
Currently, the web platform supports the `clearAnonymousId` option. Full reset option support is planned for future releases.

## Migration Timeline

- **Current**: Both old and new APIs are supported
- **v4.0.0**: Deprecated `clearAnonymousId` parameter will be removed
- **Recommended**: Start using `RudderResetOption` in new code immediately
