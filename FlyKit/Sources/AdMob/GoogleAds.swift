//
// GoogleAds.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds

public struct GoogleAds {
  public static func start() async {
    await GADMobileAds.sharedInstance().start()
  }
}
