//
// BannerViewController.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import UIKit

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {

  var viewWidth: Double {
    view.frame.inset(by: view.safeAreaInsets).size.width
  }

  weak var delegate: BannerViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    delegate?.bannerViewController(self, didUpdate: viewWidth)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate { _ in } completion: { [weak self] _ in
      guard let self else { return }
      self.delegate?.bannerViewController(self, didUpdate: viewWidth)
    }
  }
}
