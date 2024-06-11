//
// Toolbar.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

public struct Toolbar: ToolbarContent {

  let store: StoreOf<FlyStore>

  @State private var refresh = false

  public var body: some ToolbarContent {

    ToolbarItem(placement: .topBarLeading) {
      SettingsMenu(store: store)
    }

    ToolbarItem(placement: .principal) {
      titleView
    }

    ToolbarItem(placement: .topBarTrailing) {
      FileMenu(store: store)
    }
  }

  var titleView: some View {
    HStack(spacing: 4) {
      Image("Monkey", bundle: .module)
        .resizable()
        .frame(width: 40, height: 40)

      Text(title)
        .foregroundStyle(Color(.leadLemon))
        .font(.system(.callout, design: .rounded).weight(.heavy))
    }
    .id(refresh)
    .onAppear {
      refresh.toggle()
    }
  }

  var title: String {
    if let selectedFiles = store.filesView?.selectedFiles,
       store.editMode.isEditing {
      if selectedFiles.isEmpty {
        "Select files"
      } else {
        "\(selectedFiles.count) Files"
      }
    } else {
      "Fly Server"
    }
  }
}

#Preview(body: {
  NavigationView {
    VStack {}
      .toolbar {
        Toolbar(store: FlyStore.mockStore())
      }
  }
})
