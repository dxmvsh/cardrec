// swift-tools-version: 5.0

import PackageDescription

let package = Package(
    name: "cardrec",
    products: [
        .library(
            name: "cardrec",
            targets: ["cardrec"]
        ),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "cardrec",
            dependencies: []
        ),
        .testTarget(
            name: "cardrecTests",
            dependencies: ["cardrec"]
        ),
    ]
)
