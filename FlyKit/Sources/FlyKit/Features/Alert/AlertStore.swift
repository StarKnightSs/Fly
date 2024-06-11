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
    var autoDismiss: Bool = false
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
