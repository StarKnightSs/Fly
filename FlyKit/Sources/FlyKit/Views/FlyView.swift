//
// FlyView.swift
// Created by Arpit Williams on 06/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import QuickLook
import SwiftUI

public struct FlyView: View {

  @Environment(\.scenePhase) private var scenePhase
  @EnvironmentObject private var viewModel: FlyViewModel

  public init() {}

  public var body: some View {
    NavigationView {
      ZStack {
        rootView
        if viewModel.showFolderAlert {
          folderAlert
        } else if viewModel.showRenameAlert {
          renameAlert
        } else if viewModel.showTransferAlert {
          transferAlert
        } else if viewModel.showProgressView {
          progressView
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
    .onChange(of: viewModel.files) {
      if $0.isEmpty {
        viewModel.editMode = .inactive
      }
    }
    .onChange(of: scenePhase) {
      if $0 == .active {
        viewModel.loadServer()
      }
    }
    .toolbar {
      Toolbar(
        editMode: $viewModel.editMode,
        selectedFiles: $viewModel.selectedFiles
      )
    }
    .quickLookPreview(
      $viewModel.previewFile,
      in: viewModel.allFilesURLs
    )
    .fileImporter(
      isPresented: $viewModel.showFilesPicker,
      allowedContentTypes: FilesManager.supportedTypes,
      allowsMultipleSelection: true,
      onCompletion: { viewModel.importFiles(result: $0) }
    )
    .sheet(isPresented: $viewModel.showPhotosPicker) {
      PhotosPicker(
        filesManager: viewModel.filesManager,
        onCompletion: { viewModel.importPhotos(from: $0) }
      ).ignoresSafeArea(edges: .bottom)
    }
    .sheet(isPresented: $viewModel.showUploadView) {
      UploadView()
    }
  }

  var folderAlert: some View {
    AlertView(
      title: "Add Folder",
      mainButtonTitle: "Add",
      cancelButtonTitle: "Cancel",
      textInputTitle: "Folder Name",
      textInputValue: $viewModel.folderName,
      done: { viewModel.folderAlertDone() },
      dismiss: { viewModel.folderAlertDismiss() }
    )
  }

  var renameAlert: some View {
    AlertView(
      title: "Rename File",
      mainButtonTitle: "Rename",
      cancelButtonTitle: "Cancel",
      textInputTitle: "File Name",
      textInputValue: $viewModel.fileRename,
      done: { viewModel.renameAlertDone() },
      dismiss: { viewModel.renameAlertDismiss() }
    )
  }

  var transferAlert: some View {
    AlertView(
      title: "Transferred in \(format(viewModel.lastTransferTime))⌛️",
      image: Image("Monkey", bundle: .module),
      autoDismiss: true,
      dismissDuration: 4,
      spacing: 0,
      dismiss: { viewModel.showTransferAlert = false }
    )
  }

  var progressView: some View {
    ProgressView(value: viewModel.progress.value, total: 100.0)
      .progressViewStyle(FileProgressView())
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
