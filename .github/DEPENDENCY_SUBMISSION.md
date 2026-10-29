# Native dependency inventory

The workflow uses Flutter 3.41.9, JDK 17, and the example's existing AGP 8.8 / Gradle 8.10.2 / Kotlin 1.8.10 toolchain. Flutter 3.47.3 rejects this wrapper, so dependency resolution uses a compatible Flutter version without upgrading the SDK build. It keeps two generated Android contexts:

- `.dependency-consumers/published` copies the published example's manifest, lock and Android project. Pub reconciles SDK-provided packages with Flutter 3.41.9 in that copy. Published SDK/integration constraints remain unchanged; checked-in example inputs are never rewritten.
- `.dependency-consumers/local` is generated from the example's Android consumer. Its manifest selects every current local package and overrides transitive published selections with those sources. A guard checks all ten local Android plugins, including Kochava. Generated files are ignored.

Kochava's malformed core range is corrected from `[1.21.3 2.0.0)` to `[1.21.3,2.0.0)` so the intended bounds can resolve. No SDK runtime minimum or dependency family is upgraded.

Pull requests generate read-only artifacts. Default-branch dependency changes, weekly refreshes and manual runs also resolve both contexts. Only successful runs on `develop` can submit, using a separate write-permission job. Matrix identities keep the contexts distinct. The pinned Gradle action needs organization allowlist approval.

The embedded Swift package now retains `Package.resolved`. A read-only macOS job verifies its resolution, and a Swift Dependabot entry follows the existing monthly/zero-routine policy. This covers the embedded package's external Swift selection; it does not build the iOS application or establish CocoaPods coverage. Standalone Swift SDK rollout remains separate.

After merge, verify both Maven inventories and the embedded Swift lock in GitHub at the source revision. Confirm local plugin selections and direct/indirect runtime/development Maven entries. Native updater traversal through Flutter source packages remains a separate parser check; no speculative Gradle updater roots are added. Build dependencies resolved during configuration are included; external Flutter build-tool test dependencies are not separately certified.

Rollback: remove the workflow, generated-consumer script, Swift updater entry and lock tracking. Preserve the corrected Kochava separator and existing alert visibility. Previously submitted graphs can remain until superseded or removed.
