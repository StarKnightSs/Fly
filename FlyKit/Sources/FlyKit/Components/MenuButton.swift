//
// MenuButton.swift
// Created by Arpit Williams on 02/09/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

struct MenuButton: View {

  let image: String
  let title: String
  let action: (() -> Void)?

  var body: some View {
    Button(
      action: { action?() },
      label: {
        VStack(spacing: 8) {
          Image(systemName: image)
            .font(iPad ? .title2 : .headline)
            .padding(8)
            .background(Color(.lemonLead))
            .foregroundStyle(Color(.leadLemon))
            .clipShape(Circle())
            .animateReplace()
          Text(title)
            .font(.system(.caption2, design: .rounded).weight(.medium))
            .foregroundStyle(Color(.lemonLead))
        }
      }
    )
  }
}

#Preview {
  MenuButton(
    image: lightBulbOn, title: "Light Mode", action: nil
  )
}
