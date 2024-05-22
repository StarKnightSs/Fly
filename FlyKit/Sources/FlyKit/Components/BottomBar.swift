//
// BottomBar.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct BottomBar: View {

  var download: (() -> Void)?
  var upload: (() -> Void)?

  public var body: some View {
    HStack {
      Spacer()
      Spacer()
      Group {
        Label("Download", systemImage: downloadIcon)
          .onTapGesture { download?() }
        Label("Upload", systemImage: uploadIcon)
          .onTapGesture { upload?() }
      }
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .textCase(.uppercase)
      .foregroundStyle(Color.black)
      .font(.system(.headline, design: .rounded).weight(.semibold))
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.lemon))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(.black, lineWidth: 2)
      )
      Spacer()
      Spacer()
    }
    .padding(.vertical, 16)
    .background(Color(.white))
  }

  var downloadIcon: String {
    if #available(iOS 17, *) {
      "arrowshape.down.fill"
    } else {
      "arrowtriangle.down.fill"
    }
  }

  var uploadIcon: String {
    if #available(iOS 17, *) {
      "arrowshape.up.fill"
    } else {
      "arrowtriangle.up.fill"
    }
  }
}

#Preview(body: {
  BottomBar()
})
