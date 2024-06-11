//
// FlyStore.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
public struct FlyStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  public struct State: Equatable {
    var lastTransferTime = 0.0
    var showProgressView = false
    var editMode = EditMode.inactive
    var progress: FlyServer.Progress = .zero

    @Presents
    var alertView: AlertStore.State?

    @Presents
    var filesView: FilesStore.State?

    var hasFiles: Bool {
      filesView?.files.isEmpty == false
    }
  }

  public enum Action: BindableAction {
    case loadFiles
    case loadServer
    case showFileTransferAlert
    case trackFileProgress
    case binding(BindingAction<State>)
    case alertView(PresentationAction<AlertStore.Action>)
    case filesView(PresentationAction<FilesStore.Action>)
  }

  @Reducer
  public enum Destination {
    case alert(AlertStore)
    case fileView(FilesStore)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
    Reduce { state, action in
      switch action {

      case .loadFiles:
        state.filesView = .init()
        return .send(.filesView(.presented(.loadFiles)))

      case .loadServer:
        return .run { send in
          Task { @MainActor in
            var server = dependencies.server
            server.updateHandler = { url, type in
              switch type {
              case .POST:
                send(.filesView(.presented(.addFile(url))))
              case .DELETE:
                send(.filesView(.presented(.removeFile(url))))
              default:
                break
              }
            }
            server.start()
            send(.trackFileProgress)
          }
        }

      case .trackFileProgress:
        return .run { send in
          Task { @MainActor in
            ProgressManager.shared.trackProgress = { currentProgress, elapsedTime, isCancelled in
              send(.set(\.showProgressView, isCancelled == false))
              send(.set(\.progress, currentProgress))
              send(.set(\.lastTransferTime, elapsedTime))
              if isCancelled { send(.showFileTransferAlert) }
            }
          }
        }

      case .showFileTransferAlert:
        state.alertView = .init(
          type: .fileTransferTime,
          title: "Transferred in \(format(state.lastTransferTime))⌛️",
          image: Image("Monkey", bundle: .module),
          autoDismiss: true,
          spacing: 0
        )

      case let .alertView(action):
        if case let .presented(action) = action,
           case .dismiss = action {
          state.lastTransferTime = 0
        }

      case .binding(\.editMode):
        // Update edit mode in files store
        let editMode = state.editMode
        state.filesView?.editMode = editMode

      case .binding:
        break

      case .filesView:
        break
      }
      return .none
    }
    .ifLet(\.$alertView, action: \.alertView) {
      AlertStore()
    }
    .ifLet(\.$filesView, action: \.filesView) {
      FilesStore()
    }
  }
}

// MARK: Load Store

extension FlyStore {

  public static func loadStore() -> StoreOf<Self> {
    .init(initialState: State()) {
      FlyStore()
    }
  }

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State()) {
      FlyStore()
    }
  }
}
