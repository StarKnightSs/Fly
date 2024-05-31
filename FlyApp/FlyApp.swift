//
// FlyApp.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

@main
struct FlyApp: App {

  @Environment(\.colorScheme) var colorMode
  @AppStorage("isDarkMode") private var isDarkMode: Bool?

  #if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #elseif os(macOS)
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  #endif

  var colorScheme: ColorScheme {
    if let isDarkMode {
      isDarkMode ?
        ColorScheme.light :
        ColorScheme.dark
    } else {
      colorMode
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .preferredColorScheme(colorScheme)
        .environment(\.colorScheme, colorScheme)
    }
  }
}
