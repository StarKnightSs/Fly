//
// FlyView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLook
import SwiftUI

public struct FlyView: View {

  @State private var previewFile: URL?
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
        Spacer()
          .frame(height: 1)
        List(selection: $viewModel.selectedFiles) {
          ForEach(viewModel.files) { file in
            FileView(file: file)
              .id(viewModel.editMode)
              .listRowSeparator(.hidden)
              .listRowInsets(.init(.zero))
              .onTapGesture {
                if file.isDirectory == false,
                   viewModel.editMode.isEditing == false {
                  viewModel.previewFile = file.url
                }
              }
          }
          .onDelete {
            if viewModel.editMode.isEditing == false {
              viewModel.deleteFile(at: $0.map { $0 })
            }
          }
          .deleteDisabled(viewModel.editMode.isEditing)
        }
        .listStyle(.plain)
        .background(Color(.snowLicorice))
      }
      BottomBar(
        download: { print("Download") },
        upload: { print("Upload") }
      )
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
    .toolbar { Toolbar() }
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

struct FlyView_Previews: PreviewProvider {
  static var previews: some View {
    FlyView()
      .environmentObject(
        FlyViewModel(
          filesManager: FilesManager(fileManager: .default),
          files: [.mockFile, .mockFolder]
        )
      )
  }
}
