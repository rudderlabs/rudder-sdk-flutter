import 'dart:io';

// Execute dart run tool/setup_git_hooks.dart to setup pre-commit hook
Future<void> main() async {
  final preCommitHook = File('.git/hooks/pre-commit');
  await preCommitHook.parent.create(recursive: true);
  await preCommitHook.writeAsString(
    '''
#!/bin/sh
exec dart pub run dart_pre_commit # specify custom options here
''',
  );

  if (!Platform.isWindows) {
    final result = await Process.run('chmod', ['a+x', preCommitHook.path]);
    stdout.write(result.stdout);
    stderr.write(result.stderr);
    exitCode = result.exitCode;
  }
}
