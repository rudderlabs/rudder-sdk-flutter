/// Platform interface for RudderStack Flutter SDK.
///
/// This library provides the platform-agnostic interface for the RudderStack
/// Flutter SDK, including models for configuration, event properties, user traits,
/// and options. It serves as the foundation for all platform-specific implementations
/// of the SDK.
///
/// The main components include:
/// - [RudderConfig] for SDK configuration
/// - [RudderProperty] for event properties
/// - [RudderTraits] for user traits and identify calls
/// - [RudderOption] for event-level options and integrations
/// - Various utility classes and enums for SDK functionality
///
/// This library is typically not used directly by end users, but rather through
/// the main RudderStack SDK package.
library;

export 'src/constants.dart';
export 'src/enums.dart';
export 'src/rudder_logger.dart';
export 'src/db_encryption_interface.dart';
export 'src/models/rudder_config.dart';
export 'src/models/rudder_web_config.dart';
export 'src/models/rudder_mobile_config.dart';
export 'src/models/rudder_integration.dart';
export 'src/models/rudder_option.dart';
export 'src/models/rudder_property.dart';
export 'src/models/rudder_traits.dart';
export 'src/models/web_config_interfaces/index.dart';
