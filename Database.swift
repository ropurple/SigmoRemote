//
//  Db2.swift
//  Sqlite
//
//  Created by macOS User on 06/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import GRDB
import UIKit

var dbQueue: DatabaseQueue!

func setupDatabase(_ application: UIApplication) throws -> DatabaseQueue{
    
    // Connect to the database
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
    let databasePath = documentsPath.appendingPathComponent("sigmo.sqlite")
    dbQueue = try DatabaseQueue(path: databasePath)
    
    // Be a nice iOS citizen, and don't consume too much memory
    // See https://github.com/groue/GRDB.swift/#memory-management
    
    dbQueue.setupMemoryManagement(in: application)
    
    return dbQueue
}


//-----------CARGA INICIAL DE LA APLICACION---------------

func crearTablas(num: Int)throws{
    // Use DatabaseMigrator to setup the database
    // See https://github.com/groue/GRDB.swift/#migrations
    
    try dbQueue.inTransaction{ db in
        switch num {
            
        case 0: // TABLAS PERMANENTES DEL SISTEMA
            
                try db.execute("DROP TABLE IF EXISTS log");
                try db.execute("CREATE TABLE IF NOT EXISTS log (" +
                    "id_log INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "id_usuario INT (11)," +
                    "equ_imei VARCHAR (250)," +
                    "log_fecha DATETIME," +
                    "log_nombre_foto VARCHAR(250)," +
                    "log_mensaje VARCHAR(100)," +
                    "log_detalle TEXT," +
                    "log_porsubir INT (1)," +
                    "id_tipo_error INT (1))")
            
                try db.execute("DROP TABLE IF EXISTS sync");
                try db.execute("CREATE TABLE IF NOT EXISTS sync (" +
                    "id_sync INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "syn_tabla VARCHAR(80)," +
                    "syn_fecha DATETIME," +
                    "id_nivel INT (11))")
            
                try db.execute("DROP TABLE IF EXISTS config");
                try db.execute("CREATE TABLE IF NOT EXISTS config (" +
                    "id_config INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "con_nombre VARCHAR(50)," +
                    "con_url TEXT," +
                    "con_imei VARCHAR(200)," +
                    "State INT(1)," +
                    "Message TEXT," +
                    "con_ftp_path VARCHAR(200)," +
                    "version VARCHAR(50))")
                
                try db.execute("DROP TABLE IF EXISTS log");
                try db.execute("CREATE TABLE IF NOT EXISTS log (" +
                    "id_log INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "id_usuario INT(11)," +
                    "log_fecha DATETIME," +
                    "log_tabla VARCHAR (50)," +
                    "log_msje VARCHAR (200))")

        case 1: // SYNC 1
            // -------------------TABLA: USUARIO------------------
            // ---------------------------------------------------
                try db.execute("DROP table if exists usuario")
                try db.execute("CREATE TABLE IF NOT EXISTS usuario (" +
                    "id_usuario INT (11) PRIMARY KEY, " +
                    "id_tipousuario INTEGER, " +
                    "usu_rut VARCHAR(10), " +
                    "usu_nombre VARCHAR(100), " +
                    "usu_apellido VARCHAR(100), " +
                    "usu_cantidad_faenas INTEGER," +
                    "usu_login VARCHAR(50), " +
                    "usu_pass VARCHAR (100)," +
                    "usu_estado INT (1))")
            
            
            //---FETCH A USUARIOS------
            /*try dbQueue.inDatabase { db in
             
             let usuarios = try Usuario.fetchAll(db, "SELECT * FROM usuario ORDER BY id_usuario") // DEVUELVE UN ARRAY DE USUARIOS
             // RECORRE EL ARRAY DE USUARIOS E IMPRIME SUS VALORES
             if(usuarios.count == 0){
             print("No existen registros")
             }
             
             }//--------O-----------
             
             */
            // -------------------TABLA: NIVEL------------------
            // ---------------------------------------------------
            
                try db.execute("DROP table if exists nivel")
                try db.execute("CREATE TABLE IF NOT EXISTS nivel (" +
                    "id_nivel INT (11) PRIMARY KEY, " +
                    "id_nivelpadre INT (11)," +
                    "id_nivelvalor INT (11)," +
                    "niv_ruta TEXT," +
                    "niv_hijos TEXT," +
                    "niv_posicion INT (11))")
            
            // -------------------TABLA: NIVELVALOR------------------
            // ---------------------------------------------------
            
                try db.execute("DROP table if exists nivelvalor")
                try db.execute("CREATE TABLE IF NOT EXISTS nivelvalor (" +
                    "id_nivelvalor INT (11) PRIMARY KEY, " +
                    "id_niveltipo INT (11)," +
                    "nva_valor VARCHAR (250)," +
                    "nva_valorcorto VARCHAR (100))")
            
            // -------------------TABLA: NIVELTIPO------------------
            // ---------------------------------------------------
            
                try db.execute("DROP table if exists niveltipo")
                try db.execute("CREATE TABLE IF NOT EXISTS niveltipo (" +
                    "id_niveltipo INT (11) PRIMARY KEY, " +
                    "nti_nombre VARCHAR(250)," +
                    "nti_orden INT (2)," +
                    "nti_requerido INT (1))")
            
            
            
            
            //USUARIOTIPODOC
                try db.execute("DROP TABLE IF EXISTS usuariotipodoc");
                try db.execute("CREATE TABLE IF NOT EXISTS usuariotipodoc (" +
                    "id_usuario INT (11), " +
                    "id_nivel INT (11)," +
                    "id_tipodocumento INT (11)," +
                    "PRIMARY KEY (id_usuario, id_nivel, id_tipodocumento))")
            
            //ACCION
                try db.execute("DROP TABLE IF EXISTS accion");
                try db.execute("CREATE TABLE IF NOT EXISTS accion (" +
                    "id_accion INT (11) PRIMARY KEY, " +
                    "id_acciontipo INT (11)," +
                    "acc_nombre TEXT," +
                    "acc_riesgo TEXT," +
                    "acc_control TEXT," +
                    "acc_capacitacion TEXT," +
                    "acc_lubricante INT (1)," +
                    "acc_foto INT (1))")
            
            //ACCIONTIPO
                try db.execute("DROP TABLE IF EXISTS acciontipo");
                try db.execute("CREATE TABLE IF NOT EXISTS acciontipo (" +
                    "id_acciontipo INT (11) PRIMARY KEY, " +
                    "ati_nombre VARCHAR(100))")
            
           
            
            //ACTIVIDADESTADO
                try db.execute("DROP TABLE IF EXISTS actividadestado");
                try db.execute("CREATE TABLE IF NOT EXISTS actividadestado (" +
                    "id_actividadestado INT (11) PRIMARY KEY, " +
                    "ade_nombre VARCHAR(250))")
        
            
            //PRIORIDAD
                try db.execute("DROP TABLE IF EXISTS prioridad");
                try db.execute("CREATE TABLE IF NOT EXISTS prioridad (" +
                    "id_prioridad INT (11) PRIMARY KEY, " +
                    "pri_nombre VARCHAR(250)," +
                    "pri_orden INT (11))")
            
            //PRODUCTO
                try db.execute("DROP TABLE IF EXISTS producto");
                try db.execute("CREATE TABLE IF NOT EXISTS producto (" +
                    "id_producto INT (11) PRIMARY KEY, " +
                    "pro_nombre VARCHAR(250)," +
                    "pro_descripcion TEXT)")
            
            
            
            //TIPODOCUMENTO
                try db.execute("DROP TABLE IF EXISTS tipodocumento");
                try db.execute("CREATE TABLE IF NOT EXISTS tipodocumento (" +
                    "id_tipodocumento INT (11) PRIMARY KEY, " +
                    "tdo_nombre VARCHAR(250)," +
                    "tdo_nombrecorto VARCHAR(100)," +
                    "tdo_orden INT (11))")
                
            //TIPOOBSERVACION
                try db.execute("DROP TABLE IF EXISTS tipoobservacion");
                try db.execute("CREATE TABLE IF NOT EXISTS tipoobservacion (" +
                    "id_tipoobservacion INT (11) PRIMARY KEY, " +
                    "tob_nombre VARCHAR(250)," +
                    "tob_default INT (1))")
            
            //POSTERGAR
                try db.execute("DROP TABLE IF EXISTS postergar");
                try db.execute("CREATE TABLE IF NOT EXISTS postergar (" +
                    "id_postergar INT (11) PRIMARY KEY, " +
                    "pos_nombre VARCHAR(250))")
            
            //TIPOHALLAZGO
                try db.execute("DROP TABLE IF EXISTS tipohallazgo");
                try db.execute("CREATE TABLE IF NOT EXISTS tipohallazgo (" +
                    "id_tipohallazgo INT (11) PRIMARY KEY, " +
                    "tha_nombre VARCHAR(250))")
            
            //FOTO
                try db.execute("DROP TABLE IF EXISTS foto");
                try db.execute("CREATE TABLE IF NOT EXISTS foto (" +
                    "id_foto INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "id_actividad INT(11)," +
                    "fot_nombre VARCHAR (100)," +
                    "fot_peso INT(11)," +
                    "fot_orden INT(2)," +
                    "fot_subida INTEGER," +
                    "con_url VARCHAR (100))")
                
            
            // Al cambiar de ambiente se debe borrar SYNC
                try db.execute("DROP TABLE IF EXISTS sync");
                try db.execute("CREATE TABLE IF NOT EXISTS sync (" +
                    "id_sync INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    "syn_tabla VARCHAR(80)," +
                    "syn_fecha DATETIME," +
                    "id_nivel INT (11))")
            
        case 2: // SYNC2
            
            // -------------------TABLA: USUARIONIVEL------------------
            // ---------------------------------------------------
                try db.execute("DROP table if exists usuarionivel")
                try db.execute("CREATE TABLE IF NOT EXISTS usuarionivel (" +
                    "id_usuario INT (11), " +
                    "id_nivel INT (11)," +
                    "PRIMARY KEY (id_usuario, id_nivel))")
            
            //USUARIOTIPODOC
                try db.execute("DROP TABLE IF EXISTS usuariotipodoc");
                try db.execute("CREATE TABLE IF NOT EXISTS usuariotipodoc (" +
                    "id_usuario INT (11), " +
                    "id_nivel INT (11)," +
                    "id_tipodocumento INT (11)," +
                    "PRIMARY KEY (id_usuario, id_nivel, id_tipodocumento))")
            
        case 3: // Sync 3, Después de selección de NIVEL
            
            //ACTIVIDAD
            try db.execute("DROP TABLE IF EXISTS actividad");
            try db.execute("CREATE TABLE IF NOT EXISTS actividad (" +
                "id_actividad INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "id_actividadpadre INT (11)," +
                "id_objeto INT (11)," +
                "id_nivel INT (11)," +
                "id_actividadestado INT (11)," +
                "id_programadadetalle INT (11)," +
                "act_contingencia TEXT," +
                "act_fec_asignada DATETIME," +
                "act_fec_anterior DATETIME," +
                "act_fec_realizada DATETIME," +
                "act_fec_realizada_servidor DATETIME," +
                "id_producto INT (11)," +
                "id_tipohallazgo INT (11)," +
                "id_tipoobservacion INT (11)," +
                "id_tipodocumento INT (11)," +
                "id_usuario INT (11)," +
                "act_cantidad DOUBLE," +
                "act_cantidadretirado DOUBLE," +
                "act_obs_planificador TEXT," +
                "id_postergar INT (11)," +
                "act_tiempo INT (11)," +
                "act_fec_app DATETIME," +
                "act_datos TEXT," +         //JSON DATOS ADICIONALES
                "act_obs_ejecutor TEXT," +
                "act_obs_np TEXT," +
                "act_subida INT(1)," +
                "act_creada_local INT(1))")
            
            //INVENTARIO
            try db.execute("DROP TABLE IF EXISTS inventario");
            try db.execute("CREATE TABLE IF NOT EXISTS inventario (" +
                "id_inventario INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "id_actividad INT (11)," +
                "inv_estado INT (1))")
            
            //INVENTARIODETALLE
            try db.execute("DROP TABLE IF EXISTS inventariodetalle");
            try db.execute("CREATE TABLE IF NOT EXISTS inventariodetalle (" +
                "id_inventariodetalle INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "id_inventario INT (11)," +
                "ind_index VARCHAR (12)," +
                "ind_valor DOUBLE," +
                "pro_nombre VARCHAR (200)," +
                "pro_codigo VARCHAR (12)," +
                "pro_envase VARCHAR (50)," +
                "ind_estado INT (1))")
            
            
            //OBJETO
            try db.execute("DROP TABLE IF EXISTS objeto");
            try db.execute("CREATE TABLE IF NOT EXISTS objeto (" +
                "id_objeto INT (11) PRIMARY KEY," +
                "id_objetopadre INT (11)," +
                "id_nivel INT (11)," +
                "obj_nombre VARCHAR(250)," +
                "obj_nombrecorto VARCHAR(250)," +
            "obj_orden INT (11))")
            
            //PROGRAMADA
            try db.execute("DROP TABLE IF EXISTS programada");
            try db.execute("CREATE TABLE IF NOT EXISTS programada (" +
                "id_programada INT (11) PRIMARY KEY, " +
                "id_objeto INT (11)," +
                "id_accion INT (11)," +
                "prg_orden INT (11)," +
                "prg_nombre VARCHAR(100)," +
            "prg_detalle TEXT)")
            
            //PROGRAMADADETALLE
            try db.execute("DROP TABLE IF EXISTS programadadetalle");
            try db.execute("CREATE TABLE IF NOT EXISTS programadadetalle (" +
            "id_programadadetalle INT (11) PRIMARY KEY, " +
            "id_programada INT (11)," +
            "id_tipodocumento INT (11)," +
            "id_frecuencia INT (11)," +
            "id_prioridad INT (11)," +
            "pde_tiempo INT (11))")
            
            //PROGRAMADAPRODUCTO
            try db.execute("DROP TABLE IF EXISTS programadaproducto");
            try db.execute("CREATE TABLE IF NOT EXISTS programadaproducto (" +
            "id_programadaproducto INT (11) PRIMARY KEY, " +
            "id_programadadetalle INT (11)," +
            "id_producto INT (11)," +
            "ppr_cantidad DOUBLE," +
            "ppr_principal INT (1))")
            
            //NIVELVALOROBS
            try db.execute("DROP TABLE IF EXISTS nivelvalorobs");
            try db.execute("CREATE TABLE IF NOT EXISTS nivelvalorobs (" +
            "id_nivelvalor INT (11), " +
            "id_tipoobservacion INT (11)," +
            "PRIMARY KEY (id_nivelvalor, id_tipoobservacion))")
            
            
        default:
            print("NO EXISTE SYNC")
        }
        
        return .commit
    }
     
    
    
    
    print("CREACION TABLAS", "TODAS OK");
 
 
    
}//-----------------------END FUNC cargaInicial()--------------------
//-------------------------------------------------------------------



