//
//  Funciones.swift
//  Sigmo
//
//  Created by macOS User on 23/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


func alertWithTitle(title:String, msg:String, vc:UIViewController)
{
    let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

extension UIViewController {
    
    public func showToast(message : String, bottom: CGFloat = 150) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-bottom, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name:"AvenirNextCondensed-Medium", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1.0, delay: 2, options: .transitionFlipFromBottom, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

func borrarTablas(){
    try! crearTablas(num: 0) // BORRA Y CREA LAS TABLAS internas
    try! crearTablas(num: 1)
    try! crearTablas(num: 2)
    try! crearTablas(num: 3)
}
// ------------------------- FUNCIONES FECHAS -------------------------------
// --------------------------------------------------------------------------

func fechaNow()->String{
    
    let date = DateFormatter()
    let hoy = Date()
    date.timeStyle = .medium
    date.dateStyle = .medium
    date.locale = Locale(identifier: "es_CL")
    let fechaFormat = date.string(from: hoy)
    //print("Fecha: "+fechaFormat)
    
    return fechaFormat
    //return "30-03-2018 11:32:40"
}

// ---------- Modifica los días de la fecha add o menos ---------
func addDays(fecha: Date, cant: Int = 7) -> Date {
    
    let fechaNueva = Calendar.current.date(byAdding: .day, value: cant, to: fecha)
    return fechaNueva!
    
}//------------------------ o ----------------------


// ---- Entrega el formato de chile para la fecha sin time-----
func formatearFecha(fecha: Date, format:String = "", hora: Bool = false) -> String{
    
    let date = DateFormatter()
    date.dateStyle = .medium
    if(hora){
        date.timeStyle = .medium
    }
    date.locale = Locale(identifier: "es_CL")
    if(format != ""){
        date.dateFormat = format
    }
    
    let fechaFormat = date.string(from: fecha)
    
    return fechaFormat.uppercased()
}//------------------------ o ----------------------

func stringToDate(fechaString: String, hora: Bool, format: String = "yyyy-MM-dd") -> Date{
    
    let date = DateFormatter()
    var formato = format
    date.dateStyle = .medium
    date.locale = Locale(identifier: "es_CL")
    if(hora){
        formato += " HH:mm:ss"
    }
    date.dateFormat = formato
    //print(formato, fechaString)
    
    let fechaFormat = date.date(from: fechaString)
    
    return fechaFormat!
}//------------------------ o ----------------------

//------------------------ FIN FUNCIONES FECHAS --------------------------------
//------------------------------------------------------------------------------


//--------- IMG para navigation bar en derecha (Logo SIGMO)------------------

    func imgBarRight(vc: UIViewController){
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "sigmo4"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        //button.addTarget(target, action: nil, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        vc.navigationItem.rightBarButtonItems = [barButtonItem]
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }//----------------------- o ------------------------------


// -------------- DIRECTORIO PARA GUARDAR IMG ---------------

    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }// ------------ END Directorio -------------


// ---------------- REQUESTS FUNCTIONS ------------------------------
// ------------------------------------------------------------------

    func loginServer(id_usuario: Int64, usu_pass: String, equ_imei: String, success: @escaping (Bool, String)->()) {
        
        let urlBase = Config.config.con_url!
        print("URLBASE: ", urlBase)
        
        
        let urlSync = URL(string: urlBase+"?action=app_login")
        
        var request = URLRequest(url: urlSync!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var postString = ""
        
        postString  += "id_usuario="+String(id_usuario)
        postString += "&usu_pass="+usu_pass
        postString += "&equ_imei="+equ_imei
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = JSON(data)
            print("-------JSON--------\n\(json)")
            if(json["State"] == 1){
                success(true, json["Message"].stringValue)
                print("JSON: \(json["Message"])")
                
                
                
            }
            else{
                success(false, json["Message"].stringValue)
                //passCorrecto = false
                //passServer = false
            }
        }
        task.resume()
    }

func ultimaConexion(equ_imei: String, success: @escaping (Bool, String)->()) {
    
    let urlBase = Config.config.con_url!
    print("URLBASE: ", urlBase)
    
    
    let urlSync = URL(string: urlBase+"?action=app_insert_ultima_conexion")
    
    var request = URLRequest(url: urlSync!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    let postString = "log_imei="+String(equ_imei)
    
    request.httpBody = postString.data(using: .utf8)
    print(postString)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let json = JSON(data)
        print("-------JSON----Ultima conexión----\n\(json)")
        if(json["State"] == 1){
            success(true, json["Message"].stringValue)
            print("JSON: \(json["Message"])")
        
        }
        else{
            success(false, json["Message"].stringValue)
            //passCorrecto = false
            //passServer = false
        }
    }
    task.resume()
}



    //-------------------------------  ACTIVIDADES -------------------------------------//
    //----------------------------------------------------------------------------------//


func updateActividadLocal(id_actividad: Int64, id_producto: Int64 = 0, act_cantidad: Double = 0, act_obs_ejecutor: String, id_tipoobservacion: Int64, id_usuario: Int64, id_actividadestado: Int64, act_fec_realizada: String, act_datos: String, id_postergar: Int64 = 0, act_tiempo: Int64 = 0, act_fec_asignada: String = "") {
    
    print("------ ID_ACT_ESTADO: ", id_actividadestado," ------------")
            let updateSql = "UPDATE actividad SET id_producto = ?, act_cantidad = ?, act_obs_ejecutor = ?, id_tipoobservacion = ?, id_usuario = ?, id_actividadestado = ?, act_fec_realizada = ?, act_datos = ?, id_postergar = ?, act_tiempo = ?, act_fec_asignada = ?, act_subida = 0  WHERE id_actividad = ?"
            
            do{
                try dbQueue.inTransaction{ db in
                    try db.execute(updateSql, arguments: [ id_producto, act_cantidad, act_obs_ejecutor, id_tipoobservacion, id_usuario, id_actividadestado, act_fec_realizada, act_datos, id_postergar, act_tiempo, act_fec_asignada, id_actividad])
                    print("Actividad: \(id_actividad) Guardada en local")
                    
                    return .commit
                }
            }
            catch{
                print(error)
            }
        }

func updateActividadServer(id_actividad: Int64, id_producto: Int64 = 0, act_cantidad: Double = 0, act_obs_ejecutor: String, id_tipoobservacion: Int64, id_usuario: Int64, id_actividadestado: Int64, act_fec_realizada: String, act_datos: String, id_postergar: Int64 = 0, act_tiempo: Int64 = 0, act_fec_asignada: String = "", id_nivel: Int64, id_objeto: Int64, id_tipohallazgo: Int64 = 0, success: @escaping (Bool, Int, String, Int64)->()) {
            
    let urlBase = Config.config.con_url!

    
    var urlSync = URL(string: urlBase+"?action=app_update")
    if(id_tipohallazgo > 0){
        urlSync = URL(string: urlBase+"?action=app_insert")
    }
    //print("URLBASE: ", urlSync)
    var request = URLRequest(url: urlSync!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    var postString = ""
    
    postString  += "id_usuario="+String(id_usuario)
    postString += "&id_producto="+String(id_producto)
    postString += "&act_cantidad="+String(act_cantidad)
    postString += "&id_actividad="+String(id_actividad)
    postString += "&id_actividadestado="+String(id_actividadestado)
    postString += "&act_obs_ejecutor="+act_obs_ejecutor
    postString += "&id_tipoobservacion="+String(id_tipoobservacion)
    postString += "&act_fec_realizada="+String(act_fec_realizada)
    postString += "&act_datos="+act_datos
    postString += "&id_postergar="+String(id_postergar)
    postString += "&act_tiempo="+String(act_tiempo)
    postString += "&act_fec_asignada="+act_fec_asignada
    postString += "&id_objeto="+String(id_objeto)
    postString += "&id_nivel="+String(id_nivel)
    postString += "&id_tipohallazgo="+String(id_tipohallazgo)
    
    request.httpBody = postString.data(using: .utf8)
    print("URL: \(String(describing: urlSync))\(postString)")

    if(Internet.isConnectedToNetwork()){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = JSON(data)
            print("-------JSON--------\n\(json)")
            
            if(json["State"] == 1){
                success(true, 1, json["Message"].stringValue, Int64(json["id_actividad"].stringValue)!)
                //print("JSON: \(json["Message"])")
                print("Actividad: \(id_actividad) Sync en Server\n\n")
            }
            else if(json["State"] == 2){
                print("JSON State: \(json["State"])")
                success(true, 2, json["Message"].stringValue, 0)
        
            }
            else{
                print("JSON State: \(json["State"])")
                success(true, 0, json["Message"].stringValue, 0)
            }
        }
        task.resume()
    }
    else {
        success(false, 0, "No hay conexión a internet", 0)
    }

}//----------------------- O --------------------------
//------------------------------------------------------

func getImgUrlServer(id_actividad: Int64, success: @escaping (Bool, String)->()) {
        
    let urlBase = Config.config.con_url!
    let equ_imei = Config.equ_imei
    
    
    let urlSync = URL(string: urlBase+"?action=app_image")
    //print("URLBASE: ", urlSync)
    var request = URLRequest(url: urlSync!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    var postString = ""
    
    postString  += "equ_imei="+equ_imei
    postString += "&id_actividad="+String(id_actividad)
    
    request.httpBody = postString.data(using: .utf8)
    
    if(Internet.isConnectedToNetwork()){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = JSON(data)
            print("-------JSON--------\n\(json)")
            
            if(json["State"] == 1){
                success(true, json["aar_url"].stringValue)
                print("JSON: \(json["aar_url"])")
                //print("Actividad: \(id_actividad) Sync en Server")
            }
            else{
                success(false, json["Message"].stringValue)
                //passCorrecto = false
                //passServer = false
            }
        }
        task.resume()
    }
    else {
        success(false, "No hay conexión a internet")
    }
    
}//----------------------- O --------------------------
//------------------------------------------------------

func insertarActividad(id_actividad: Int64, id_actividadestado: Int64, act_obs_ejecutor: String, id_tipoobservacion: Int64, act_datos: String, id_nivel: Int64, id_objeto: Int64, id_tipohallazgo: Int64 = 0) -> Actividad{
    
    var id_act_insert:Int64 = 0
    var act = fetchActividad(id_actividad: id_actividad)
    act.id_actividad = nil
    if(id_actividad > 0){
        act.id_actividadpadre = id_actividad
    }
    act.id_actividadestado = id_actividadestado
    act.act_creada_local = 1
    act.act_fec_realizada = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
    act.act_obs_ejecutor = act_obs_ejecutor
    act.id_tipoobservacion = id_tipoobservacion
    act.act_datos = act_datos
    act.id_usuario = userID!
    act.id_nivel = id_nivel
    act.id_objeto = id_objeto
    act.id_tipohallazgo = id_tipohallazgo
    act.act_subida = 0
    
    do{
        try dbQueue.inTransaction { db in
            try act.insert(db)
            //print("\n Actividad duplicada: ", act)
            
            id_act_insert = db.lastInsertedRowID
            
            act.id_actividad = id_act_insert
            return .commit
        }
    }catch{
        print("\n Error duplicar act: ", error)
    }
    let actInsert = fetchActividad(id_actividad: id_act_insert)
    print("\n Actividad id:", id_act_insert, "insertada")
    print("\n\n Actividad insertada local: ", actInsert)
    return act
}

//------------- END INAERTAR ACTIVIDAD --------------------
//---------------------------------------------------------


func getImage(imageName: String) -> UIImage {
    
    let fileManager = FileManager.default
    let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(imageName).jpg")
    if fileManager.fileExists(atPath: imagePAth){
        print("Existe imagen")
        return UIImage(contentsOfFile: imagePAth)!
    }else{
        print("No Image")
        return UIImage()
    }
}

func deleteImage(imageName: String) -> Bool {
    
    let fileManager = FileManager.default
    let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(imageName).jpg")
    if fileManager.fileExists(atPath: imagePAth){
        print("Existe imagen")
        do{
            try fileManager.removeItem(atPath: imagePAth)
        }
        catch{
            print("Error al borrar imagen: ", error)
        }
        return true
    }else{
        print("No existe Imagen")
        return false
    }
}


func subirImg(imageView: UIImageView, i: Int, name: String, id_act: Int64, completion: @escaping (Bool) -> Void){
    
    let urlBase = Config.config.con_url!
    let urlImg = URL(string: urlBase+"?action=app_insert_img")
    
    if(imageView.image == nil){
        print("Image: \(name) is nil")
        completion(false)
    }
    else{
        let imgData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        let equ_imei = Config.equ_imei
        let id_actividad = id_act
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "actividadarchivo", fileName: "\(name).jpg", mimeType: "image/jpeg")
                multipartFormData.append(equ_imei.data(using: String.Encoding.utf8)!, withName: "equ_imei")
                multipartFormData.append("\(id_actividad)".data(using: String.Encoding.utf8)!, withName: "id_actividad")
                multipartFormData.append("\(i+1)".data(using: String.Encoding.utf8)!, withName: "aar_posicion")
                
        },
            to: urlImg!, //
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        print("-----ÉXITO AL SUBIR FOTO------: \n equ_imei: ", equ_imei, "\n id_actividad: ", id_actividad, "\n aar_posicion: \(i+1) \n\n")
                        //debugPrint(response)
                        completion(true)
                    }
                case .failure(let encodingError):
                    print("ERROR SUBIR FOTO: ", encodingError)
                    completion(false)
                }
        }
        )
    }
}// ------------------- END ---------------------------//



