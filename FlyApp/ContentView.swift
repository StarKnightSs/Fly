//
// ContentView.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyKit
import Foundation
import SwiftUI

struct ContentView: View {

  @State var isBooting = true

  var body: some View {
    if isBooting {
      LaunchView()
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isBooting = false
          }
        }
    } else {
      FlyView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
