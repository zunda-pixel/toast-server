import Fluent
import FluentMySQLDriver
import Vapor
import XCTest

@testable import App

final class HelloWorldServerTests: XCTestCase {
  let app: Application = {
    let app = Application()

    app.databases.use(
      .mysql(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!
      ),
      as: .mysql
    )
    return app
  }()

  deinit {
    app.shutdown()
  }

  var handler: any APIProtocol {
    return APIHandler(app: app)
  }

  func testPostUser() async throws {
    let user: Components.Schemas.User = .init(
      id: UUID().uuidString,
      firstName: "fisrtName",
      lastName: "lastName",
      age: 21
    )

    let response = try await handler.postUser(.init(body: .json(user)))

    try XCTAssertEqual(response.ok.body.json, user)
  }

  func testGetUserById() async throws {
    let user: Components.Schemas.User = .init(
      id: UUID().uuidString,
      firstName: "fisrtName",
      lastName: "lastName",
      age: 21
    )

    _ = try await handler.postUser(.init(body: .json(user)))

    let response2 = try await handler.getUserById(query: .init(userID: user.id))
    try XCTAssertEqual(response2.ok.body.json, user)
  }

  func testDeleteUserById() async throws {
    let user: Components.Schemas.User = .init(
      id: UUID().uuidString,
      firstName: "fisrtName",
      lastName: "lastName",
      age: 21
    )

    _ = try await handler.postUser(.init(body: .json(user)))
    let response2 = try await handler.deleteUserByID(.init(query: .init(userID: user.id)))

    try XCTAssertEqual(response2.noContent, .init())
  }
}
