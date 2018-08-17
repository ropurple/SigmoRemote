 //
//  ViewController.swift
//  Sigmo
//
//  Created by macOS User on 07/09/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import UIKit
import CoreLocation

var userID:Int64? = 0// idUsuario global
var usuName:String? = ""
var usuApe:String? = ""
var otroAmbiente = false
var modoOffline = false
var firstLaunch:Bool = false
 
class ViewController: UIViewController{

    
    @IBOutlet weak var usuarioText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var imeiLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var ambienteLabel: UILabel!
    @IBOutlet weak var syncBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var pruebaView: UIView!
    
    var sync:Bool = false
    var equ_imei : String = ""
    var fechaFormat: String = ""
    var equipoHabilitado = false
    var usuarios = [Usuario]()
    var config:Bool = false
    var version:String = ""
  

    
    // ----------------------- FUNC MAIN ---------------------------
    // --------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() // Ocultar teclado al tocar afuera
        equ_imei = Config.equ_imei
        
        loading.frame = loadingView.bounds
        
        //pruebaView.removeFromSuperview()
        //updateViewConstraints()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore") // VERIFICA SI ES LA PRIMERA VEZ QUE SE INICIA LA APP
        
        if !launchedBefore { // primer inicio
            borrarTablas()
            firstLaunch = true
        }
        
       // let fotos = fetchFotosPendientes()
        //print("Fotos count: ", fotos.count)
        
        //subirActividadesPendientes()
        
        /* let del = deleteImage(imageName: name)
          print("Img subida y borrada del móvil", del)*/
        
        //fetchActividadesPendientes()
         //borrarTablas()
        
        // MANEJAR CUANDO SE ACTUALICE APP Y HAYAN CAMBIOS EN BBDD 
        
        
        //---------- LABELS ------------------
        version = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!).\(Bundle.main.infoDictionary!["CFBundleVersion"]!)"
        self.versionLabel.text = "Versión: "+version
        self.imeiLabel.text = "IMEI: "+equ_imei
   
        if Internet.isConnectedToNetwork(){
            // Subir actividades pendientes si existen
            subirActividadesPendientes{ (success, estado) -> () in
                if success {
                    if estado == 1 {
                        print("OK, estado:", estado)
                    }
                    if estado == 2 {
                        print("actividades offline pendientes por subir //Estado:", estado)
                    }
                    if estado == 3 {
                        print("No hay actividades Pendientes.// Estado:", estado)
                    }
                    if !self.sync {
                        self.sync1{ (success) -> () in
                            if success {
                                print("SUCCESS sync1")
                                self.sync = true
                            }
                        }
                    }
                }
                else{
                    print("ERROR", estado)
                    if !self.sync {
                        self.sync1{ (success) -> () in
                            if success {
                                print("SUCCESS sync1")
                                self.sync = true
                            }
                        }
                    }
                }
                
            }
            
        }// ---- Internet connection -----
        else{
            let con = fetchConfig()
            if(con.con_nombre != ""){
                equipoHabilitado = true
            }
            showToast(message: "CONECTAR A INTERNET PARA SINCRONIZAR")
            self.syncLabel!.text = "SYNC "+traerFechaSync(tabla: "usuario")
            self.ambienteLabel.text = "Ambiente: \(con.con_nombre!)"
            
        }// ---- Sin internet ------
        
        //---------- END LABELS ----------------
  
    }// ---------- ViewDidLoad -----------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true // No mostrar Tab Bar
       
    }

    
//---------------BOTON SYNC-------------------
    
    @IBAction func sincronizar(_ sender: Any) {
        
        if Internet.isConnectedToNetwork(){ // Si hay Internet Sincroniza!!!
            sync1{ (success) -> () in
                if success {
                    print("SUCCESS btn sincronizar")
                }
                
            }
        }
        else{ // Avisa para conectarse a internet
            
            showToast(message: "CONECTAR A INTERNET PARA SINCRONIZAR")
        }
    }
    

