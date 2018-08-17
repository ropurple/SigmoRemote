//
//  EjecutarViewController.swift
//  Sigmo
//
//  Created by macOS User on 08/01/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB
import Alamofire
import MapKit
import AVFoundation
//import CoreLocation

@available(iOS 11.0, *)

class EjecutarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Labels cabecera
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // Textfields pickers
    @IBOutlet weak var tipoObsTextfield: UITextField! // picker tipoobs
    @IBOutlet weak var productoTextfield: UITextField! // picker producto
    
    @IBOutlet weak var observacionField: UITextField!// texto informacion
    
    // view oculta de producto
    @IBOutlet weak var productoSwitch: UISwitch!
    @IBOutlet weak var productoView: UIView!
    @IBOutlet weak var productoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productoCantField: UITextField!
    
    // Textfields de imágenes
    @IBOutlet weak var imgLabel1: UITextField!
    @IBOutlet weak var imgLabel2: UITextField!
    @IBOutlet weak var imgLabel3: UITextField!
    
    // Loading & loading view
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    var count = 0
    
    var imagePicker: UIImagePickerController!
    var imageViews: [UIImageView] = []
    var imgLabels: [UITextField] = []
    var tipoObs = fetchTipoobservacion()
    var productos = [Product]()
    var id_producto:Int64 = 0
    var TipoObsPicker = UIPickerView()
    var productoPicker = UIPickerView()
    var gps = Gps()
    
    var id_tipoobservacion:Int64 = 0
    var id_actividad: Int64 = 0
    var locationManager = CLLocationManager()
    var lat: String = ""
    var lon: String = ""
    
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    
    // --------------- VIEWDIDLOAD() -----------------
    //-------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBarRight(vc: self)// Logo a la derecha del nav
        loading.frame = loadingView.bounds
        
        if(gps.getLocation(locationManager: locationManager)){
            
            lat = UserDefaults.standard.string(forKey: "latitud")!
            lon = UserDefaults.standard.string(forKey: "longitud")!
        }
        
        self.hideKeyboardWhenTappedAround() // Ocultar teclado al tocar afuera
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)

        
        id_actividad = Int64(self.datosEjecucion.id_actividad!)!
        print("Datos ejecucion: ", datosEjecucion)
        
        let foto1 = UIImageView()
        let foto2 = UIImageView()
        let foto3 = UIImageView()
        
        imageViews.append(foto1)
        imageViews.append(foto2)
        imageViews.append(foto3)
        
        imgLabels.append(imgLabel1); imgLabels.append(imgLabel2); imgLabels.append(imgLabel3)
        
        imgLabel1.isUserInteractionEnabled = false
        imgLabel2.isUserInteractionEnabled = false
        imgLabel3.isUserInteractionEnabled = false
        
        count = 0
        if(datosEjecucion.acc_lubricante! != "1"){ // Esconder view de productos
            productoViewHeight.constant = 0
            productoViewHeight.priority = UILayoutPriority(rawValue: 999)
            productoView.isHidden = true
        }
        else{
            productoView.isHidden = false
        }
        
        // -------- Pickerviews config --------------
        productoPicker.delegate = self
        productoPicker.dataSource = self
        productoPicker.tag = 2
        productoTextfield.inputView = productoPicker
        
        TipoObsPicker.delegate = self
        TipoObsPicker.dataSource = self
        TipoObsPicker.tag = 1
        tipoObsTextfield.inputView = TipoObsPicker
        // ------- END Pickerviews config --------
        
        productos = getProductos(todos: false)
        
        // ------ Actualizar Labels ------
        fechaLabel.text = formatearFecha(fecha: datosEjecucion.fecha!, format: "EEEE dd/MM")
        nivelLabel.text = "\(datosEjecucion.nti_nombre!): \(datosEjecucion.nva_valor!)"
        print("NIVEL: ", nivelLabel.text!)
        objetoLabel.text = datosEjecucion.obj_nombre!
        print("OBJ: ", objetoLabel.text!)
        accionLabel.text = datosEjecucion.prg_nombre!
        infoLabel.text = datosEjecucion.info!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.tabBarController?.tabBar.isHidden = true // No mostrar Tab Bar
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1){
            tipoObsTextfield.text = tipoObs[row].tob_nombre!
            tipoObsTextfield.resignFirstResponder()
            id_tipoobservacion = tipoObs[row].id_tipoobservacion!
        }
        
        if(pickerView.tag == 2){
            if(productos.count > 0){
                productoTextfield.text = productos[row].pro_nombre!
                id_producto = productos[row].id_producto!
                productoTextfield.resignFirstResponder()
            }
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var string = ""
        
        if(pickerView.tag == 1){
            string = tipoObs[row].tob_nombre!
        }
        if(pickerView.tag == 2){
            string = productos[row].pro_nombre!
        }
        return string
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        var int = 0
        
        if(pickerView.tag == 1){
            int = tipoObs.count
        }
        if(pickerView.tag == 2){
            int = productos.count
        }
        return int
    }
    
    // Se necesitan para bloquear o desbloquear el tab controller cuando se abre un modal
    // bloquearTab va conectado con el boton del modal de niveles
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // Se deja en true para que no muestre el tab bar después del modal de niveles
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = true
    }

    
