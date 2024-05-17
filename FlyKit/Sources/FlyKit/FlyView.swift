//
// FlyView.swift
// Created by Arpit Williams on 23/09/23.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct FlyView: View {

  // swiftlint:disable:next force_try
  @StateObject var server = try! FileServer(port: 8080)

  public init() {}

  public var body: some View {
    NavigationView {
      List {
        ForEach(server.fileURLs, id: \.path) { file in
          NavigationLink {
            FileView(url: file)
          } label: {
            Text(file.lastPathComponent)
          }
        }
        .onDelete { server.deleteFile(at: $0.map { $0 }) }
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text(ProcessInfo().hostName + ":8080")
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
