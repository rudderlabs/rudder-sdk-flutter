import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  final options = _parseArguments(arguments);
  final base = await _resolveRevision(options.base);
  final head = await _resolveRevision(options.head);

  final packages = await _loadPackages(head);
  final dependencyGraph = {
    for (final package in packages) package.name: package.dependencies,
  };
  final changedPackages = <String, _ReleasePackage>{};

  for (final package in packages) {
    final pubspecPath = '${package.path}/pubspec.yaml';
    final baseVersion = await _readVersion(base, pubspecPath);

    if (package.version != baseVersion) {
      changedPackages[package.name] = _ReleasePackage(
        name: package.name,
        version: package.version,
        path: package.path,
      );
    }
  }

  final orderedPackages = _orderPackages(changedPackages, dependencyGraph);
  final manifest = <String, Object>{
    'schemaVersion': 1,
    'base': base,
    'head': head,
    'packages': orderedPackages.map((package) => package.toJson()).toList(),
  };
  final output = const JsonEncoder.withIndent('  ').convert(manifest);

  if (options.outputPath == null) {
    stdout.writeln(output);
    return;
  }

  final outputFile = File(options.outputPath!);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString('$output\n');
  stdout.writeln(
      'Wrote ${orderedPackages.length} packages to ${outputFile.path}');
}

_Options _parseArguments(List<String> arguments) {
  String? base;
  String head = 'HEAD';
  String? outputPath;

  for (var index = 0; index < arguments.length; index++) {
    switch (arguments[index]) {
      case '--base':
        base = _nextArgument(arguments, ++index, '--base');
      case '--head':
        head = _nextArgument(arguments, ++index, '--head');
      case '--output':
        outputPath = _nextArgument(arguments, ++index, '--output');
      default:
        throw ArgumentError('Unknown argument: ${arguments[index]}');
    }
  }

  if (base == null) {
    throw ArgumentError('Use --base <git-revision>.');
  }

  return _Options(base: base, head: head, outputPath: outputPath);
}

String _nextArgument(List<String> arguments, int index, String option) {
  if (index >= arguments.length) {
    throw ArgumentError('$option requires a value.');
  }
  return arguments[index];
}

Future<List<_WorkspacePackage>> _loadPackages(String revision) async {
  final paths = (await _run(
    'git',
    ['ls-tree', '-r', '--name-only', revision, '--', 'packages'],
  ))
      .split('\n')
      .where((path) => path.endsWith('/pubspec.yaml'))
      .toList()
    ..sort();

  final pubspecs = <String, String>{};
  final packageNames = <String, String>{};
  final versions = <String, String>{};

  for (final pubspecPath in paths) {
    final contents = await _readFile(revision, pubspecPath);
    if (contents == null || _isPrivate(contents)) {
      continue;
    }

    final name = _requiredValue(contents, 'name', pubspecPath);
    final version = _requiredValue(contents, 'version', pubspecPath);
    final path = pubspecPath.substring(0, pubspecPath.length - 13);
    pubspecs[path] = contents;
    packageNames[path] = name;
    versions[path] = version;
  }

  final localPackageNames = packageNames.values.toSet();
  return pubspecs.entries.map((entry) {
    final name = packageNames[entry.key]!;
    return _WorkspacePackage(
      name: name,
      version: versions[entry.key]!,
      path: entry.key,
      dependencies: _readDependencies(entry.value, localPackageNames),
    );
  }).toList();
}

Future<String?> _readVersion(String revision, String pubspecPath) async {
  final contents = await _readFile(revision, pubspecPath);
  if (contents == null) {
    return null;
  }
  return _requiredValue(contents, 'version', pubspecPath);
}

Future<String?> _readFile(String revision, String path) async {
  final result = await Process.run(
    'git',
    ['show', '$revision:$path'],
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );

  if (result.exitCode != 0) {
    return null;
  }
  return result.stdout as String;
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

List<String> _readDependencies(
  String contents,
  Set<String> localPackageNames,
) {
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
    if (name != null && localPackageNames.contains(name)) {
      dependencies.add(name);
    }
  }

  dependencies.sort();
  return dependencies;
}

List<_ReleasePackage> _orderPackages(
  Map<String, _ReleasePackage> packages,
  Map<String, List<String>> dependencyGraph,
) {
  final ordered = <_ReleasePackage>[];
  final visiting = <String>{};
  final visited = <String>{};

  void visit(String name) {
    if (visited.contains(name)) {
      return;
    }
    if (!visiting.add(name)) {
      throw StateError('Dependency cycle includes $name.');
    }

    final dependencies = [...?dependencyGraph[name]]..sort();
    for (final dependency in dependencies) {
      if (packages.containsKey(dependency)) {
        visit(dependency);
      }
    }

    visiting.remove(name);
    visited.add(name);
    ordered.add(packages[name]!);
  }

  final names = packages.keys.toList()..sort();
  for (final name in names) {
    visit(name);
  }
  return ordered;
}

Future<String> _resolveRevision(String revision) async {
  return (await _run('git', ['rev-parse', '$revision^{commit}'])).trim();
}

Future<String> _run(String executable, List<String> arguments) async {
  final result = await Process.run(
    executable,
    arguments,
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );
  if (result.exitCode != 0) {
    throw ProcessException(
      executable,
      arguments,
      result.stderr as String,
      result.exitCode,
    );
  }
  return result.stdout as String;
}

class _Options {
  const _Options({
    required this.base,
    required this.head,
    required this.outputPath,
  });

  final String base;
  final String head;
  final String? outputPath;
}

class _WorkspacePackage {
  const _WorkspacePackage({
    required this.name,
    required this.version,
    required this.path,
    required this.dependencies,
  });

  final String name;
  final String version;
  final String path;
  final List<String> dependencies;
}

class _ReleasePackage {
  const _ReleasePackage({
    required this.name,
    required this.version,
    required this.path,
  });

  final String name;
  final String version;
  final String path;

  Map<String, String> toJson() => {
        'name': name,
        'version': version,
        'path': path,
        'tag': '$name-v$version',
      };
}
