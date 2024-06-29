//
// GoogleAdMob.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds
import UserMessagingPlatform

public struct GoogleAdMob {

  private static var isLoaded = false

  @MainActor
  public static func requestConsent(from view: AdMobView) async throws {
    if UMPConsentInformation.sharedInstance.canRequestAds {
      await start()
    }
    try await UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: UMPRequestParameters())
    try await UMPConsentForm.loadAndPresentIfRequired(from: view.viewController)
    await start()
  }

  private static func start() async {
    guard isLoaded == false else { return }
    isLoaded = true
    await GADMobileAds.sharedInstance().start()
  }
}
