#!/usr/bin/env bash
# Builds a new app that uses, by local path, every RudderStack package with native code for one platform.
# usage: native-build-check.sh <repo-root> <android|ios> <work-dir>
set -uo pipefail

usage() {
  echo "usage: $0 <repo-root> <android|ios> <work-dir>" >&2
  exit 2
}

[ "$#" -eq 3 ] || usage
PLATFORM=$2
case "$PLATFORM" in
  android | ios) ;;
  *) usage ;;
esac
ROOT=$(cd "$1" && pwd) || usage
mkdir -p "$3" || usage
WORK=$(cd "$3" && pwd) || usage

# The encryption plugin still needs the 3.x core.
SKIPPED="rudder_plugin_db_encryption"
APP="$WORK/app-$PLATFORM"
CREATE_LOG="$WORK/create-$PLATFORM.log"
PUB_LOG="$WORK/pub-get-$PLATFORM.log"
BUILD_LOG="$WORK/build-$PLATFORM.log"

fail() {
  echo "RESULT $PLATFORM: FAIL ($1)"
  if [ -n "${2:-}" ] && [ -f "$2" ]; then
    echo "--- last 40 lines of $(basename "$2"):"
    tail -40 "$2"
  fi
  exit 1
}

rm -rf "$APP"
flutter create --platforms="$PLATFORM" --project-name rudder_native_check "$APP" >"$CREATE_LOG" 2>&1 ||
  fail "flutter create" "$CREATE_LOG"
cd "$APP" || fail "cd $APP"

if [ "$PLATFORM" = ios ]; then
  PBXPROJ=ios/Runner.xcodeproj/project.pbxproj
  sed -i.bak 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/' "$PBXPROJ" && rm -f "$PBXPROJ.bak"
  if grep 'IPHONEOS_DEPLOYMENT_TARGET' "$PBXPROJ" | grep -qv '= 15.0;'; then
    fail "deployment target"
  fi
fi

python3 - "$ROOT" "$PLATFORM" "$SKIPPED" <<'PY' || fail "pubspec setup"
import re
import sys
from pathlib import Path

root, platform, skipped = Path(sys.argv[1]), sys.argv[2], set(sys.argv[3].split())

packages = {}
for manifest in sorted((root / "packages").glob("*/*/pubspec.yaml")):
    match = re.search(r"^name:\s*([a-zA-Z0-9_]+)", manifest.read_text(), re.MULTILINE)
    if not match:
        sys.exit(f"Missing package name: {manifest}")
    if match[1] not in skipped:
        packages[match[1]] = manifest.parent

native_code = {"android": "android/build.gradle*", "ios": "ios/*/Package.swift"}[platform]
deps = sorted(name for name, path in packages.items() if any(path.glob(native_code)))
if "rudder_sdk_flutter" not in deps:
    sys.exit(f"rudder_sdk_flutter with {platform} code not found under packages/")
print("Packages: " + ", ".join(deps))
print("Skipped: " + ", ".join(sorted(skipped)))

def entries(names):
    return "".join(f"  {n}:\n    path: {packages[n]}\n" for n in names)

pubspec = open("pubspec.yaml").read()
anchor = "dependencies:\n  flutter:\n    sdk: flutter\n"
if anchor not in pubspec:
    sys.exit("Unexpected pubspec.yaml template: dependencies block")
pubspec = pubspec.replace(anchor, anchor + entries(deps), 1)
setting = "enable-swift-package-manager: true"
pubspec = pubspec.replace("\nflutter:\n", "\nflutter:\n  config:\n    %s\n" % setting, 1)
if setting not in pubspec:
    sys.exit("Unexpected pubspec.yaml template: flutter block")
pubspec += "\ndependency_overrides:\n" + entries(sorted(packages))
open("pubspec.yaml", "w").write(pubspec)

if platform == "android":
    # The app uses the highest minSdk that a package declares, as each package README tells it to.
    min_sdks = [int(m) for n in deps for f in (packages[n] / "android").glob("build.gradle*")
                for m in re.findall(r"^\s*minSdk\s*=\s*(\d+)", f.read_text(), re.MULTILINE)]
    if not min_sdks:
        sys.exit("No minSdk found in the package build files")
    gradle = Path("android/app/build.gradle.kts")
    text = gradle.read_text()
    if "minSdk = flutter.minSdkVersion" not in text:
        sys.exit("Unexpected android/app/build.gradle.kts template: minSdk")
    gradle.write_text(text.replace("minSdk = flutter.minSdkVersion", f"minSdk = {max(min_sdks)}", 1))
    print(f"minSdk: {max(min_sdks)}")
PY

flutter pub get >"$PUB_LOG" 2>&1 || fail "pub get" "$PUB_LOG"

if [ "$PLATFORM" = android ]; then
  # A release build also runs R8 with the keep rules of each package.
  build=(flutter build apk --release)
else
  build=(flutter build ios --simulator --no-codesign --debug)
fi
if "${build[@]}" >"$BUILD_LOG" 2>&1; then
  echo "RESULT $PLATFORM: PASS"
  exit 0
fi
fail "build" "$BUILD_LOG"
