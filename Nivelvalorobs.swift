//
//  Nivelvalorobs.swift
//  Sigmo
//
//  Created by macOS User on 12/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Nivelvalorobs : Codable {
    public var id_nivelvalor : Int64?
    public var id_tipoobservacion : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_nivelvalor = try Int64(container.decode(String.self, forKey: .id_nivelvalor))
        id_tipoobservacion = try Int64(container.decode(String.self, forKey: .id_tipoobservacion))
    }
}

extension Nivelvalorobs : TableMapping, Persistable {
    public static let databaseTableName = "nivelvalorobs"
}

extension Nivelvalorobs : RowConvertible {
    public init(row: Row) {
        id_nivelvalor = row["id_nivelvalor"]
        id_tipoobservacion = row["id_tipoobservacion"]
        
    }
}
