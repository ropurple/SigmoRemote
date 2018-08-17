//
//  Foto.swift
//  Sigmo
//
//  Created by macOS User on 04/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//


import Foundation
import GRDB

public struct Foto : Codable {
    public var id_foto : Int64?
    public var id_actividad : Int64?
    public var fot_nombre : String?
    public var fot_peso : Int64?
    public var fot_orden : Int64?
    public var fot_subida : Int64?
    public var con_url : String?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_foto = try Int64(container.decode(String.self, forKey: .id_foto))
        id_actividad = try Int64(container.decode(String.self, forKey: .id_actividad))
        fot_nombre = try container.decode(String.self, forKey: .fot_nombre)
        fot_peso = try Int64(container.decode(String.self, forKey: .fot_peso))
        fot_orden = try Int64(container.decode(String.self, forKey: .fot_orden))
        fot_subida = try Int64(container.decode(String.self, forKey: .fot_subida))
        con_url = try container.decode(String.self, forKey: .con_url)
    }
    init(id_actividad: Int64 = 0, fot_orden: Int64 = 0, fot_subida: Int64 = 0, con_url: String = ""){
        
    }
}

extension Foto : TableMapping, Persistable {
    public static let databaseTableName = "foto"
}

extension Foto : RowConvertible {
    public init(row: Row) {
        id_foto = row["id_foto"]
        id_actividad = row["id_actividad"]
        fot_nombre = row["fot_nombre"]
        fot_peso = row["fot_peso"]
        fot_orden = row["fot_orden"]
        fot_subida = row["fot_subida"]
        con_url = row["con_url"]
        
    }
}

