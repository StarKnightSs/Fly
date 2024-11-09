//
// FlyApp.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyKit
import SwiftUI

@main
struct FlyApp: App {
  @Environment(\.colorScheme) var colorMode
  @AppStorage("isDarkMode") private var isDarkMode: Bool?
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
      GeometryReader { screen in
        ContentView()
          .preferredColorScheme(colorScheme)
          .environment(\.colorScheme, colorScheme)
          .environment(\.windowSize, screen.size)
      }
    }
  }
}