// ------------ IBACTIONS fotos-----------------//
//----------------------------------------------//
    
    @IBAction func tomarFoto1(_ sender: Any) {
        openCamera(foto: 0)
    }
    @IBAction func tomarFoto2(_ sender: Any) {
        openCamera(foto: 1)
    }
    @IBAction func tomarFoto3(_ sender: Any) {
        openCamera(foto: 2)
        
    }//---------------- Fotos -----------------//
    
    
// ------------ IBACTION PRODUCTO-----------------//
//------------------------------------------------//
    @IBAction func mostrarProductos(_ sender: Any) {
        
        if(productoSwitch.isOn){
            productos = getProductos(todos: true)
        }
        else{
            productos = getProductos(todos: false)
        }
        productoPicker.reloadAllComponents()
    }//---------------- producto -----------------//
    
    
//----------------- IBACTION EJECUTAR NORMAL --------------------//
//---------------------------------------------------------------//
    @IBAction func guardarEjecucion(_ sender: Any) {
        
        let validacion = validarCampos()
        
        if validacion {
            ejecutarActividad(id_actividadestado: 2)
        }
        else{
            alertWithTitle(title: "¡Datos incompletos!", msg: "Debe completar los campos obligatorios ", vc: self)
        }
        
        
    }//-----------------END-----------------------

    
//----------------- IBACTION EJECUTAR EN PROCESO --------------------//
//-------------------------------------------------------------------//
    @IBAction func ejecutarEnproceso(_ sender: Any) {
        
        let validacion = validarCampos()
        
        if validacion {
            ejecutarActividad(id_actividadestado: 8)
        }
        else{
            alertWithTitle(title: "¡Datos incompletos!", msg: "Debe completar los campos obligatorios ", vc: self)
        }
        
    }//-----------------END-----------------------
    
    
    
//---------------- GUARDAR IMG LOCALMENTE EN DISPOSITIVO -----------------//
//------------------------------------------------------------------------//
    func saveImage(i: Int) {
        
        if ((imageViews[i].image) != nil){
            
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // choose a name for your image
            let fileName = "\(imgLabels[i].text!).jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            print("URL IMG: ", fileURL)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = UIImageJPEGRepresentation(imageViews[i].image!, 0.02),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("img: \(fileName) -saved")
                } catch {
                    print("error saving file -\(i)- :", error)
                }
            }
            
            
            //UIImageWriteToSavedPhotosAlbum(imageViews[i].image!, nil, nil, nil)
        }
        else{
            print("No existe foto \(i)")
        }
        
        print("OK")
    
    }//-----------------END-----------------------//
    
    
    
//------------------ IMAGE PICKER CONTROLLER -----------------------//
//------------------------------------------------------------------//
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageViews[count].image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (count == 0){
            self.imgLabel1.text = "\(formatearFecha(fecha: Date(), format: "YYYYMMddHHmmss"))_1"
            self.imgLabels[count].text = imgLabel1.text
        }
        if (count == 1){
            self.imgLabel2.text = "\(formatearFecha(fecha: Date(), format: "YYYYMMddHHmmss"))_2"
            self.imgLabels[count].text = imgLabel2.text
        }
        if (count == 2){
            self.imgLabel3.text = "\(formatearFecha(fecha: Date(), format: "YYYYMMddHHmmss"))_3"
            self.imgLabels[count].text = imgLabel3.text
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }//-----------------END-----------------------//
    
    
 
