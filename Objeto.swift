//
//  Objeto.swift
//  Sigmo
//
//  Created by macOS User on 12/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Objeto : Codable {
    public var id_objeto : Int64?
    public var id_objetopadre : Int64?
    public var id_nivel : Int64?
    public var obj_nombre : String?
    public var obj_nombrecorto : String?
    public var obj_orden : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_objeto = try Int64(container.decode(String.self, forKey: .id_objeto))
        id_objetopadre = try Int64(container.decode(String.self, forKey: .id_objetopadre))
        id_nivel = try Int64(container.decode(String.self, forKey: .id_nivel))
        obj_nombre = try container.decode(String.self, forKey: .obj_nombre)
        obj_nombrecorto = try container.decode(String.self, forKey: .obj_nombrecorto)
        obj_orden = try Int64(container.decode(String.self, forKey: .obj_orden))
    }
}

extension Objeto : TableMapping, Persistable {
    public static let databaseTableName = "objeto"
}

extension Objeto : RowConvertible {
    public init(row: Row) {
        id_objeto = row["id_objeto"]
        id_objetopadre = row["id_objetopadre"]
        id_nivel = row["id_nivel"]
        obj_nombre = row["obj_nombre"]
        obj_nombrecorto = row["obj_nombrecorto"]
        obj_orden = row["obj_orden"]
        
    }
}
