//
//  Accion.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Accion : Codable {
    public var id_accion : Int64?
    public var id_acciontipo : Int64?
    public var acc_nombre : String?
    public var acc_riesgo : String?
    public var acc_control : String?
    public var acc_capacitacion : String?
    public var acc_lubricante : Int64?
    public var acc_foto : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_accion = try Int64(container.decode(String.self, forKey: .id_accion))
        id_acciontipo = try Int64(container.decode(String.self, forKey: .id_acciontipo))
        acc_nombre = try container.decode(String.self, forKey: .acc_nombre)
        acc_riesgo = try container.decodeIfPresent(String.self, forKey: .acc_riesgo)
        acc_control = try container.decodeIfPresent(String.self, forKey: .acc_control)
        acc_capacitacion = try container.decodeIfPresent(String.self, forKey: .acc_capacitacion)
        acc_lubricante = try Int64(container.decode(String.self, forKey: .acc_lubricante))
        acc_foto = try Int64(container.decode(String.self, forKey: .acc_foto))
    }
}

extension Accion : TableMapping, Persistable {
    public static let databaseTableName = "accion"
}

extension Accion : RowConvertible {
    public init(row: Row) {
        id_accion = row["id_accion"]
        id_acciontipo = row["id_acciontipo"]
        acc_nombre = row["acc_nombre"]
        acc_riesgo = row["acc_riesgo"]
        acc_control = row["acc_control"]
        acc_capacitacion = row["acc_capacitacion"]
        acc_lubricante = row["acc_lubricante"]
        acc_foto = row["acc_foto"]
        
    }
}
