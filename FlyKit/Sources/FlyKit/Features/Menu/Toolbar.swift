//
// Toolbar.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

public struct Toolbar: ToolbarContent {

  let store: StoreOf<FilesStore>
  @State private var refresh = false

  public var body: some ToolbarContent {
    WithPerceptionTracking {
      ToolbarItem(placement: .topBarLeading) {
        SettingsMenu(store: store)
      }

      ToolbarItem(placement: .principal) {
        WithPerceptionTracking {
          titleView
        }
      }

      ToolbarItem(placement: .topBarTrailing) {
        FileMenu(store: store)
      }
    }
  }

  var titleView: some View {
    HStack(spacing: 4) {
      Image("Monkey", bundle: .module)
        .resizable()
        .frame(width: iPad ? 54 : 40, height: iPad ? 54 : 40)
        .animation(.bouncy, value: title)

      Text(title)
        .foregroundStyle(Color(.leadLemon))
        .font(.system(iPad ? .title2 : .callout, design: .rounded).weight(.heavy))
        .animation(.smooth, value: title)
    }
    .id(refresh)
    .onAppear {
      refresh.toggle()
    }
  }

  var title: String {
    if store.editMode.isEditing {
      store.selectedFiles.isEmpty ?
        "Select files" :
        "\(store.selectedFiles.count) Files"
    } else if let folder = store.selectedFolders
      .last?.lastPathComponent {
      folder
    } else {
      "Fly Server"
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}
      .toolbar {
        Toolbar(
          store: FilesStore.mockStore()
        )
      }
  }
})
