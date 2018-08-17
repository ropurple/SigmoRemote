//
//  Programadadetalle.swift
//  Sigmo
//
//  Created by macOS User on 12/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Programadadetalle : Codable {
    public var id_programadadetalle : Int64?
    public var id_programada : Int64?
    public var id_tipodocumento : Int64?
    public var id_frecuencia : Int64?
    public var id_prioridad : String?
    public var pde_tiempo : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_programadadetalle = try Int64(container.decode(String.self, forKey: .id_programadadetalle))
        id_programada = try Int64(container.decode(String.self, forKey: .id_programada))
        id_tipodocumento = try Int64(container.decode(String.self, forKey: .id_tipodocumento))
        id_frecuencia = try Int64(container.decode(String.self, forKey: .id_frecuencia))
        id_prioridad = try container.decode(String.self, forKey: .id_prioridad)
        pde_tiempo = try container.decode(String.self, forKey: .pde_tiempo)
    }
}

extension Programadadetalle : TableMapping, Persistable {
    public static let databaseTableName = "programadadetalle"
}

extension Programadadetalle : RowConvertible {
    public init(row: Row) {
        id_programadadetalle = row["id_programadadetalle"]
        id_programada = row["id_programada"]
        id_tipodocumento = row["id_tipodocumento"]
        id_frecuencia = row["id_frecuencia"]
        id_prioridad = row["id_prioridad"]
        pde_tiempo = row["pde_tiempo"]
        
    }
}
