import Vapor

actor APIHandler: APIProtocol {
  let app: Application

  init(app: Application) {
    self.app = app
  }
}
