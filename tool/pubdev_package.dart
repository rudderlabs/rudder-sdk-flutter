import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  final options = _parseArguments(arguments);
  final configuration = jsonDecode(
    await File('.github/pubdev-trusted-publishers.json').readAsString(),
  ) as Map<String, dynamic>;
  if (configuration['schemaVersion'] != 1 ||
      configuration['repository'] != 'rudderlabs/rudder-sdk-flutter' ||
      configuration['pushEvents'] != true ||
      configuration['workflowDispatchEvents'] != true) {
    throw StateError('Invalid trusted publisher configuration header.');
  }
  final configuredPackages =
      (configuration['packages'] as List<dynamic>).cast<Map<String, dynamic>>();

  final packages = <String, _Package>{};
  for (final entry in configuredPackages) {
    final package = await _readPackage(entry);
    if (packages.containsKey(package.name)) {
      throw StateError('Duplicate package configuration: ${package.name}');
    }
    packages[package.name] = package;
  }

  await _validatePackageCoverage(packages.values);

  if (options.validateOnly) {
    stdout.writeln('Validated ${packages.length} trusted publisher mappings.');
    return;
  }

  final matches =
      packages.values.where((package) => package.tag == options.tag!).toList();
  if (matches.length != 1) {
    throw StateError(
      'Tag ${options.tag} must match exactly one configured package version.',
    );
  }

  final package = matches.single;
  final dependencies = package.dependencyNames
      .where(packages.containsKey)
      .map((name) => packages[name]!)
      .map((dependency) => {
            'name': dependency.name,
            'version': dependency.version,
          })
      .toList()
    ..sort((left, right) => left['name']!.compareTo(right['name']!));

  final metadata = {
    'name': package.name,
    'version': package.version,
    'path': package.path,
    'tag': package.tag,
    'dependencies': dependencies,
  };
  final output = const JsonEncoder.withIndent('  ').convert(metadata);

  if (options.outputPath == null) {
    stdout.writeln(output);
    return;
  }

  final outputFile = File(options.outputPath!);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString('$output\n');
  stdout.writeln('Wrote package metadata to ${outputFile.path}');
}

_Options _parseArguments(List<String> arguments) {
  String? tag;
  String? outputPath;
  var validateOnly = false;

  for (var index = 0; index < arguments.length; index++) {
    switch (arguments[index]) {
      case '--tag':
        tag = _nextArgument(arguments, ++index, '--tag');
      case '--output':
        outputPath = _nextArgument(arguments, ++index, '--output');
      case '--validate-only':
        validateOnly = true;
      default:
        throw ArgumentError('Unknown argument: ${arguments[index]}');
    }
  }

  if (tag == null && !validateOnly) {
    throw ArgumentError('Use --tag <package-name-vversion>.');
  }
  if (tag != null && validateOnly) {
    throw ArgumentError('Use either --tag or --validate-only.');
  }
  return _Options(
    tag: tag,
    outputPath: outputPath,
    validateOnly: validateOnly,
  );
}

String _nextArgument(List<String> arguments, int index, String option) {
  if (index >= arguments.length) {
    throw ArgumentError('$option requires a value.');
  }
  return arguments[index];
}

Future<_Package> _readPackage(Map<String, dynamic> entry) async {
  final configuredName = entry['name'] as String;
  final path = entry['path'] as String;
  final tagPattern = entry['tagPattern'] as String;
  final pubspec = File('$path/pubspec.yaml');
  if (!await pubspec.exists()) {
    throw StateError('Missing ${pubspec.path}.');
  }

  final contents = await pubspec.readAsString();
  final name = _requiredValue(contents, 'name', pubspec.path);
  final version = _requiredValue(contents, 'version', pubspec.path);
  if (name != configuredName) {
    throw StateError(
        '$path is configured as $configuredName but contains $name.');
  }

  final expectedPattern = '$name-v{{version}}';
  if (tagPattern != expectedPattern) {
    throw StateError('$name must use $expectedPattern, but uses $tagPattern.');
  }

  return _Package(
    name: name,
    version: version,
    path: path,
    tag: tagPattern.replaceAll('{{version}}', version),
    dependencyNames: _readDependencyNames(contents),
  );
}

Future<void> _validatePackageCoverage(Iterable<_Package> packages) async {
  final configuredPaths = packages.map((package) => package.path).toSet();
  final discoveredPaths = <String>{};

  await for (final entity in Directory('packages').list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('/pubspec.yaml')) {
      continue;
    }
    final contents = await entity.readAsString();
    if (_isPrivate(contents)) {
      continue;
    }
    discoveredPaths.add(entity.parent.path);
  }

  final missing = discoveredPaths.difference(configuredPaths).toList()..sort();
  final stale = configuredPaths.difference(discoveredPaths).toList()..sort();
  if (missing.isNotEmpty || stale.isNotEmpty) {
    throw StateError(
      'Trusted publisher configuration mismatch. '
      'Missing: ${missing.join(', ')}. Stale: ${stale.join(', ')}.',
    );
  }
}

String _requiredValue(String contents, String key, String path) {
  final match = RegExp('^$key:\\s*[\\\'"]?([^\\s#\\\'"]+)', multiLine: true)
      .firstMatch(contents);
  if (match == null) {
    throw StateError('$path has no $key.');
  }
  return match.group(1)!;
}

bool _isPrivate(String contents) {
  final publishTo = RegExp(
    r'''^publish_to:\s*['"]?([^\s#'"]+)''',
    multiLine: true,
  ).firstMatch(contents);
  return publishTo?.group(1) == 'none';
}

List<String> _readDependencyNames(String contents) {
  final dependencies = <String>[];
  var inDependencies = false;

  for (final line in const LineSplitter().convert(contents)) {
    final topLevel = RegExp(r'^([a-zA-Z0-9_]+):').firstMatch(line);
    if (topLevel != null) {
      inDependencies = topLevel.group(1) == 'dependencies';
      continue;
    }
    if (!inDependencies) {
      continue;
    }

    final dependency = RegExp(r'^  ([a-zA-Z0-9_]+):').firstMatch(line);
    final name = dependency?.group(1);
    if (name != null) {
      dependencies.add(name);
    }
  }
  return dependencies;
}

class _Options {
  const _Options({
    required this.tag,
    required this.outputPath,
    required this.validateOnly,
  });

  final String? tag;
  final String? outputPath;
  final bool validateOnly;
}

class _Package {
  const _Package({
    required this.name,
    required this.version,
    required this.path,
    required this.tag,
    required this.dependencyNames,
  });

  final String name;
  final String version;
  final String path;
  final String tag;
  final List<String> dependencyNames;
}
