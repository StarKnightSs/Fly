// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "Fly",
  platforms: [.macOS(.v13), .iOS(.v15)],
  products: Module.allCases.map(Product.library),
  dependencies: [
    .vapor,
    .leaf
  ],
  targets: [
    .flyKit,
    .flyKitTests,
    .flyServer
  ]
)

// MARK: - Modules

enum Module: String, CaseIterable {
  // swiftlint:disable identifier_name
  case FlyKit
  case FlyServer
  // swiftlint:enable identifier_name

  var test: String {
    "\(rawValue)Tests"
  }
}

// MARK: - Target

extension Target {

  static var flyKit: Target {
    .target(
      name: Module.FlyKit.rawValue,
      dependencies: [.flyServer],
      resources: [.process("Resources")]
    )
  }

  static var flyServer: Target {
    .target(
      name: Module.FlyServer.rawValue,
      dependencies: [.vapor, .leaf],
      resources: [.process("Resources")]
    )
  }
}

// MARK: - Test Target

extension Target {

  static var flyKitTests: Target {
    .testTarget(name: Module.FlyKit.test, dependencies: [
      .flyKit
    ])
  }
}

// MARK: - Target Dependency

extension Target.Dependency {

  init(_ module: Module) {
    self.init(stringLiteral: module.rawValue)
  }

  static var flyKit: Target.Dependency {
    .init(.FlyKit)
  }

  static var flyServer: Target.Dependency {
    .init(.FlyServer)
  }

  static var vapor: Target.Dependency {
    product(name: "Vapor", package: "vapor")
  }

  static var leaf: Target.Dependency {
    product(name: "Leaf", package: "Leaf")
  }
}

// MARK: - Package Dependency

extension Package.Dependency {

  static var vapor: Package.Dependency {
    package(url: "https://github.com/vapor/vapor.git", from: "4.92.5")
  }

  static var leaf: Package.Dependency {
    package(url: "https://github.com/vapor/leaf.git", from: "4.3.0")
  }
}

// MARK: - Product

extension Product {
  static func library(_ module: Module) -> Product {
    Product.library(name: module.rawValue, targets: [module.rawValue])
  }
}
