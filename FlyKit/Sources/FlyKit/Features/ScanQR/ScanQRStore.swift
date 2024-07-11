//
// ScanQRStore.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
public struct ScanQRStore {

  @ObservableState
  public struct State: Equatable {
    var title: String?
    var qrCode: String?
    var message: String?
    var shareLink: String?
    var shareLinkInfo: String?
    var note: String?

    var shareUrl: URL {
      URL(string: qrCode ?? "") ?? serverUrl(for: 80)
    }
  }

  public enum Action: BindableAction {
    case dismiss
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { _, action in
      switch action {
      case .binding:
        return .none
      case .dismiss:
        return .run { _ in
          await self.dismiss(animation: .default)
        }
      }
    }
  }
}

// MARK: Static States

extension ScanQRStore {
  static func uploadState(port: Int) -> State {
    .init(
      title: String.scanCode.uppercased(),
      qrCode: serverUrl(for: port).appendingPathComponent("/upload").absoluteString,
      message: String.scanToUpload,
      shareLink: String.uploadLink,
      shareLinkInfo: String.uploadLinkInfo,
      note: String.scanNote
    )
  }

  static func downloadState(port: Int, filename: String? = nil) -> State {
    var downloadLink = serverUrl(for: port)
    if let filename {
      // File download link
      downloadLink = downloadLink.appendingPathComponent("/download/\(filename)")
    } else {
      // Archive download link
      downloadLink = downloadLink.appendingPathComponent("/download/archive.zip")
    }
    return .init(
      title: String.scanCode.uppercased(),
      qrCode: downloadLink.absoluteString,
      message: String.scanToDownload,
      shareLink: String.downloadLink,
      shareLinkInfo: String.downloadLinkInfo,
      note: String.scanNote
    )
  }
}

// MARK: Mock Store

extension ScanQRStore {
  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(
      title: "Scan Code",
      qrCode: "test.com",
      message: "Scan QR Code",
      shareLink: "Share Link",
      shareLinkInfo: "Share Direct Link",
      note: "Not: Don't dimiss this sheet"
    )) {
      ScanQRStore()
    }
  }
}
