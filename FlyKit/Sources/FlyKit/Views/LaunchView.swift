//
// LaunchView.swift
// Created by Arpit Williams on 19/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import Resolver
import SwiftUI

public struct LaunchView: View {

  @Environment(\.windowSize) var screenSize

  /// Closure to get app config from launch view
  private var config: ((AppConfig?) -> Void)?
  public init(config: @escaping (AppConfig?) -> Void) {
    self.config = config
  }

  public var body: some View {
    VStack {
      Spacer()
      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: screenSize.width * (iPad ? 0.6 : 1))
        .padding(20)

      Text("FileFlyer")
        .font(.system(.largeTitle, design: .rounded).weight(.heavy))
        .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)

      Text("Offline File Transfer")
        .font(.system(iPad ? .largeTitle : .title, design: .rounded).weight(.semibold))

      Text("Over Wifi & Hotspot Networks")
        .foregroundStyle(Color(.systemIndigo))
        .font(.system(iPad ? .title3 : .headline, design: .rounded).weight(.medium))

      Spacer()

      ProgressView()
        .tint(Color(.lead))
        .scaleEffect(iPad ? 2.8 : 2.0, anchor: .center)
        .progressViewStyle(CircularProgressViewStyle())

      Spacer()

      Text("Max Upload File Size: 100 GB")
        .foregroundStyle(Color(.systemPink))
        .font(.system(iPad ? .title3 : .headline, design: .rounded).weight(.semibold))

      Text("Supersized File Transfer At The Speed Of Now")
        .multilineTextAlignment(.center)
        .font(.system(iPad ? .body : .callout, design: .rounded).weight(.medium))

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .onAppear { loadAppConfig() }
    .foregroundStyle(Color(.lead))
    .background(
      getLinearGradient([Color(.lime), Color(.banana), Color(.lemon)])
        .ignoresSafeArea()
    )
    .ignoresSafeArea()
  }

  private func loadAppConfig() {
    Task {
      let appConfigManager: AppConfigManagerProtocol? = Resolver.optional()
      let appConfig = try? await appConfigManager?.getConfig()
      try await Task.sleep(nanoseconds: 1_000_000_000)
      config?(appConfig)
    }
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView { _ in }
      .setPreviewWindowSize()
  }
}
