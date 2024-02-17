import Fluent
import FluentMySQLDriver
import Logging
import OpenAPIVapor
import Vapor

@main
struct App {
  static func main() async throws {
    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)

    let app = Application(env)
    defer { app.shutdown() }

    let fileMiddleware = FileMiddleware(
      publicDirectory: app.directory.publicDirectory
    )

    switch app.environment {
    case .development:
      app.passwords.use(.plaintext)
      app.databases.use(
        .mysql(
          hostname: Environment.get("DATABASE_HOST")!.trimmingCharacters(in: .newlines),
          username: Environment.get("DATABASE_USERNAME")!,
          password: Environment.get("DATABASE_PASSWORD")!,
          database: Environment.get("DATABASE_NAME")!
        ),
        as: .mysql
      )
    case .production:
      app.passwords.use(.bcrypt)
      app.databases.use(
        try .mysql(url: Environment.get("JAWSDB_URL")!),
        as: .mysql
      )
    default:
      fatalError()
    }

    app.middleware.use(fileMiddleware, at: .end)

    app.middleware.use(CORSMiddleware(), at: .beginning)

    let transport = VaporTransport(routesBuilder: app)

    let handler = APIHandler(app: app)
    try handler.registerHandlers(on: transport)

    do {
      try await app.execute()
    } catch {
      app.logger.report(error: error)
      throw error
    }
  }
}
