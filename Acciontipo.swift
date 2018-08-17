//
//  Acciontipo.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Acciontipo : Codable {
    public var id_acciontipo : Int64?
    public var ati_nombre : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
  
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_acciontipo = try Int64(container.decode(String.self, forKey: .id_acciontipo))
        ati_nombre = try container.decode(String.self, forKey: .ati_nombre)
    }
}

extension Acciontipo : TableMapping, Persistable {
    public static let databaseTableName = "acciontipo"
}

extension Acciontipo : RowConvertible {
    public init(row: Row) {
        id_acciontipo = row["id_acciontipo"]
        ati_nombre = row["ati_nombre"]
       
        
    }
}
