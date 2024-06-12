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
      .font(.headline)
      .foregroundStyle(Color(.leadLemon))
      .animateReplace()
      .onDisappear {
        isSelected = false
        store.send(.deSelectAllFiles)
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
      .font(.headline)
      .foregroundStyle(Color(.leadLemon))
      .animateReplace()
    }
  }
}

#Preview(body: {
  SettingsMenu(
    store: FilesStore.mockStore()
  )
})
