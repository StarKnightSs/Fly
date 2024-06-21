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
    var sharePreview: String?
    var shareLinkInfo: String?
    var note: String?

    var shareUrl: URL {
      URL(string: qrCode ?? "") ?? serverURL
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
  static func uploadState() -> State {
    .init(
      title: "SCAN CODE",
      qrCode: serverURL.absoluteString,
      message: "Scan QR Code to upload files",
      shareLink: "Share Link",
      sharePreview: "Fly Server\nUpload Link ▲",
      shareLinkInfo: "Or share a direct link for the fly server🐒",
      note: "NOTE: Please keep the app active & make sure that both devices " +
        "are connected on the same wifi or hotspot network during file transfer."
    )
  }

  static func downloadState(_ filename: String? = nil) -> State {
    var downloadLink = serverURL
    if let filename {
      // File download link
      downloadLink = downloadLink.appendingPathComponent("/\(filename)")
    } else {
      // Archive download link
      downloadLink = downloadLink.appendingPathComponent("/archive.zip")
    }
    return .init(
      title: "SCAN CODE",
      qrCode: downloadLink.absoluteString,
      message: "Scan QR Code to download file",
      shareLink: "Download Link",
      sharePreview: "Fly Server\nDownload Link ▼",
      shareLinkInfo: "Or share a direct download link for the file 🐒",
      note: "NOTE: Please keep the app active & make sure that both devices " +
        "are connected on the same wifi or hotspot network during file transfer."
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
