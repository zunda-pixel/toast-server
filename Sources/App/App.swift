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

    app.get("openapi") { request in request.redirect(to: "openapi.html", redirectType: .permanent) }
    
    let fileMiddleware = FileMiddleware(
      publicDirectory: app.directory.publicDirectory
    )

    app.databases.use(
      .mysql(
        hostname: Environment.get("DATABASE_HOST")!,
        username: Environment.get("DATABASE_USERNAME")!,
        password: Environment.get("DATABASE_PASSWORD")!,
        database: Environment.get("DATABASE_NAME")!,
        tlsConfiguration: .makePreSharedKeyConfiguration()
      ),
      as: .mysql
    )

    switch app.environment {
    case .development:
      app.passwords.use(.plaintext)
    case .production:
      app.passwords.use(.bcrypt)
    default:
      fatalError()
    }

    app.middleware.use(fileMiddleware, at: .end)

    app.middleware.use(CORSMiddleware(), at: .beginning)

    let transport = VaporTransport(routesBuilder: app)

    let handler = APIHandler(app: app)
    try handler.registerHandlers(
      on: transport,
      serverURL: URL(string: "/api")!,
      middlewares: [
        LoggingMiddleware(),
        MetricsMiddleware(counterPrefix: "ToastServer"),
      ]
    )

    do {
      try await app.execute()
    } catch {
      app.logger.report(error: error)
      throw error
    }
  }
}
