//
//  FlyApp.swift
//  Fly
//
//  Created by Arpit Williams on 23/09/23.
//

import SwiftUI

@main
struct FlyApp: App {

  @Environment(\.scenePhase) private var scenePhase
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
