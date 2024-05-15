//
//  AppDelegate.swift
//  Fly
//
//  Created by Arpit Williams on 11/05/24.
//

#if os(iOS)

  import UIKit

  class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      return true
    }
  }

#elseif os(macOS)

  import AppKit

  class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {}
  }

#endif
