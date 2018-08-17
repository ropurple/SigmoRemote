//
//  Producto.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Producto : Codable {
    public var id_producto : Int64?
    public var pro_nombre : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_producto = try Int64(container.decode(String.self, forKey: .id_producto))
        pro_nombre = try container.decode(String.self, forKey: .pro_nombre)
    }
}

extension Producto : TableMapping, Persistable {
    public static let databaseTableName = "producto"
}

extension Producto : RowConvertible {
    public init(row: Row) {
        id_producto = row["id_producto"]
        pro_nombre = row["pro_nombre"]
        
        
    }
}

