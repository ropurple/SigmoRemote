//
//  Actividad.swift
//  Sigmo
//
//  Created by macOS User on 21/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public struct Actividad : Codable, MutablePersistable {
    public var id_actividad : Int64?
    public var id_actividadpadre : Int64?
    public var id_objeto : Int64?
    public var id_nivel : Int64?
    public var id_actividadestado : Int64?
    public var id_programadadetalle : Int64?
    public var act_contingencia : String?
    public var act_fec_asignada : String?
    public var act_fec_anterior : String?
    public var act_fec_realizada : String?
    public var act_fec_realizada_servidor : String?
    public var id_producto : Int64?
    public var id_tipohallazgo : Int64?
    public var id_tipoobservacion : Int64?
    public var id_tipodocumento : Int64?
    public var id_usuario : Int64?
    public var act_cantidad : Double?
    public var act_cantidadretirado : Double?
    public var act_obs_planificador : String?
    public var id_postergar : Int64?
    public var act_tiempo : Int64?
    public var act_fec_app : String?
    public var act_datos : String?
    public var act_obs_ejecutor : String?
    public var act_obs_np : String? = ""
    public var act_subida : Int64? = 0
    public var act_creada_local : Int64? = 0
    
    public static let persistenceConflictPolicy = PersistenceConflictPolicy(
        insert: .replace,
        update: .replace)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_actividad = try Int64(container.decode(String.self, forKey: .id_actividad))
        id_actividadpadre = Int64(try container.decode(String.self, forKey: .id_actividadpadre))
        id_objeto = Int64(try container.decode(String.self, forKey: .id_objeto))
        id_nivel = Int64(try container.decode(String.self, forKey: .id_nivel))
        id_actividadestado = Int64(try container.decode(String.self, forKey: .id_actividadestado))
        id_programadadetalle = Int64(try container.decode(String.self, forKey: .id_programadadetalle))
        act_contingencia = try container.decodeIfPresent(String.self, forKey: .act_contingencia)
        act_fec_asignada = try container.decodeIfPresent(String.self, forKey: .act_fec_asignada)
        act_fec_anterior = try container.decodeIfPresent(String.self, forKey: .act_fec_anterior)
        act_fec_realizada = try container.decodeIfPresent(String.self, forKey: .act_fec_realizada)
        act_fec_realizada_servidor = try container.decodeIfPresent(String.self, forKey: .act_fec_realizada_servidor)
        id_producto = Int64(try container.decode(String.self, forKey: .id_producto))
        id_tipohallazgo = Int64(try container.decode(String.self, forKey: .id_tipohallazgo))
        id_tipoobservacion = Int64(try container.decode(String.self, forKey: .id_tipoobservacion))
        id_tipodocumento = Int64(try container.decode(String.self, forKey: .id_tipodocumento))
        id_usuario = Int64(try container.decode(String.self, forKey: .id_usuario))
        act_cantidad = Double(try container.decode(String.self, forKey: .act_cantidad))
        act_cantidadretirado = Double(try container.decode(String.self, forKey: .act_cantidadretirado))
        act_obs_planificador = try container.decodeIfPresent(String.self, forKey: .act_obs_planificador)
        id_postergar = Int64(try container.decode(String.self, forKey: .id_postergar))
        act_tiempo = try container.decodeIfPresent(Int64.self, forKey: .act_tiempo)
        act_fec_app = try container.decodeIfPresent(String.self, forKey: .act_fec_app)
        act_datos = try container.decodeIfPresent(String.self, forKey: .act_datos)
        act_obs_ejecutor = try container.decodeIfPresent(String.self, forKey: .act_obs_ejecutor)
        act_obs_np = try container.decodeIfPresent(String.self, forKey: .act_obs_np)
        act_subida = try container.decodeIfPresent(Int64.self, forKey: .act_subida)
        act_creada_local = try container.decodeIfPresent(Int64.self, forKey: .act_creada_local)
    }
    
    public init(id_actividad:Int64 = 0,
                id_actividadpadre: Int64 = 0,
                id_objeto: Int64 = 0,
                id_nivel: Int64 = 0,
                id_actividadestado: Int64 = 0,
                id_programadadetalle: Int64 = 0,
                act_contingencia: String = "",
                act_fec_asignada: String = "",
                act_fec_anterior: String = "",
                act_fec_realizada_servidor: String = "",
                id_producto: Int64 = 0,
                id_tipohallazgo: Int64 = 0,
                id_tipoobservacion: Int64 = 0,
                id_tipodocumento: Int64 = 0,
                id_usuario: Int64 = 0,
                act_cantidad: Double = 0,
                act_cantidadretirado: Double = 0,
                act_obs_planificador: String = "",
                id_postergar: Int64 = 0,
                act_tiempo: Int64 = 0,
                act_fec_app: String = "",
                act_datos: String = "",
                act_obs_ejecutor: String = "",
                act_obs_np: String = "",
                act_subida: Int64 = 0,
                act_creada_local: Int64 = 0
                ){
        print("Usuario nil")
    }
}

extension Actividad : TableMapping, Persistable {
    public static let databaseTableName = "actividad"
}

extension Actividad : RowConvertible {
    public init(row: Row) {
        id_actividad = row["id_actividad"]
        id_actividadpadre = row["id_actividadpadre"]
        id_objeto = row["id_objeto"]
        id_nivel = row["id_nivel"]
        id_actividadestado = row["id_actividadestado"]
        id_programadadetalle = row["id_programadadetalle"]
        act_contingencia = row["act_contingencia"]
        act_fec_asignada = row["act_fec_asignada"]
        act_fec_anterior = row["act_fec_anterior"]
        act_fec_realizada = row["act_fec_realizada"]
        act_fec_realizada_servidor = row["act_fec_realizada_servidor"]
        id_producto = row["id_producto"]
        id_tipohallazgo = row["id_tipohallazgo"]
        id_tipoobservacion = row["id_tipoobservacion"]
        id_tipodocumento = row["id_tipodocumento"]
        id_usuario = row["id_usuario"]
        act_cantidad = row["act_cantidad"]
        act_cantidadretirado = row["act_cantidadretirado"]
        act_obs_planificador = row["act_obs_planificador"]
        id_postergar = row["id_postergar"]
        act_tiempo = row["act_tiempo"]
        act_fec_app = row["act_fec_app"]
        act_datos = row["act_datos"]
        act_obs_ejecutor = row["act_obs_ejecutor"]
        act_obs_np = row["act_obs_np"]
        act_subida = row["act_subida"]
        act_creada_local = row["act_creada_local"]
        
    }
}

