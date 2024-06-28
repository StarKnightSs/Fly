//
// FlyStore.swift
// Created by Arpit Williams on 27/06/24.
// Copyright (c) 2024 StarKnights Technologies

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
    var lastTransferTime = 0.0
    var showProgressView = false
    var progress: FlyServer.Progress = .zero
    @Presents var alertView: AlertStore.State?
    @Presents var filesView: FilesStore.State?

    // The total count of files transferred
    @Shared(.appStorage("fileCount")) var fileCount = 0

    // Admob
    var isAdMobEnabled = false
    let admobView = AdMobView()
    let adCoordinator = AdCoordinator()
  }

  public enum Action: BindableAction {
    case loadServer
    case loadAppConfig
    case showGoogleAds
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

      case .loadAppConfig:
        return .run { [admobView = state.admobView] send in
          Task {
            let appConfig = try await dependencies.appConfigManager.getConfig()
            // Request review
            if appConfig.askReview == true {
              requestReview()
            }
            // Load google admob
            if appConfig.enableAdmob == true {
              do {
                if GoogleAdMob.hasConsent {
                  try await GoogleAdMob.start()
                  await send(.showGoogleAds)
                }
                try await GoogleAdMob.requestConsent(from: admobView)
                await send(.showGoogleAds)
              } catch {
                if (error as? AdMobError) == AdMobError.alreadyLoaded {
                  await send(.showGoogleAds)
                }
              }
            }
          }
        }

      case .showGoogleAds:
        state.isAdMobEnabled = true
        state.filesView?.showBannerView = true

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
        state.fileCount += 1
        state.alertView = AlertStore.fileTransferAlert(state.lastTransferTime)

      case .alertView(.presented(.dismiss)):
        state.lastTransferTime = 0
        guard state.isAdMobEnabled else { return .none }
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