func subirActividadesPendientes(completion: @escaping (Bool, Int) -> Void){
    
    if(Internet.isConnectedToNetwork()){
        let acts = fetchActividadesPendientes()
        if acts.count > 0 {
            var actCount = 0
            
            var imageViews:[UIImageView] = []
            let imageView1 = UIImageView()
            let imageView2 = UIImageView()
            let imageView3 = UIImageView()
            
            imageViews.append(imageView1); imageViews.append(imageView2); imageViews.append(imageView3)
            
            for act in acts{
                let id_actividad = act.id_actividad!
                var id_act = id_actividad
                
                if(act.id_actividadestado! == 8){
                    id_act = act.id_actividadpadre!
                }
                
                print("\n\n ACTIVIDAD PENDIENTE LOCAL: \n " +
                    "id_actividad: ", id_actividad, "\n" +
                    "id_act_estado: ", act.id_actividadestado!, "\n" +
                    "id_usuario: ", act.id_actividadestado!, "\n" +
                    "id_tipohallazgo: ", act.id_tipohallazgo!, "\n")
                
                updateActividadServer(id_actividad: id_act, act_obs_ejecutor: act.act_obs_ejecutor!, id_tipoobservacion: act.id_tipoobservacion!, id_usuario: act.id_usuario!, id_actividadestado: act.id_actividadestado!, act_fec_realizada: act.act_fec_realizada!, act_datos: act.act_datos!, id_nivel: act.id_nivel!, id_objeto: act.id_objeto!, id_tipohallazgo:act.id_tipohallazgo!, success: { success, state, message, id_actServer in
                    if(success){
                        
                        actCount += 1
                        if(id_actServer > 0){
                            id_act = id_actServer
                        }
                        updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(id_actividad)")
                        print("\n\n\n Update Actividad server: ", success, "Id_actividad: ", id_act, "\n\n")
                        
                        
                        let fotos = fetchFotos(id_actividad: id_actividad)
                        print("ID_ACT: ", id_actividad, "FOTOS: ", fotos)
                        
                        for foto in fotos {
                            let index = Int(foto.fot_orden! - 1)
                            let id_foto = foto.id_foto!
                            let fot_nombre = foto.fot_nombre!
                            print(" -Id_foto: ", id_foto)
                             print(" -NOMBRE: ", fot_nombre)
                            
                            imageViews[index].image = getImage(imageName: fot_nombre)
                            
                            if(imageViews[index].image != nil){
                                subirImg(imageView: imageViews[index], i: index, name: fot_nombre, id_act: id_act){ (success) -> () in
                                    if success {
                                        print("SUCCESS!!! { \nFoto: ", index+1, "ID_Server: ", id_actServer, "ID_Local: ", id_actividad, "\n }\n")
                                        //Update campo de foto subida
                                        updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_foto", whereValor: "\(id_foto)")
                                        
                                        // --- Actualiza el id actividad que retorna del server en la tabla foto
                                        updateTable(tabla: "foto", campo: "id_actividad", valor: "\(id_act)", whereCampo: "id_foto", whereValor: "\(id_foto)")

                                        
                                    }else{
                                        print("FAIL!!!  No se subió la imagen")
                                    }
                                    
                                }
                            }
                        }
                    }
        
                })// End Update Actividad Server
                
                if(actCount == acts.count){
                    completion(true, 1)
                }
                else if(actCount > 0 && actCount < acts.count){
                    completion(true, 2) // Subieron algunas
                }
                else if(actCount == 0 && actCount < acts.count){
                    completion(false, -1) //Con internet, no se ha subido ninguna
                }
            }
        }
        else{
            completion(true, 3) // No existen actividades pendientes
        }
       /* let fotosPendientes = fetchFotosPendientes()
        
        if(fotosPendientes.count > 0){
            var imageViews:[UIImageView] = []
            let imageView1 = UIImageView()
            let imageView2 = UIImageView()
            let imageView3 = UIImageView()
            imageViews.append(imageView1); imageViews.append(imageView2); imageViews.append(imageView3)
            
            for foto in fotosPendientes {
                let index = Int(foto.fot_orden! - 1)
                let id_foto = foto.id_foto
                let fot_nombre = foto.fot_nombre
                print(" -Id_foto: ", id_foto!)
                print(" -NOMBRE: ", fot_nombre!)
                
                imageViews[index].image = getImage(imageName: fot_nombre!)
                
                if(imageViews[index].image != nil){
                    subirImg(imageView: imageViews[index], i: index, name: fot_nombre!, id_act: foto.id_actividad!){ (success) -> () in
                        if success {
                            //Update campo de foto subida
                            updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(foto.id_actividad!)")
                            print("Foto: ", index+1, "Actividad: ", foto.id_actividad!)
                            
                        }
                    }
                }
            }
            
        }*/
        
    }
    else{
        completion(false, 0) // No hay internet
    }
}// ----------- END FUNCTION ---------


