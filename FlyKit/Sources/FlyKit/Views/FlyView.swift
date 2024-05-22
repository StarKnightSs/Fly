//
// FlyView.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FlyView: View {

  @StateObject var server = FileServer()

  public init() {}

  public var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        List {
          ForEach(server.fileURLs, id: \.path) { file in
            NavigationLink {
              #if os(iOS)
              FilePreview(url: file)
              #endif
            } label: {
              Text(file.lastPathComponent)
            }
          }
          .onDelete { server.deleteFile(at: $0.map { $0 }) }
        }
        .padding(.top, 1)

        BottomBar(
          download: { print("Download") },
          upload: { print("Upload") }
        )
      }
      .background(Color(.lemon))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        TopBar(
          gearTapped: { print("Gear") },
          folderTapped: { print("Folder") }
        )
      }
      .onAppear {
        server.start()
        server.loadFiles()
      }
    }.preferredColorScheme(.light)
  }
}

struct FlyView_Previews: PreviewProvider {
  static var previews: some View {
    FlyView()
  }
}