//----------------------- BOTON INGRESAR --------------------------
//-----------------------------------------------------------------
    
    @IBAction func validarLogin(_ sender: Any) {
        
        if(!equipoHabilitado){
            
            showToast(message: "EQUIPO NO REGISTRADO, FAVOR SYNC")
        }
       
        else{ //(equipoHabilitado ){
            
            if (usuarioText.text == "" ){
                alertWithTitle(title: "Alerta", msg: "Debe ingresar el rut", vc: self)
                self.usuarioText.becomeFirstResponder()
                
            }
            else{
            
                //rutValidacion = true
                
                if( passText.text! == ""){
                    alertWithTitle(title: "Alerta", msg: "Debe ingresar contraseña", vc: self)
                    self.passText.becomeFirstResponder()
                }
                else{
                    
                    var usuario = fetchUsuario(usu_rut: usuarioText.text!)
                    if(usuario.id_usuario! > 0){
                        
                    // ------Validacion de contraseña----------
                        if( passText.text!.count > 4){
                            //passValidacion = true
                            // Ver logueo de contraseña arriba
                            
                           // for item in usuarios {
                            
                                //print(item.usu_rut!)
                                if(usuarioText.text == usuario.usu_rut) {
                                   // rutCorrecto = true
                                    
                                    if(Internet.isConnectedToNetwork()){
                                        loading.startAnimating()// loaading gif

                                        loginServer( id_usuario: usuario.id_usuario!, usu_pass: passText.text!, equ_imei: equ_imei, success: { success, message in
                                            print("Pass OK", success)
                                            
                                            if(success){
                                               // passCorrecto = true
                                                //jsonMsge = json["Message"].stringValue
                                                userID = usuario.id_usuario
                                                usuName = usuario.usu_nombre
                                                usuApe = usuario.usu_apellido
                                                usuario.usu_pass = self.passText.text!
                                                
                                                if updatePass(usuario: usuario){
                                                    print("Contraseña actualizada localmente")
                                                    print("Contraseña: ", self.passText.text!)
                                                    print("usuario.pass: ", usuario.usu_pass!)
                                                }
                                                print("otroAmbiente antes: ", otroAmbiente)
                                                
                                                
                                                print("otroAmbiente despues: ", otroAmbiente)
                                                DispatchQueue.main.async(execute: {
                                                    
                                                    let usuNivel = fetchUsunivel()
                                                    if((!otroAmbiente || !firstLaunch) && (usuNivel.count > 0)){
                                                        
                                                        let alert = UIAlertController(title: "Permisos de Usuario", message: "¿Desea sincronizar permisos de usuario antes de ingresar?", preferredStyle: .alert)
                                                        for i in ["INGRESAR OFFLINE", "SYNC E INGRESAR"] {
                                                            alert.addAction(UIAlertAction(title: i, style: .default, handler: self.ingresar))
                                                        }
                                                        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: self.ingresar))
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                    else{ // Syncroniza directamente sin preguntar
                                                        
                                                        let alert = UIAlertAction(title: "SYNC E INGRESAR", style: .default, handler: nil)
                                                        self.ingresar(alert: alert)
                                                    }
                                                })
                                                ultimaConexion(equ_imei: self.equ_imei, success: { success, message in
                                                })
                                            }
                                            else{
                                                DispatchQueue.main.async(execute: {
                                                    print("Error: "+message)
                                                    alertWithTitle(title: "Error", msg: message, vc: self)
                                                    self.loading.stopAnimating()
                                                })
                                            }
                                        })
                                        
                                       // break // sale del for ya que encontró el match

                                    }
                                    else{
                                        print("Entra al else")
                                        let usu = fetchUsuario(usu_rut: self.usuarioText.text!)
                                        
                                        
                                        if(self.passText.text != "" && self.passText.text == usu.usu_pass){
                                            print("Pass local correcta")
                                            userID = usu.id_usuario
                                            let alert = UIAlertAction(title: "INGRESAR OFFLINE", style: .default, handler: nil)
                                            self.ingresar(alert: alert)
                                        }
                                        else{
                                            alertWithTitle(title: "Error", msg: "Datos incorrectos", vc: self)
                                        }
                                    }
                                    
                                }
                                    
                                else{
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        self.showToast(message: "¡DATOS INCORRECTOS!")
                                    })
                                }
                            //}// ------For------------
                            
                            }
                        else{
                            //passValidacion = false
                            showToast(message: "CONTRASEÑA MUY CORTA")
                        }
                    }
                    else{
                        self.showToast(message: "¡DATOS INCORRECTOS!")
                    }
                }
            }
        }
    } // ----   IB ACTION -------------

    
