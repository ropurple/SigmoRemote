import Foundation
import GRDB

public struct Usuariotipodoc : Codable {
    public var id_usuario : Int64?
    public var id_nivel : Int64?
    public var id_tipodocumento : Int64?
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_usuario = try Int64(container.decode(String.self, forKey: .id_usuario))
        id_nivel = try Int64(container.decode(String.self, forKey: .id_nivel))
        id_tipodocumento = Int64(try container.decode(String.self, forKey: .id_tipodocumento))
    }
}

extension Usuariotipodoc : TableMapping, Persistable {
    public static let databaseTableName = "usuariotipodoc"
}

extension Usuariotipodoc : RowConvertible {
    public init(row: Row) {
        id_usuario = row["id_usuario"]
        id_nivel = row["id_nivel"]
        id_tipodocumento = row["id_tipodocumento"]
        
    }
}
