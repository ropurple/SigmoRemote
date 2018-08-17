//
//  Tipodocumento.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Tipodocumento : Codable {
    public var id_tipodocumento : Int64?
    public var tdo_nombre : String?
    public var tdo_nombrecorto : String?
    public var tdo_orden : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_tipodocumento = try Int64(container.decode(String.self, forKey: .id_tipodocumento))
        tdo_nombre = try container.decode(String.self, forKey: .tdo_nombre)
        tdo_nombrecorto = try container.decode(String.self, forKey: .tdo_nombrecorto)
        tdo_orden = try Int64(container.decode(String.self, forKey: .tdo_orden))
        
    }
}

extension Tipodocumento : TableMapping, Persistable {
    public static let databaseTableName = "tipodocumento"
}

extension Tipodocumento : RowConvertible {
    public init(row: Row) {
        id_tipodocumento = row["id_tipodocumento"]
        tdo_nombre = row["tdo_nombre"]
        tdo_nombrecorto = row["tdo_nombrecorto"]
        tdo_orden = row["tdo_orden"]
        
        
    }
}

