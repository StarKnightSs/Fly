//
// UploadView.swift
// Created by Arpit Williams on 07/06/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

struct UploadView: View {

  @Environment(\.dismiss) var dismiss
  @State private var shareLink = false

  var body: some View {
    VStack(spacing: 0) {
      close
      title
      qrCodeImage
      shareQrCodeInfo
      AnyView(shareLinkView)
      shareLinkInfo
      Spacer(minLength: 20)
      note
    }
    .background(Color(.bananaLead))
    .foregroundStyle(Color(.leadSnow))
    .updatePresentationDetent()
    .onDisappear {
      if shareLink {
        share([serverURL])
      }
    }
  }

  var close: some View {
    HStack {
      Spacer()
      Image(systemName: xmarkCircleFill)
        .font(.title3)
        .imageScale(.large)
        .padding(.top, 16)
        .padding(.trailing, 20)
        .onTapGesture { dismiss() }
    }
  }

  var title: some View {
    Text("SCAN CODE")
      .offset(y: -28)
      .font(.system(.title3, design: .rounded)
        .weight(.bold)
      )
  }

  var qrCodeImage: some View {
    Image
      .generateQRCode(from: serverURL.absoluteString)
      .interpolation(.none)
      .resizable()
      .aspectRatio(1, contentMode: .fit)
      .frame(maxWidth: 180)
      .offset(y: -16)
  }

  var shareQrCodeInfo: some View {
    Text("Scan QR Code to upload files")
      .offset(y: -4)
      .font(.system(.body, design: .rounded)
        .weight(.medium)
      )
  }

  var shareLinkView: any View {
    if #available(iOS 16.0, *) {
      ShareLink(item: serverURL) {
        shareLinkLabel
      }
    } else {
      Button {
        shareLink = true
        dismiss()
      } label: {
        shareLinkLabel
      }
    }
  }

  var shareLinkLabel: some View {
    Label("Share Link", systemImage: link)
      .padding(.vertical, 10)
      .padding(.horizontal, 14)
      .background(Color(.leadLemon))
      .foregroundStyle(Color(.lemonLead))
      .font(.system(.callout, design: .rounded).weight(.semibold))
      .cornerRadius(8)
      .padding(.top, 20)
  }

  var shareLinkInfo: some View {
    Text("Or share a direct link for the fly server🐒")
      .padding(.top, 12)
      .padding(.horizontal, 20)
      .multilineTextAlignment(.center)
      .font(.system(.subheadline, design: .rounded)
        .weight(.medium)
      )
  }

  var note: some View {
    Text(
      "NOTE: Please keep the app active & make sure that both devices " +
        "are connected on the same wifi or hotspot network during file transfer."
    )
    .padding(.bottom, 8)
    .padding(.horizontal, 20)
    .foregroundStyle(Color.red)
    .font(.system(.footnote, design: .default).weight(.medium))
  }
}

#Preview {
  UploadView()
}
