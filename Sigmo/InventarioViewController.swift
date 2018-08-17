//
//  InventarioViewController.swift
//  Sigmo
//
//  Created by macOS User on 12/07/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB
import Alamofire
import MapKit
import AVFoundation

class InventarioViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scrolView: UIScrollView!
    
    // Labels cabecera
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // formulario
    @IBOutlet weak var observacionField: UITextField!
    
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
    
    //var gps = Gps()
    
    var id_actividad: Int64 = 0
    //var locationManager = CLLocationManager()
    //var lat: String = ""
    //var lon: String = ""
    
    var proValores:[ProductoValor] = []
    var x:Double = 0
    var y:Double = 20
    
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
        //let fecApp = traerFechaSync(tabla: "actividad", id_nivel: Int64(id_nivel), format: "yyyy-MM-dd HH:mm:ss")
        id_actividad = Int64(self.datosEjecucion.id_actividad!)!
        
        //-------------------------------INVENTARIO --------------------------------------
        //-----------Por ahora en duro, cambiar la fecha según corresponda----------------
        
        if getInvDetalle(id_actividad: id_actividad){
            print("Éxito INV")
        }
                    
        // -------- SCROLLVIEW OPTIONS ----------
        let size = CGSize(width: 350, height: self.y)
        self.scrolView.layoutIfNeeded()
        self.scrolView.isScrollEnabled = true
        self.scrolView.showsHorizontalScrollIndicator = false
        self.scrolView.isDirectionalLockEnabled = true
        self.scrolView.contentSize = size
                    
        
        //-------------------------------INVENTARIO --------------------------------------
        //--------------------------------------------------------------------------------
        
        imgBarRight(vc: self)// Logo a la derecha del nav
        loading.frame = loadingView.bounds
        
        self.hideKeyboardWhenTappedAround() // Ocultar teclado al tocar afuera
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        id_actividad = Int64(self.datosEjecucion.id_actividad!)!
        print("Datos ejecucion: ", datosEjecucion)
        
        // crea var de Fotos
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
    
    func generaTextField(index: Int, id_ind: String, labelText: String,  ejey: Double, ejex: Double)  {
        
        //print("Char de texto: ",labelText.count)
       
        
        let label = UILabel(frame: CGRect(x: ejex, y: ejey, width: 270.00, height: 45.00))
        label.text = labelText
        label.autoresizingMask = [.flexibleLeftMargin]
        label.font = label.font?.withSize(13)
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        //label.center.y = self.view.center.y
        
        scrolView.addSubview(label) // cambiar por la view correspondiente con autolayout
        
        let field = UITextField(frame: CGRect(x: ejex + 285, y: ejey, width: 55.00, height: 40.00));
        
        // Or you can position UITextField in the center of the view //nombreField.center = self.view.center
        // Set UITextField placeholder text
        //field.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        //field.center.y = self.view.center.y
        field.placeholder = ""
        // Set text to UItextField
        // Set UITextField border style
        field.borderStyle = UITextBorderStyle.roundedRect
        field.font = field.font?.withSize(12)
        field.autoresizingMask = [.flexibleWidth]
        field.autoresizingMask = [.flexibleRightMargin]
        field.keyboardType = .decimalPad
        
        // Set UITextField background colour //myTextField.backgroundColor = UIColor.white // Set UITextField text color //myTextField.textColor = UIColor.blue
        scrolView.addSubview(field)
        
        let proValor = ProductoValor(index: index, id_ind: id_ind, proNombre: labelText, proLabel: label, proField: field, proValor: "")
        proValores.append(proValor)
    }//------------------------ o -------------------------------
    
    
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
    
    
    
    //----------------- IBACTION EJECUTAR NORMAL --------------------//
    //---------------------------------------------------------------//
    @IBAction func guardarEjecucion(_ sender: Any) {
        
        if(proValores.count == 0){
            alertWithTitle(title: "Error de inventario", msg: "¡Inventario vacío, imposible ejecutar!", vc: self)
            return
        }
            
        let validacion = validarCampos()
        
        if validacion {
            ejecutarActividad(id_actividadestado: 2)
        }
        else{
            
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
    }// ------------------- END ---------------------------/
    
    // ------------------ FUNCION PARA EJECUTAR ACTIVIDAD ---------------------//
    // ------------------------------------------------------------------------//
    func ejecutarActividad(id_actividadestado: Int64){
        
        // Si la validación está OK
        loading.startAnimating()
        resetearCampos()
        
        let fecha = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
        let datos = parsearDatos()
        let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
        
        updateActividadLocal(id_actividad: id_actividad, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: 0, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: fecha, act_datos: datos)
        
        for i in 0...2{ // Recorre las 3 imagenes si existen
            
            if((imageViews[i].image) != nil){
                saveImage(i: i)
                getImage(i: i){ (success) -> () in
                    if success {
                        
                        //Insert de foto en tabla Foto
                        if insertFoto(id_actividad: self.id_actividad, fot_nombre: self.imgLabels[i].text!, fot_peso: 0, fot_orden: Int64(i+1), fot_subida: 0, con_url: Config.config.con_url!){
                            print("Foto \(self.imgLabels[i].text!) insertada en db")
                        }
                    }
                }
            }// if((imageViews[i].image) != nil)
        }// For.-----
        
        
        updateActividadServer(id_actividad: id_actividad, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: 0, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: fecha, act_datos: datos, id_nivel: Int64(id_nivel), id_objeto: Int64(datosEjecucion.id_objeto ?? "0")!, success: { success, state, message, id_actServer in
            if(success && state == 1){
                print("Update Actividad server: ", success)
                
                updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                
                for i in 0...2{ // Recorre las 3 imagenes si existen e intenta subirlas
                    
                    if((self.imageViews[i].image) != nil){
                        self.subirImg(i: i, name: self.imgLabels[i].text!, id_act: self.id_actividad){ (success) -> () in
                            if success {
                                //Update campo de foto subida
                                updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                                print("Foto: ", i+1, "Actividad: ", self.id_actividad)
                                // --- Actualiza el id actividad que retorna del server en la tabla foto
                                updateTable(tabla: "foto", campo: "id_actividad", valor: "\(self.id_actividad)", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                                
                                
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
            
        
    }// ----------------------- END FUNCTION---------------------------//

    
    
    func validarCampos() -> Bool {
        // validaciones
        var ok = true
        
        if(observacionField.text! == "" ){
            observacionField.borderStyle = UITextBorderStyle.roundedRect
            observacionField.layer.borderColor = UIColor.red.cgColor
            observacionField.layer.borderWidth = 1.0
            
            ok = false
        }
        else{
            observacionField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
      
        if(imgLabel1.text! == "" ){
            imgLabel1.borderStyle = UITextBorderStyle.roundedRect
            imgLabel1.layer.borderColor = UIColor.red.cgColor
            imgLabel1.layer.borderWidth = 1.0
            
            ok = false
        }
        else{
            imgLabel1.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if(proValores.count > 0){
            for n in 0...(proValores.count - 1){
                if(proValores[n].proField?.text! == "" ){
                    proValores[n].proField?.borderStyle = UITextBorderStyle.roundedRect
                    proValores[n].proField?.layer.borderColor = UIColor.red.cgColor
                    proValores[n].proField?.layer.borderWidth = 1.0
                    
                    ok = false
                }
                else{
                    proValores[n].proField?.layer.borderColor = UIColor.lightGray.cgColor
                }
                
            }
        }
        
        return ok
    }
    
    func resetearCampos(){
        
        observacionField.borderStyle = UITextBorderStyle.roundedRect
        observacionField.layer.borderColor = UIColor.clear.cgColor
        
        imgLabel1.borderStyle = UITextBorderStyle.roundedRect
        imgLabel1.layer.borderColor = UIColor.clear.cgColor
        
        if(proValores.count > 0){
            for n in 0...(proValores.count - 1){
               
                proValores[n].proField?.borderStyle = UITextBorderStyle.roundedRect
                proValores[n].proField?.layer.borderColor = UIColor.clear.cgColor
                
            }
        }
    }
    
    func getInvDetalle(id_actividad: Int64) -> Bool{
        
        
        let invSql = "SELECT d.* " +
            "FROM inventariodetalle d " +
            "INNER JOIN inventario i ON i.id_inventario = d.id_inventario " +
            "WHERE i.id_actividad = \(id_actividad) AND d.ind_estado = 1"
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, invSql)
                if( rows.count == 0){
                    print("No existen registros de Inventario")
                    
                    let label = UILabel(frame: CGRect(x: self.x, y: self.y, width: Double(self.scrolView.frame.size.width), height: 45.00))
                    label.text = "¡No existen productos para el inventario!"
                    label.textColor = UIColor.red
                    label.font = label.font?.withSize(16)
                    label.textAlignment = .center
                    label.lineBreakMode = .byWordWrapping
                    label.numberOfLines = 0
                    scrolView.addSubview(label) // cambiar por la view correspondiente con autolayout
                }
                else{
                    print("ROWS: ", rows)
                    var c = 0
                    for row in rows {
                        //print("ROW: ", row)
                        let pro_codigo = "\(row["pro_codigo"]!)"
                        let pro_nombre = "\(row["pro_nombre"]!)"
                        let pro_envase = "\(row["pro_envase"]!)"
                        let ind_index = "\(row["ind_index"]!)"
                       
                        
                        let label = "\(pro_codigo), \(pro_envase), \(pro_nombre)"
                        
                        self.generaTextField(index: c, id_ind: ind_index, labelText: label,  ejey: self.y, ejex: self.x)
                        self.y += 50
                        c += 1
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
       return true
    }
    
    
    // Datos JSON parseados en string
    func parsearDatos() -> String{
        
        var datoString = "{"
        
        // Recorre el array de valor producto
        for n in 0...(proValores.count - 1){
            
            let i = proValores.index(where: {$0.index == n})! // Encuentra el index
            //print(proValores[i].id_ind!, ": ", proValores[i].proField!.text!)
            // llena el string parseado de Datos
            datoString += "\"\(proValores[i].id_ind!)\":\"\(proValores[i].proField!.text!)\""
            if n < (proValores.count - 1){
                datoString += ","
            }
            else{
                datoString += "}"
            }
        }
        print("DatoString: ", datoString) // Ok data
        return datoString
    }
    
    
    struct ProductoValor{
        
        var index: Int? // Posicion en el array de productos de Inventario
        var id_ind: String? // nombre enviado en Datos
        var proNombre: String? // nombre Para mostrar al usuario
        var proLabel: UILabel? // label
        var proField: UITextField? // Textfield
        var proValor: String? // valor en textfield
        
        
        init(index: Int, id_ind: String, proNombre: String, proLabel: UILabel, proField: UITextField, proValor: String) {
            self.index = index
            self.id_ind = id_ind // ind_1, ind_2...
            self.proNombre = proNombre
            self.proLabel = proLabel // nombre producto (label)
            self.proField = proField
            self.proValor = proValor
        }
    }
        
}

