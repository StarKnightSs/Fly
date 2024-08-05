//
// BannerView.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import GoogleAdmobSPM
import SwiftUI

public struct BannerView: UIViewControllerRepresentable {

  private let bannerView = GADBannerView()
  private var showBanner: ((Bool) -> Void)?

  @State private var viewWidth: CGFloat = .zero

  public init(showBanner: ((Bool) -> Void)? = nil) {
    self.showBanner = showBanner
  }

  public func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = bannerAdUnitID
    bannerView.delegate = context.coordinator
    bannerView.rootViewController = bannerViewController
    bannerViewController.view.addSubview(bannerView)
    bannerViewController.delegate = context.coordinator
    return bannerViewController
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self, showBanner: showBanner)
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }
    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  public class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {

    let parent: BannerView
    var showBanner: ((Bool) -> Void)?

    init(_ parent: BannerView, showBanner: ((Bool) -> Void)? = nil) {
      self.parent = parent
      self.showBanner = showBanner
    }

    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
      parent.viewWidth = width
    }

    // MARK: - GADBannerViewDelegate methods

    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      showBanner?(true)
    }

    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      showBanner?(false)
    }
  }
}

struct BannerView_Previews: PreviewProvider {
  static var previews: some View {
    BannerView()
  }
}
