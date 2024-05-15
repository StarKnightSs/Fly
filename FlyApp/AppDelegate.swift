//
// AppDelegate.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

#if os(iOS)

  import UIKit

  class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
      _: UIApplication,
      didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      true
    }
  }

#elseif os(macOS)

  import AppKit

  class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_: Notification) {}
  }

#endif
