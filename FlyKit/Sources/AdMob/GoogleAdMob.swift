//
// GoogleAdMob.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleAdmobSPM

public struct GoogleAdMob {
  public static func start() async {
    let requestConfiguration = GADMobileAds.sharedInstance().requestConfiguration
    requestConfiguration.maxAdContentRating = .general
    requestConfiguration.tagForUnderAgeOfConsent = true
    requestConfiguration.tagForChildDirectedTreatment = true
    let status = await GADMobileAds.sharedInstance().start()
    print(status.adapterStatusesByClassName)
  }
}
