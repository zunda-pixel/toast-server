import XCTest
@testable import App

final class HelloWorldServerTests: XCTestCase {
  func testGreet() async throws {
    let handler: APIProtocol = APIHandler()
    let response = try await handler.getGreeting(query: .init(name: "Jane"))
    XCTAssertEqual(response, .ok(.init(body: .json(.init(message: "Hello, Jane san!")))))
  }
}
