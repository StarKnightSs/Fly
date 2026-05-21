# Fly

Fly is a SwiftUI-based iPhone and iPad app for local file transfer and file management.
It turns the device into a lightweight file server so content can be browsed, uploaded,
downloaded, and organized on the same network without relying on cloud storage.

## What the app does

Fly is designed for fast on-device and local-network file workflows:

- browse files and folders exposed by the local server
- upload files from another device using the built-in web interface
- download files directly from the device
- create, rename, copy, move, and delete files and folders
- import files from the Files app and photos from the photo library
- sort files by date, name, size, or type
- archive selected files into a ZIP for sharing
- scan QR codes to simplify upload/download flows
- show transfer progress, alerts, and status feedback
- optionally display AdMob banner and fullscreen ads
- request App Store reviews when the app is in a good state to do so

## Repository structure

- `FlyApp/` — app shell, launch, and scene setup
- `FlyKit/` — shared UI, reducers, and feature logic
- `FlyKit/Sources/FlyServer/` — local Vapor server, filesystem utilities, and file routing
- `FlyKit/Sources/AdMob/` — Google Mobile Ads integration helpers
- `FlyTests/` and `FlyUITests/` — app-level test targets

## Architecture overview

The app is split into three main modules:

### `FlyKit`
Shared SwiftUI and Composable Architecture feature layer. It owns the app flow,
main file browser, alerts, progress UI, and the connections to the server and ad layer.

### `FlyServer`
The local server backend built on Vapor. It handles file listing, upload and download
routing, ZIP archiving, metadata extraction, and filesystem operations.

### `AdMob`
Google Mobile Ads integration used for banner and fullscreen ad presentation.
It centralizes SDK startup, ad unit IDs, and ad coordinator logic.

## Requirements

- iOS 16 or later for the app target
- macOS 13 or later for the package targets
- Xcode project: `Fly.xcodeproj`

## Build and run

1. Open `Fly.xcodeproj` in Xcode.
2. Select the `Fly` scheme.
3. Run on an iPhone, iPad, or simulator target.

For the file-transfer experience, a physical device is the most representative
run destination.

## Module documentation

- [`FlyKit/README.md`](FlyKit/README.md)
- [`FlyKit/Sources/FlyServer/README.md`](FlyKit/Sources/FlyServer/README.md)
- [`FlyKit/Sources/AdMob/README.md`](FlyKit/Sources/AdMob/README.md)

## Notes

- Google Mobile Ads is configured through the app’s ad helpers and Info.plist entries.
- The server and transfer flows are implemented locally within the app package.
- File and transfer behavior is coordinated through `FlyStore` and `FilesStore`.
