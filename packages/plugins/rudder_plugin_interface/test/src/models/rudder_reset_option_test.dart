import 'package:flutter_test/flutter_test.dart';
import 'package:rudder_sdk_flutter_platform_interface/src/models/rudder_reset_option.dart';

void main() {
  group('RudderResetOption', () {
    test('should create default instance with expected values', () {
      final resetOption = RudderResetOption();
      
      expect(resetOption.clearAnonymousId, false);
      expect(resetOption.resetDeviceState, true);
      expect(resetOption.resetIntegrationState, true);
    });

    test('should create instance with custom values', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: true,
        resetDeviceState: false,
        resetIntegrationState: false,
      );
      
      expect(resetOption.clearAnonymousId, true);
      expect(resetOption.resetDeviceState, false);
      expect(resetOption.resetIntegrationState, false);
    });

    test('should create basic reset option equivalent', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: true,
        resetDeviceState: false,
        resetIntegrationState: false,
      );
      
      expect(resetOption.clearAnonymousId, true);
      expect(resetOption.resetDeviceState, false);
      expect(resetOption.resetIntegrationState, false);
    });

    test('should create basic reset option with custom clearAnonymousId', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: false,
        resetDeviceState: false,
        resetIntegrationState: false,
      );
      
      expect(resetOption.clearAnonymousId, false);
      expect(resetOption.resetDeviceState, false);
      expect(resetOption.resetIntegrationState, false);
    });

    test('should create session reset option equivalent', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: false,
        resetDeviceState: true,
        resetIntegrationState: true,
      );
      
      expect(resetOption.clearAnonymousId, false);
      expect(resetOption.resetDeviceState, true);
      expect(resetOption.resetIntegrationState, true);
    });

    test('should convert to mobile map correctly', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: true,
        resetDeviceState: false,
        resetIntegrationState: true,
      );
      
      final mobileMap = resetOption.toMobileMap();
      
      expect(mobileMap['clearAnonymousId'], true);
      expect(mobileMap['resetDeviceState'], false);
      expect(mobileMap['resetIntegrationState'], true);
    });

    test('should convert to web map correctly', () {
      final resetOption = RudderResetOption(
        clearAnonymousId: false,
        resetDeviceState: true,
        resetIntegrationState: false,
      );
      
      final webMap = resetOption.toWebMap();
      
      expect(webMap['clearAnonymousId'], false);
      expect(webMap['resetDeviceState'], true);
      expect(webMap['resetIntegrationState'], false);
    });

    test('should have correct string representation', () {
      final resetOption = RudderResetOption();
      final stringRepresentation = resetOption.toString();
      
      expect(stringRepresentation, contains('RudderResetOption'));
      expect(stringRepresentation, contains('clearAnonymousId: false'));
      expect(stringRepresentation, contains('resetDeviceState: true'));
      expect(stringRepresentation, contains('resetIntegrationState: true'));
    });

    test('should implement equality correctly', () {
      final resetOption1 = RudderResetOption();
      final resetOption2 = RudderResetOption();
      final resetOption3 = RudderResetOption(clearAnonymousId: true);
      
      expect(resetOption1, equals(resetOption2));
      expect(resetOption1, isNot(equals(resetOption3)));
    });

    test('should implement hashCode correctly', () {
      final resetOption1 = RudderResetOption();
      final resetOption2 = RudderResetOption();
      final resetOption3 = RudderResetOption(clearAnonymousId: true);
      
      expect(resetOption1.hashCode, equals(resetOption2.hashCode));
      expect(resetOption1.hashCode, isNot(equals(resetOption3.hashCode)));
    });
  });
}
