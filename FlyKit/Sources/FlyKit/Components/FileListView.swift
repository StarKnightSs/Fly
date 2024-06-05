//
// FileListView.swift
// Created by Arpit Williams on 28/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

struct FileListView: View {

  var hideFiles = false
  @EnvironmentObject private var viewModel: FlyViewModel

  var body: some View {
    List(selection: $viewModel.selectedFiles) {
      ForEach(viewModel.files.filter {
        guard hideFiles else { return true }
        return $0.isDirectory
      }) {
        FileView(file: $0)
          .deleteDisabled(true)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(.zero))
      }
    }
    .padding(.top, 2)
    .listStyle(.plain)
    .id(viewModel.editMode)
    .background(Color(.snowLicorice))
  }
}

#Preview {
  FileListView()
    .environmentObject(
      FlyViewModel(
        filesManager: FilesManager(fileManager: .default),
        files: [.mockFile, .mockFolder]
      )
    )
}
