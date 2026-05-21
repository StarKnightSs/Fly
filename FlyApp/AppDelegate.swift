//
// AppDelegate.swift
// Created by Arpit Williams on 11/05/24.
// Copyright (c) 2026 StarKnights Technologies

import FirebaseCore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
