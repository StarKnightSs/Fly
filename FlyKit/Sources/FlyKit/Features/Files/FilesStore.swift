//
// FilesStore.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
public struct FilesStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  public struct State: Equatable {
    var files = [File]()
    var previewFile: URL?
    var selectedFile: File?
    var selectedFiles = Set<UUID>()
    var selectedFolders = [URL]()
    var editMode = EditMode.inactive
    var showUploadView = false
    var showFilesPicker = false
    var showPhotosPicker = false
    @Presents var alertView: AlertStore.State?

    @Shared(.appStorage("sortName"))
    var sortName = SortType.date.name

    @Shared(.appStorage("sortAscending"))
    var sortAscending = false

    var sortType: SortType {
      SortType.type(for: sortName)
    }

    var allFilesURLs: [URL] {
      files
        .filter { $0.isDirectory == false }
        .map(\.url)
    }
  }

  public enum Action: BindableAction {
    case loadFiles
    case loadFolder
    case loadPrevious
    case addFile(URL)
    case addFolder(String)
    case removeFile(URL)
    case removeSelectedFiles
    case renameFile(URL, String)
    case sortFiles
    case selectAllFiles
    case deSelectAllFiles
    case importPhotos([URL])
    case importFiles(Result<[URL], any Error>)
    case showCreateFolderAlert
    case showFileRenameAlert(File)
    case binding(BindingAction<State>)
    case alertView(PresentationAction<AlertStore.Action>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
    Reduce { state, action in
      switch action {

      case .loadFiles:
        if let files = try? dependencies.filesManager.filesAtCurrentDirectory() {
          state.files = files
          return .send(.sortFiles)
        }

      case .loadFolder:
        if let folder = state.selectedFolders.last {
          dependencies.filesManager.setCurrentDirectory(to: folder)
          return .send(.loadFiles)
        }

      case .loadPrevious:
        state.selectedFolders.removeLast()
        if let selectedFolder = state.selectedFolders.last {
          dependencies.filesManager.setCurrentDirectory(to: selectedFolder)
        } else if let documentsDirectory = try? dependencies.filesManager.documentsDirectory() {
          dependencies.filesManager.setCurrentDirectory(to: documentsDirectory)
        }
        return .send(.loadFiles)

      case let .addFile(url):
        if let file = dependencies.filesManager.file(for: url) {
          state.files.append(file)
          return .send(.sortFiles)
        }

      case let .addFolder(name):
        if name.isEmpty == false,
           let folderPath = try? dependencies.filesManager.create(folder: name) {
          return .concatenate(
            .send(.addFile(folderPath)),
            .send(.sortFiles)
          )
        }

      case let .removeFile(url):
        if let index = state.files.firstIndex(where: { $0.url == url }) {
          state.files.remove(at: index)
          try? dependencies.filesManager.remove(at: url)
        }

      case .removeSelectedFiles:
        return .concatenate(
          .merge(
            state.files.enumerated()
              .filter { state.selectedFiles.contains($0.element.id) }
              .map(\.offset)
              .map {
                let url = state.files[$0].url
                return Effect.send(Action.removeFile(url))
              }
          ),
          .send(.deSelectAllFiles)
        )

      case let .renameFile(url, filename):
        if let index = state.files.firstIndex(where: { $0.url == url }),
           let url = try? dependencies.filesManager.rename(at: state.files[index].url, to: filename),
           let file = dependencies.filesManager.file(for: url) {
          state.files[index] = file
          return .send(.sortFiles)
        }

      case .sortFiles:
        state.files = sortFiles(
          state.files, by: state.sortType,
          isAscending: state.sortAscending
        )

      case .selectAllFiles:
        state.selectedFiles = state.selectedFiles
          .union(state.files.map(\.id))

      case .deSelectAllFiles:
        state.selectedFiles.removeAll()

      case let .importPhotos(urls):
        return .merge(urls.map {
          Effect.send(Action.addFile($0))
        })

      case let .importFiles(result):
        if case let .success(urls) = result {
          return .merge(urls.map { url in
            var effect = Effect<Action>.none
            if url.startAccessingSecurityScopedResource() {
              do {
                let filePath = try dependencies.filesManager.filePath(for: url.lastPathComponent)
                try dependencies.filesManager.copy(from: url, to: filePath)
                effect = .send(.addFile(filePath))
              } catch {
                print(error)
              }
            }
            url.stopAccessingSecurityScopedResource()
            return effect
          })
        }

      case .showCreateFolderAlert:
        state.alertView = .init(
          type: .createFolder,
          title: "Add Folder",
          mainButtonTitle: "Add",
          cancelButtonTitle: "Cancel",
          showTextInput: true,
          textInputTitle: "Folder Name"
        )

      case let .showFileRenameAlert(file):
        state.selectedFile = file
        let filename = file.isDirectory ? file.name :
          file.url.deletingPathExtension().lastPathComponent
        state.alertView = .init(
          type: .renameFile,
          title: "Rename File",
          mainButtonTitle: "Rename",
          cancelButtonTitle: "Cancel",
          showTextInput: true,
          textInputTitle: "File Name",
          textInputValue: filename
        )

      case let .alertView(.presented(.done(type))):
        switch type {
        case .createFolder:
          return .send(.addFolder(state.alertView?.textInputValue ?? ""))

        case .renameFile:
          if let file = state.selectedFile,
             var filename = state.alertView?.textInputValue, filename.isEmpty == false {
            filename = filename.trimmingCharacters(in: .whitespacesAndNewlines)
            filename = file.isDirectory ? filename : (filename + "." + file.type)
            state.selectedFile = nil
            return .send(.renameFile(file.url, filename))
          }

        default:
          break
        }

      case .binding, .alertView:
        break
      }
      return .none
    }
    .ifLet(\.$alertView, action: \.alertView) {
      AlertStore()
    }
  }
}

// MARK: Sort Helpers

extension FilesStore {

  func sortFiles(_ files: [File], by type: SortType, isAscending: Bool) -> [File] {
    switch type {
    case .date:
      sortByDate(files, ascending: isAscending)
    case .name:
      sortByName(files, ascending: isAscending)
    case .size:
      sortBySize(files, ascending: isAscending)
    case .type:
      sortByType(files, ascending: isAscending)
    }
  }

  func sortByDate(_ files: [File], ascending: Bool) -> [File] {
    files.sorted(by: {
      ascending ?
        $0.creationDate < $1.creationDate :
        $0.creationDate > $1.creationDate
    })
  }

  func sortByName(_ files: [File], ascending: Bool) -> [File] {
    files.sorted(by: {
      ascending ?
        $0.name < $1.name :
        $0.name > $1.name
    })
  }

  func sortBySize(_ files: [File], ascending: Bool) -> [File] {
    files.sorted(by: {
      ascending ?
        $0.fileSize < $1.fileSize :
        $0.fileSize > $1.fileSize
    })
  }

  func sortByType(_ files: [File], ascending: Bool) -> [File] {
    files.sorted(by: {
      ascending ?
        $0.type < $1.type :
        $0.type > $1.type
    })
  }
}

// MARK: Load Store

extension FilesStore {

  public static func loadStore() -> StoreOf<Self> {
    .init(initialState: State()) {
      FilesStore()
    }
  }

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(
      files: [.mockFile, .mockFolder]
    )) {
      FilesStore()
    }
  }
}
