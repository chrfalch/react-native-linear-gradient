// swift-tools-version: 6.0

import Foundation
import PackageDescription

// The target uses the package root so that its public-header shim and iOS
// sources can coexist. Exclude every other root entry to keep SwiftPM from
// scanning examples, dependencies, and repository metadata as resources.
let usedRootEntries: Set<String> = ["ios", "include", "spm-headers", "Package.swift"]
let unusedRootEntries = try! FileManager.default.contentsOfDirectory(atPath: Context.packageDirectory)
    .filter { !usedRootEntries.contains($0) }
    .sorted()

let package = Package(
    name: "RNLinearGradient",
    platforms: [.iOS("15.1")],
    products: [
        .library(name: "RNLinearGradient", targets: ["RNLinearGradient"]),
    ],
    dependencies: [
        .package(name: "ReactNative", path: "../../../../xcframeworks"),
        .package(name: "React-GeneratedCode", path: "../../../ios"),
    ],
    targets: [
        .target(
            name: "RNLinearGradient",
            dependencies: [
                .product(name: "ReactHeaders", package: "ReactNative"),
                .product(name: "ReactNativeHeaders", package: "ReactNative"),
                .product(name: "ReactNativeDependenciesHeaders", package: "ReactNative"),
                .product(name: "ReactAppHeaders", package: "React-GeneratedCode"),
            ],
            path: ".",
            exclude: ["ios/RNLinearGradient.xcodeproj"] + unusedRootEntries,
            sources: ["ios"],
            publicHeadersPath: "include",
            cSettings: [
                .define("RCT_NEW_ARCH_ENABLED", to: "1"),
                .headerSearchPath("ios"),
                .headerSearchPath("spm-headers"),
            ],
            cxxSettings: [
                .define("RCT_NEW_ARCH_ENABLED", to: "1"),
                .headerSearchPath("ios"),
                .headerSearchPath("spm-headers"),
                .define("DEBUG", .when(configuration: .debug)),
                .define("NDEBUG", .when(configuration: .release)),
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("QuartzCore"),
            ]
        ),
    ],
    cxxLanguageStandard: .cxx20
)
