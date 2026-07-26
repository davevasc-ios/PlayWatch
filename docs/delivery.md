# Delivery pipeline

How a change reaches TestFlight, and why each piece is the way it is. The
reasoning matters more than the mechanics here: most of these choices look
arbitrary until you know what they are avoiding, and several were arrived at
by hitting the alternative first.

## The flow

```
fastlane ship                     on your Mac, ~5 seconds
  ├─ refuses a dirty tree or a branch that breaks the naming convention
  ├─ push, then gh pr create --fill-first
  └─ gh pr merge --auto --squash --delete-branch

ci.yml            pull_request → develop|main       ~5 min
  └─ fastlane tests — 15 tests, no secrets

auto-merge fires when build-test is green
  └─ squash into develop, branch deleted

testflight.yml    push → develop                    ~5 min
  └─ fastlane beta — match, gym, upload_to_testflight

release.yml       tag vX.Y.Z                        ~10 min
  └─ fastlane release — same build, submitted to App Store Connect
```

Nothing triggers on a commit or on pushing a branch. The chain starts when the
pull request opens.

## Why the merge is armed from your Mac

`gh pr merge --auto` runs locally, with your token, rather than from a
workflow. A merge performed by a workflow using `GITHUB_TOKEN` does not trigger
further workflows — GitHub suppresses those cascades to prevent loops — so the
push to develop would never start `testflight.yml`. Doing it locally also
avoids a personal access token in secrets that expires once a year.

## Build numbers come from App Store Connect

`resolve_build_number` asks Apple for the highest build number the app has
ever had and adds one. Two alternatives were tried and rejected:

`GITHUB_RUN_NUMBER` is per-workflow. The TestFlight and release workflows would
keep separate counters, and the first tagged release would submit a number
below one develop had already used. App Store Connect rejects that.

Querying builds *for the current version* fails differently: Apple normalises
version strings, so `1.0.0` and `1.0` are the same version train to it but not
to the API's version filter. A query for `1.0.0` returned zero builds while the
app had thirty under `1.0`, the upload proposed build 1, and Apple rejected it
as a redundant binary. Taking the global maximum cannot collide however Apple
chooses to spell the version.

Both uploading workflows share the concurrency group `appstore-upload` so two
runs can never read the same number. Known trade-off: GitHub keeps one running
slot and one pending slot, so three merges inside one build cycle drop the
middle one. Nothing is lost — TestFlight builds are cumulative — but that
commit gets no build of its own.

## Versions are never committed by automation

`Config/Version.xcconfig` holds both numbers and is the project's base
configuration. CI passes `CURRENT_PROJECT_VERSION=<n>` to `xcodebuild` at build
time; nothing is written back. This avoids `agvtool`, script build phases
(which would collide with `ENABLE_USER_SCRIPT_SANDBOXING = YES`), automated
commits that retrigger CI, and merge conflicts in `project.pbxproj`.

`MARKETING_VERSION` is bumped by hand with `fastlane bump type:minor` because
whether a release is a patch, a minor or a major is a human judgement.

**Never add `MARKETING_VERSION` or `CURRENT_PROJECT_VERSION` to a target's
build settings.** A target-level setting overrides the xcconfig and silently
makes it decorative. The eight that were there originally are gone.

## Signing

`fastlane match` keeps the distribution certificate and provisioning profile
encrypted in the private repository `ios-certificates`. Runners read it through
a read-only SSH deploy key, which unlike a personal access token never expires.

Two alternatives were rejected:

`-allowProvisioningUpdates` reuses a certificate only when its private key is
in the local keychain. On an ephemeral runner it never is, so every run creates
a new one — and Apple caps an account at three Apple Distribution certificates.
The pipeline would die on the fourth build.

A `.p12` in secrets works but has to be exported, encoded and replaced by hand
every twelve months, which is discovered when an urgent release fails.

The project stays on `CODE_SIGN_STYLE = Automatic`. Signing overrides live only
in `gym`'s `xcargs`, so Xcode keeps working locally with no configuration, and
`gym` generates `ExportOptions.plist` at runtime rather than one being
committed. `Matchfile` pins `readonly: true` so CI can never create a
certificate.

