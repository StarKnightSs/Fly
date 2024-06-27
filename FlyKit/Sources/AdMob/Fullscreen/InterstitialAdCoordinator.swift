//
// InterstitialAdCoordinator.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds
import SwiftUI

public class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {

  private let adUnitID: String
  private let appOpenadUnitID: String

  private var appOpenAd: GADAppOpenAd?
  private var interstitial: GADInterstitialAd?

  public init(
    adUnitID: String = "ca-app-pub-3940256099942544/4411468910",
    appOpenadUnitID: String = "ca-app-pub-3940256099942544/5575463023"
  ) {
    self.adUnitID = adUnitID
    self.appOpenadUnitID = appOpenadUnitID
  }

  public func loadAd() {
    clean()
    GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
      self.interstitial = ad
      self.interstitial?.fullScreenContentDelegate = self
      print(error ?? "")
    }
  }

  public func showAd(from viewController: UIViewController) {
    guard let interstitial else {
      return print("Ad wasn't ready")
    }
    interstitial.present(fromRootViewController: viewController)
  }

  public func loadInterstitialAd() async throws -> GADInterstitialAd {
    clean()
    return try await withCheckedThrowingContinuation { continuation in
      GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  public func loadAppOpenAd() async throws -> GADAppOpenAd {
    clean()
    return try await withCheckedThrowingContinuation { continuation in
      GADAppOpenAd.load(withAdUnitID: appOpenadUnitID, request: GADRequest()) { ad, error in
        if let error {
          continuation.resume(throwing: error)
        } else if let ad {
          ad.fullScreenContentDelegate = self
          continuation.resume(returning: ad)
        }
      }
    }
  }

  private func clean() {
    interstitial = nil
    appOpenAd = nil
  }

  // MARK: - GADFullScreenContentDelegate methods

  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    clean()
  }
}
