//
// BannerView.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleMobileAds
import SwiftUI

public struct BannerView: UIViewControllerRepresentable {

  private let bannerView = GADBannerView()
  @State private var viewWidth: CGFloat = .zero

  public init() {}

  public func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = bannerAdUnitID
    bannerView.rootViewController = bannerViewController
    bannerViewController.view.addSubview(bannerView)
    bannerViewController.delegate = context.coordinator
    return bannerViewController
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }
    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  public class Coordinator: NSObject, BannerViewControllerWidthDelegate {

    let parent: BannerView
    init(_ parent: BannerView) {
      self.parent = parent
    }

    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
      parent.viewWidth = width
    }
  }
}

struct BannerView_Previews: PreviewProvider {
  static var previews: some View {
    BannerView()
  }
}
