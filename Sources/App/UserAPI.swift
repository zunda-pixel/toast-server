import Vapor

extension APIHandler {
  func getUserById(_ input: Operations.getUserById.Input) async throws
    -> Operations.getUserById.Output
  {
    guard let userID = UUID(uuidString: input.query.userID) else {
      return .badRequest(.init())
    }
    guard let user = try await User.find(userID, on: app.db) else {
      return .notFound(.init())
    }

    return .ok(.init(body: .json(user.componentUser)))
  }

  func postUser(_ input: Operations.postUser.Input) async throws -> Operations.postUser.Output {
    guard case let .json(user) = input.body else { return .badRequest(.init()) }
    try await user.dbUser.create(on: app.db)
    return .ok(.init(body: .json(user)))
  }

  func deleteUserByID(_ input: Operations.deleteUserByID.Input) async throws
    -> Operations.deleteUserByID.Output
  {
    guard let userID = UUID(uuidString: input.query.userID) else { return .badRequest(.init()) }

    let userCount = try await User.query(on: app.db)
      .filter(\.$id, .equal, userID).limit(1).count()

    guard userCount > 0 else {
      return .notFound(.init())
    }

    try await User.query(on: app.db)
      .filter(\.$id, .equal, userID)
      .delete()

    return .noContent(.init())
  }

  func updateUserByID(_ input: Operations.updateUserByID.Input) async throws
    -> Operations.updateUserByID.Output
  {
    guard let userID = UUID(uuidString: input.query.userID) else { return .badRequest(.init()) }
    guard case let .json(user) = input.body else { return .badRequest(.init()) }

    let userCount = try await User.query(on: app.db)
      .filter(\.$id, .equal, userID).limit(1).count()

    guard userCount > 0 else {
      return .notFound(.init())
    }

    var query = User.query(on: app.db)

    if let firstName = user.firstName {
      query = query.set(\.$firstName, to: firstName)
    }

    if let lastName = user.lastName {
      query = query.set(\.$lastName, to: lastName)
    }

    if let age = user.age {
      query = query.set(\.$age, to: age)
    }

    try await query
      .filter(\User.$id, .equal, userID)
      .update()

    guard let user = try await User.find(userID, on: app.db) else {
      return .notFound(.init())
    }

    return .ok(.init(body: .json(user.componentUser)))
  }
}
