#!/usr/bin/env bash
# Build a fresh iOS app that depends, by local path, on the RudderStack Flutter
# core and the active integrations, with Swift Package Manager on or off.
#
# usage: ios-spm-check.sh <repo-root> <on|off> <work-dir>
set -uo pipefail

ROOT=$1
SPM=$2
WORK=$3
APP="$WORK/app-spm-$SPM"
LOG="$WORK/build-spm-$SPM.log"

case "$SPM" in
  on | off) ;;
  *) echo "usage: $0 <repo-root> <on|off> <work-dir>" >&2; exit 2 ;;
esac

mkdir -p "$WORK"
rm -rf "$APP"
if ! flutter create --platforms=ios --project-name rudder_spm_check "$APP" >/dev/null; then
  echo "RESULT spm=$SPM: FAIL (flutter create)"
  exit 1
fi
cd "$APP" || exit 1

python3 - "$ROOT" "$SPM" <<'PY' || { echo "RESULT spm=$SPM: FAIL (pubspec setup)"; exit 1; }
import sys

root, spm = sys.argv[1], sys.argv[2]
packages = root + "/packages"
deps = {
    "rudder_sdk_flutter": "plugins/rudder_plugin",
    "rudder_integration_adjust_flutter": "integrations/rudder_integration_adjust_flutter",
    "rudder_integration_amplitude_flutter": "integrations/rudder_integration_amplitude_flutter",
    "rudder_integration_appsflyer_flutter": "integrations/rudder_integration_appsflyer_flutter",
    "rudder_integration_braze_flutter": "integrations/rudder_integration_braze_flutter",
    "rudder_integration_firebase_flutter": "integrations/rudder_integration_firebase_flutter",
}
overrides = dict(deps)
overrides.update({
    "rudder_sdk_flutter_platform_interface": "plugins/rudder_plugin_interface",
    "rudder_plugin_android": "plugins/rudder_plugin_android",
    "rudder_plugin_ios": "plugins/rudder_plugin_ios",
    "rudder_plugin_web": "plugins/rudder_plugin_web",
})

def path_entries(entries):
    return "".join(f"  {name}:\n    path: {packages}/{rel}\n" for name, rel in entries.items())

pubspec = open("pubspec.yaml").read()
anchor = "dependencies:\n  flutter:\n    sdk: flutter\n"
assert anchor in pubspec, "unexpected pubspec.yaml template"
pubspec = pubspec.replace(anchor, anchor + path_entries(deps), 1)
pubspec = pubspec.replace(
    "\nflutter:\n",
    "\nflutter:\n  config:\n    enable-swift-package-manager: %s\n" % ("true" if spm == "on" else "false"),
    1,
)
pubspec += "\ndependency_overrides:\n" + path_entries(overrides)
open("pubspec.yaml", "w").write(pubspec)
PY

if ! flutter pub get >/dev/null 2>&1; then
  echo "RESULT spm=$SPM: FAIL (pub get)"
  flutter pub get 2>&1 | tail -5
  exit 1
fi

if flutter build ios --simulator --no-codesign --debug >"$LOG" 2>&1; then
  echo "RESULT spm=$SPM: PASS"
  exit 0
fi

echo "RESULT spm=$SPM: FAIL (build). Key lines:"
grep -E "Unable to find a specification|depended upon by|error:|\(Xcode\):|\[!\] (Unable|CocoaPods could not|Error)" "$LOG" | sort -u | head -8
exit 1
