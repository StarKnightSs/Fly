//
// ContentView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyKit
import FlyServer
import Foundation
import SwiftUI

struct ContentView: View {

  @State private var store: StoreOf<FlyStore>?

  var body: some View {
    if let store {
      FlyView(store: store)
    } else {
      LaunchView {
        loadStore(with: $0)
      }
    }
  }

  func loadStore(with config: AppConfig?) {
    store = FlyStore.loadStore(appConfig: config)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
