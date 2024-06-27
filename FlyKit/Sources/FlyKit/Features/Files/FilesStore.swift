//
// FilesStore.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
// swiftlint:disable:next type_body_length
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
    var selectedFilesUrlSet = Set<URL>()
    var editMode = EditMode.inactive

    var isMovingFile = false
    var isCopyingFile = false
    var pasteAllFiles = false

    var showBannerView = false
    var showUploadView = false
    var showDownloadView = false
    var showFilesPicker = false
    var showPhotosPicker = false

    @Presents var alertView: AlertStore.State?
    @Presents var scanQRCodeView: ScanQRStore.State?

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

    var selectedFilesUrls: [URL] {
      files.enumerated()
        .filter { selectedFiles.contains($0.element.id) }
        .map(\.offset)
        .map { files[$0].url }
    }
  }

  public enum Action: BindableAction {
    case loadFiles
    case loadFolder
    case loadPrevious
    case addFile(URL)
    case addFolder(String)
    case copyMove(File, Bool)
    case copyMoveAll(Bool)
    case paste
    case pasteAll
    case removeFile(URL)
    case removeSelectedFiles
    case renameFile(URL, String)
    case archiveFiles
    case downloadFile(String)
    case sortFiles
    case selectAllFiles
    case deSelectAllFiles
    case importPhotos([URL])
    case importFiles(Result<[URL], any Error>)
    case showCreateFolderAlert
    case showFileRenameAlert(File)
    case showErrorAlert(Error)
    case resetState
    case binding(BindingAction<State>)
    case alertView(PresentationAction<AlertStore.Action>)
    case scanQRCodeView(PresentationAction<ScanQRStore.Action>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
    Reduce { state, action in
      switch action {

      case .loadFiles:
        do {
          let files = try dependencies.filesManager.filesAtCurrentDirectory()
          state.files = files
          return .send(.sortFiles)
        } catch {
          return .send(.showErrorAlert(error))
        }

      case .loadFolder:
        if let folder = state.selectedFolders.last {
          dependencies.filesManager.setCurrentDirectory(to: folder)
          return .send(.loadFiles)
        }

      case .loadPrevious:
        if state.selectedFolders.isEmpty == false {
          state.selectedFolders.removeLast()
        }
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
        do {
          let folderPath = try dependencies.filesManager.create(folder: name)
          return .concatenate(.send(.addFile(folderPath)), .send(.sortFiles))
        } catch {
          return .send(.showErrorAlert(error))
        }

      case let .copyMove(file, isMovingFile):
        state.selectedFile = file
        state.pasteAllFiles = false
        state.isMovingFile = isMovingFile
        state.isCopyingFile = isMovingFile == false

      case let .copyMoveAll(isMovingFile):
        state.pasteAllFiles = true
        state.isMovingFile = isMovingFile
        state.isCopyingFile = isMovingFile == false
        state.selectedFilesUrlSet = Set(state.selectedFilesUrls)

      case .paste:
        guard let selectedFile = state.selectedFile else { return .none }
        do {
          try dependencies.filesManager.copyFile(
            from: selectedFile.url, shouldMove: state.isMovingFile
          )
          return .concatenate(.send(.resetState), .send(.loadFiles))
        } catch {
          return .send(.showErrorAlert(error))
        }

      case .pasteAll:
        return .concatenate(
          .merge(state.selectedFilesUrlSet.map {
            try? dependencies.filesManager.copyFile(from: $0, shouldMove: state.isMovingFile)
            return Effect.none
          }),
          .send(.deSelectAllFiles), .send(.resetState), .send(.loadFiles)
        )

      case let .removeFile(url):
        if let index = state.files.firstIndex(where: { $0.url == url }) {
          state.files.remove(at: index)
          try? dependencies.filesManager.remove(at: url)
        }

      case .removeSelectedFiles:
        return .concatenate(
          .merge(state.selectedFilesUrls.map {
            Effect.send(Action.removeFile($0))
          }),
          .send(.deSelectAllFiles)
        )

      case let .renameFile(url, filename):
        do {
          guard let index = state.files.firstIndex(where: { $0.url == url }) else { return .none }
          let url = try dependencies.filesManager.rename(at: state.files[index].url, to: filename)
          guard let file = dependencies.filesManager.file(for: url) else { return .none }
          state.files[index] = file
          return .send(.sortFiles)
        } catch {
          return .send(.showErrorAlert(error))
        }

      case .archiveFiles:
        return .run { [state] send in
          do {
            await send(.set(\.alertView, AlertStore.archiveFileAlert()))
            try dependencies.zipManager.zip(files: state.selectedFilesUrls)
            await send(.deSelectAllFiles)
            await send(.set(\.alertView, nil))
            await send(.set(\.showDownloadView, true))
          } catch {
            await send(.showErrorAlert(error))
          }
        }

      case let .downloadFile(filename):
        state.scanQRCodeView = ScanQRStore.downloadState(filename)

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
        state.selectedFilesUrlSet.removeAll()

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
        state.alertView = AlertStore.createFolderAlert()

      case let .showFileRenameAlert(file):
        state.selectedFile = file
        let filename = file.isDirectory ? file.name :
          file.url.deletingPathExtension().lastPathComponent
        state.alertView = AlertStore.fileRenameAlert(filename)

      case let .alertView(.presented(.done(type))):
        switch type {
        case .createFolder:
          if let folderName = state.alertView?.textInputValue
            .trimmingCharacters(in: .whitespacesAndNewlines),
            folderName.isEmpty == false {
            state.alertView?.textInputValue = ""
            return .send(.addFolder(folderName))
          }

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

      case let .showErrorAlert(error):
        state.alertView = nil
        enum CancelID { case error }
        let message = (error as? FileError)?.description ?? error.localizedDescription
        let errorAlert = Effect<Action>
          .send(.set(\.alertView, AlertStore.handleErrorAlert(message: message)))
          .debounce(id: CancelID.error, for: 0.5, scheduler: dependencies.mainQueue)
        return .concatenate(
          .send(.deSelectAllFiles),
          .send(.resetState),
          errorAlert
        )

      case .resetState:
        state.previewFile = nil
        state.selectedFile = nil
        state.isMovingFile = false
        state.isCopyingFile = false
        state.pasteAllFiles = false
        state.showUploadView = false
        state.showDownloadView = false
        state.showFilesPicker = false
        state.showPhotosPicker = false

      case .binding(\.showUploadView):
        state.scanQRCodeView = state.showUploadView ? ScanQRStore.uploadState() : nil

      case .binding(\.showDownloadView):
        state.scanQRCodeView = state.showDownloadView ? ScanQRStore.downloadState() : nil

      case .binding, .alertView, .scanQRCodeView:
        break
      }
      return .none
    }
    .ifLet(\.$alertView, action: \.alertView) {
      AlertStore()
    }
    .ifLet(\.$scanQRCodeView, action: \.scanQRCodeView) {
      ScanQRStore()
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
