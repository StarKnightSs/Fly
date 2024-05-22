//
// TopBar.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct TopBar: ToolbarContent {

  var gearTapped: (() -> Void)?
  var folderTapped: (() -> Void)?

  public var body: some ToolbarContent {

    ToolbarItem(placement: .principal) {
      HStack(spacing: 4) {

        Image(systemName: "gearshape.fill")
          .font(.headline)
          .offset(y: 1.5)
          .onTapGesture {
            gearTapped?()
          }

        Spacer()

        Image("Monkey", bundle: .module)
          .resizable()
          .frame(width: 40, height: 40)

        Text("File Server")
          .font(.system(.callout, design: .rounded).weight(.heavy))

        Spacer()

        Image(systemName: "folder.fill.badge.plus")
          .font(.headline)
          .onTapGesture {
            folderTapped?()
          }
      }
      .foregroundStyle(Color.black)
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
