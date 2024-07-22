// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "Fly",
  defaultLocalization: "en",
  platforms: [.macOS(.v13), .iOS(.v15)],
  products: Module.allCases.map(Product.library),
  dependencies: [
    .vapor,
    .leaf,
    .composableArchitecture,
    .resolver,
    .zip
  ],
  targets: [
    .adMob,
    .flyKit,
    .flyKitTests,
    .flyServer
  ]
)

// MARK: - Modules

enum Module: String, CaseIterable {
  // swiftlint:disable identifier_name
  case AdMob
  case FlyKit
  case FlyServer
  // swiftlint:enable identifier_name

  var test: String {
    "\(rawValue)Tests"
  }
}

// MARK: - Target

extension Target {

  static var adMob: Target {
    .target(name: Module.AdMob.rawValue)
  }

  static var flyKit: Target {
    .target(
      name: Module.FlyKit.rawValue,
      dependencies: [.adMob, .flyServer, .composableArchitecture, .resolver],
      resources: [.process("Resources")]
    )
  }

  static var flyServer: Target {
    .target(
      name: Module.FlyServer.rawValue,
      dependencies: [.vapor, .leaf, .resolver, .zip],
      resources: [.process("Resources")],
      swiftSettings: [.unsafeFlags(["-suppress-warnings"])]
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

  static var adMob: Target.Dependency {
    .init(.AdMob)
  }

  static var vapor: Target.Dependency {
    product(name: "Vapor", package: "vapor")
  }

  static var leaf: Target.Dependency {
    product(name: "Leaf", package: "Leaf")
  }

  static var composableArchitecture: Target.Dependency {
    product(name: "ComposableArchitecture", package: "swift-composable-architecture")
  }

  static var resolver: Target.Dependency {
    product(name: "Resolver", package: "Resolver")
  }

  static var zip: Target.Dependency {
    product(name: "Zip", package: "Zip")
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

  static var composableArchitecture: Package.Dependency {
    package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.11.0")
  }

  static var resolver: Package.Dependency {
    package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.1"))
  }

  static var zip: Package.Dependency {
    package(url: "https://github.com/marmelroy/Zip.git", .upToNextMajor(from: "2.1.2"))
  }
}

// MARK: - Product

extension Product {
  static func library(_ module: Module) -> Product {
    Product.library(name: module.rawValue, targets: [module.rawValue])
  }
}
