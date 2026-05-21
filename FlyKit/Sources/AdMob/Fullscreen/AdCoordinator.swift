//
// AdCoordinator.swift
// Created by Arpit Williams on 28/06/24.
// Copyright (c) 2026 StarKnights Technologies

import GoogleAdmobSPM
import SwiftUI

public final class AdCoordinator: NSObject, GADFullScreenContentDelegate, @unchecked Sendable {

  override public init() {}

  public func loadAppOpenAd() async throws -> GADAppOpenAd {
    return try await withCheckedThrowingContinuation { continuation in
      GADAppOpenAd.load(withAdUnitID: appOpenAdUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  public func loadInterstitialAd() async throws -> GADInterstitialAd {
    return try await withCheckedThrowingContinuation { continuation in
      GADInterstitialAd.load(withAdUnitID: interstitialAdUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  public func loadRewardedAd() async throws -> GADRewardedAd {
    return try await withCheckedThrowingContinuation { continuation in
      GADRewardedAd.load(withAdUnitID: rewardedAdUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  public func loadRewardedInterstitialAd() async throws -> GADRewardedInterstitialAd {
    return try await withCheckedThrowingContinuation { continuation in
      GADRewardedInterstitialAd.load(withAdUnitID: rewardedInterstitialAdUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  // MARK: - GADFullScreenContentDelegate methods

  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Dimissed Ad: \(ad.description)")
  }
}
