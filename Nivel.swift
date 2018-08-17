//
//  Nivel.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import GRDB
import Foundation

public struct Nivel : Codable {
    public var id_nivel : Int64?
    public var id_nivelpadre : Int64?
    public var id_nivelvalor : Int64?
    public var niv_ruta : String?
    public var niv_hijos: String?
    public var niv_posicion: Int64?
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_nivel = try Int64(container.decode(String.self, forKey: .id_nivel))
        id_nivelpadre = try Int64(container.decode(String.self, forKey: .id_nivelpadre))
        id_nivelvalor = try Int64(container.decode(String.self, forKey: .id_nivelvalor))
        niv_ruta = try container.decodeIfPresent(String.self, forKey: .niv_ruta)
        niv_hijos = try container.decodeIfPresent(String.self, forKey: .niv_hijos)
        niv_posicion = try Int64(container.decode(String.self, forKey: .niv_posicion))
        
    }
}

extension Nivel : TableMapping, Persistable {
    public static let databaseTableName = "nivel"
} 

extension Nivel : RowConvertible {
    public init(row: Row) {
        id_nivel? = row["id_nivel"]
        id_nivelpadre = row["id_nivelpadre"]
        id_nivelvalor = row["id_nivelvalor"]
        niv_ruta = row["niv_ruta"]
        niv_hijos = row["niv_hijos"]
        niv_posicion = row["niv_posicion"]
    }
}



