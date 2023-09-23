// swift-tools-version:5.4.0

import PackageDescription

let package = Package(
  name: "BuildTools",
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", .exact("0.52.2")),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", .exact("0.51.5"))
  ],
  targets: [.target(name: "BuildTools", path: "")]
)
