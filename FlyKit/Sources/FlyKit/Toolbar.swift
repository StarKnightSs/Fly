//
// Toolbar.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct ToolBar: ToolbarContent {

  public var body: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      Image(systemName: "person.fill")
        .font(.title3)
        .padding(.top, 4)
    }

    ToolbarItem(placement: .principal) {
      HStack(spacing: 4) {
        Image("Monkey", bundle: .module)
          .resizable()
          .frame(width: 40, height: 40)

        Text("File Server")
          .font(.system(size: 16, weight: .heavy, design: .rounded))
      }
    }

    ToolbarItem(placement: .topBarTrailing) {
      Image(systemName: "folder.fill.badge.plus")
        .font(.headline)
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}.toolbar {
      ToolBar()
    }
  }
})
