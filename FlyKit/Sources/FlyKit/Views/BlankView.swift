//
// BlankView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct BlankView: View {

  @Binding var showUploadView: Bool
  @Environment(\.windowSize) var screenSize

  public var body: some View {
    VStack {

      Spacer()

      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: screenSize.width * (iPad ? 0.4 : 0.5))

      Text("Space is Empty 🧑‍🚀")
        .font(.system(iPad ? .largeTitle : .title, design: .rounded))

      Text("Tap the \(Image(systemName: folderFillBadgePlus)) icon on the top right,\nto add your files & photos")
        .padding(20)
        .multilineTextAlignment(.center)
        .font(.system(iPad ? .title2 : .headline, design: .rounded).weight(.medium))

      Text("Or tap below to drop files here,\nIt's quick and easy \(Image(systemName: downArrow))")
        .padding(16)
        .multilineTextAlignment(.center)
        .font(.system(iPad ? .title3 : .body, design: .rounded).weight(.semibold))

      Spacer()

      Button("Drop Files", systemImage: downArrow) {
        showUploadView = true
      }
      .textCase(.uppercase)
      .padding(.vertical, 16)
      .padding(.horizontal, 20)
      .font(.system(iPad ? .title2 : .headline, design: .rounded).weight(.semibold))
      .foregroundStyle(Color(.lemonLead))
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.leadLemon))
      )

      Spacer()
        .frame(height: 20)
    }
    .frame(maxWidth: .infinity)
    .background(Color(.lemonLicorice))
  }
}

#Preview(body: {
  BlankView(
    showUploadView: .constant(false)
  )
})
