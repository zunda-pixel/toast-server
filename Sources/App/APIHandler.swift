struct APIHandler: APIProtocol {
  func getGreeting(_ input: Operations.getGreeting.Input) async throws -> Operations.getGreeting.Output {
    let name = input.query.name
    let welcomeMessage = Components.Schemas.Greeting(message: "Hello, \(name) san!")
    return .ok(.init(body: .json(welcomeMessage)))
  }
}
