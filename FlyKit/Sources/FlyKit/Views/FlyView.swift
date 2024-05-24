//
// FlyView.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLook
import SwiftUI

public struct FlyView: View {

  @State private var selectedFile: URL?
  @EnvironmentObject private var viewModel: FlyViewModel

  public init() {}

  public var body: some View {
    NavigationView {
      VStack(spacing: 0) {

        if viewModel.files.isEmpty {
          BlankView()
        } else {
          List {
            ForEach(viewModel.files.map(\.url), id: \.path) { file in
              Text(file.lastPathComponent)
                .onTapGesture {
                  selectedFile = file
                }
            }
            .onDelete { viewModel.deleteFile(at: $0.map { $0 }) }
          }
          .padding(.top, 1)
        }

        BottomBar(
          download: { print("Download") },
          upload: { print("Upload") }
        )
      }
      .background(Color(.background))
      .navigationBarTitleDisplayMode(.inline)
      .quickLookPreview($selectedFile)
      .toolbar { Toolbar() }
      .onAppear {
        viewModel.server.start()
        viewModel.loadFiles()
      }
    }
  }
}

struct FlyView_Previews: PreviewProvider {
  static var previews: some View {
    FlyView()
      .environmentObject(
        FlyViewModel(
          filesManager: FilesManager(fileManager: .default)
        )
      )
  }
}