// --------------  ALERT para volver al VC Anterior ------------------
// ---------------------------------------------------------------------
func goBackMsge(vc: UIViewController, title: String, msge: String, loading: UIActivityIndicatorView){
    
    let alertController = UIAlertController(title: title, message: msge, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
        //run your function here
        vc.navigationController?.popViewController(animated: true)
        vc.dismiss(animated: true, completion: nil)
    }))
    loading.stopAnimating()
    vc.present(alertController, animated: true, completion: nil)
}
// -------- END ALERT VC ANTERIOR -----------


class Gps: CLLocationManager, CLLocationManagerDelegate {

    //let locationManager = CLLocationManager()
    
    public func getLocation(locationManager: CLLocationManager) -> (Bool){
        
        var bool = false
        
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined, .restricted, .denied:
                print("No access to Location")
                // mostrar alert para que el usuario modifique los permisos de gps para sigmo
                
            case .authorizedAlways, .authorizedWhenInUse:
                //print("Latitud: ", locationManager.location!.coordinate.latitude)
                
                UserDefaults.standard.set(String(locationManager.location!.coordinate.latitude), forKey: "latitud")
                UserDefaults.standard.set(String(locationManager.location!.coordinate.longitude), forKey: "longitud")
              //let lat = UserDefaults.standard.string(forKey: "latitud")
                bool = true
                //print("Latitud: ", UserDefaults.standard.string(forKey: "latitud")!)
                //print("Longitud: ", UserDefaults.standard.string(forKey: "longitud")!)
            }
            
        } else {
            print("Location services are not enabled")
            
        }
        return bool
    }

}