//---------------- OBTENER URL DE IMG EN DISPOSITIVO -----------------//
//--------------------------------------------------------------------//
    func getImage(i: Int, completion: @escaping (Bool) -> Void ){
        
        let fileManager = FileManager.default
        let imagePAth = (getDirectoryPath() as NSString).appendingPathComponent("\(imgLabels[i].text!).jpg")
        if fileManager.fileExists(atPath: imagePAth){
            self.imageViews[i].image = UIImage(contentsOfFile: imagePAth)
            print("Existe imagen")
            completion(true)
        }else{
            print("No Image")
            completion(false)
        }
    }
    
    //---------------- UTILIZAR CAMARA DE DISPOSITIVO-----------------//
    //----------------------------------------------------------------//
    func openCamera(foto:Int){
        count = foto
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    
                    self.imagePicker =  UIImagePickerController()
                    self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    self.imagePicker.sourceType = .camera
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
                else{
                    
                    let alert = UIAlertController(title: "¡Alerta!", message: "SIGMO no está autorizada para usar la cámara. Permitir acceso para poder continuar.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Configuración", style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                                
                            }
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Cámara no encontrada", message: "Este dispositivo no tiene cámara", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }// ----------------- END -------------------------//

    
// ------------------ SUBIR IMG AL SERVER ------------------------//
// ---------------------------------------------------------------//
    func subirImg(i: Int, name: String, id_act: Int64, completion: @escaping (Bool) -> Void){
        
        let urlBase = Config.config.con_url!
        let urlImg = URL(string: urlBase+"?action=app_insert_img")
        
        if(imageViews[i].image == nil){
            print("Image: \(i) is nil")
            completion(false)
        }
        else{
            let imgData = UIImageJPEGRepresentation(imageViews[i].image!, 0.1)!
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
                            debugPrint(response)
                            completion(true)
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        completion(false)
                    }
            }
            )
        }
    }// ------------------- END ---------------------------//
    
    
