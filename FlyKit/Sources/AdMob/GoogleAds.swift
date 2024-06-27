//
// GoogleAds.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds

public struct GoogleAds {
  public static func start() async {
    await GADMobileAds.sharedInstance().start()
  }

  #if DEBUG
  static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
  #else
  static let bannerAdUnitID = "ca-app-pub-3954157944286926/9958970550"
  #endif
}
