//
// FlyApp.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

@main
struct FlyApp: App {

  #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #elseif os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #endif

  @Environment(\.scenePhase) private var scenePhase

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) {
      switch $0 {
      case .background:
        break
      case .active:
        break
      default:
        break
      }
    }
  }
}
