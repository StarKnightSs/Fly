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
        Label("Download", systemImage: downArrow)
          .onTapGesture { download?() }
        Label("Upload", systemImage: upArrow)
          .onTapGesture { upload?() }
      }
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .textCase(.uppercase)
      .font(.system(.headline, design: .rounded).weight(.semibold))
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.bananaLead))
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
    .foregroundStyle(Color(.leadLemon))
  }
}

#Preview(body: {
  BottomBar()
})
