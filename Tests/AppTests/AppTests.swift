import XCTest
@testable import App
import Vapor

final class HelloWorldServerTests: XCTestCase {
  let app = Application()
  var handler: APIProtocol { APIHandler(app: app) }
  
  func testGreet() async throws {
    let userID = "userID"
    let response = try await handler.getUserById(query: .init(userID: userID))
    try XCTAssertEqual(response.ok.body.json.id, userID)
  }
}
