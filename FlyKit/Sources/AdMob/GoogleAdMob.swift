//
// GoogleAdMob.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleAdmob

public struct GoogleAdMob {
  public static func start() async {
    let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
    requestConfiguration.maxAdContentRating = .general
    requestConfiguration.tagForUnderAgeOfConsent = true
    requestConfiguration.tagForChildDirectedTreatment = true
    await GADMobileAds.sharedInstance().start()
  }
}
