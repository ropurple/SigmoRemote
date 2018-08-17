//
//  Prioridad.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Prioridad : Codable {
    public var id_prioridad : Int64?
    public var pri_nombre : String?
    public var pri_orden : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_prioridad = try Int64(container.decode(String.self, forKey: .id_prioridad))
        pri_nombre = try container.decode(String.self, forKey: .pri_nombre)
        pri_orden = Int64(try container.decode(String.self, forKey: .pri_orden))
    }
}

extension Prioridad : TableMapping, Persistable {
    public static let databaseTableName = "prioridad"
}

extension Prioridad : RowConvertible {
    public init(row: Row) {
        id_prioridad = row["id_prioridad"]
        pri_nombre = row["pri_nombre"]
        pri_orden = row["pri_orden"]
        
        
    }
}
