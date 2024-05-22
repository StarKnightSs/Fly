//
// TopBar.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct TopBar: ToolbarContent {

  var gearTapped: (() -> Void)?
  var folderTapped: (() -> Void)?

  public var body: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      Image(systemName: "gearshape.fill")
        .foregroundStyle(Color.black)
        .font(.headline)
        .offset(y: 1.2)
        .onTapGesture {
          gearTapped?()
        }
    }

    ToolbarItem(placement: .principal) {
      HStack(spacing: 4) {

        Image("Monkey", bundle: .module)
          .resizable()
          .frame(width: 40, height: 40)

        Text("File Server")
          .foregroundStyle(Color.black)
          .font(.system(.callout, design: .rounded).weight(.heavy))
      }
    }

    ToolbarItem(placement: .topBarTrailing) {
      Image(systemName: "folder.fill.badge.plus")
        .foregroundStyle(Color.black)
        .font(.headline)
        .onTapGesture {
          folderTapped?()
        }
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}.toolbar {
      TopBar()
    }
  }
})
