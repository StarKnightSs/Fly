//
// Image.swift
// Created by Arpit Williams on 05/06/24.
// Copyright (c) 2024 StarKnights Technologies

import CoreImage.CIFilterBuiltins
import SwiftUI

public extension Image {

  static func generateQRCode(from string: String) -> Image {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    filter.message = Data(string.utf8)
    guard let outputImage = filter.outputImage,
          let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
    else { return Image(systemName: "xmark.circle") }
    return Image(uiImage: UIImage(cgImage: cgImage))
  }
}
