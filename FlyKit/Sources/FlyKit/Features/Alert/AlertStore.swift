//
// AlertStore.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
public struct AlertStore {

  @ObservableState
  public struct State: Equatable {
    let type: AlertType
    var title: String?
    var message: String?
    var image: Image?
    var mainButtonTitle: String?
    var cancelButtonTitle: String?
    var showTextInput = false
    var textInputTitle: String?
    var textInputValue = ""
    var titleColor: Color = Color(.leadBanana)
    var messageColor: Color = Color(.licoriceLemon)
    var showProgress = false
    var autoDismiss: Bool = false
    var dismissOnTap: Bool = true
    var dismissDuration = 2
    var spacing = 20.0
  }

  public enum Action: BindableAction {
    case done(AlertType)
    case dismiss(AlertType)
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none
      default:
        return .run { _ in
          await self.dismiss(animation: .default)
        }
      }
    }
  }
}

// MARK: Static States

extension AlertStore {

  static func createFolderAlert() -> State {
    .init(
      type: .createFolder,
      title: "Add Folder",
      mainButtonTitle: "Add",
      cancelButtonTitle: "Cancel",
      showTextInput: true,
      textInputTitle: "Folder Name"
    )
  }

  static func fileRenameAlert(_ filename: String) -> State {
    .init(
      type: .renameFile,
      title: "Rename File",
      mainButtonTitle: "Rename",
      cancelButtonTitle: "Cancel",
      showTextInput: true,
      textInputTitle: "File Name",
      textInputValue: filename
    )
  }

  static func fileTransferAlert(_ totalTime: Double) -> State {
    .init(
      type: .fileTransferTime,
      title: "Transferred in \(format(totalTime))⌛️",
      image: Image("Monkey", bundle: .module),
      autoDismiss: true,
      spacing: 0
    )
  }

  static func archiveFileAlert() -> State {
    .init(
      type: .archiveFile,
      title: "Archiving Files",
      message: "Please wait,\nPreparing download...",
      image: Image("Monkey", bundle: .module),
      showProgress: true,
      dismissOnTap: false,
      spacing: 8
    )
  }

  static func unexpectedErrorAlert(message: String? = nil) -> State {
    .init(
      type: .unexpectedError,
      title: "Unexpected Error",
      message: message,
      image: Image("Monkey", bundle: .module),
      autoDismiss: true,
      spacing: 8
    )
  }
}

// MARK: Mock Store

extension AlertStore {
  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(
      type: .createFolder,
      title: "Title",
      message: "Message",
      mainButtonTitle: "OK",
      cancelButtonTitle: "Cancel"
    )) {
      AlertStore()
    }
  }
}
