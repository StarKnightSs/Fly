//
// ContentView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyKit
import FlyServer
import Foundation
import SwiftUI

struct ContentView: View {

  @State var isBooting = true
  var body: some View {
    if isBooting {
      LaunchView()
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isBooting = false
          }
        }
    } else {
      FlyView(
        store: FlyStore.loadStore()
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
