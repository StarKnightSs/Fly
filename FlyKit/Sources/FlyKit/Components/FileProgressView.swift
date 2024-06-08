//
// FileProgressView.swift
// Created by Arpit Williams on 08/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import SwiftUI

struct FileProgressView: ProgressViewStyle {

  @EnvironmentObject private var viewModel: FlyViewModel

  var speed: String {
    String(
      format: "%@ Mbps",
      viewModel.progress.speed
        .formatted(.number.precision(.fractionLength(2)))
    )
  }

  var time: String {
    let seconds = viewModel.progress.time
    return format(seconds)
  }

  func makeBody(configuration: Configuration) -> some View {
    ZStack {
      transparentBackground
      VStack(spacing: 0) {
        title
        progressView(configuration.fractionCompleted ?? 0)
        subTitle
        footNote
      }
      .padding(.vertical, 20)
      .frame(maxWidth: .infinity)
      .background(Color(.lemonLicorice))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .shadow(color: Color(.licoriceSnow), radius: 8)
      .padding(.horizontal, 20)
      .offset(y: -30)
    }
  }

  var transparentBackground: some View {
    VStack { Color.black }
      .opacity(0.4)
      .ignoresSafeArea()
      .allowsHitTesting(true)
  }

  var title: some View {
    Text("Data In Transit")
      .textCase(.uppercase)
      .padding(.vertical, 4)
      .foregroundStyle(Color(.leadLemon))
      .font(.system(.headline, design: .rounded).weight(.bold))
  }

  func progressView(_ progress: Double) -> some View {
    GeometryReader { geometry in
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color(.pinkLime), lineWidth: 16)
        .background(alignment: .leading) {
          RoundedRectangle(cornerRadius: 0)
            .fill(Color(.leadLemon))
            .frame(width: geometry.size.width * progress)
            .overlay(
              Text("\(progress.formatted(.percent))")
                .lineLimit(1)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color(.lemonLead))
            )
        }
    }
    .frame(height: 60)
    .padding(20)
  }

  var subTitle: some View {
    HStack(spacing: 4) {
      Text("Speed: \(speed)")
      Spacer()
      Text("Time: \(time)")
    }
    .padding(.top, 4)
    .padding(.horizontal, 20)
    .foregroundStyle(Color(.leadLime))
    .font(.system(.caption, design: .rounded).weight(.medium))
  }

  var footNote: some View {
    Text("Please don't kill the app during file transfer✌️")
      .padding(.top, 20)
      .foregroundStyle(Color(.leadLemon))
      .font(.system(.footnote, design: .rounded).weight(.light))
  }
}

#Preview(body: {
  ProgressView(value: 80, total: 100)
    .progressViewStyle(
      FileProgressView()
    )
    .environmentObject(
      FlyViewModel(
        filesManager: .init(fileManager: .default)
      )
    )
})
