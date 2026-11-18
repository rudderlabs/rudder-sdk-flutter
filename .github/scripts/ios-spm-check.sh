#!/usr/bin/env bash
# Build a fresh iOS app that depends, by local path, on the RudderStack Flutter
# plugins, with Swift Package Manager on or off.
#
# The packages come from packages/*/*/pubspec.yaml. DISCONTINUED plugins are
# never built. With SPM on, the plugins in COCOAPODS_ONLY are skipped too: they
# have no Swift package and stay CocoaPods-only.
#
# usage: ios-spm-check.sh <repo-root> <on|off> <work-dir>
set -uo pipefail

usage() {
  echo "usage: $0 <repo-root> <on|off> <work-dir>" >&2
  exit 2
}

[ "$#" -eq 3 ] || usage
SPM=$2
case "$SPM" in
  on | off) ;;
  *) usage ;;
esac
ROOT=$(cd "$1" && pwd) || usage
mkdir -p "$3" || usage
WORK=$(cd "$3" && pwd) || usage

DISCONTINUED="rudder_integration_appcenter_flutter rudder_integration_kochava_flutter rudder_integration_leanplum_flutter"
COCOAPODS_ONLY="rudder_plugin_db_encryption"
APP="$WORK/app-spm-$SPM"
CREATE_LOG="$WORK/create-spm-$SPM.log"
PUB_LOG="$WORK/pub-get-spm-$SPM.log"
BUILD_LOG="$WORK/build-spm-$SPM.log"

fail() {
  echo "RESULT spm=$SPM: FAIL ($1)"
  if [ -n "${2:-}" ] && [ -f "$2" ]; then
    echo "--- last 40 lines of $(basename "$2"):"
    tail -40 "$2"
  fi
  exit 1
}

rm -rf "$APP"
flutter create --platforms=ios --project-name rudder_spm_check "$APP" >"$CREATE_LOG" 2>&1 ||
  fail "flutter create" "$CREATE_LOG"
cd "$APP" || fail "cd $APP"

# The flutter create template targets an older iOS; the plugins need iOS 15.
PBXPROJ=ios/Runner.xcodeproj/project.pbxproj
sed -i.bak 's/IPHONEOS_DEPLOYMENT_TARGET = [0-9.]*;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/' "$PBXPROJ" && rm -f "$PBXPROJ.bak"
if grep 'IPHONEOS_DEPLOYMENT_TARGET' "$PBXPROJ" | grep -qv '= 15.0;'; then
  fail "deployment target"
fi

python3 - "$ROOT" "$SPM" "$DISCONTINUED" "$COCOAPODS_ONLY" <<'PY' || fail "pubspec setup"
import re
import sys
from pathlib import Path

root, spm = Path(sys.argv[1]), sys.argv[2]
discontinued, cocoapods_only = set(sys.argv[3].split()), set(sys.argv[4].split())

packages = {}
for manifest in sorted((root / "packages").glob("*/*/pubspec.yaml")):
    match = re.search(r"^name:\s*([a-zA-Z0-9_]+)", manifest.read_text(), re.MULTILINE)
    if not match:
        sys.exit(f"Missing package name: {manifest}")
    packages[match[1]] = manifest.parent
if "rudder_sdk_flutter" not in packages:
    sys.exit("rudder_sdk_flutter not found under packages/")

# Direct dependencies: the core, plus every plugin that has its own iOS code.
# rudder_plugin_ios comes in through rudder_sdk_flutter.
native = sorted(
    name for name, path in packages.items()
    if any((path / "ios").glob("*.podspec")) and name != "rudder_plugin_ios"
)
excluded = sorted(n for n in native if n in discontinued)
skipped = sorted(n for n in native if spm == "on" and n in cocoapods_only)
deps = ["rudder_sdk_flutter"] + [n for n in native if n not in excluded and n not in skipped]
print("Plugins: " + ", ".join(deps))
if excluded:
    print("Excluded (discontinued): " + ", ".join(excluded))
if skipped:
    print("Skipped with SPM on (CocoaPods-only): " + ", ".join(skipped))

def entries(names):
    return "".join(f"  {n}:\n    path: {packages[n]}\n" for n in names)

pubspec = open("pubspec.yaml").read()
anchor = "dependencies:\n  flutter:\n    sdk: flutter\n"
if anchor not in pubspec:
    sys.exit("Unexpected pubspec.yaml template: dependencies block")
pubspec = pubspec.replace(anchor, anchor + entries(deps), 1)
setting = "enable-swift-package-manager: %s" % ("true" if spm == "on" else "false")
pubspec = pubspec.replace("\nflutter:\n", "\nflutter:\n  config:\n    %s\n" % setting, 1)
if setting not in pubspec:
    sys.exit("Unexpected pubspec.yaml template: flutter block")
pubspec += "\ndependency_overrides:\n" + entries(sorted(packages))
open("pubspec.yaml", "w").write(pubspec)
PY

flutter pub get >"$PUB_LOG" 2>&1 || fail "pub get" "$PUB_LOG"

if flutter build ios --simulator --no-codesign --debug >"$BUILD_LOG" 2>&1; then
  echo "RESULT spm=$SPM: PASS"
  exit 0
fi
fail "build" "$BUILD_LOG"