//--------FETCH A TABLA USUARIOS---------

func fetchUsuarios() -> [Usuario]{
    
    var usuarios = [Usuario]()
    do{
        try dbQueue.inTransaction { db in
            usuarios = try Usuario.fetchAll(db, "SELECT * FROM usuario ORDER BY id_usuario") // DEVUELVE UN ARRAY DE USUARIOS
            if(usuarios.count > 0){
                //print("Existen")
            }
            else{
                print("No existen usuarios!")
            }
            return .commit
        }
        //--------O-----------
    }catch{
        print(error)
    }
    return usuarios
    
}//-------------------END FETCH-----------------------


func fetchUsuario(usu_rut: String) -> Usuario{
    
    var usuario = Usuario()
    do{
        try dbQueue.inDatabase { db in
            if let usu = try Usuario.fetchOne(db, "SELECT * FROM usuario WHERE usu_rut = ?", arguments: [usu_rut]){
                usuario = usu
                print("Usuario: ", usu)
            }//if let usu = try Usuario.fetchOne(db, key: id_usuario){
                //print(usu.usu_nombre!, usu.usu_apellido!)
            else{
                usuario.id_usuario = 0
            }
        }
    }
    catch{
        print(error)
    }
    return usuario
}

func updatePass(usuario: Usuario) -> Bool{
    
    var exito = false
    
    do{
        try dbQueue.inDatabase { db in
            
            try usuario.insert(db)
            exito = true
        }
    }
    catch{
        print(error)
        exito = false
    }
    return exito
}

