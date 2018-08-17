//
//  Postergar.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Postergar : Codable {
    public var id_postergar : Int64?
    public var pos_nombre : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_postergar = try Int64(container.decode(String.self, forKey: .id_postergar))
        pos_nombre = try container.decode(String.self, forKey: .pos_nombre)
        
    }
}

extension Postergar : TableMapping, Persistable {
    public static let databaseTableName = "postergar"
}

extension Postergar : RowConvertible {
    public init(row: Row) {
        id_postergar = row["id_postergar"]
        pos_nombre = row["pos_nombre"]
        
        
    }
}
