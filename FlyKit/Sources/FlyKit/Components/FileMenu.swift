//
// FileMenu.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FileMenu: View {

  @State private var folderName = ""
  @State private var showFolderAlert = false
  @State private var showFilesPicker = false

  @EnvironmentObject private var viewModel: FlyViewModel

  public var body: some View {
    Menu(
      content: {
        Button(
          action: { showFolderAlert = true },
          label: { Label("New Folder", systemImage: "folder.fill") }
        )

        Button(
          action: { showFilesPicker = true },
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
    .alert("Add Folder", isPresented: $showFolderAlert) {
      alertView
    }
    .fileImporter(
      isPresented: $showFilesPicker,
      allowedContentTypes: FilesManager.supportedTypes,
      allowsMultipleSelection: true,
      onCompletion: { viewModel.importFiles(result: $0) }
    )
  }

  var alertView: some View {
    VStack {
      TextField("Folder Name", text: $folderName)
      Button("Create") {
        viewModel.addFolder(folderName)
        folderName = ""
      }
      Button("Cancel") {
        folderName = ""
        showFolderAlert = false
      }
    }
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
