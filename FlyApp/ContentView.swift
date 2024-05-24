//
// ContentView.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import FlyKit
import Foundation
import SwiftUI

struct ContentView: View {

  @State var isBooting = true

  @StateObject private var flyViewModel = FlyViewModel(
    filesManager: FilesManager(fileManager: FileManager.default)
  )

  var body: some View {
    if isBooting {
      LaunchView()
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isBooting = false
          }
        }
    } else {
      FlyView()
        .environmentObject(flyViewModel)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
