//
//  Tipoobservacion.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Tipoobservacion : Codable {
    public var id_tipoobservacion : Int64?
    public var tob_nombre : String?
    public var tob_default : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_tipoobservacion = try Int64(container.decode(String.self, forKey: .id_tipoobservacion))
        tob_nombre = try container.decode(String.self, forKey: .tob_nombre)
        tob_default = try Int64(container.decode(String.self, forKey: .tob_default))
    }
}

extension Tipoobservacion : TableMapping, Persistable {
    public static let databaseTableName = "tipoobservacion"
}

extension Tipoobservacion : RowConvertible {
    public init(row: Row) {
        id_tipoobservacion = row["id_tipoobservacion"]
        tob_nombre = row["tob_nombre"]
        tob_default = row["tob_default"]
        
        
    }
}

