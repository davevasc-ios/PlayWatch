fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Build and test. Runs on every pull request and needs no secrets.

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload to TestFlight. Runs on every merge to develop.

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and submit to App Store Connect. Runs on a vX.Y.Z tag.

### ios doctor

```sh
[bundle exec] fastlane ios doctor
```

Check everything beta needs, without building or uploading anything.

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Create the distribution certificate and profile. Run once, locally.

### ios ship

```sh
[bundle exec] fastlane ios ship
```

Push the current branch, open a PR against develop and arm auto-merge.

### ios bump

```sh
[bundle exec] fastlane ios bump
```

Bump the marketing version. bump type:minor

### ios tag_release

```sh
[bundle exec] fastlane ios tag_release
```

Tag the current main commit with the version in the xcconfig.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
