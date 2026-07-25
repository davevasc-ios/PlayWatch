# PlayWatch

SwiftUI app for iOS 26. Browse films, series and people from TMDB, and play
AI-generated film quizzes backed by OpenAI, Gemini or DeepSeek.

No external dependencies: no SPM packages, no CocoaPods, no Carthage.

## Commands

Tests run on the base iPhone model, the app runs on the Pro model, both on the
newest installed iOS. Resolve the simulator instead of hardcoding a UDID — they
differ per machine and change with Xcode updates:

```bash
xcodebuild -showdestinations -project PlayWatch.xcodeproj -scheme PlayWatch \
  | grep "name:iPhone 17 }"
```

```bash
# Tests
xcodebuild test -project PlayWatch.xcodeproj -scheme PlayWatch \
  -configuration Debug -destination "id=<iPhone 17 udid>"

# Build
xcodebuild -project PlayWatch.xcodeproj -scheme PlayWatch \
  -configuration Debug -sdk iphonesimulator build
```

Tests must run in **Debug**: `ENABLE_TESTABILITY` is only set there, and
`@testable import PlayWatch` needs it. The deployment target is iOS 26.0, so
older simulators fail with a deployment-target error rather than a useful one.

## Setup

`PlayWatch/Network/Configuration/APIKey-Info.plist` is a required resource of
the app target and is gitignored. Without it the build fails outright. Copy
`APIKey-Info.plist.template` next to it and fill in the four keys. Placeholder
values are enough to compile and to run the test suite, which never hits the
network.

## Architecture — MVSU

Model · View · Service · Utility, with a Repository layer underneath. Data flows
one way:

```
View (SwiftUI)
  └─ @Environment(AppService.self)
       AppService ──> MediaService / GameService / PreferencesService
            └─ Utility          business logic, in protocol extensions
                 └─ Repository  request + decode
                      └─ Network  Endpoints → HTTP → URLRequest.fetchData
                           └─ Model  DTO → domain
```

`Service/AppService.swift` is the composition root: `AppService.production`
builds the whole graph by hand. `Preview Content/AppService+Preview.swift`
builds the same graph with mocks. Views never see a repository — they read
`AppService` from the environment, so swapping real for mock happens in one
place.

| Folder | Holds |
|---|---|
| `View/` | SwiftUI only. No networking. Emits events, never calls business methods. |
| `Model/` | Domain structs, DTOs and config enums, grouped by domain. |
| `Repository/` | Protocols plus real implementations. Fetch and decode, stateless. |
| `Service/` | `@Observable final class` holding app state and error handling. |
| `Network/` | Endpoints, HTTP builders, decoders, API errors. |
| `Utility/` | Reusable business logic in protocol extensions. |
| `Core/` | Domain-agnostic: constants, extensions, errors, shared components. |
| `Preview Content/` | Static mocks. Excluded from release builds. |

## Conventions

**The dominant pattern is a protocol with a default implementation in an
extension.** Protocols declare one primitive method; composed logic lives in
the extension, so mocks implement the primitive and inherit everything else.
`MediaRepositoryProtocol.fetchMediaSections` is the clearest example — it fans
out over sections with a task group and prepends a synthetic `.hero` section,
and every conforming type gets that for free.

- **Naming**: layer suffixes (`*Repository`, `*RepositoryPreview`, `*Service`,
  `*Utility`, `*Endpoint`, `*View`). Capability protocols end in `-ing` /
  `-able` (`MediaRequestProviding`, `SettingsManaging`). Extension files are
  `Type+Concept.swift`.
- **Events**: services conform to `EventHandler` with a nested `Event` enum.
  Views call `await appService.mediaService.on(.loadData)` and never reach into
  business methods directly.
- **Decoding**: every response model gets
  `static func decode(from:using:)` in a `// MARK: - Decoding` extension,
  rewrapping failures as `API.Error.invalidData`.
- **Previews and mocks** always sit inside `#if DEBUG`.
- **`// MARK: -`** throughout. In services the order is: public read-only
  properties → private properties → init → event handling → public → private.
- **Language**: code, comments and commit messages in English.

## Concurrency

Swift 6 with `SWIFT_STRICT_CONCURRENCY = complete` and
`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`. **Everything is `@MainActor` by
default**, which is why explicit annotations are rare — and why you will see
`nonisolated` used to opt *out*. Protocols crossing layer boundaries are
`Sendable`. The only actor is `AIRequestProvider`, which caches endpoints.

## Localization

8 languages (`en, es, ca, eu, fr, it, pt-PT, de`), source language English,
split into 7 `.xcstrings` tables by feature. Strings are wrapped in typed
`LocalizedStringResource` constants under `Localization/`, one nested enum per
table (`Localizable.Home`, `Localizable.Settings`, …). Keys follow
`<feature>.<group>.<name>`. Language switches at runtime by injecting
`\.locale` from `PlayWatchApp`.

## Versioning

`Config/Version.xcconfig` is the single source of truth, wired in as the
project's base configuration. Never add `MARKETING_VERSION` or
`CURRENT_PROJECT_VERSION` to a target's build settings — a target-level setting
overrides the xcconfig and silently makes it decorative.

`MARKETING_VERSION` is bumped deliberately. The build number is injected at
build time by CI as `CURRENT_PROJECT_VERSION=<n>`, never committed.

## Branching

`main` (production) · `develop` (integration) · short-lived `feature/*`,
`fix/*`, `chore/*` off develop. Squash merges only, linear history. Releases
are git tags `vX.Y.Z` on `main`.

## Known debt

- `Model/Media/MediaContent.swift` is a half-finished refactor toward
  polymorphic media types. It has duplicate protocols and unused structs; the
  live model is still the flat `Media`. Marked with a TODO.
- `SectionType.hero` has a hardcoded Spanish title.
- `SettingsView` has several unlocalized labels.
- `MediaFetchType.type` maps `.trendingAll` and `.searchAll` to
  `SectionType.randomMovies` as a placeholder.
- `Constants.homeSections` repeats `.cinemaUpcomimg`. This is intentional
  scaffolding while the home screen is still being built.
