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

    app.middleware.use(fileMiddleware, at: .end)

    app.middleware.use(CORSMiddleware(), at: .beginning)

    let transport = VaporTransport(routesBuilder: app)

    try APIHandler().registerHandlers(on: transport)

    do {
      try await app.execute()
    } catch {
      app.logger.report(error: error)
      throw error
    }
  }
}
