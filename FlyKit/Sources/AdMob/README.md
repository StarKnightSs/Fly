# AdMob

`AdMob` contains the Google Mobile Ads integration used by Fly. It is responsible for
configuring the SDK, providing ad unit identifiers, and presenting banner and fullscreen
ads from SwiftUI.

## Responsibilities

- start and configure the Google Mobile Ads SDK
- centralize test and production ad unit identifiers
- bridge UIKit ad presentation into SwiftUI
- coordinate full-screen ad delegate callbacks
- provide a reusable banner ad wrapper for the main app

## Main types

- `GoogleAdMob` — starts the Mobile Ads SDK and configures request settings
- `AdUnits.swift` — environment-specific banner, interstitial, app open, rewarded,
  and rewarded interstitial ad unit IDs
- `AdMobView` — a `UIViewControllerRepresentable` wrapper used as the SwiftUI host
- `AdCoordinator` — loads fullscreen ad formats and acts as the delegate
- `BannerView` / `BannerViewController` — banner ad presentation helpers

## Behavior

Fly uses this module to:

- initialize AdMob once the app feature flow is ready
- render a banner view behind the main content when ads are enabled
- load interstitial, rewarded, app-open, and rewarded-interstitial placements
- react to ad dismissal events in a predictable way

## Usage

Typical usage follows this sequence:

1. Call `GoogleAdMob.start()` once the app is ready to present ads.
2. Keep an `AdCoordinator` alive for the duration of the feature flow.
3. Load an ad through the coordinator and present it from a view controller.

## Notes

- Test ad unit IDs are used in `#if DEBUG` builds.
- Production ad unit IDs are defined in `AdUnits.swift`.
- Fly only shows ads when the remote app configuration enables them.
