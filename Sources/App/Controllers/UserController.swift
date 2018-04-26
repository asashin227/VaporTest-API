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
    
    /// '/users/[id]'に対してのPATCH
    func update(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        try user.update(for: req)
        
        try user.save()
        return user
    }
    
    /// '/users/[id]'に対してのPUT
    func replace(_ req: Request, user: UserModel) throws -> ResponseRepresentable {
        let new = try req.user()
        
        user.name = new.name
        user.age = new.age
        try user.save()
        return user
    }
    
    /// 操作に対応したクロージャを引数にResourceを生成
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
