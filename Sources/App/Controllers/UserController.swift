//
//  UserController.swift
//  App
//
//  Created by Asakura Shinsuke on 2018/04/24.
//

import Vapor
import HTTP
import Foundation

final class UserController: ResourceRepresentable {
    /// /usersに対してのGET
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try UserModel.all().makeJSON()
    }
    
    /// /usersに対してのPOST
    func store(_ req: Request) throws -> ResponseRepresentable {
        let user = try req.user()
        
        try user.save()
        return user
    }
    
    /// '/users/[id]'に対してのGET
    func show(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        return user
    }
    
    /// '/users/[id]'に対してのDELETE
    func delete(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        try user.delete()
        return Response(status: .ok)
    }
    
    /// '/users'に対してのDELETE
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try UserModel.makeQuery().delete()
        return Response(status: .ok)
    }
    
    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values.
    func update(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        // See `extension Post: Updateable`
        try user.update(for: req)
        
        // Save an return the updated post.
        try user.save()
        return user
    }
    
    /// When a user calls 'PUT' on a specific resource, we should replace any
    /// values that do not exist in the request with null.
    /// This is equivalent to creating a new Post with the same ID.
    func replace(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        // First attempt to create a new Post from the supplied JSON.
        // If any required fields are missing, this request will be denied.
        let new = try req.user()
        
        // Update the post with all of the properties from
        // the new post
        user.name = new.name
        user.age = new.age
        try user.save()
        
        // Return the updated post
        return user
    }
    
    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this
    /// implementation
    func makeResource() -> Resource<UserModel> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }

}
extension Request {
    func user() throws -> UserModel {
        guard let json = json else { throw Abort.badRequest }
        return try UserModel(json: json)
    }
}


extension UserController: EmptyInitializable { }
