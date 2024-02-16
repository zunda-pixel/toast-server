import Vapor
import OpenAPIVapor
import Logging

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
    case .testing:
      app.passwords.use(.bcrypt)
    case .production:
      app.passwords.use(.bcrypt)
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