// ------------------ FUNCION PARA EJECUTAR ACTIVIDAD ---------------------//
// ------------------------------------------------------------------------//
    func ejecutarActividad(id_actividadestado: Int64){
        
        // Si la validación está OK
        loading.startAnimating()
        resetearCampos()
        
        var actHija = Actividad()// Actividad duplicada localmente
        let fecha = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
        let datos = parsearDatos()
        var cantProd: Double = 0
        if productoCantField.text == nil { // valida para que sea
            cantProd = Double(productoCantField.text!)!
        }
        var id_act:Int64 = id_actividad
        let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
        
        if(id_actividadestado == 2){ // Ejecutar normal
            
            updateActividadLocal(id_actividad: id_actividad, id_producto: 0, act_cantidad: cantProd, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: self.id_tipoobservacion, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: fecha, act_datos: datos)
        }
        if(id_actividadestado == 8){ // ejecutar en proceso
            actHija = insertarActividad(id_actividad: id_actividad, id_actividadestado: 8, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: self.id_tipoobservacion, act_datos: datos, id_nivel: Int64(id_nivel), id_objeto: Int64(datosEjecucion.id_objeto!)!)
            id_act = actHija.id_actividad!
        }
        
        
        for i in 0...2{ // Recorre las 3 imagenes si existen
            
            if((imageViews[i].image) != nil){
                saveImage(i: i)
                getImage(i: i){ (success) -> () in
                    if success {
                        
                        //Insert de foto en tabla Foto
                        if insertFoto(id_actividad: id_act, fot_nombre: self.imgLabels[i].text!, fot_peso: 0, fot_orden: Int64(i+1), fot_subida: 0, con_url: Config.config.con_url!){
                            print("Foto \(self.imgLabels[i].text!) insertada en db")
                        }
                    }
                }
            }// if((imageViews[i].image) != nil)
        }// For.-----

        if(id_actividadestado == 2){
            updateActividadServer(id_actividad: id_actividad, id_producto: id_producto, act_cantidad: cantProd, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: self.id_tipoobservacion, id_usuario: userID!, id_actividadestado: 2, act_fec_realizada: fecha, act_datos: datos, id_nivel: Int64(id_nivel), id_objeto: Int64(datosEjecucion.id_objeto!)!, success: { success, state, message, id_actEnproceso  in
                if(success && state == 1){
                    
                    updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                    
                    for i in 0...2{ // Recorre las 3 imagenes si existen e intenta subirlas
                        
                        if((self.imageViews[i].image) != nil){
                            self.subirImg(i: i, name: self.imgLabels[i].text!, id_act: self.id_actividad){ (success) -> () in
                                if success {
                                    //Update campo de foto subida
                                    updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                                    print("Foto: ", i+1, "Actividad: ", self.id_actividad)
                                    
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        goBackMsge(vc: self, title: "INFO", msge: "Actividad sincronizada con éxito", loading: self.loading)
                    })
                    
                }
                else if(success && state == 2){
                    DispatchQueue.main.async(execute: {
                        goBackMsge(vc: self, title: "INFO", msge: "¡Actividad YA EJECUTADA!", loading: self.loading)
                    })
                } // Actividad ya insertada, mostrar modal
                else if(success && state == 0){
                    DispatchQueue.main.async(execute: {
                        goBackMsge(vc: self, title: "INFO", msge: "¡Actividad NO ENCONTRADA!", loading: self.loading)
                    })
                } // Actividad no encontrada, mostrar modal
                    
                else {
                    DispatchQueue.main.async(execute: {
                        goBackMsge(vc: self, title: "INFO", msge: "Actividad guardada localmente", loading: self.loading)
                    })
                }
            })
        
        }// ActividadEstado == 2 // Ejecutar normal
        
        // ------ EN PROCESO -----------------
        if(id_actividadestado == 8){
            
            if actHija.id_actividad! > 0 { // Se inserta correctamente
               
                updateActividadServer(id_actividad: id_actividad, act_obs_ejecutor: actHija.act_obs_ejecutor!, id_tipoobservacion: actHija.id_tipoobservacion!, id_usuario: userID!, id_actividadestado: 8, act_fec_realizada: actHija.act_fec_realizada!, act_datos: actHija.act_datos!, id_nivel: actHija.id_nivel!, id_objeto: actHija.id_objeto!, success: { success, state, message, id_actEnproceso in
                    if(success && state == 1){
                        // Update actividad subida
                        updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(actHija.id_actividad!)")
                        
                        print("\n\n\n Update Actividad server: ", success, "Id_actividad: ", id_actEnproceso, "\n\n")
                        
                        // --- Actualiza el id actividad que retorna del server en la tabla foto
                        updateTable(tabla: "foto", campo: "id_actividad", valor: "\(id_actEnproceso)", whereCampo: "id_actividad", whereValor: "\(actHija.id_actividad!)")
                        
                        for i in 0...2{ // Recorre las 3 imagenes si existen e intenta subirlas
                            
                            if((self.imageViews[i].image) != nil){
                                self.subirImg(i: i, name: self.imgLabels[i].text!, id_act: id_actEnproceso){ (success) -> () in
                                    if success {
                                        //Update campo de foto subida
                                        updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(id_actEnproceso)")
                                        print("Foto: ", i+1, "Actividad: ", id_actEnproceso)
                                        
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            goBackMsge(vc: self, title: "INFO", msge: "Actividad EP sincronizada con éxito", loading: self.loading)
                        })
                    }
                    else if(success && state == 2){
                        DispatchQueue.main.async(execute: {
                            goBackMsge(vc: self, title: "INFO", msge: "¡Actividad YA INSERTADA!", loading: self.loading)
                        })
                    } // Actividad ya insertada, mostrar modal
                    else if(success && state == 0){
                        DispatchQueue.main.async(execute: {
                            goBackMsge(vc: self, title: "INFO", msge: message, loading: self.loading)
                        })
                    } // Actividad no encontrada, mostrar modal
                    else{
                        print("Sincronizacion de Actividad en proceso \(actHija.id_actividad!) fallida")
                        print("\n\n\n Update Actividad server: ", success, "MSGE: ", message, "id_act: ", id_actEnproceso, "\n\n")
                        
                        DispatchQueue.main.async(execute: {
                            
                            goBackMsge(vc: self, title: "INFO", msge: "Actividad EP guardada localmente", loading: self.loading)
                        })
                    }
                }) // ---- END Update act Server ------
            }
        }// Ejecutar en proceso id actividadestado == 8
    
    }// ----------------------- END FUNCTION---------------------------//
    
    
    
    func validarCampos() -> Bool {
        // validaciones
        var ok = true
        
        resetearCampos()
        
        if(observacionField.text! == "" ){
            observacionField.borderStyle = UITextBorderStyle.roundedRect
            observacionField.layer.borderColor = UIColor.red.cgColor
            observacionField.layer.borderWidth = 1.0
            observacionField.layer.cornerRadius = 5
            
            ok = false
        }
        
        if(tipoObsTextfield.text! == "" ){
            tipoObsTextfield.borderStyle = UITextBorderStyle.roundedRect
            tipoObsTextfield.layer.borderColor = UIColor.red.cgColor
            tipoObsTextfield.layer.borderWidth = 1.0
            tipoObsTextfield.layer.cornerRadius = 5
            
            ok = false
        }
        if(imgLabel1.text! == "" ){
            imgLabel1.borderStyle = UITextBorderStyle.roundedRect
            imgLabel1.layer.borderColor = UIColor.red.cgColor
            imgLabel1.layer.borderWidth = 1.0
            imgLabel1.layer.cornerRadius = 5
            
            ok = false
        }
        
        return ok
    }
    
    func resetearCampos(){
        
        observacionField.borderStyle = UITextBorderStyle.roundedRect
        observacionField.layer.borderColor = UIColor.clear.cgColor
        
        tipoObsTextfield.borderStyle = UITextBorderStyle.roundedRect
        tipoObsTextfield.layer.borderColor = UIColor.clear.cgColor
        
        imgLabel1.borderStyle = UITextBorderStyle.roundedRect
        imgLabel1.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    func getProductos(todos:Bool) -> [Product]{
        
        var productos = [Product]()
        var productoSql = "SELECT p.id_producto, r.pro_nombre, p.ppr_cantidad " +
            "FROM actividad a " +
            "INNER JOIN programadaproducto p ON p.id_programadadetalle = a.id_programadadetalle " +
            "INNER JOIN producto r ON r.id_producto = p.id_producto " +
            "WHERE id_actividad = \(datosEjecucion.id_actividad!) " +
        "ORDER BY p.ppr_principal desc, r.pro_nombre";
        
        if (todos){
            productoSql = "SELECT p.id_producto, p.pro_nombre " +
                "FROM producto p " +
            "ORDER BY p.pro_nombre";
        }
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, productoSql)
                if( rows.count == 0){
                    print("No existen registros de productos")
                }
                else{
                    print("ROWS: ", rows)
                    for row in rows {
                        //print("ROW: ", row)
                        let id_producto:Int64? = Int64("\(row["id_producto"]!)")
                        let pro_nombre = "\(row["pro_nombre"]!)"
                        var ppr_cantidad: Double?  = Double("0.0")
                        if(!todos){
                            ppr_cantidad = Double("\(row["ppr_cantidad"]!)")!
                        }
                        
                        let producto = Product(id_producto: id_producto!, pro_nombre: pro_nombre, ppr_cantidad: ppr_cantidad!)
                        
                        productos.append(producto)
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
        if (productos.count > 0){
            productoTextfield.placeholder = "-= SELECCIONAR PRODUCTO =-"
            productoTextfield.isUserInteractionEnabled = true
        }
        else{
            productoTextfield.placeholder = "-= SIN PRODUCTOS =-"
            productoTextfield.isUserInteractionEnabled = false
        }
        return productos
    }
    
    
    
    struct Product {
        
        var id_producto : Int64?
        var pro_nombre : String?
        var ppr_cantidad: Double?
        
        init(id_producto : Int64, pro_nombre : String, ppr_cantidad: Double){
            
            self.id_producto = id_producto
            self.pro_nombre = pro_nombre
            self.ppr_cantidad = ppr_cantidad
        }
    }
    
    struct Activity {
        
        var id_producto: Int64
        var act_cantidad: Int64
        var act_obs_ejecutor: String
        var id_tipoobservacion: Int64
        var id_usuario: Int64
        var id_actividadestado: Int64
        var act_fec_realizada: String
        var act_subida: Int64
        var act_datos: String
        
        init(id_producto: Int64, act_cantidad: Int64, act_obs_ejecutor: String, id_tipoobservacion: Int64, id_usuario: Int64, id_actividadestado: Int64, act_fec_realizada: String, act_subida: Int64, act_datos: String){
            
            self.id_producto = id_producto
            self.act_cantidad = act_cantidad
            self.act_obs_ejecutor = act_obs_ejecutor
            self.id_tipoobservacion = id_tipoobservacion
            self.id_usuario = id_usuario
            self.id_actividadestado = id_actividadestado
            self.act_fec_realizada = act_fec_realizada
            self.act_subida = act_subida
            self.act_datos = act_datos
        }
        
    }
    
    struct Ejecucion: Codable {
        var act_latitud: String
        var act_longitud: String
        var act_radio: Double
    }
    
    func parsearDatos() -> String{
        
        var stringData = ""
        
        let datos = Ejecucion(act_latitud: lat, act_longitud: lon, act_radio:0)
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(datos)
            stringData = String(data: jsonData, encoding: .utf8)!
            
        }catch{
            print(error)
        }
        return stringData
    }
    
}


