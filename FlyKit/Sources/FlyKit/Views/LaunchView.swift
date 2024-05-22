//
// LaunchView.swift
// Created by Arpit Williams on 19/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct LaunchView: View {

  public init() {}

  public var body: some View {
    VStack {
      Spacer()
      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(20)

      Text("Fly Server")
        .foregroundColor(.black)
        .font(.system(.largeTitle, design: .rounded).weight(.semibold))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)

      Text("Offline File Transfer")
        .foregroundColor(.black)
        .font(.system(.title, design: .rounded).weight(.semibold))

      Text("Over Wifi & Hotspot Networks")
        .foregroundColor(Color(hex: 0x942193))
        .font(.system(.headline, design: .rounded).weight(.medium))

      Spacer()

      ProgressView()
        .tint(.black)
        .scaleEffect(2.0, anchor: .center)
        .progressViewStyle(CircularProgressViewStyle())

      Spacer()

      Text("Max Upload File Size: 100 GB")
        .foregroundColor(.black)
        .font(.system(.headline, design: .rounded).weight(.semibold))

      Text("Supersized File Transfer At The Speed Of Now")
        .multilineTextAlignment(.center)
        .foregroundColor(.black)
        .font(.system(.callout, design: .rounded))

      Spacer()
    }
    .background(Color(hex: 0xF5EC00))
    .preferredColorScheme(.light)
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView()
  }
}
