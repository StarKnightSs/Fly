//
// FlyStore.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2026 StarKnights Technologies

import AdMob
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
    var appConfig: AppConfig?
    var lastTransferTime = 0.0
    var showProgressView = false
    var isReviewRequested = false
    var progress: FlyServer.Progress = .zero

    // Admob
    var isAdmobActive = false
    let admobView = AdMobView()
    let adCoordinator = AdCoordinator()

    @Presents var alertView: AlertStore.State?
    @Presents var filesView: FilesStore.State? = .init()

    /// The total count of files transferred
    @Shared(.appStorage("fileCount")) var fileCount = 0
  }

  public enum Action: BindableAction {
    case loadServer
    case loadAdmob
    case requestReview
    case trackFileProgress
    case showFileTransferAlert
    case binding(BindingAction<State>)
    case alertView(PresentationAction<AlertStore.Action>)
    case filesView(PresentationAction<FilesStore.Action>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
    Reduce { state, action in
      switch action {

      case .loadServer:
        return .run { send in
          Task { @MainActor in
            var server = dependencies.server
            server.updateHandler = { url, type in
              Task { @MainActor in
                switch type {
                case .POST:
                  send(.filesView(.presented(.addFile(url))))
                case .DELETE:
                  send(.filesView(.presented(.removeFile(url))))
                default:
                  break
                }
              }
            }
            server.start()
            send(.trackFileProgress)
          }
        }

      case .loadAdmob:
        guard state.isAdmobActive == false,
              state.appConfig?.enableAdmob == true
        else { return .none }
        return .run { send in
          await GoogleAdMob.start()
          await send(.set(\.isAdmobActive, true))
          await send(.filesView(.presented(.set(\.showBannerView, true))))
        }

      case .requestReview:
        guard state.isReviewRequested == false,
              state.appConfig?.askReview == true
        else { return .none }
        state.isReviewRequested = true
        return .run { _ in
          Task { @MainActor in
            requestReview()
          }
        }

      case .trackFileProgress:
        return .run { send in
          Task { @MainActor in
            ProgressManager.shared.trackProgress = { currentProgress, elapsedTime, isCancelled in
              send(.filesView(.presented(.set(\.showUploadView, false))))
              send(.set(\.showProgressView, isCancelled == false))
              send(.set(\.progress, currentProgress))
              send(.set(\.lastTransferTime, elapsedTime))
              if isCancelled { send(.showFileTransferAlert) }
            }
          }
        }

      case .showFileTransferAlert:
        state.$fileCount.withLock { $0 += 1 }
        state.alertView = AlertStore.fileTransferAlert(state.lastTransferTime)

      case .alertView(.presented(.dismiss)):
        state.lastTransferTime = 0

        // Show interstitial ad if admob is active
        guard state.isAdmobActive else { return .none }
        return .run { [admobView = state.admobView, adCoordinator = state.adCoordinator] _ in
          Task { @MainActor in
            let ad = try? await adCoordinator.loadInterstitialAd()
            ad?.present(fromRootViewController: admobView.viewController)
          }
        }

      case .binding, .alertView, .filesView:
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

  public static func loadStore(appConfig: AppConfig?) -> StoreOf<Self> {
    .init(initialState: State(appConfig: appConfig)) {
      FlyStore()
    }
  }

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State()) {
      FlyStore()
    }
  }
}
