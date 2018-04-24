//
//  UserRoutes.swift
//  App
//
//  Created by Asakura Shinsuke on 2018/04/24.
//

import Vapor

extension Droplet {
    func setupUserRoutes() throws {
        try resource("users", UserController.self)
    }
}
