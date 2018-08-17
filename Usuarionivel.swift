//
//  Usuarionivel.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Usuarionivel : Codable {
    public var id_usuario : Int64?
    public var id_nivel : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_usuario = try Int64(container.decode(String.self, forKey: .id_usuario))
        id_nivel = try Int64(container.decode(String.self, forKey: .id_nivel))
    }
}

extension Usuarionivel : TableMapping, Persistable {
    public static let databaseTableName = "usuarionivel"
}

extension Usuarionivel : RowConvertible {
    public init(row: Row) {
        id_usuario = row["id_usuario"]
        id_nivel = row["id_nivel"]
    }
}
