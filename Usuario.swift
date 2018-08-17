//
//  Usuario.swift
//  Sigmo
//
//  Created by macOS User on 02/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//
import GRDB
import Foundation

public struct Usuario : Codable, MutablePersistable {
    public var id_usuario : Int64?
    public var usu_rut : String?
    public var usu_nombre : String?
    public var usu_apellido : String?
    public var id_tipousuario : Int64?
    public var usu_login : String?
    public var usu_pass : String?
    
   public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_usuario = try Int64(container.decode(String.self, forKey: .id_usuario))
        usu_rut = try container.decode(String.self, forKey: .usu_rut)
        usu_nombre = try container.decode(String.self, forKey: .usu_nombre)
        usu_apellido = try container.decode(String.self, forKey: .usu_apellido)
        id_tipousuario = try Int64(container.decode(String.self, forKey: .id_tipousuario))
        usu_login = try container.decode(String.self, forKey: .usu_login)
    }
    
    public init(id_usuario:Int64 = 0, id_tipousuario: Int64 = 0, usu_rut: String = ""){
        print("Usuario nil")
    }
    
}
    
extension Usuario : TableMapping, Persistable {
    public static let databaseTableName = "usuario"
}

extension Usuario : RowConvertible {
    public init(row: Row) {
        id_usuario = row["id_usuario"]
        usu_rut = row["usu_rut"]
        usu_nombre = row["usu_nombre"]
        usu_apellido = row["usu_apellido"]
        id_tipousuario = row["id_tipousuario"]
        usu_login = row["usu_login"]
        usu_pass = row["usu_pass"]
    }
}






