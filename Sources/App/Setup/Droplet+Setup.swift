@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        
        // Do any additional droplet setup
        // '/users'を有効にする
        try setupUserRoutes()
    }
}
