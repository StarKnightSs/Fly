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
        .font(.system(.largeTitle, design: .rounded).weight(.heavy))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)

      Text("Offline File Transfer")
        .font(.system(.title, design: .rounded).weight(.semibold))

      Text("Over Wifi & Hotspot Networks")
        .foregroundStyle(Color(.maroon))
        .font(.system(.headline, design: .rounded).weight(.medium))

      Spacer()

      ProgressView()
        .tint(.black)
        .scaleEffect(2.0, anchor: .center)
        .progressViewStyle(CircularProgressViewStyle())

      Spacer()

      Text("Max Upload File Size: 100 GB")
        .font(.system(.headline, design: .rounded).weight(.semibold))

      Text("Supersized File Transfer At The Speed Of Now")
        .multilineTextAlignment(.center)
        .font(.system(.callout, design: .rounded))

      Spacer()
    }
    .background(Color(.lemon))
    .foregroundStyle(Color(.black))
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView()
  }
}
