//
//  Programadaproducto.swift
//  Sigmo
//
//  Created by macOS User on 12/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Programadaproducto : Codable {
    public var id_programadaproducto : Int64?
    public var id_programadadetalle : Int64?
    public var id_producto : Int64?
    public var ppr_cantidad : Double?
    public var ppr_principal : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_programadaproducto = try Int64(container.decode(String.self, forKey: .id_programadaproducto))
        id_programadadetalle = try Int64(container.decode(String.self, forKey: .id_programadadetalle))
        id_producto = try Int64(container.decode(String.self, forKey: .id_producto))
        ppr_cantidad = try Double(container.decode(String.self, forKey: .ppr_cantidad))
        ppr_principal = try Int64(container.decode(String.self, forKey: .ppr_principal))
    }
}

extension Programadaproducto : TableMapping, Persistable {
    public static let databaseTableName = "programadaproducto"
}

extension Programadaproducto : RowConvertible {
    public init(row: Row) {
        id_programadaproducto = row["id_programadaproducto"]
        id_programadadetalle = row["id_programadadetalle"]
        id_producto = row["id_producto"]
        ppr_cantidad = row["ppr_cantidad"]
        ppr_principal = row["ppr_principal"]
        
    }
}
