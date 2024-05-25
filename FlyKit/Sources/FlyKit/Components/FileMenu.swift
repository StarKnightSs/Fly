//
// FileMenu.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FileMenu: View {

  @EnvironmentObject private var viewModel: FlyViewModel

  public var body: some View {
    Menu(
      content: {
        Button(
          action: { viewModel.showFolderAlert = true },
          label: { Label("New Folder", systemImage: "folder.fill") }
        )

        Button(
          action: { viewModel.showFilesPicker = true },
          label: { Label("Add Files", systemImage: "doc.fill") }
        )

        Button(
          action: {},
          label: { Label("Import Photos", systemImage: photosIcon) }
        )

        Menu("Sort By", systemImage: "square.grid.3x3") {
          Button(
            action: {},
            label: { Text("Name") }
          )

          Button(
            action: {},
            label: { Text("Type") }
          )

          Button(
            action: {},
            label: { Text("Date") }
          )

          Button(
            action: {},
            label: { Text("Size") }
          )
        }
      },
      label: {
        Image(systemName: "folder.fill.badge.plus")
          .foregroundStyle(Color(.leadLemon))
          .font(.headline)
      }
    )
  }

  var photosIcon: String {
    if #available(iOS 17, *) {
      "photo.badge.plus.fill"
    } else {
      "photo.fill"
    }
  }
}

#Preview(body: {
  FileMenu()
})