// ---------------------- FUNCIONES ----------------------------
    
    func bloquearCampos(){
        
        self.usuarioText.isUserInteractionEnabled = false
        self.passText.isUserInteractionEnabled = false
        self.syncBtn.isUserInteractionEnabled = false
        self.loginBtn.isUserInteractionEnabled = false
        self.syncBtn.alpha = CGFloat(0.5)
        self.loginBtn.alpha = CGFloat(0.5)
    }
     
    func desbloquearCampos(){
        
        self.usuarioText.isUserInteractionEnabled = true
        self.passText.isUserInteractionEnabled = true
        self.syncBtn.isUserInteractionEnabled = true
        self.loginBtn.isUserInteractionEnabled = true
        self.syncBtn.alpha = CGFloat(1)
        self.loginBtn.alpha = CGFloat(1)
    }

    
    //------------- Funcion Ingresar ----------------
    //--------------------------------------------
    
    func ingresar(alert: UIAlertAction){
       
        self.bloquearCampos()
        
        if(alert.title == "INGRESAR OFFLINE"){
            modoOffline = true
            self.loading.stopAnimating()
            self.desbloquearCampos()
            self.performSegue(withIdentifier: "Niveles", sender: self.usuarios)
        }
        else if(alert.title == "SYNC E INGRESAR"){
            modoOffline = false
            self.syncLabel!.text = "SINCRONIZANDO TABLAS..."
            try! crearTablas(num: 2) // Elimina tabalas usuarionivel y usuariotipodoc
            Request<Usuarionivel>.postRequest(fecha: false, usuario: true, item: { item in
            }, success: { success, message in
                print("Sync Usuarionivel", success)
                //self.syncLabel!.text = "SYNC Usuario OK!..."
                //self.syncLabel!.text = "SYNC tabla NIVEL..."
                
                Request<Usuariotipodoc>.postRequest(fecha: false, usuario: true, item: { item in
                }, success: { success, message in
                    print("SYNC Usuariotipodoc ", success)
                    DispatchQueue.main.async(execute: {
                        self.desbloquearCampos()
                        self.loading.stopAnimating()
                        self.syncLabel!.text = "SYNC "+traerFechaSync(tabla: "usuario")
                        self.performSegue(withIdentifier: "Niveles", sender: self.usuarios)
                    })
                    //self.syncLabel!.text = "SYNC Nivel OK!..."
                })
            })

            
         
        }
        else{
            self.loading.stopAnimating()
            desbloquearCampos()
            print("Cancelar")
        }
    }//----------------------- END Ingresar -------------------------------//
    
    // -------------------- TRAER CONFIG ---------------------------
    private func traerConfig( completion: @escaping (Bool) -> ()){
        
        //var bool = false
        Config.Get(equ_imei : equ_imei, ver_nombre: version){ success, message in
            //print("Configuracion Actualizada", success)
            if(!success){
                print(message)
                completion(false)
            }
            //print("Equipo Habilitado", Config.config.State == 1)
            if (success && Config.config.State == 1) {
                print("Ambiente", Config.config.con_nombre!)
               
                completion(true)
            }else{
                
                print("Error Config", Config.config.Message)
                completion(false)
            }
        }//------------------ END CONFIG --------------------------
    }
    
    
