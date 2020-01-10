// swift-tools-version:5.1
//
//  Package.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSProtocols
//
//  Created by Darren Ehlers on 2019/08/12.
//  Copyright © 2019 - 2016 Darren Ehlers and DoubleNode, LLC. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "DNSProtocols",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DNSProtocols",
            targets: ["DNSProtocols"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/DoubleNode/DNSDataObjects.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DNSProtocols",
            dependencies: ["DNSDataObjects"]),
        .testTarget(
            name: "DNSProtocolsTests",
            dependencies: ["DNSProtocols"]),
    ],
    swiftLanguageVersions: [.v5]
)
