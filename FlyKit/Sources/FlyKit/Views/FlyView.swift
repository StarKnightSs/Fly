//
// FlyView.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLook
import SwiftUI

public struct FlyView: View {

  @State private var previewFile: URL?
  @EnvironmentObject private var viewModel: FlyViewModel

  public init() {}

  public var body: some View {
    // swiftlint:disable:next closure_body_length
    NavigationView {
      VStack(spacing: 0) {

        if viewModel.files.isEmpty {
          BlankView()

        } else {

          Spacer()
            .frame(height: 1)

          List {
            ForEach(viewModel.files) { file in
              FileView(file: file)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)
                .onTapGesture {
                  if file.isDirectory == false {
                    previewFile = file.url
                  }
                }
            }
            .onDelete {
              viewModel.deleteFile(at: $0.map { $0 })
            }
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
      .quickLookPreview($previewFile)
      .toolbar { Toolbar() }
      .onAppear {
        viewModel.server.start()
        viewModel.loadFiles()
      }
      .alert("Add Folder", isPresented: $viewModel.showFolderAlert) {
        alertView
      }
      .fileImporter(
        isPresented: $viewModel.showFilesPicker,
        allowedContentTypes: FilesManager.supportedTypes,
        allowsMultipleSelection: true,
        onCompletion: { viewModel.importFiles(result: $0) }
      )
    }
  }

  var alertView: some View {
    VStack {
      TextField("Folder Name", text: $viewModel.folderName)
      Button("Create") {
        viewModel.addFolder(viewModel.folderName)
        viewModel.folderName = ""
      }
      Button("Cancel") {
        viewModel.folderName = ""
        viewModel.showFolderAlert = false
      }
    }
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
