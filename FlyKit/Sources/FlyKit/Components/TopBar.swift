//
// TopBar.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct TopBar: ToolbarContent {

  var gearTapped: (() -> Void)?
  var addFolder: ((String) -> Void)?
  var addFiles: (() -> Void)?
  var addPhotos: (() -> Void)?
  var sortBy: ((String) -> Void)?

  @State var folderName = ""
  @State var showFolderAlert = false

  public var body: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      Image(systemName: "gearshape.fill")
        .foregroundStyle(Color.black)
        .font(.headline)
        .offset(y: 1.2)
        .onTapGesture {
          gearTapped?()
        }
    }

    ToolbarItem(placement: .principal) {
      HStack(spacing: 4) {

        Image("Monkey", bundle: .module)
          .resizable()
          .frame(width: 40, height: 40)

        Text("File Server")
          .foregroundStyle(Color.black)
          .font(.system(.callout, design: .rounded).weight(.heavy))
      }
    }

    ToolbarItem(placement: .topBarTrailing) {
      Menu {

        Button { showFolderAlert = true } label: {
          Label("New Folder", systemImage: "folder.fill")
        }

        Button { addFiles?() } label: {
          Label("Add Files", systemImage: "doc.fill")
        }

        Button { addPhotos?() } label: {
          Label("Import Photos", systemImage: "photo.badge.plus.fill")
        }

        Menu("Sort By", systemImage: "square.grid.3x3") {

          Button { sortBy?("Name") } label: {
            Text("Name")
          }

          Button { sortBy?("Type") } label: {
            Text("Type")
          }

          Button { sortBy?("Date") } label: {
            Text("Date")
          }

          Button { sortBy?("Size") } label: {
            Text("Size")
          }
        }
      } label: {
        Image(systemName: "folder.fill.badge.plus")
          .foregroundStyle(Color.black)
          .font(.headline)
      }
      .alert("Add Folder", isPresented: $showFolderAlert) {
        TextField("Folder Name", text: $folderName)
        Button("Cancel", role: .cancel, action: {})
        Button("Ok", action: { addFolder?(folderName) })
      }
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}.toolbar {
      TopBar()
    }
  }
})
