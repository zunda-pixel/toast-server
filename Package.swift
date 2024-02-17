// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "toast-server",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .visionOS(.v1)
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
    .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
    .package(url: "https://github.com/swift-server/swift-openapi-vapor", from: "1.0.0"),
    .package(url: "https://github.com/vapor/fluent-mysql-driver", from: "4.4.0"),
    .package(url: "https://github.com/vapor/fluent", from: "4.9.0"),
    .package(url: "https://github.com/apple/swift-format", from: "509.0.0"),
  ],
  targets: [
    .executableTarget(
      name: "App",
      dependencies: [
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
        .product(name: "OpenAPIVapor", package: "swift-openapi-vapor"),
        .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
        .product(name: "Fluent", package: "fluent"),
      ],
      plugins: [
        .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
      ]
    ),
    .testTarget(
      name: "AppTests",
      dependencies: [
        .target(name: "App")
      ]
    ),
  ]
)
