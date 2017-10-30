// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebladeECS",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "FirebladeECS",
            targets: ["FirebladeECS"]),
		.executable(
			name: "FirebladeECSDemo",
			targets: ["FirebladeECSDemo"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/PureSwift/CSDL2.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "FirebladeECS",
            dependencies: []),
		.target(
			name: "FirebladeECSDemo",
			dependencies: ["FirebladeECS"]),
        .testTarget(
            name: "FirebladeECSTests",
            dependencies: ["FirebladeECS"])
    ]
)