func getInventario(fec_app: String, id_nivel: String, success: @escaping (Bool, Int, String)->()) {
    
    let urlBase = Config.config.con_url!
    
    
    let urlSync = URL(string: urlBase+"?action=app_inv")

    //print("URLBASE: ", urlSync)
    var request = URLRequest(url: urlSync!)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    var postString = ""
    
    postString += "id_nivel=\(id_nivel)"
    postString += "&fec_app=\(fec_app)"
    
    request.httpBody = postString.data(using: .utf8)
    print("URL: \(String(describing: urlSync))\(postString)")
    
    if(Internet.isConnectedToNetwork()){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let json = JSON(data)
            
            //print(json)
            
            if(json["State"] == 1){
                
                for item in json["Data"]{
                    
                    print("--- ID_ACT: \(item.1["id_actividad"]) ----//")
                    let id_actividad = Int64(item.1["id_actividad"].stringValue)
                    //INGRESAR ID_ACTIVIDAD EN TABLA INVENTARIO
                    // ---------------------------------------
                    let id_inventario = insertInventario(id_actividad: id_actividad)
                    
                    // INVENTARIO POR ACTIVIDAD
                    let invJson = item.1["inv_json"]["inventario"]
                    
                    //-------PRODUCTOS POR ACTIVIDAD-------
                    for pro in invJson{
                        
                        //INSERTAR PRODUCTOS EN TABLA INVENTARIODETALLE
                        if insertInvDetalle(id_inventario: id_inventario, ind_index: pro.1["name"].stringValue, ind_valor: 0, pro_nombre: pro.1["pro_nombre"].stringValue, pro_codigo: pro.1["codigo"].stringValue, pro_envase: pro.1["envase"].stringValue){
                            print("INV DETALLE insertado!!!!!!")
                        }
                        print("CODIGO: \(pro.1["codigo"].stringValue)")
                        print("Envase: \(pro.1["envase"].stringValue)")
                        print("Nombre: \(pro.1["pro_nombre"].stringValue)")
                        print("Index: \(pro.1["name"].stringValue)")
                    }
                    //let label = "\(json.1["codigo"].stringValue), \(json.1["envase"].stringValue), \(json.1["pro_nombre"].stringValue)"
                    
                }
                success(true, 1, "msge")
            }
            else if(json["State"] == 2){
                success(true, 2, json["Message"].stringValue)
                
            }
            else{
                
                success(true, 0, json["Message"].stringValue)
                print("mensaje: ", json["Message"])
            }
            
        }
        task.resume()
    }
    else {
        success(false, 0, "No hay conexión a internet")
    }
    
}//----------------------- O --------------------------
//------------------------------------------------------





