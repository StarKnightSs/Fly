//
// FileMenu.swift
// Created by Arpit Williams on 12/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

public struct FileMenu: View {

  @Perception.Bindable
  var store: StoreOf<FilesStore>

  @State var animate = false
  @State var sortAscending = false
  @State var sortType: SortType = .date

  private var isEditing: Bool {
    store.editMode.isEditing
  }

  private var isMovingFile: Bool {
    store.isMovingFile || store.isCopyingFile
  }

  private var isNotSelected: Bool {
    store.selectedFiles.isEmpty
  }

  public var body: some View {
    WithPerceptionTracking {
      if isMovingFile {
        pasteView
      } else {
        menuView
      }
    }
  }

  var menuView: some View {
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

  var pasteView: some View {
    Button {
      store.send(
        store.pasteAllFiles ? .pasteAll : .paste
      )
    } label: {
      Image(systemName: listBulletClipboard)
        .foregroundStyle(Color(.leadLemon))
        .font(.headline)
        .animateBounce(animate)
        .onAppear { animate.toggle() }
    }
  }
}

// MARK: Edit Menu

extension FileMenu {

  var ediMenu: some View {
    Group {
      done
      Divider()
      send
      Divider()
      copy
      move
      delete
    }
  }

  var done: some View {
    Button {
      store.editMode = .inactive
      store.send(.deSelectAllFiles)
    } label: {
      Text("Done")
    }
  }

  var send: some View {
    Button {
      store.editMode = .inactive

      // Download file without archiving if only 1 file is selected
      if let fileUrl = store.selectedFilesUrls.first,
         store.selectedFilesUrls.count == 1,
         fileUrl.isDirectory == false {
        let fileName = fileUrl.lastPathComponent
        store.send(.downloadFile(fileName))
      }

      // Archive files for download if only single folder or more than 1 files are selected
      else if (store.selectedFilesUrls.count == 1 &&
        store.selectedFilesUrls.first?.isDirectory == true) ||
        store.selectedFiles.count > 1 {
        store.send(.archiveFiles(store.selectedFilesUrls))
      }
    } label: {
      Label("Send Files", systemImage: upArrow)
    }.disabled(isNotSelected)
  }

  var copy: some View {
    Button {
      store.editMode = .inactive
      store.send(.copyMoveAll(false))
    } label: {
      Label("Copy", systemImage: docOnDoc)
    }
  }

  var move: some View {
    Button {
      store.editMode = .inactive
      store.send(.copyMoveAll(true))
    } label: {
      Label("Move", systemImage: folder)
    }
  }

  var delete: some View {
    Button(role: .destructive) {
      store.editMode = .inactive
      store.send(.removeSelectedFiles)
    } label: {
      Label("Delete", systemImage: trash)
    }
  }
}

// MARK: File Menu

extension FileMenu {

  var fileMenu: some View {
    VStack {
      if store.files.isEmpty == false {
        selectFile
        Divider()
        recieveFile
        Divider()
      }
      addFiles
      addPhotos
      addFolder
      if store.files.isEmpty == false {
        Divider()
        sortMenu
      }
    }
  }

  var selectFile: some View {
    Button {
      store.editMode = .active
    } label: {
      Label("Select", systemImage: checkmarkCircle)
    }
  }

  var recieveFile: some View {
    Button {
      store.showUploadView = true
    } label: {
      Label("Recieve Files", systemImage: downArrow)
    }
  }

  var addFiles: some View {
    Button {
      store.showFilesPicker = true
    } label: {
      Label("Add Files", systemImage: docFill)
    }
  }

  var addPhotos: some View {
    Button {
      store.showPhotosPicker = true
    } label: {
      Label("Add Photos", systemImage: photo)
    }
  }

  var addFolder: some View {
    Button {
      store.send(.showCreateFolderAlert)
    } label: {
      Label("Add Folder", systemImage: folderFill)
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
