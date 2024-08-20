// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "BuildTools",
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", exact: "0.56.1"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.54.3")
  ],
  targets: [.target(name: "BuildTools", path: "")]
)
