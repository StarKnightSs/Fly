//
// SettingsMenu.swift
// Created by Arpit Williams on 31/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

public struct SettingsMenu: View {

  let store: StoreOf<FilesStore>

  @State private var isSelected = false

  @Environment(\.colorScheme)
  var colorMode

  @AppStorage("isDarkMode")
  private var isDarkMode: Bool?

  private var isEditing: Bool {
    store.editMode.isEditing
  }

  public var body: some View {
    WithPerceptionTracking {
      if isEditing {
        checkMark
      } else if store.selectedFolders
        .isEmpty == false {
        backButton
      } else {
        lightBulb
      }
    }
  }

  var checkMark: some View {
    Button {
      if isSelected {
        store.send(.deSelectAllFiles)
      } else {
        store.send(.selectAllFiles)
      }
      isSelected.toggle()
    } label: {
      Image(systemName: isSelected ?
        checkmarkCircleFill :
        checkmarkCircle
      )
      .font(iPad ? .title2 : .headline)
      .foregroundStyle(Color(.leadLemon))
      .animateReplace()
      .onAppear {
        isSelected = false
      }
    }
  }

  var lightBulb: some View {
    Button {
      isDarkMode = colorMode == .dark
    } label: {
      Image(systemName: colorMode == .dark ?
        lightBulbOff : lightBulbOn
      )
      .font(iPad ? .title2 : .headline)
      .foregroundStyle(Color(.leadLemon))
      .animateReplace()
    }
  }

  var backButton: some View {
    Button {
      store.send(.loadPrevious)
    } label: {
      Image(systemName: chevronLeft)
        .font(iPad ? .title2 : .headline)
        .foregroundStyle(Color(.leadLemon))
    }
  }
}

#Preview(body: {
  SettingsMenu(
    store: FilesStore.mockStore()
  )
})
