//
//  Nivelvalor.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import GRDB

public struct Nivelvalor : Codable {
    public var id_nivelvalor : Int64?
    public var id_niveltipo : Int64?
    public var nva_valor : String?
    public var nva_valorcorto : String?
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_nivelvalor = try Int64(container.decode(String.self, forKey: .id_nivelvalor))
        id_niveltipo = try Int64(container.decode(String.self, forKey: .id_niveltipo))
        nva_valor = try container.decode(String.self, forKey: .nva_valor)
        nva_valorcorto = try container.decode(String.self, forKey: .nva_valorcorto)
        
    }
}

extension Nivelvalor : TableMapping, Persistable {
    public static let databaseTableName = "nivelvalor"
}

extension Nivelvalor : RowConvertible {
    public init(row: Row) {
        id_nivelvalor = row["id_nivelvalor"]
        id_niveltipo = row["id_niveltipo"]
        nva_valor = row["nva_valor"]
        nva_valorcorto = row["nva_valorcorto"]
    }
}
