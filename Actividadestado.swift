//
//  Actividadestado.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Actividadestado : Codable {
    public var id_actividadestado : Int64?
    public var ade_nombre : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_actividadestado = try Int64(container.decode(String.self, forKey: .id_actividadestado))
        ade_nombre = try container.decode(String.self, forKey: .ade_nombre)
    }
}

extension Actividadestado : TableMapping, Persistable {
    public static let databaseTableName = "actividadestado"
}

extension Actividadestado : RowConvertible {
    public init(row: Row) {
        id_actividadestado = row["id_actividadestado"]
        ade_nombre = row["ade_nombre"]
        
        
    }
}
