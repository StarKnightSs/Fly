//
// FileListView.swift
// Created by Arpit Williams on 28/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

struct FileListView: View {

  @EnvironmentObject private var viewModel: FlyViewModel
  var hideFiles = false

  var body: some View {
    List(selection: $viewModel.selectedFiles) {
      ForEach(
        viewModel.files.filter {
          guard hideFiles else { return true }
          return $0.isDirectory
        }
      ) { file in
        FileView(file: file)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(.zero))
          .onTapGesture {
            if file.isDirectory == false,
               viewModel.editMode.isEditing == false {
              viewModel.previewFile = file.url
            }
          }
          .deleteDisabled(
            (iOS16 || iOS17) ? viewModel.editMode.isEditing : false
          )
      }
      .onDelete {
        viewModel.removeFiles(at: $0.map { $0 })
      }
    }
    .listStyle(.plain)
    .background(Color(.snowLicorice))
    .if(iOS16 || iOS17) {
      $0.id(viewModel.editMode)
    }
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