func limpiarPass() -> Bool{
    
    var exito = false
    let sql = "UPDATE usuario SET usu_pass = '' "
    do{
        try dbQueue.inDatabase { db in
            
            try db.execute(sql)
            exito = true
        }
    }
    catch{
        print(error)
        exito = false
    }
    return exito
}

func fetchUsunivel() -> [Usuarionivel]{
    
    var usuarios = [Usuarionivel]()
    do{
        try dbQueue.inTransaction { db in
            usuarios = try Usuarionivel.fetchAll(db, "SELECT * FROM usuarionivel") // DEVUELVE UN ARRAY DE USUARIOS
            if(usuarios.count > 0){
                //print("Existen")
            }
            else{
                print("No existen usuarios!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return usuarios
    
}//-------------------END FETCH-----------------------

func fetchNivel() -> [Nivel]{
    
    var usuarios = [Nivel]()
    do{
        try dbQueue.inTransaction { db in
            usuarios = try Nivel.fetchAll(db, "SELECT * FROM nivel") // DEVUELVE UN ARRAY DE USUARIOS
            if(usuarios.count > 0){
                //print("Existen")
            }
            else{
                print("No existen Nivel!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return usuarios
    
}//-------------------END FETCH-----------------------

func fetchNivelvalor() -> [Nivelvalor]{
    
    var usuarios = [Nivelvalor]()
    do{
        try dbQueue.inTransaction { db in
            usuarios = try Nivelvalor.fetchAll(db, "SELECT * FROM nivelvalor") // DEVUELVE UN ARRAY DE USUARIOS
            if(usuarios.count > 0){
                //print("Existen")
            }
            else{
                print("No existen Nivelvalor!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return usuarios
    
}//-------------------END FETCH-----------------------

func fetchNiveltipo() -> [Niveltipo]{
    
    var usuarios = [Niveltipo]()
    do{
        try dbQueue.inTransaction { db in
            usuarios = try Niveltipo.fetchAll(db, "SELECT * FROM niveltipo") // DEVUELVE UN ARRAY DE USUARIOS
            if(usuarios.count > 0){
                //print("Existen")
            }
            else{
                print("No existen Niveltipo!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return usuarios
    
}//-------------------END FETCH-----------------------


func fetchActividad(id_actividad: Int64) -> Actividad{
    
    var actividad = Actividad()
    do{
        try dbQueue.inTransaction { db in
            if let act = try Actividad.fetchOne(db, "SELECT * FROM actividad WHERE id_actividad = ?", arguments: [id_actividad]){
                actividad = act
            }//if let usu = try Usuario.fetchOne(db, key: id_usuario){
                //print(usu.usu_nombre!, usu.usu_apellido!)
            else{
                actividad.id_actividad = 0
            }
            return .commit
        }
    }
    catch{
        print(error)
    }
    return actividad
}

func fetchActividades() -> [Actividad]{
    
    var actividades = [Actividad]()
    do{
        try dbQueue.inTransaction { db in
            actividades = try Actividad.fetchAll(db)
            /*
             fetchAll(db, "SELECT strftime('%Y-%m-%d',a.act_fec_asignada) as fecha, strftime('%w', a.act_fec_asignada) as weekday, count(*) as c,  SUM(CASE WHEN p.id_prioridad = 1 THEN 1 ELSE 0 END) AS alta, SUM(CASE WHEN p.id_prioridad = 2 THEN 1 ELSE 0 END) AS media, SUM(CASE WHEN p.id_prioridad = 3 THEN 1 ELSE 0 END) AS baja FROM usuariotipodoc u INNER JOIN actividad a ON a.id_nivel = u.id_nivel AND a.id_nivel IN (3) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento AND a.act_fec_asignada BETWEEN '2018-01-08 00:00:00' AND '2018-01-14 23:59:59' INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle WHERE u.id_usuario = '1' GROUP BY strftime('%Y-%m-%d',a.act_fec_asignada) ORDER BY a.act_fec_asignada ASC") // DEVUELVE UN ARRAY DE USUARIOS
             */
            if(actividades.count > 0){
                print("ACTIVIDADES TOTAL: \n\n", actividades)
            }
            else{
                print("No existen ACTIVIDADES!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return actividades
    
}//-------------------END FETCH-----------------------

func fetchActividadesPendientes() -> [Actividad]{
    
    var actividades = [Actividad]()
    let sql = "SELECT * FROM actividad WHERE act_subida = 0 "
    do{
        try dbQueue.inTransaction { db in
            actividades = try Actividad.fetchAll(db, sql)
            /*
             fetchAll(db, "SELECT strftime('%Y-%m-%d',a.act_fec_asignada) as fecha, strftime('%w', a.act_fec_asignada) as weekday, count(*) as c,  SUM(CASE WHEN p.id_prioridad = 1 THEN 1 ELSE 0 END) AS alta, SUM(CASE WHEN p.id_prioridad = 2 THEN 1 ELSE 0 END) AS media, SUM(CASE WHEN p.id_prioridad = 3 THEN 1 ELSE 0 END) AS baja FROM usuariotipodoc u INNER JOIN actividad a ON a.id_nivel = u.id_nivel AND a.id_nivel IN (3) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento AND a.act_fec_asignada BETWEEN '2018-01-08 00:00:00' AND '2018-01-14 23:59:59' INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle WHERE u.id_usuario = '1' GROUP BY strftime('%Y-%m-%d',a.act_fec_asignada) ORDER BY a.act_fec_asignada ASC") // DEVUELVE UN ARRAY DE USUARIOS
             */
            if(actividades.count > 0){
                print("\n\n ACTIVIDADES PENDIENTES: \n\n", actividades.count)
            }
            else{
                print("No existen ACTIVIDADES Pendientes!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return actividades
    
}//-------------------END FETCH-----------------------



//----------------- FOTOS ------------------------

func fetchFoto(id_actividad: Int64, fot_orden: Int64 ) -> Foto{
    
    var foto = Foto()
    do{
        try dbQueue.inTransaction { db in
         
            if let pic = try Foto.fetchOne(db, "SELECT * FROM foto WHERE id_actividad = ? AND fot_orden = ?", arguments: [id_actividad, fot_orden]){
                foto = pic
                print("Foto \(pic.fot_orden!): \(foto)")
            }
            return .commit
        }
        
    }
    catch{
        print(error)
    }
    return foto
}

func fetchFotos(id_actividad: Int64 = 0, subida: Int64 = 2) -> [Foto]{
    
    var fotos:[Foto] = []
    var sql = ""
    
    if id_actividad == 0 {
        sql = "SELECT * FROM foto WHERE fot_subida = 1 ORDER BY fot_orden"
    
        if subida == 1 {
            sql = "SELECT * FROM foto WHERE fot_subida = 1 ORDER BY fot_orden"
        }
        if subida == 0 {
            sql = "SELECT * FROM foto WHERE fot_subida = 0 ORDER BY fot_orden"
        }
    }
    else{
        if subida == 1 {
            sql = "SELECT * FROM foto WHERE id_actividad = \(id_actividad) AND fot_subida = 1 ORDER BY fot_orden"
        }
        if subida == 0 {
            sql = "SELECT * FROM foto WHERE id_actividad = \(id_actividad) AND fot_subida = 0 ORDER BY fot_orden"
        }
        if subida == 2 {
            sql = "SELECT * FROM foto WHERE id_actividad = \(id_actividad) ORDER BY fot_orden"
        }
    }
    
    do{
        try dbQueue.inTransaction { db in

            let pics = try Foto.fetchAll(db, sql)
                fotos = pics
            return .commit
        }
    }
    catch{
        print(error)
    }
    return fotos
}

func fetchFotosPendientes() -> [Foto]{
    
    var fotos:[Foto] = []
    let sql = "SELECT * FROM foto f " +
                "INNER JOIN actividad a ON a.id_actividad = f.id_actividad AND a.act_subida = 1 WHERE fot_subida = 0"
    
    do{
        try dbQueue.inTransaction { db in
            
            let pics = try Foto.fetchAll(db, sql)
            fotos = pics
            return .commit
        }
    }
    catch{
        print(error)
    }
    return fotos
}

func insertFoto(id_actividad : Int64?, fot_nombre : String?, fot_peso : Int64?, fot_orden : Int64?, fot_subida : Int64?, con_url : String?) -> Bool{
    
    var bool = false
    do{
        try dbQueue.inTransaction { db in
            try db.execute(
                "INSERT INTO foto (id_actividad, fot_nombre, fot_peso, fot_orden, fot_subida, con_url) VALUES (?, ?, ?, ?, ?, ?)",
                arguments: [ id_actividad!, fot_nombre!, fot_peso!, fot_orden!, fot_subida!, con_url!]
            )
            bool = true
            print("Foto \(id_actividad!)_\(fot_orden!) guardada en local")
            return .commit
        }
    }
    catch{
        print(error)
    }
    return bool
}




// ----------------------- UPDATE GENÉRICO ---------------------------
func updateTable(tabla: String, campo: String, valor: String, whereCampo: String, whereValor: String, whereCampo2: String = "", whereValor2: String = ""){
    
    var donde = whereCampo+" = ?"
    if(whereCampo2 != ""){
        donde += " AND \(whereCampo2) = ?"
    }
    
    let updateSql = "UPDATE \(tabla) SET \(campo) = ? WHERE \(donde)"
  
    do{
        try dbQueue.inTransaction{ db in
            
            //let updateStatement = try db.makeUpdateStatement(updateSql)
            
            var arguments: StatementArguments = [valor, whereValor]
            
            if(whereCampo2 != ""){
                arguments = [valor, whereValor, whereValor2]
            }
            
            try db.execute(updateSql, arguments: arguments)
            
            return .commit
        }
    }
    catch{
        print(error)
    }
    
    
    /* \(whereCampo) = '\(whereValor)' "
    
    if(whereCampo2 != ""){
        updateSql += "AND \(whereCampo2) = '\(whereValor2)' "
    }
    
    if(whereCampo3 != ""){
        updateSql += "AND \(whereCampo3) = '\(whereValor3)' "
    }
    */
    
}// --------- END Update genérico ------------




func traerFechaSync(tabla: String, id_nivel: Int64 = 0, format: String = "dd-MM-yyyy HH:mm:ss") ->String{
    
    var fecha:String? = ""
    var id_nivelString = ""
    if(id_nivel > 0){
        id_nivelString = "AND id_nivel = '\(id_nivel)'"
    }
    do{
        try dbQueue.inTransaction { db in
            if let fec = try Sync.fetchOne(db, "SELECT syn_fecha FROM sync WHERE syn_tabla = '\(tabla)' \(id_nivelString) Order by datetime(syn_fecha) desc LIMIT 1"){
            print("FECHA SYNC : \(fec.syn_fecha!)")
                
                fecha = formatearFecha(fecha: stringToDate(fechaString: fec.syn_fecha!, hora: true), format: format)
            }
            else{
                print("No hay fecha para la tabla")
            }
            return .commit
        }
    }
    catch{
        print(error)
    }
    return fecha!
}

func fetchSync(){
    
       do{
        try dbQueue.inTransaction { db in
            let fec = try Sync.fetchAll(db, "SELECT * FROM sync Order by strftime('%d-%m-%Y %H:%M:%S', datetime(syn_fecha)) DESC ")
            
            for i in fec{
                print("ID: \(i.id_sync!), Tabla: \(i.syn_tabla!), Fecha: \(i.syn_fecha!), Nivel: \(i.id_nivel!)" )
            }
            return .commit
        }
    }
    catch{
        print(error)
    }
}

func guardarFechaSync(tabla: String, id_nivel: Int = 0, fec_app: String){
    //let fecha = stringToDate(fechaString: fec_app, hora: true, format: "yyyy-MM-dd HH:mm:ss")
    //let fecha = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
    //let date = stringToDate(fechaString: fecha)
    do{
        try dbQueue.inTransaction { db in
            try db.execute(
                "INSERT INTO sync (syn_tabla, syn_fecha, id_nivel) VALUES (?, ?, ?)",
                arguments: [ tabla, fec_app, id_nivel])
            print("SYNCRO: ", fec_app, tabla)
            return .commit
        }
    }
    catch{
        print(error)
    }
}

func fetchConfig() -> ConfigResponse{
    
    var config:ConfigResponse? = ConfigResponse()
    
    do{
        try dbQueue.inTransaction { db in
            if let con = try ConfigResponse.fetchOne(db){
                print("Ultima CONFIG: ", con.con_nombre!)
                config = con
            }
            else{
                print("No existe Config!")
            }
            return .commit
        }
    }
    catch{
        print(error)
    }
    return config!
}

func guardarConfig(config: ConfigResponse) -> Bool{
    
    var exito = false
   
    do{
        try dbQueue.inTransaction { db in
            try ConfigResponse.deleteAll(db)
            
            try config.insert(db)
            exito = true
            return .commit
        }
    }
    catch{
        print(error)
        exito = false
    }
    return exito
}

func fetchTipoobservacion(id_nivelvalor: Int = 0) -> [Tipoobservacion]{
    
    var tipoObs = [Tipoobservacion]()
    var string = ""
    if(id_nivelvalor > 0){
        string = "WHERE id_nivelvalor = \(id_nivelvalor)"
    }
    else{
        string = "WHERE tob_default = 1"
    }
    do{
        
        try dbQueue.inTransaction { db in
            tipoObs = try Tipoobservacion.fetchAll(db, "SELECT * FROM tipoobservacion \(string)") // DEVUELVE UN ARRAY DE tipoObs
            if(tipoObs.count > 0){
                //print("Existen")
            }
            else{
                print("No existen tipoObs!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return tipoObs
    
}//-------------------END FETCH-----------------------



func fetchPostergar() -> [Postergar]{
    
    var postergados = [Postergar]()
    do{
        try dbQueue.inTransaction { db in
            postergados = try Postergar.fetchAll(db)
           
            if(postergados.count > 0){
                print("Existen postergados: \n\n", postergados)
            }
            else{
                print("No existen postergados!")
            }
            return .commit
        }//--------O-----------
    }catch{
        print(error)
    }
    return postergados
} // --------------------  END FETCH ---------------------

func insertLog(log: Log) -> Bool{
    
    var exito = false
    
    do{
        try dbQueue.inTransaction { db in
            
            try log.insert(db)
            exito = true
            return .commit
            
        }
    }
    catch{
        print(error)
        exito = false
    }
    return exito
}

func deleteRow(tabla: String, campo: String, valor: String) -> Bool{
    
    var bool = false
    do{
        try dbQueue.inTransaction { db in
            try db.execute(
                "DELETE FROM \(tabla) WHERE \(campo) = \(valor)")
            bool = true
            print("ID: \(valor) eliminado  de tabla: \(tabla)")
            return .commit
        }
    }
    catch{
        print(error)
    }
    return bool
}

func insertInventario(id_actividad : Int64?) -> Int64{
    
    var id_inv:Int64 = 0
    
    do{
        try dbQueue.inTransaction { db in
            try db.execute(
                "INSERT INTO inventario (id_actividad, inv_estado) VALUES (?, ?)",
                arguments: [ id_actividad!, 1]
            )
            id_inv = db.lastInsertedRowID
            print("id_inv:  \(id_inv)")
            return .commit
        }
    }
    catch{
        print(error)
    }
    return id_inv
}

func insertInvDetalle(id_inventario: Int64?, ind_index: String?, ind_valor: Double?, pro_nombre: String?, pro_codigo: String?, pro_envase: String?) -> Bool{
    
    var bool = false
    
    do{
        try dbQueue.inTransaction { db in
            try db.execute(
                "INSERT INTO inventariodetalle (id_inventario, ind_index, ind_valor, pro_nombre, pro_codigo, pro_envase, ind_estado) VALUES (?, ?, ?, ?, ?, ?, ?)",
                arguments: [ id_inventario!, ind_index!, ind_valor!, pro_nombre!, pro_codigo!, pro_envase!, 1]
            )
            bool = true
            return .commit
        }
    }
    catch{
        print(error)
    }
    return bool
}












