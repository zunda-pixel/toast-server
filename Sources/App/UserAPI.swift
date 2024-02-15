extension APIHandler {
  func getUserById(_ input: Operations.getUserById.Input) async throws -> Operations.getUserById.Output {
    let userID = input.query.userID
    let user: Components.Schemas.User = .init(
      id: userID,
      firstName: "firstName",
      lastName: "lastName",
      age: 12
    )
    let body: Operations.getUserById.Output.Ok.Body = .json(user)
    let ok: Operations.getUserById.Output.Ok = .init(body: body)
    let output: Operations.getUserById.Output = .ok(ok)
    return output
  }
  
  func postUser(_ input: Operations.postUser.Input) async throws -> Operations.postUser.Output {
    if case let .json(user) = input.body {
      print(user)
    }
    return .undocumented(statusCode: 200, .init())
  }
  
  func deleteUserByID(_ input: Operations.deleteUserByID.Input) async throws -> Operations.deleteUserByID.Output {
    return .notFound(.init())
  }
  
  func updateUserByID(_ input: Operations.updateUserByID.Input) async throws -> Operations.updateUserByID.Output {
    return .notFound(.init())
  }
}
