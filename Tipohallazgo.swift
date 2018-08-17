//
//  Tipohallazgo.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Tipohallazgo : Codable {
    public var id_tipohallazgo : Int64?
    public var tha_nombre : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_tipohallazgo = try Int64(container.decode(String.self, forKey: .id_tipohallazgo))
        tha_nombre = try container.decode(String.self, forKey: .tha_nombre)

    }

}

extension Tipohallazgo : TableMapping, Persistable {
    public static let databaseTableName = "tipohallazgo"
}

extension Tipohallazgo : RowConvertible {
    public init(row: Row) {
        id_tipohallazgo = row["id_tipohallazgo"]
        tha_nombre = row["tha_nombre"]
        
        
    }
}
