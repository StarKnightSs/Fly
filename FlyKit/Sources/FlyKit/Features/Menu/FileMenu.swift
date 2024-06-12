//
// FileMenu.swift
// Created by Arpit Williams on 26/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

public struct FileMenu: View {

  @Perception.Bindable
  var store: StoreOf<FilesStore>

  @State var sortAscending = false
  @State var sortType: SortType = .date

  private var isEditing: Bool {
    store.editMode.isEditing
  }

  public var body: some View {
    WithPerceptionTracking {
      Menu {
        if isEditing {
          ediMenu
        } else {
          fileMenu
        }
      } label: {
        Image(systemName: isEditing ?
          ellipsisCircleFill : folderFillBadgePlus
        )
        .foregroundStyle(Color(.leadLemon))
        .font(.headline)
        .animateBounce(isEditing)
      }
      .onAppear {
        sortType = store.sortType
        sortAscending = store.sortAscending
      }
    }
  }

  var ediMenu: some View {
    Group {

      // Done
      Button {
        store.editMode = .inactive
      } label: {
        Text("Done")
      }

      Divider()

      // Send Files
      Button {
        print("Send")
      } label: {
        Label("Send Files", systemImage: upArrow)
      }
      .disabled(store.selectedFiles.isEmpty == true)

      // Delete
      Button(role: .destructive) {
        store.editMode = .inactive
        store.send(.removeSelectedFiles)
      } label: {
        Label("Delete", systemImage: trash)
      }
    }
  }

  var fileMenu: some View {
    VStack {

      if store.files.isEmpty == false {

        // Select
        Button {
          store.editMode = .active
        } label: {
          Label("Select", systemImage: checkmarkCircle)
        }

        Divider()

        // Recieve Files
        Button {
          store.showUploadView = true
        } label: {
          Label("Recieve Files", systemImage: downArrow)
        }

        Divider()
      }

      // Add Files
      Button {
        store.showFilesPicker = true
      } label: {
        Label("Add Files", systemImage: docFill)
      }

      // Add Photos
      Button {
        store.showPhotosPicker = true
      } label: {
        Label("Add Photos", systemImage: photo)
      }

      // Add Folder
      Button {
        store.send(.showCreateFolderAlert)
      } label: {
        Label("Add Folder", systemImage: folderFill)
      }

      // Sort Menu
      if store.files.isEmpty == false {
        Divider()
        sortMenu
      }
    }
  }

  var sortMenu: some View {
    Picker(selection: $sortType.didSet(handleSort)) {
      ForEach(SortType.allCases, id: \.self) { type in
        if type == sortType {
          Label(
            type.name,
            systemImage: sortAscending ? chevronUp : chevronDown
          )
        } else {
          Text(type.name)
        }
      }
    } label: {
      Label("Sort By", systemImage: squareGrid3x3)
    }
    .pickerStyle(.menu)
  }

  func handleSort(newSort: SortType, oldSort: SortType) {
    if newSort == oldSort {
      sortAscending.toggle()
    } else {
      switch newSort {
      case .date, .size:
        sortAscending = false
      case .name, .type:
        sortAscending = true
      }
    }

    // Update sort name & sort ascending in files store
    store.sortName = newSort.name
    store.sortAscending = sortAscending

    // Trigger sort
    store.send(.sortFiles)
  }
}

#Preview(body: {
  FileMenu(
    store: FilesStore.mockStore()
  )
})
