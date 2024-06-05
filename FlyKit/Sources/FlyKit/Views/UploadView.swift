//
// UploadView.swift
// Created by Arpit Williams on 05/06/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

struct UploadView: View {

  @Environment(\.dismiss) var dismiss
  @State private var sheetHeight: CGFloat = .zero

  var body: some View {
    VStack {
      close
      title
      qrCodeImage
      spacer
      shareQrCodeInfo
      shareLinkInfo
      spacer
      shareQRCode
      spacer
      shareLink
      Spacer(minLength: 40)
      note
      spacer
    }
    .background(Color(.bananaLead))
    .foregroundStyle(Color(.leadSnow))
    .modify { AnyView(updatePresentation(for: $0)) }
  }

  var spacer: some View {
    Spacer()
      .frame(height: 20)
  }

  var close: some View {
    HStack {
      Spacer()
      Image(systemName: "xmark.circle.fill")
        .font(.title3)
        .imageScale(.large)
        .padding(.top, 16)
        .padding(.trailing, 20)
        .onTapGesture { dismiss() }
    }
  }

  var title: some View {
    Text("QR CODE")
      .font(.system(.title2, design: .rounded).weight(.bold))
  }

  var shareQrCodeInfo: some View {
    Text("Scan this QR code to receive files")
      .multilineTextAlignment(.center)
      .font(.system(.body, design: .rounded).weight(.medium))
  }

  var shareLinkInfo: some View {
    Text("OR share a direct link to the fly server 🐒")
      .multilineTextAlignment(.center)
      .font(.system(.callout, design: .rounded))
  }

  var note: some View {
    Text("NOTE: Please make sure that devices are connected on the same wifi or hotspot network while sending or receving files.")
      .padding(.horizontal, 20)
      .foregroundStyle(Color.red)
      .font(.system(.footnote, design: .default).weight(.medium))
  }

  var qrCodeImage: some View {
    Image
      .generateQRCode(from: "http://\(ProcessInfo().hostName)")
      .interpolation(.none)
      .resizable()
      .scaledToFit()
      .frame(maxWidth: 180, maxHeight: 180)
  }

  var shareQRCode: some View {
    Button("Share QR", systemImage: "qrcode") {}
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(Color(.leadLemon))
      .foregroundStyle(Color(.lemonLead))
      .font(.system(.headline, design: .rounded).weight(.semibold))
      .cornerRadius(12)
  }

  var shareLink: some View {
    Button("Share Link", systemImage: "link") {}
      .padding(.vertical, 12)
      .padding(.horizontal, 16)
      .background(Color(.leadLemon))
      .foregroundStyle(Color(.lemonLead))
      .font(.system(.headline, design: .rounded).weight(.semibold))
      .cornerRadius(12)
  }

  func updatePresentation(for view: some View) -> any View {
    guard #available(iOS 16, *) else { return view }
    return view.presentationDetents([.fraction(0.74)])
      .modify {
        guard #available(iOS 16.4, *) else { return $0 }
        return $0.presentationBackground(Color(.bananaLead))
      }
  }
}

#Preview {
  UploadView()
}
