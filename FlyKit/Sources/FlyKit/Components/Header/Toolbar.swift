//
// Toolbar.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct Toolbar: ToolbarContent {

  var editMode: Binding<EditMode>
  var selectedFiles: Binding<Set<UUID>>

  @State private var refresh = false

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

        Text(title)
          .foregroundStyle(Color(.leadLemon))
          .font(.system(.callout, design: .rounded).weight(.heavy))
      }
      .id(refresh)
      .onAppear {
        refresh.toggle()
      }
    }

    ToolbarItem(placement: .topBarTrailing) {
      RightMenu()
    }
  }

  var title: String {
    if editMode.wrappedValue.isEditing {
      if selectedFiles.wrappedValue.isEmpty {
        "Select files"
      } else {
        "\(selectedFiles.wrappedValue.count) Files"
      }
    } else {
      "Fly Server"
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}.toolbar {
      Toolbar(
        editMode: .constant(EditMode.inactive),
        selectedFiles: .constant(.init())
      )
    }
  }
})
