# FlyKit

`FlyKit` is the shared SwiftUI and Composable Architecture feature layer for **Fly**.
It owns the main application state, the primary file-management screens, and the
UI flow that coordinates the local server, file browser, alerts, progress UI, and
optional ad/review prompts.

## Responsibilities

- Compose the main app experience through `FlyView`
- Manage global feature state in `FlyStore`
- Render the file browser, transfer progress, and presentation overlays
- Bridge UI actions to `FlyServer` and `AdMob`
- Persist user-facing preferences such as sorting and transfer counters

## Key entry points

- `FlyView(store:)` — root SwiftUI view for the app experience
- `FlyStore.loadStore(appConfig:)` — creates the feature store used by the app shell
- `FlyStore.State` — owns app configuration, progress, review, and ad-related state

## Main capabilities

FlyKit drives the user-facing workflows that make Fly a local file-transfer app:

- browsing files and folders
- creating, renaming, copying, moving, and deleting items
- importing content from Files and Photos
- showing upload/download progress and success/failure alerts
- triggering QR-based upload and download flows
- showing banner and fullscreen ads when enabled
- requesting App Store reviews at the appropriate time

## Dependencies

This module depends on:

- `ComposableArchitecture` for state management
- `FlyServer` for file-system and server operations
- `AdMob` for ad integration
- `Resolver` and `FirebaseCore` for dependency wiring and app services

## Project notes

- App-wide state such as sort mode and file counts is stored with `@Shared`
- `FlyView` composes the current file list, alert overlay, and transfer progress UI
- The app shell in `FlyApp/` is responsible for instantiating the store and injecting the window size

## Building

Open `Fly.xcodeproj` in Xcode and build the `Fly` scheme.
