//
//  Request.swift
//  Sigmo
//
//  Created by macOS User on 02/03/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import Foundation
import GRDB

public class Request<T:Codable> {
  
    
    public static func postRequest(page: Int = 1, id_nivel: Int64 = 0, fecha:Bool = true, usuario:Bool = false, item: @escaping (T)->(), success: @escaping (Bool, String)->()) {
        
        let urlBase = Config.config.con_url!
        print("AMBIENTE: ", urlBase)
        let tabla = String(describing: T.self).lowercased()
        print("------ TABLA: \(tabla) ----------")
        
        let urlSync = URL(string: urlBase+"?action=app_sync&table=\(tabla)&page=\(page)")
        let fecApp = traerFechaSync(tabla: tabla, id_nivel: id_nivel, format: "yyyy-MM-dd HH:mm:ss")
        
        var request = URLRequest(url: urlSync!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var postString = ""
        if usuario{

            postString += "id_usuario=\( userID ?? 0)"
            if(id_nivel > 0){
                postString += "&id_nivel=\(id_nivel)"
            }
            if(fecha && traerFechaSync(tabla: tabla, id_nivel: id_nivel) != ""){ // Verifica si es otro ambiente para así traer todo
                postString += "&fec_app="+fecApp
            }
        }
        else{
            if(id_nivel > 0){
                postString += "id_nivel="+String(describing: id_nivel)
                if(fecha && traerFechaSync(tabla: tabla, id_nivel: id_nivel) != ""){ // Verifica si es otro ambiente para así traer todo
                    postString += "&fec_app="+fecApp
                }
            }
            else{
                if(fecha && traerFechaSync(tabla: tabla, id_nivel: id_nivel) != ""){ // Verifica si es otro ambiente para así traer todo
                    postString += "fec_app="+fecApp
                    
                }
            }
        }
        
        print("POST: ", postString)
        request.httpBody = postString.data(using: .utf8)
        
        
        // -------------------------------- TASK---------------------------------
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                success(false, error!.localizedDescription)
                return
            }
            
            guard let data = data else { return success(false, "Sync "+tabla+" Data Error") }
            do {
                let response = try JSONDecoder().decode(SyncResponse<T>.self, from: data)
                
                if(response.Total == nil){
                    response.Total = 0
                }
                
                dump(response)
                if(data.count > 0){
                    
                    try dbQueue.inTransaction { db in
                        
                        for item in response.Data{
                            
                            switch tabla {
                            case "usuario":
                                let obj = item as! Usuario
                                try obj.insert(db)
                            case "nivel":
                                let obj = item as! Nivel
                                try obj.insert(db)
                            case "nivelvalor":
                                let obj = item as! Nivelvalor
                                try obj.insert(db)
                            case "niveltipo":
                                let obj = item as! Niveltipo
                                try obj.insert(db)
                            case "accion":
                                let obj = item as! Accion
                                try obj.insert(db)
                            case "acciontipo":
                                let obj = item as! Acciontipo
                                try obj.insert(db)
                            case "actividadestado":
                                let obj = item as! Actividadestado
                                try obj.insert(db)
                            case "prioridad":
                                let obj = item as! Prioridad
                                try obj.insert(db)
                            case "producto":
                                let obj = item as! Producto
                                try obj.insert(db)
                            case "tipodocumento":
                                let obj = item as! Tipodocumento
                                try obj.insert(db)
                            case "tipoobservacion":
                                let obj = item as! Tipoobservacion
                                try obj.insert(db)
                            case "postergar":
                                let obj = item as! Postergar
                                try obj.insert(db)
                            case "tipohallazgo":
                                let obj = item as! Tipohallazgo
                                try obj.insert(db)
                                
                            // SYNCRONIZACION 2
                            case "usuarionivel":
                                let obj = item as! Usuarionivel
                                //print("\nIDNIVEL: ", obj.id_nivel!)
                                try obj.insert(db)
                            case "usuariotipodoc":
                                let obj = item as! Usuariotipodoc
                                try obj.insert(db)
                                
                            // SYNC 3
                            case "actividad":
                                let obj = item as! Actividad
                                //print("\n Act_contingencia: ", obj.act_contingencia!)
                                try obj.insert(db)
                            case "objeto":
                                let obj = item as! Objeto
                                try obj.insert(db)
                            case "programada":
                                let obj = item as! Programada
                                //print("\nIDNIVEL: ", obj.id_nivel!)
                                try obj.insert(db)
                            case "programadadetalle":
                                let obj = item as! Programadadetalle
                                try obj.insert(db)
                            case "programadaproducto":
                                let obj = item as! Programadaproducto
                                //print("\nIDNIVEL: ", obj.id_nivel!)
                                try obj.insert(db)
                            case "nivelvalorobs":
                                print("\n Nivelvalor: ", item)
                                let obj = item as! Nivelvalorobs
                                try obj.insert(db)
                                
                                default:
                                    print("Tabla \(tabla) no existe para sync")
                            }
       
                        }
                        return .commit
                    } // --- FOR ITEMS ----
                }// ------ IF TOTAL > 0 --------
                
                //Elimina las filas que se envían desde la sync
                response.Delete?.split(separator: ",").forEach { i in
                    print("ENTRA AL ELIMINAR, FROM Tabla: \(tabla)")
                    if deleteRow(tabla: tabla, campo: "id_\(tabla)", valor: "\(i)"){
                        print("ELIMINADO ID: \(i) FROM Tabla: \(tabla)")
                    }
                }
                print("\n\n_______´PAGINA: \(String(describing: response.Page))___________\n\n")
                
                if(response.Page!<response.Pages!){
                   print("FEC_APP: ",fecApp)
                    self.postRequest(page: page+1, id_nivel: id_nivel, fecha: fecha, usuario: usuario, item: item, success: success)
                }else{
                    
                    if(tabla == "actividad"){
                        print("Entra a guardar el user defaults de actFechaSync")
                        UserDefaults.standard.set(fecApp, forKey: "actFechaSync") // Fecha anterior de sync de actividad
                    }
                    success(true, "")
                    print("FEC_server: ",response.fec_app!)
                    
                    // Guarda la fecha de sync de actividades para usarla en inventario
                    
                    guardarFechaSync(tabla: tabla, id_nivel: Int(id_nivel), fec_app: response.fec_app!) // Guarda la fecha del server en  sync
                    return
                }
            } catch let jsonError {
                print("JSONError: ", jsonError)
                success(false, error!.localizedDescription)
                return
            }
        }// --------------------  END TASK ------------------------
        
        task.resume()
    }
}

