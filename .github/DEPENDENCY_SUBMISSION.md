# Native dependency inventory

The workflow uses Flutter 3.41.9, JDK 17, and the example's existing AGP 8.8 / Gradle 8.10.2 / Kotlin 1.8.10 toolchain. Flutter 3.47.3 rejects this wrapper, so dependency resolution uses a compatible Flutter version without upgrading the SDK build.

The single generated consumer at `.dependency-consumers/local` uses the example's Android project. Its manifest selects every current local package and overrides transitive published selections with those sources. A guard checks all ten local Android plugins, including Kochava. Generated files are ignored; checked-in example inputs are never rewritten.

Preparation supplies the ignored wrapper launchers and JAR from the pinned Flutter SDK cache. It preserves the checked-in Gradle version and keeps wrapper checksum validation enabled.

The published example is not resolved separately. The [October 30 hosted comparison](https://github.com/rudderlabs/rudder-sdk-flutter/actions/runs/41058706925) found 571 shared Maven package/version pairs: 576 in the local-source inventory and 572 in the published inventory. The published inventory added only `com.rudderstack.android.integration:appsflyer:1.0.4`. This accepted limit avoids a second Android resolution job and dual consumer preparation. The local-source inventory does not certify older published selections or arbitrary customer applications. Revisit this choice if a concrete missed advisory or remediation requires published-version coverage. [SDK-5570](https://linear.app/rudderstack/issue/SDK-5570) tracks this boundary.

Kochava's malformed core range is corrected from `[1.21.3 2.0.0)` to `[1.21.3,2.0.0)` so the intended bounds can resolve. No SDK runtime minimum or dependency family is upgraded.

Pull requests generate read-only artifacts. Default-branch dependency changes, weekly refreshes and manual runs also resolve the local-source consumer. Only successful runs on `develop` can submit, using a separate write-permission job. Unresolved dependencies fail graph generation before submission. Kotlin metadata in the example app cannot choose among Android variants for the listed Flutter plugin projects. The check permits only those known local project-variant mismatches; each plugin project is resolved separately. Other unresolved dependencies fail the run. The pinned Gradle action is on the organization allowlist as of 2026-10-30. Hosted generation and default-branch ingestion remain separate acceptance steps.

The embedded Swift package now retains `Package.resolved`. A read-only macOS job verifies its resolution, and a Swift Dependabot entry follows the existing monthly/zero-routine policy. This covers the embedded package's external Swift selection; it does not build the iOS application or establish CocoaPods coverage. Standalone Swift SDK rollout remains separate.

After merge, verify the local-source Maven inventory and the embedded Swift lock in GitHub at the source revision. Confirm local plugin selections and direct/indirect runtime/development Maven entries. Native updater traversal through Flutter source packages remains a separate parser check; no speculative Gradle updater roots are added. Build dependencies resolved during configuration are included; external Flutter build-tool test dependencies are not separately certified.

Rollback: remove the workflow, generated-consumer script, Swift updater entry and lock tracking. Preserve the corrected Kochava separator and existing alert visibility. Previously submitted graphs can remain until superseded or removed.

Merge this PR with rebase or a merge commit to preserve the separate Kochava `fix:` commit in release notes. Do not squash it under the `ci:` title.
