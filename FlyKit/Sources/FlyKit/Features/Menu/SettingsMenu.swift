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
        slideMenu
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

  var slideMenu: some View {
    Button {
      store.send(.binding(.set(\.showMenu, true)))
    } label: {
      Image(systemName: gearshapeFill)
        .font(iPad ? .title2 : .headline)
        .foregroundStyle(Color(.leadLemon))
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
