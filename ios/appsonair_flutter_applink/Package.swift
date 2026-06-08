// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "appsonair_flutter_applink",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "appsonair-flutter-applink", targets: ["appsonair_flutter_applink"])
    ],
    dependencies: [
        .package(url: "https://github.com/apps-on-air/AppsOnAir-iOS-AppLink.git", exact: "1.4.0")
    ],
    targets: [
        .target(
            name: "appsonair_flutter_applink",
            dependencies: [
                .product(name: "AppsOnAir_AppLink", package: "AppsOnAir-iOS-AppLink")
            ],
            path: ".",
            // Explicitly list only the Swift file.
            // SPM does not support mixed Swift + ObjC in one target.
            // The ObjC bridge files (if any) are used by CocoaPods only and must be excluded from SPM.
            sources: [
                "Sources/appsonair_flutter_applink/AppsonairFlutterApplinkPlugin.swift"
            ]
        )
    ]
)
