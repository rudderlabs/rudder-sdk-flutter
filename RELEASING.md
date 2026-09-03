# Release the Flutter SDK

This repository uses Melos and GitHub Actions.

## Release controls

Get approval before these actions:

- Start the **Draft new release** workflow.
- Merge the release pull request into `main`.
- Publish a package manually.
- Merge the back-merge pull request into `develop`.
- Change the release ticket status or send a manual Slack message.

Use a merge commit for both release pull requests. Do not use squash or rebase.

## Required access

Confirm these GitHub settings:

- GitHub App client ID in the `RELEASE_APP_ID` repository variable
- `RELEASE_PRIVATE_KEY` repository or organization secret
- `SLACK_BOT_TOKEN` repository or organization secret
- `SLACK_RELEASE_CHANNEL_ID` repository or organization secret

Confirm that each public package has a pub.dev trusted publisher.

The expected package settings are in
[`.github/pubdev-trusted-publishers.json`](.github/pubdev-trusted-publishers.json).

See the [pub.dev trusted-publishing guide](https://dart.dev/tools/pub/automated-publishing) for the pub.dev setup.

## Prepare a release

1. Merge all required changes into `develop`.
2. Confirm that all required checks pass.
3. Confirm that each customer change uses a versionable Conventional Commit type.
4. Use `feat:` for a minor version increase.
5. Use `fix:` for a patch version increase.
6. Do not use `chore:` for a customer change.
7. Confirm that each required native Android or iOS version is public.
8. Create the Linear release ticket.
9. Create or select the Slack message for the release thread.

Melos uses these versionable types: `feat`, `fix`, `bug`, `perf`, `refactor`, `revert`, and `docs`.

Check the commits for each package that must ship:

```bash
git fetch origin develop --tags
git log PACKAGE_TAG..origin/develop --pretty=format:'%s' -- PACKAGE_PATH
```

Replace `PACKAGE_TAG` with the last package tag. Replace `PACKAGE_PATH` with the package directory.

Stop if a required package has no versionable commit.

## Create the release pull request

The [Draft new release workflow](.github/workflows/draft-new-release.yml) creates the release pull request.

1. Open **Draft new release** in GitHub Actions.
2. Select `develop`.
3. Enter the Linear release ticket ID.
4. Enter the Slack message URL.
5. Get approval to start the workflow.
6. Start the workflow.
7. Wait for the `release/X.Y.Z` pull request into `main`.
8. Record the generated package versions in the Linear release ticket.
9. Confirm that the workflow posted the pull request in the selected Slack thread.

For a hotfix, select the approved `hotfix/NAME` branch instead of `develop`.

## Review the release pull request

1. Review every version change.
2. Review every changelog change.
3. Review the **Release packages** table in the workflow summary.
4. Confirm that all required checks pass.
5. Confirm that the `melos publish --dry-run` check passes.
6. Confirm that the package list matches the Linear release ticket.
7. Get approval to merge the release pull request.
8. Merge the pull request with a merge commit.

Do not merge when a package, version, or changelog entry is unexpected.

## Publish the release

The merge starts the
[Publish new github release workflow](.github/workflows/publish-new-release.yml).

The workflow does these actions:

1. It creates the monorepo GitHub tag and release.
2. It creates one tag for each changed public package.
3. Each package tag starts the [Deploy to pub.dev workflow](.github/workflows/deploy-pubdev.yml).
4. Each package workflow runs `flutter pub publish --dry-run`.
5. Each package workflow publishes with pub.dev OpenID Connect (OIDC).
6. Each package workflow verifies the version on pub.dev.
7. The release workflow waits until every package version is available on pub.dev.
8. The release workflow creates the `main` to `develop` pull request.
9. The release workflow posts one release message in the Slack channel.
10. The release workflow posts the result in the selected Slack thread.

OIDC gives GitHub Actions a short-lived identity. The repository does not store a pub.dev credential.

## Package publication order

The release manifest puts dependencies before dependents.

The required dependency order is:

1. `rudder_sdk_flutter_platform_interface` comes before its dependents.
2. `rudder_plugin_android`, `rudder_plugin_ios`, and `rudder_plugin_web` come before `rudder_sdk_flutter`.
3. `rudder_sdk_flutter` comes before database encryption and integration packages.

Integration packages are Adjust, Amplitude, App Center, AppsFlyer, Braze, Firebase, Kochava, and Leanplum.

The manifest sorts independent packages by package name. Integration packages and database encryption have no dependency on each other.

Package workflows can start at the same time. A dependent package waits until its required version is public.

## Verify the release

1. Open the **Publish new github release** run.
2. Confirm that the run succeeded.
3. Open each **Deploy to pub.dev** run.
4. Confirm that each required version is on [pub.dev](https://pub.dev/publishers/rudderstack.com/packages).
5. Confirm that the Slack channel has one Flutter release message.
6. Confirm that the selected Slack thread has the package versions.
7. Confirm that the selected Slack thread has the back-merge pull request.
8. Review the back-merge pull request.
9. Get approval to merge the back-merge pull request.
10. Merge the back-merge pull request with a merge commit.
11. Add the GitHub, pub.dev, Snyk, and Sonar links to the Linear release ticket.
12. Get approval to close the Linear release ticket.
13. Move the release ticket and completed release issues to `Done`.

The following evidence shows a successful release:

| Phase | Required evidence |
| --- | --- |
| Draft | Release pull request, package table, and Slack thread message |
| Review | Green CI and a successful pub.dev dry run |
| Publish | GitHub release, package tags on the merge commit, and successful package workflows |
| Verify | Expected versions on pub.dev and Slack success messages |
| Close | Merged back-merge pull request and completed Linear ticket |

## Recover from a failure

### Release pull request validation fails

1. Do not merge the release pull request.
2. Fix the reported cause.
3. Run the failed check again.
4. Create a new release draft if the package versions must change.

### Package tag creation fails

The release workflow can reuse a tag only when it points to the expected merge commit.

1. Open the failed **Publish new github release** workflow.
2. Compare every existing release and package tag with the release merge commit.
3. Stop if an existing tag points to a different commit.
4. Fix the tag creation failure.
5. Run the failed release job again.
6. Confirm that the retry creates each missing tag and reuses each matching tag.

Do not delete or move an existing tag.

### A package publication fails

The package workflow skips publication when the exact version is already public.

1. Open the failed package workflow.
2. Copy the exact package tag.
3. Fix the reported cause.
4. Restart the package workflow:

   ```bash
   gh workflow run deploy-pubdev.yml --ref "PACKAGE_TAG"
   ```

5. Confirm that the package workflow succeeds.
6. Run the failed **Publish new github release** job again.
7. Confirm that the release posts the success messages.

Do not delete or move a package tag.

Stop if an existing tag points to a different commit.

### A Slack notification fails

1. Confirm that the release result is correct.
2. Confirm that both Slack secrets are available to the repository.
3. Confirm that the bot can post in the selected channel.
4. Re-run the **Notify Slack** job after the configuration is fixed.

A Slack failure is visible in GitHub Actions. A Slack failure does not change a package publication result.

### The back-merge has a conflict

1. Do not squash the back-merge pull request.
2. Resolve the conflict in the back-merge branch.
3. Confirm that CI passes.
4. Merge with a merge commit after approval.

## Manual publication fallback

Use manual publication only during an approved incident.

1. Confirm the exact package list and versions.
2. Check out the merged release commit.
3. Confirm that the worktree is clean.
4. Publish only changed packages.
5. Publish dependencies before dependents.
6. Confirm each version on pub.dev.
7. Record the reason and versions in the Linear release ticket.

Run the dry run before each manual publication:

```bash
cd PACKAGE_PATH
flutter pub publish --dry-run
flutter pub publish
```

The person who publishes must sign in as an authorized publisher.

## Create a hotfix

1. Open the **Create new hotfix branch** workflow.
2. Select `main`.
3. Enter a short name without the `hotfix/` prefix.
4. Put the approved fix on `hotfix/NAME`.
5. Use a `fix:` commit for the customer fix.
6. Start **Draft new release** from `hotfix/NAME` after approval.
7. Use the normal review, publish, verify, and back-merge steps.

Update the shared release page only after this guide passes review and a controlled release.
