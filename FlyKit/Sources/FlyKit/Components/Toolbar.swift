//
// Toolbar.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct Toolbar: ToolbarContent {

  public var body: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      Image(systemName: "gearshape.fill")
        .foregroundStyle(Color(.leadLemon))
        .font(.headline)
        .offset(y: 1.2)
    }

    ToolbarItem(placement: .principal) {
      HStack(spacing: 4) {

        Image("Monkey", bundle: .module)
          .resizable()
          .frame(width: 40, height: 40)

        Text("File Server")
          .foregroundStyle(Color(.leadLemon))
          .font(.system(.callout, design: .rounded).weight(.heavy))
      }
    }

    ToolbarItem(placement: .topBarTrailing) {
      FileMenu()
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}.toolbar {
      Toolbar()
    }
  }
})
