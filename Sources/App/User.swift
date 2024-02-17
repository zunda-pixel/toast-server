import Fluent
import Foundation

final class User: Model {
  static let schema = "User"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "firstName")
  var firstName: String

  @Field(key: "lastName")
  var lastName: String

  @Field(key: "age")
  var age: Int

  init() {}

  init(
    id: UUID?,
    firstName: String,
    lastName: String,
    age: Int
  ) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  var componentUser: Components.Schemas.User {
    .init(
      id: self.id!.uuidString,
      firstName: self.firstName,
      lastName: self.lastName,
      age: self.age
    )
  }
}

extension Components.Schemas.User {
  var dbUser: User {
    .init(
      id: UUID(uuidString: self.id)!,
      firstName: self.firstName,
      lastName: self.lastName,
      age: self.age
    )
  }
}
