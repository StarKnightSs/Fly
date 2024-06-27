//
// RewardedAdCoordinator.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds
import SwiftUI

public class RewardedAdCoordinator: NSObject, GADFullScreenContentDelegate {

  private let adUnitID: String
  private let interstitialID: String

  private var rewardedAd: GADRewardedAd?
  private var rewardedInterstitialAd: GADRewardedInterstitialAd?

  public init(
    adUnitID: String = "ca-app-pub-3940256099942544/1712485313",
    interstitialID: String = "ca-app-pub-3940256099942544/6978759866"
  ) {
    self.adUnitID = adUnitID
    self.interstitialID = interstitialID
  }

  public func loadAd() {
    clean()
    GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
      self.rewardedAd = ad
      self.rewardedAd?.fullScreenContentDelegate = self
      print(error ?? "")
    }
  }

  public func loadInterstitialAd() async throws -> GADRewardedInterstitialAd {
    clean()
    return try await withCheckedThrowingContinuation { continuation in
      GADRewardedInterstitialAd.load(withAdUnitID: interstitialID, request: GADRequest()) { ad, error in
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
    clean()
    return try await withCheckedThrowingContinuation { continuation in
      GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
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
    self.rewardedInterstitialAd = nil
    self.rewardedAd = nil
  }

  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    clean()
  }

  public func showAd(from viewController: UIViewController, userDidEarnRewardHandler completion: @escaping (Int) -> Void) {
    guard let rewardedAd else {
      return print("Ad wasn't ready")
    }

    rewardedAd.present(fromRootViewController: viewController) {
      let reward = rewardedAd.adReward
      completion(reward.amount.intValue)
    }
  }
}
