// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GooglePlacesAPI",
    platforms: [.iOS(.v10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "GooglePlaces", targets: ["GooglePlaces"]),
        .library(name: "GoogleMapsDirections", targets: ["GoogleMapsDirections"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/kwiadmin/ObjectMapper", from: "4.2.0"),
        .package(url: "https://github.com/kwiadmin/Alamofire", from: "5.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "GoogleMapsDirections", dependencies: [
            .product(name: "Alamofire", package: "Alamofire"),
            .product(name: "ObjectMapper", package: "ObjectMapper"),
        ], path: "Source/GoogleMapsDirectionsAPI"),
        .target(name: "GooglePlaces", dependencies: [
            .product(name: "Alamofire", package: "Alamofire"),
            .product(name: "ObjectMapper", package: "ObjectMapper"),
        ], path: "Source/GooglePlacesAPI"),
        .testTarget(
            name: "GoogleMapsDirectionsAPITests",
            dependencies: ["GoogleMapsDirections"]),
        .testTarget(
            name: "GooglePlacesAPITests",
            dependencies: ["GooglePlaces"]),
    ]
)
