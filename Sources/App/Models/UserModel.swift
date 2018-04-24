//
//  UserModel.swift
//  App
//
//  Created by Asakura Shinsuke on 2018/04/24.
//

import Vapor
import FluentProvider
import HTTP

final class UserModel: Model {
    let storage = Storage()
    
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let age = "age"
    }
    
    static let idType: IdentifierType = .uuid
    var name: String
    var age: Int = 0
    
    init(name: String, age: Int ) {
        self.name = name
        self.age = age
    }
    
    required init(row: Row) throws {
        name = try row.get(UserModel.Keys.name)
        age = try row.get(UserModel.Keys.age)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(UserModel.Keys.name, name)
        try row.set(UserModel.Keys.age, age)
        return row
    }
}


// Preparation protocolに準拠させるとをRun時にCreateTable
extension UserModel: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { (builder: Creator) in
            builder.id()
            builder.string("name")
            builder.int("age")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// Preparation protocolに準拠させるとをリクエストに対してモデルを返却できる
extension UserModel: ResponseRepresentable { }

// JSONとの変換を可能にする
extension UserModel: JSONConvertible {
    public convenience init(json: JSON) throws {
        self.init(
            name: try json.get(UserModel.Keys.name),
            age: try json.get(UserModel.Keys.age)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(UserModel.Keys.id, id)
        try json.set(UserModel.Keys.name, name)
        try json.set(UserModel.Keys.age, age)
        return json
    }
}

extension UserModel: Updateable {
    public static var updateableKeys: [UpdateableKey<UserModel>] {
        return [
            UpdateableKey(UserModel.Keys.name, String.self) { user, name in
                user.name = name
            },
            UpdateableKey(UserModel.Keys.age, Int.self) { user, age in
                user.age = age
            }
        ]
    }
}