//--------------------- SINCRONIZACION 1 ------------------------------
//---------------------------------------------------------------------
    
    func sync1(completion: @escaping (Bool) -> Void){
        
        loading.startAnimating()
        bloquearCampos()
        self.syncLabel!.text = "Descargando configuración..."
        self.traerConfig { (success) -> () in
            if success {
                //print("Configuracion : \(Config.config.State)")
                if(Config.config.State == 1){
                    self.equipoHabilitado = true
                    
                    let con = fetchConfig()
                    
                    
                    // Borra las tablas si es que es distinta la version
                    if(con.version != nil && self.version != con.version && !firstLaunch){
                        
                        borrarTablas()
                    }
                    
                    if(con.con_nombre != nil && con.con_nombre != Config.config.con_nombre){
                        print(con.con_nombre!, "AMBIENTE DISTINTO!!!!")
                        otroAmbiente = true
                        // truncate tablas sync 1
                        // Falta sincronizar activiades pendientes de sync con ambiente antiguo
                        //---------------------- OJO ----------------------
                        borrarTablas()
                        print("Borrando tablas")
                    }
                    else{
                        otroAmbiente = false
                    }
                    
                    // Copia la config actual en un let y asigna la version a ese objeto
                    let config = Config.config
                    config.version = self.version
                    
                    if guardarConfig(config: config){
                        print("Configuracion guardada OK")
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.syncLabel!.text = "SINCRONIZANDO TABLAS..."
                            self.ambienteLabel.text = "Ambiente: "+Config.config.con_nombre!
                        }
                    })
                    Request<Usuario>.postRequest(item: { item in
                    }, success: { success, message in
                        print("Sync Usuario", success)
                        //self.syncLabel!.text = "SYNC Usuario OK!..."
                        //self.syncLabel!.text = "SYNC tabla NIVEL..."
                        
                        Request<Nivel>.postRequest(item: { item in
                        }, success: { success, message in
                            print("SYNC Nivel ", success)
                            //self.syncLabel!.text = "SYNC Nivel OK!..."
                            
                            Request<Nivelvalor>.postRequest(item: { item in
                            }, success: { success, message in
                                print("SYNC Nivelvalor ", success)
                                //self.syncLabel!.text = "SYNC Nivel OK!..."
                                
                                Request<Niveltipo>.postRequest(item: { item in
                                }, success: { success, message in
                                    print("Sync Niveltipo", success)
                                    //self.syncLabel!.text = "SYNC Niveltipo OK!..."
                                    
                                    Request<Accion>.postRequest(item: { item in
                                    }, success: { success, message in
                                        print("Sync Accion", success)
                                        //self.syncLabel!.text = "SYNC Accion OK!..."
                                        
                                        Request<Acciontipo>.postRequest(item: { item in
                                        }, success: { success, message in
                                            print("Sync Acciontipo", success)
                                            //self.syncLabel!.text = "SYNC Acciontipo OK!..."
                                            
                                            Request<Actividadestado>.postRequest(item: { item in
                                            }, success: { success, message in
                                                print("Sync Actividadestado", success)
                                                //self.syncLabel!.text = "SYNC Actividadestado OK!..."
                                                
                                                Request<Prioridad>.postRequest(item: { item in
                                                }, success: { success, message in
                                                    print("Sync Prioridad", success)
                                                    //self.syncLabel!.text = "SYNC Prioridad OK!..."
                                                    
                                                    Request<Producto>.postRequest(item: { item in
                                                    }, success: { success, message in
                                                        print("Sync Producto", success)
                                                        //self.syncLabel!.text = "SYNC Producto OK!..."
                                                        
                                                        Request<Tipodocumento>.postRequest(item: { item in
                                                        }, success: { success, message in
                                                            print("Sync Tipodocumento", success)
                                                            //self.syncLabel!.text = "SYNC Tipodocumento OK!..."
                                                            
                                                            Request<Tipoobservacion>.postRequest(item: { item in
                                                            }, success: { success, message in
                                                                print("Sync Tipoobservacion", success)
                                                                //self.syncLabel!.text = "SYNC Tipoobservacion OK!..."
                                                                
                                                                Request<Postergar>.postRequest(item: { item in
                                                                }, success: { success, message in
                                                                    print("Sync Postergar", success)
                                                                    //self.syncLabel!.text = "SYNC Postergar OK!..."
                                                                    
                                                                    Request<Tipohallazgo>.postRequest(item: { item in
                                                                    }, success: { success, message in
                                                                        print("Sync Tipohallazgo", success)
                                                                        
                                                                        DispatchQueue.main.async(execute: { () -> Void in
                                                                            self.loading.stopAnimating()
                                                                            self.syncLabel!.text = "¡SINCRONIZACIÓN OK!..."
                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                                                self.syncLabel!.text = "SYNC "+traerFechaSync(tabla: "usuario")
                                                                                self.desbloquearCampos()
                                                                                if limpiarPass(){
                                                                                    print("Contraseñas limpiadas")
                                                                                }
                                                                                completion(true)
                                                                            }
                                                                            
                                                                        })
                                                                        if(!success){
                                                                            print(message)
                                                                        }
                                                                    })
                                                                    if(!success){
                                                                        print(message)
                                                                    }
                                                                })
                                                                if(!success){
                                                                    print(message)
                                                                }
                                                            })
                                                            if(!success){
                                                                print(message)
                                                            }
                                                        })
                                                        if(!success){
                                                            print(message)
                                                        }
                                                    })
                                                    if(!success){
                                                        print(message)
                                                    }
                                                })
                                                if(!success){
                                                    print(message)
                                                }
                                            })
                                            if(!success){
                                                print(message)
                                            }
                                        })
                                        if(!success){
                                            print(message)
                                        }
                                    })
                                    if(!success){
                                        print(message)
                                    }
                                })
                                if(!success){
                                    print(message)
                                }
                            })
                            if(!success){
                                print(message)
                            }
                        })
                        if(!success){
                            print(message)
                        }
                    })
                    // ----- END SYNC tablas ----------
                    
                }//  ----------- Config State == 1 ------------
            }
            else{ // No habilitado
                DispatchQueue.main.async(execute: { () -> Void in
                    self.loading.stopAnimating()
                    self.syncLabel.text = "EQUIPO NO REGISTRADO"
                    self.showToast(message: "EQUIPO NO REGISTRADO")
                    self.equipoHabilitado = false
                    self.desbloquearCampos()
                })
            }
        }
    }
}
 
 extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
 }

 

