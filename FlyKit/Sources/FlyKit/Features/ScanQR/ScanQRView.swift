//
// ScanQRView.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

public struct ScanQRView: View {

  @Perception.Bindable
  var store: StoreOf<ScanQRStore>

  @State private var shareLink = false
  @Environment(\.windowSize) var screenSize

  public var body: some View {
    VStack(spacing: 0) {
      close
      if iPad || (iOS16 == false) {
        Spacer()
      }
      title
      qrCodeImage
      message
      AnyView(shareLinkView)
      shareLinkInfo
      Spacer(minLength: 20)
      note
    }
    .background(
      getLinearGradient([Color(.bananaLead), Color(.lemonLicorice)])
        .ignoresSafeArea(edges: .bottom)
    )
    .foregroundStyle(Color(.leadSnow))
    .updatePresentationDetent()
    .onDisappear {
      if shareLink {
        share([store.shareUrl])
      }
    }
    .modify { view in
      WithPerceptionTracking { view }
    }
  }

  var close: some View {
    HStack {
      Spacer()
      Button {
        store.send(.dismiss)
      } label: {
        Image(systemName: xmarkCircleFill)
          .font(iPad ? .title2 : .title3)
          .imageScale(.large)
          .padding(.top, 16)
          .padding(.trailing, 20)
      }
    }
  }

  var title: some View {
    Text(store.title ?? "")
      .offset(y: -28)
      .font(.system(iPad ? .title : .title3, design: .rounded)
        .weight(.bold)
      )
  }

  var qrCodeImage: some View {
    Image
      .generateQRCode(from: store.qrCode ?? "")
      .interpolation(.none)
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .frame(maxWidth: screenSize.width * (iPad ? 0.3 : 0.4))
      .offset(y: -16)
  }

  var message: some View {
    Text(store.message ?? "")
      .offset(y: -4)
      .font(.system(iPad ? .title3 : .body, design: .rounded)
        .weight(.medium)
      )
  }

  var shareLinkView: any View {
    if #available(iOS 16.0, *) {
      ShareLink(
        item: store.shareUrl,
        label: { shareLinkLabel }
      )
    } else {
      Button {
        shareLink = true
        store.send(.dismiss)
      } label: {
        shareLinkLabel
      }
    }
  }

  var shareLinkLabel: some View {
    Label(store.shareLink ?? "", systemImage: link)
      .padding(.vertical, 10)
      .padding(.horizontal, 14)
      .background(Color(.leadLemon))
      .foregroundStyle(Color(.lemonLead))
      .font(.system(iPad ? .title2 : .callout, design: .rounded).weight(.semibold))
      .cornerRadius(8)
      .padding(.top, 20)
  }

  var shareLinkInfo: some View {
    Text(store.shareLinkInfo ?? "")
      .padding(.top, 12)
      .padding(.horizontal, 20)
      .multilineTextAlignment(.center)
      .font(.system(iPad ? .title3 : .subheadline, design: .rounded)
        .weight(.medium)
      )
  }

  var note: some View {
    Text(store.note ?? "")
      .padding(.bottom, 8)
      .padding(.horizontal, 20)
      .foregroundStyle(Color.red)
      .font(.system(iPad ? .callout : .footnote, design: .default).weight(.medium))
  }
}

#Preview {
  ScanQRView(
    store: ScanQRStore.mockStore()
  ).setPreviewWindowSize()
}