The certificate expires after twelve months. `warn_if_certificate_expires_soon`
reads the date from App Store Connect and warns below thirty days. It is the
only notice there will be.

## Secrets

Ten secrets live in a `production` **environment**, not at repository level.
`ci.yml` does not declare an environment, so it has no path to them even if it
is edited later. This matters because the repository is public: a pull request
from a fork runs `ci.yml`, and there is nothing there to steal.

`ci.yml` needs no secrets by construction. `APIKey-Info.plist` is a required
resource of the app target and is gitignored, so `prepare_secrets(dummy: true)`
renders it from `APIKey-Info.plist.template`. The placeholders are non-empty,
which is what matters: `API.Key.description` calls `fatalError()` when the file
is missing, the key is missing, or the value is empty. Requests then fail with
401, which the app handles, and the suite makes none — the tests use preview
repositories that never touch the network.

Dummy mode refuses to overwrite an existing plist. It used to copy
unconditionally, which on a developer machine replaced real keys with
placeholders; the app still built and failed every request at runtime.

## Runners

`macos-26` carries Xcode 26.6, the version used locally, so a CI failure can
never be a compiler difference. `macos-15` also works but tops out at 26.3.
The setup action prefers 26.6 and falls back to the newest 26.x with a warning.

`.ruby-version` at the repository root is **required**. Given no version input,
`ruby/setup-ruby` looks for `.ruby-version`, `.tool-versions` or `mise.toml`
and hard-fails if none exists — it never falls back to a system Ruby and never
reads the Gemfile's `ruby` directive. Without that file all three workflows die
at the setup step before compiling anything. The version matches the
`RUBY VERSION` recorded in `Gemfile.lock`.

The test simulator is resolved at runtime from `simctl`, never hardcoded: UDIDs
differ per machine and change with Xcode. The deployment target is iOS 26.0, so
an older runtime fails with a deployment-target error rather than anything
actionable.

## Tests run in Debug

`ENABLE_TESTABILITY` is only set in Debug and `@testable import PlayWatch`
needs it. `-configuration Release` makes the suite fail to compile.

## Dependencies

Dependabot watches the GitHub Actions and the Gemfile weekly, targeting
develop, grouped so one week with four new versions produces one pull request.

Patch and minor updates merge themselves once `build-test` is green. Major
updates stay open with a comment: under semantic versioning the author is
declaring that callers must adapt. The classification comes from
`dependabot/fetch-metadata`, not from parsing version strings.

Accepted gap: CI runs `fastlane tests`, never `fastlane beta`, so a green check
says nothing about whether signing and uploading still work. A patch or minor
update that broke them would surface on the next merge into develop. That
failure is visible and reverting one commit undoes it, which is cheaper than a
standing manual task that would be approved without reading the changelog.

## Pull request descriptions become commits

The repository squash-merges with `squash_merge_commit_message = PR_BODY`, so
the pull request description is literally the commit message that lands on
develop. It is not review paperwork; it is the explanation anyone reads a year
later.

`ship` uses `--fill-first`, which takes the first commit's subject and body.
`--fill` was tried and is worse on both counts: with several commits it titles
the pull request after the branch and reduces the body to a bullet list of
subjects, dropping every explanation.

Neither flag handles a multi-commit branch well — `--fill-first` omits the
later commits entirely. Write the description by hand when a branch carries
more than one meaningful change.

## Known gaps

**API keys ship inside the ipa.** `APIKey-Info.plist` is bundled as an app
resource, so anyone with the ipa can read all four keys without any reverse
engineering. This is inherent to reading them via `Bundle.main.path` and
affects every build since April 2024. The fix is a backend proxy, planned
alongside the Supabase work. Interim control is a spending cap rather than
secrecy.

**No hotfix path.** `ship` hardcodes `--base develop`. Patching a released
version means branching from `main`, which needs a `base:` parameter. Not built
because nothing is released yet.

**The publish path is only exercised on merge.** `ci.yml` proves the app builds
and the tests pass; it never signs or uploads. Making it do so would need
secrets in a workflow that fork pull requests can trigger.
