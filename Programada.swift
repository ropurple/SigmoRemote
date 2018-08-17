//
//  Programada.swift
//  Sigmo
//
//  Created by macOS User on 12/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Programada : Codable {
    public var id_programada : Int64?
    public var id_objeto : Int64?
    public var id_accion : Int64?
    public var prg_orden : Int64?
    public var prg_nombre : String?
    public var prg_detalle : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_programada = try Int64(container.decode(String.self, forKey: .id_programada))
        id_objeto = try Int64(container.decode(String.self, forKey: .id_objeto))
        id_accion = try Int64(container.decode(String.self, forKey: .id_accion))
        prg_orden = try Int64(container.decode(String.self, forKey: .prg_orden))
        prg_nombre = try container.decodeIfPresent(String.self, forKey: .prg_nombre)
        prg_detalle = try container.decodeIfPresent(String.self, forKey: .prg_detalle)
    }
}

extension Programada : TableMapping, Persistable {
    public static let databaseTableName = "programada"
}

extension Programada : RowConvertible {
    public init(row: Row) {
        id_programada = row["id_programada"]
        id_objeto = row["id_objeto"]
        id_accion = row["id_accion"]
        prg_orden = row["prg_orden"]
        prg_nombre = row["prg_nombre"]
        prg_detalle = row["prg_detalle"]
        
    }
}
