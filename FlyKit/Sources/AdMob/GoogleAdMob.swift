//
// GoogleAdMob.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds
import UserMessagingPlatform

public struct GoogleAdMob {

  private static var isLoaded = false

  public enum AdMobError: Error {
    case alreadyLoaded
  }

  public static var hasConsent: Bool {
    UMPConsentInformation.sharedInstance.canRequestAds
  }

  public static func start() async throws {
    guard isLoaded == false else {
      throw AdMobError.alreadyLoaded
    }
    isLoaded = true
    await GADMobileAds.sharedInstance().start()
  }

  @MainActor
  public static func requestConsent(from view: AdMobView) async throws {
    try await UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: UMPRequestParameters())
    try await UMPConsentForm.loadAndPresentIfRequired(from: view.viewController)
    try await start()
  }
}
