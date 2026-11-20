import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _version(String path, RegExp pattern) =>
    pattern.firstMatch(File(path).readAsStringSync())!.group(1)!;

void main() {
  test('the iOS package version matches pubspec.yaml', () {
    expect(
      _version(
        'ios/rudder_sdk_flutter/Sources/rudder_sdk_flutter/PackageVersion.swift',
        RegExp(r'let packageVersion = "([^"]+)"'),
      ),
      _version('pubspec.yaml', RegExp(r'^version:\s*(\S+)', multiLine: true)),
      reason:
          'Run `dart run tools/write_ios_package_version.dart` from the repository root.',
    );
  });
}
