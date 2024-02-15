import Vapor
import OpenAPIVapor
import Logging

@main
struct App {
  static func main() async throws {
    let app = Application()
    defer { app.shutdown() }
    
    
    let fileMiddleware = FileMiddleware(
      publicDirectory: app.directory.publicDirectory
    )
    
    app.middleware.use(fileMiddleware)

    let transport = VaporTransport(routesBuilder: app)

    try APIHandler().registerHandlers(on: transport)

    var env = try Environment.detect()
    try LoggingSystem.bootstrap(from: &env)
      
    do {
      try await app.execute()
    } catch {
      app.logger.report(error: error)
      throw error
    }
  }
}

