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
        if viewModel.files.isEmpty == false {
          selectMenu
        }
        if isEditing == false {
          fileMenu
        }
      },
      label: {
        Image(systemName: isEditing ? "ellipsis.circle.fill" : "folder.fill.badge.plus")
          .foregroundStyle(Color(.leadLemon))
          .font(.headline)
      }
    )
  }

  var selectMenu: some View {
    VStack {

      // Select | Done
      Button(
        action: {
          viewModel.editMode = isEditing ? .inactive : .active
        },
        label: {
          Label(
            isEditing ? "Done" : "Select",
            systemImage: isEditing ? "checkmark" : "checkmark.circle"
          )
        }
      )

      // Send | Drop
      Button(
        action: {},
        label: {
          Label(
            "\(isEditing ? "Send" : "Drop") Files",
            systemImage: isEditing ? upArrow : downArrow
          )
        }
      ).disabled(
        isEditing ? viewModel.selectedFiles.isEmpty : false
      )
    }
  }

  var fileMenu: some View {
    VStack {

      // Add Folder
      Button(
        action: { viewModel.showFolderAlert = true },
        label: { Label("New Folder", systemImage: "folder.fill") }
      )

      // Add Files
      Button(
        action: { viewModel.showFilesPicker = true },
        label: { Label("Add Files", systemImage: "doc.fill") }
      )

      // Add Photos
      Button(
        action: {},
        label: { Label(
          "Import Photos", systemImage: photo
        ) }
      )

      // Sort Files
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
    }
  }
}

#Preview(body: {
  FileMenu()
})
