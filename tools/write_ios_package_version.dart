import 'dart:io';

// `melos version` runs this from the repository root, after it bumps pubspec.yaml and before it commits.
const _package = 'packages/plugins/rudder_sdk_flutter';
const _output =
    '$_package/ios/rudder_sdk_flutter/Sources/rudder_sdk_flutter/PackageVersion.swift';

Future<void> main() async {
  final pubspec = File('$_package/pubspec.yaml').readAsStringSync();
  final version = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);
  if (version == null) {
    stderr.writeln('$_package/pubspec.yaml has no version');
    exitCode = 1;
    return;
  }

  File(_output).writeAsStringSync(
    '// Written by tools/write_ios_package_version.dart from pubspec.yaml. Do not edit by hand.\n'
    'let packageVersion = "$version"\n',
  );
  final result = await Process.run('git', ['add', _output]);
  stderr.write(result.stderr);
  exitCode = result.exitCode;
}
