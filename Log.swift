//
//  log.swift
//  Sigmo
//
//  Created by macOS User on 05/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import GRDB

public struct Log : Codable {
    public var id_log : Int64?
    public var id_usuario : Int64?
    public var log_fecha : String?
    public var log_tabla : String?
    public var log_msje : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_log = try Int64(container.decode(String.self, forKey: .id_log))
        id_usuario = try Int64(container.decode(String.self, forKey: .id_usuario))
        log_fecha = try container.decode(String.self, forKey: .log_fecha)
        log_tabla = try container.decodeIfPresent(String.self, forKey: .log_tabla)
        log_msje = try container.decodeIfPresent(String.self, forKey: .log_msje)
    }
    
    public init(id_usuario:Int64 = 0,
                log_fecha: String = "",
                log_tabla: String = "",
                log_msje: String = ""){
    }
    
 
}

extension Log : TableMapping, Persistable {
    
    public static let databaseTableName = "log"
}
extension Log : RowConvertible {
    public init(row: Row) {
        id_log = row["id_log"]
        id_usuario = row["id_usuario"]
        log_fecha = row["log_fecha"]
        log_tabla = row["log_tabla"]
        log_msje = row["log_msje"]
    }
}
