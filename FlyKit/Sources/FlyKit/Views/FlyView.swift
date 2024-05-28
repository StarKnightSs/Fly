//
// FlyView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLook
import SwiftUI

public struct FlyView: View {

  @EnvironmentObject private var viewModel: FlyViewModel

  public init() {}

  public var body: some View {
    NavigationView {
      ZStack {
        rootView
        if viewModel.showFolderAlert {
          folderAlert
        }
      }
    }
  }

  var rootView: some View {
    VStack(spacing: 0) {
      if viewModel.files.isEmpty {
        BlankView()
      } else {
        FileListView()
          .padding(.top, 1)
      }
    }
    .background(Color(.lemonLead))
    .navigationBarTitleDisplayMode(.inline)
    .environment(\.editMode, $viewModel.editMode)
    .quickLookPreview($viewModel.previewFile)
    .fileImporter(
      isPresented: $viewModel.showFilesPicker,
      allowedContentTypes: FilesManager.supportedTypes,
      allowsMultipleSelection: true,
      onCompletion: { viewModel.importFiles(result: $0) }
    )
    .toolbar {
      Toolbar(
        editMode: $viewModel.editMode,
        selectedFiles: $viewModel.selectedFiles
      )
    }
    .onAppear {
      viewModel.server.start()
      viewModel.loadFiles()
    }
  }

  var folderAlert: some View {
    AlertView(
      title: "Add Folder",
      mainButtonTitle: "Add",
      cancelButtonTitle: "Cancel",
      textInputTitle: "Folder Name",
      textInputValue: $viewModel.folderName,
      done: {
        viewModel.addFolder(viewModel.folderName)
        viewModel.showFolderAlert = false
        viewModel.folderName = ""
      },
      dismiss: {
        viewModel.folderName = ""
        viewModel.showFolderAlert = false
      }
    )
  }
}

#Preview {
  FlyView()
    .environmentObject(
      FlyViewModel(
        filesManager: FilesManager(fileManager: .default),
        files: [.mockFile, .mockFolder]
      )
    )
}
