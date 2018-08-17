//
//  Json.swift
//  Sigmo
//
//  Created by macOS User on 11/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

class Json2{
    
    func conectar() throws {
        // Connect to the database
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath = documentsPath.appendingPathComponent("sigmo.sqlite")
        dbQueue = try DatabaseQueue(path: databasePath)
        
        
        // Use DatabaseMigrator to setup the database
        // See https://github.com/groue/GRDB.swift/#migrations
        
    }
    //---------------------o---------------------------------
    
    //--------------FUNC JSON POR TABLA--------------------
    func jsonNew(tabla: String, page: Int = 1){
        
        let urlBase = Config.config.con_url!
        //"http://dev.skybiz.cl/sigmo/"
        
        
        let urlSync = URL(string: urlBase+"?action=app_sync&table=\(tabla)&page=\(page)")
        
        var request = URLRequest(url: urlSync!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var postString = ""
        
        postString += "id_usuario="+String(1)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = JSON(data)
            //if let json = responseJSON as? String {
            
            //print("Páginas: \(json["Pages"]) \n")
            //print("---------JSON-------:\n\(json)")
            
            
            print("Tabla: \(tabla)")
            
            
            //if let data = try? String(contentsOf: url) {
            
            
            var nivel_sql:String = ""
            var nivelvalor_sql:String = ""
            var usuario_sql:String = ""
            var niveltipo_sql:String = ""
            var usuarionivel_sql:String = ""
            
            if(tabla == "accion"){
                print("---------JSON: --------\n----------------\n\(json)")
            }
            for item in json["Data"].arrayValue {
                
                switch tabla {
                    
                    
                // ----------------- CASE: nivel ---------------------
                case "nivel":
                    
                    nivel_sql += "INSERT OR REPLACE INTO nivel (id_nivel, id_nivelpadre, id_nivelvalor, niv_ruta, niv_hijos, niv_posicion) VALUES (\(Int64((item["id_nivel"].stringValue))!), \(Int64((item["id_nivelpadre"].stringValue))!), \(Int64((item["id_nivelvalor"].stringValue))!), '\(item["niv_ruta"].stringValue)', '\(item["niv_hijos"].stringValue)', \(Int64((item["niv_posicion"].stringValue))!)); "
                    
                    // --------------- END CASE: nivel ----------------------
                    
                // ----------------- CASE: nivelvalor ---------------------
                case "nivelvalor":
                    
                    nivelvalor_sql += "INSERT OR REPLACE INTO nivelvalor (id_nivelvalor, id_niveltipo, nva_valor, nva_valorcorto) VALUES (\(Int64((item["id_nivelvalor"].stringValue))!), \(Int64((item["id_niveltipo"].stringValue))!), '\(item["nva_valor"].stringValue)', '\(item["nva_valorcorto"].stringValue)'); "
                    
                    // ----- END CASE: nivelvalor ------
                    
                // ----- CASE: USUARIO ------
                case "usuario":
                    
                    usuario_sql += "INSERT OR REPLACE INTO usuario (id_usuario, id_tipousuario, usu_rut, usu_nombre, usu_apellido) VALUES (\(Int64((item["id_usuario"].stringValue))!), \(Int64((item["id_tipousuario"].stringValue))!), '\(item["usu_rut"].stringValue)', '\(item["usu_nombre"].stringValue)', '\(item["usu_apellido"].stringValue)'); "
                    
                    // ----- END CASE: usuario ------
                    
                // ----------------- CASE: niveltipo ---------------------
                case "niveltipo":
                    
                    niveltipo_sql += "INSERT OR REPLACE INTO niveltipo (id_niveltipo, nti_nombre, nti_orden, nti_requerido) VALUES (\(Int64((item["id_niveltipo"].stringValue))!), '\(item["nti_nombre"].stringValue)', \(Int64((item["nti_orden"].stringValue))!), '\(Int64((item["nti_requerido"].stringValue))!)'); "
                    
                    // ----- END CASE: niveltipo ------
                    
                // ----------------- CASE: usuarionivel ---------------------
                case "usuarionivel":
                    if(Int64((item["id_usuario"].stringValue))! == userID){
                        usuarionivel_sql += "INSERT OR REPLACE INTO usuarionivel (id_usuario, id_nivel) VALUES (\(Int64((item["id_usuario"].stringValue))!), '\(Int64((item["id_nivel"].stringValue))!)'); "
                    }
                    // ----- END CASE: usuarionivel ------
                    
                default :
                    print( "no existe tabla: \(tabla)")
                    
                    
                } // SWITCH
                
            }// FOR
            
            
            // ------------- INSERT DE VALORES RECOLECTADOS POR JSON--------------
            
            if (nivel_sql != ""){
                do{
                    try dbQueue.inTransaction{ db in
                        try db.execute(nivel_sql)
                        return .commit
                    }
                    
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            if (nivelvalor_sql != ""){
                do{
                    try dbQueue.inTransaction{ db in
                        try db.execute(nivelvalor_sql)
                        return .commit
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            if (usuario_sql != ""){
                do{
                    try dbQueue.inTransaction{ db in
                        try db.execute(usuario_sql)
                        return .commit
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            if (niveltipo_sql != ""){
                do{
                    try dbQueue.inTransaction{ db in
                        try db.execute(niveltipo_sql)
                        return .commit
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            if (usuarionivel_sql != ""){
                do{
                    try dbQueue.inTransaction{ db in
                        try db.execute(usuarionivel_sql)
                        return .commit
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            // ------------- END INSERT DE VALORES RECOLECTADOS POR JSON--------------
            
            if ((Int(json["Pages"].stringValue))! > page){
                
                print(" - Pagina: \(page) de \(json["Pages"].stringValue) \n\n")
                self.jsonNew(tabla: tabla, page: page+1)
            }
            else
            {
                print("\n\n PAGINA FINAL \n\n")
            }
            
            
        }
        task.resume()
        
        
    }// ------------------END func jsonNew(tabla: String)-------------------------
    
    
    
    
    
    //---- SINCRONIZACION DE LAS TABLAS ----
    
    func sincronizarTablas(numSync:Int){
        
        switch numSync {
            
        case 1:
            jsonNew(tabla: "usuario")
            jsonNew(tabla: "nivel")
            jsonNew(tabla: "nivelvalor")
            jsonNew(tabla: "niveltipo")
            
        case 2:
            jsonNew(tabla: "usuarionivel")
        //jsonNew(tabla: "usuariotipodoc")
        default:
            print("No existe num de sinc")
        }
        
        
        
        
    }
}


