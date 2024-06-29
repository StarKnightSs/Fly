//
// ContentView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyKit
import FlyServer
import Foundation
import SwiftUI

struct ContentView: View {

  @State private var isBooting = true
  @State private var appConfig: AppConfig?

  var body: some View {
    if isBooting {
      LaunchView {
        appConfig = $0
        isBooting = false
      }
    } else {
      FlyView(store: FlyStore.loadStore(
        appConfig: appConfig)
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
