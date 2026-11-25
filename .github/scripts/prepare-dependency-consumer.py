"""Prepare a local-source Flutter consumer for native graph generation."""

import json
import os
from pathlib import Path
import re
import shutil
import subprocess

root = Path(__file__).resolve().parents[2]
flutter = shutil.which("flutter")
if not flutter:
    raise SystemExit("Flutter must be on PATH")
sdk = os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT")
if not sdk:
    raise SystemExit("ANDROID_HOME or ANDROID_SDK_ROOT must identify the Android SDK")
flutter_root = Path(os.environ.get("FLUTTER_ROOT", Path(flutter).resolve().parents[1]))
consumer = root / ".dependency-consumers" / "local"
packages = {}

if consumer.exists():
    shutil.rmtree(consumer)
subprocess.run(
    [flutter, "create", "--platforms=android", "--project-name", "rudder_dependency_consumer", str(consumer)],
    check=True,
)
for manifest in sorted((root / "packages").glob("*/*/pubspec.yaml")):
    match = re.search(r"^name:\s*([a-zA-Z0-9_]+)", manifest.read_text(), re.MULTILINE)
    if not match:
        raise SystemExit(f"Missing package name: {manifest}")
    packages[match[1]] = manifest.parent
if not packages:
    raise SystemExit("No local Flutter packages found")
lines = [
    "name: rudder_dependency_consumer", "publish_to: none",
    "environment:", "  sdk: '>=3.0.0 <4.0.0'",
    "dependencies:", "  flutter:", "    sdk: flutter",
]
for name, path in packages.items():
    lines.extend([f"  {name}:", f"    path: {os.path.relpath(path, consumer)}"])
# Override published transitive selections with the same local source packages.
lines.append("dependency_overrides:")
for name, path in packages.items():
    lines.extend([f"  {name}:", f"    path: {os.path.relpath(path, consumer)}"])
(consumer / "pubspec.yaml").write_text("\n".join(lines) + "\n")

# Supply the wrapper launchers and the JAR from the Flutter SDK cache when the template has none.
wrapper_cache = flutter_root / "bin/cache/artifacts/gradle_wrapper"
wrapper_files = ("gradlew", "gradlew.bat", "gradle/wrapper/gradle-wrapper.jar")
if not all((wrapper_cache / name).is_file() for name in wrapper_files):
    subprocess.run([flutter, "precache", "--android"], check=True)
for name in wrapper_files:
    source = wrapper_cache / name
    target = consumer / "android" / name
    if not source.is_file():
        raise SystemExit(f"Flutter wrapper artifact is missing: {source}")
    if not target.exists():
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
(consumer / "android/gradlew").chmod(0o755)

subprocess.run([flutter, "pub", "get"], cwd=consumer, check=True)
(consumer / "android/local.properties").write_text(
    f"sdk.dir={sdk}\nflutter.sdk={flutter_root}\n"
)

plugins = json.loads((consumer / ".flutter-plugins-dependencies").read_text())
android = {p["name"]: Path(p["path"]).resolve() for p in plugins["plugins"]["android"]}
expected = {n: p for n, p in packages.items() if any((p / "android").glob("build.gradle*"))}
for name, path in expected.items():
    if android.get(name) != path.resolve():
        raise SystemExit(f"Android consumer omitted local package {name}")
if not expected:
    raise SystemExit("No local Android plugins found")
print(f"Verified {len(expected)} local Android plugins")
