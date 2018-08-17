//
//  Sync.swift
//  Sigmo
//
//  Created by macOS User on 05/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Sync {
    public var id_sync : Int64?
    public var syn_tabla : String?
    public var syn_fecha : String?
    public var id_nivel : Int64?
    
}

extension Sync : TableMapping {
    
    public static let databaseTableName = "Sync"
}

extension Sync : RowConvertible {
    public init(row: Row) {
        id_sync = row["id_sync"]
        syn_tabla = row["syn_tabla"]
        syn_fecha = row["syn_fecha"]
        id_nivel = row["id_nivel"]
    }
}
