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
      VStack {
        List {
          ForEach(server.fileURLs, id: \.path) { file in
            NavigationLink {
              #if os(iOS)
              FileView(url: file)
              #endif
            } label: {
              Text(file.lastPathComponent)
            }
          }
          .onDelete { server.deleteFile(at: $0.map { $0 }) }
        }
        .background(Color.white)
        .padding(.top, 1)
      }
      .toolbar { ToolBar() }
      .background(Color(.banana))
      .navigationBarTitleDisplayMode(.inline)
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
