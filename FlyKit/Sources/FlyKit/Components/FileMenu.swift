//
// FileMenu.swift
// Created by Arpit Williams on 26/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FileMenu: View {

  @EnvironmentObject private var viewModel: FlyViewModel

  var isEditing: Bool {
    viewModel.editMode.isEditing
  }

  public var body: some View {
    Menu(
      content: {
        if isEditing {
          ediMenu
        } else {
          fileMenu
        }
      },
      label: {
        Image(systemName: isEditing ? ellipsisCircleFill : folderFillBadgePlus)
          .foregroundStyle(Color(.leadLemon))
          .font(.headline)
      }
    )
  }

  var ediMenu: some View {
    VStack {

      // Done
      Button(
        action: { viewModel.editMode = .inactive },
        label: { Label("Done", systemImage: checkmark) }
      )

      // Select All
      Button(
        action: { viewModel.selectAllFiles() },
        label: { Label("Select All", systemImage: checkmarkShield) }
      )

      // Send Files
      Button(
        action: {},
        label: { Label("Send Files", systemImage: upArrow) }
      ).disabled(viewModel.selectedFiles.isEmpty)

      // Delete
      Button(
        role: .destructive,
        action: { viewModel.removeSelectedFiles() },
        label: { Label("Delete", systemImage: trash) }
      )
    }
  }

  var fileMenu: some View {
    VStack {

      if viewModel.files.isEmpty == false {

        // Select
        Button(
          action: { viewModel.editMode = .active },
          label: { Label("Select", systemImage: checkmarkCircle) }
        )

        // Recieve Files
        Button(
          action: {},
          label: { Label("Recieve Files", systemImage: downArrow) }
        )
      }

      // Add Folder
      Button(
        action: { viewModel.showFolderAlert = true },
        label: { Label("Add Folder", systemImage: folderFill) }
      )

      // Add Files
      Button(
        action: { viewModel.showFilesPicker = true },
        label: { Label("Add Files", systemImage: docFill) }
      )

      // Add Photos
      Button(
        action: { viewModel.showPhotosPicker = true },
        label: { Label("Add Photos", systemImage: photo) }
      )

      // Sort Files
      Menu("Sort By", systemImage: squareGrid3x3) {
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
    }
  }
}

#Preview(body: {
  FileMenu()
})
