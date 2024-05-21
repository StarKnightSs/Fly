//
// FlyView.swift
// Created by Arpit Williams on 23/09/23.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FlyView: View {

  @StateObject var server = FileServer()

  public init() {}

  public var body: some View {
    NavigationView {
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
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(ProcessInfo().hostName)
        }
      }
    }
    .onAppear {
      server.start()
      server.loadFiles()
    }
  }
}

struct FlyView_Previews: PreviewProvider {
  static var previews: some View {
    FlyView()
  }
}
