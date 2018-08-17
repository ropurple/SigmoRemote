//
//  Niveltipo.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import GRDB

public struct Niveltipo : Codable {
    public var id_niveltipo : Int64?
    public var nti_nombre : String?
    public var nti_orden : Int64?
    public var nti_requerido : Int64?
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_niveltipo = try Int64(container.decode(String.self, forKey: .id_niveltipo))
        nti_nombre = try container.decode(String.self, forKey: .nti_nombre)
        nti_orden = try Int64(container.decode(String.self, forKey: .nti_orden))
        nti_requerido = try Int64(container.decode(String.self, forKey: .nti_requerido))

    }
}

extension Niveltipo : TableMapping, Persistable {
    public static let databaseTableName = "niveltipo"
}

extension Niveltipo : RowConvertible {
    public init(row: Row) {
        id_niveltipo = row["id_niveltipo"]
        nti_nombre = row["nti_nombre"]
        nti_orden = row["nti_orden"]
        nti_requerido = row["nti_requerido"]
    }
}

