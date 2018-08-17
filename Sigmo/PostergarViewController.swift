//
//  PostergarViewController.swift
//  Sigmo
//
//  Created by macOS User on 16/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import AVFoundation

@available(iOS 11.0, *)
class PostergarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Fields Formulario
    @IBOutlet weak var motivoTextField: UITextField!
    @IBOutlet weak var tiempomuertoTextField: UITextField!
    @IBOutlet weak var postergarTextField: UITextField!
    @IBOutlet weak var observacionTextField: UITextField!
    
    // Labels cabecera
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // Textfields de imágenes
    @IBOutlet weak var imgLabel1: UITextField!

    // Loading & loading view
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    var count = 0
    var motivoPicker = UIPickerView()
    var postergarDatePicker = UIDatePicker()
    var imagePicker: UIImagePickerController!
    var imageViews: [UIImageView] = []
    var imgLabels: [UITextField] = []
    var gps = Gps()
    var locationManager = CLLocationManager()
    var lat: String = ""
    var lon: String = ""
    var motivos = fetchPostergar()
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    var id_actividad: Int64 = 0
    var id_postergar: Int64 = 0

   
    override func viewDidLoad() {
        super.viewDidLoad()

        imgBarRight(vc: self)// Logo a la derecha del nav

        self.hideKeyboardWhenTappedAround()
        
        if(gps.getLocation(locationManager: locationManager)){
            
            lat = UserDefaults.standard.string(forKey: "latitud")!
            lon = UserDefaults.standard.string(forKey: "longitud")!
        }
        
        id_actividad = Int64(self.datosEjecucion.id_actividad!)!
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)

        
        let foto1 = UIImageView()
        imageViews.append(foto1)
        
        imgLabels.append(imgLabel1)
        imgLabel1.isUserInteractionEnabled = false
        
        motivoPicker.delegate = self
        motivoPicker.dataSource = self
        motivoPicker.tag = 1
        motivoTextField.inputView = motivoPicker
        
        crearDatePicker()
                
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
    
    
    // ------------------- Pickerviews Functions ------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            motivoTextField.text = motivos[row].pos_nombre!
            id_postergar = motivos[row].id_postergar!
            motivoTextField.resignFirstResponder()
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return motivos[row].pos_nombre!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
      
        return motivos.count
    
    }// ----------- END Pickerview Functions ------------
    //--------------------------o--------------------------
    
    
    // ------------------- UIDatePicker --------------------
    
    func crearDatePicker(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        //Flexible space before button (para mostrar a la derecha el botón)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let seleccionar = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(selectedDate))
        seleccionar.tintColor = UIColor.black
        //seleccionar.setBackgroundImage(UIImage.init(named: "buscar_azul"), for: .normal, barMetrics: .default)
        
        toolbar.setItems([flexibleSpace,seleccionar], animated: false)
        
        postergarTextField.inputAccessoryView = toolbar
        postergarTextField.inputView = postergarDatePicker
        
        postergarDatePicker.datePickerMode = .date
        postergarDatePicker.locale = Locale(identifier: "es_CL")
        postergarDatePicker.minimumDate = addDays(fecha: Date(), cant: 1)
    }
    
    @objc func selectedDate(){
        
        
        let dateString = formatearFecha(fecha: postergarDatePicker.date, format: "dd-MM-yyyy")
        postergarTextField.text = "\(dateString)"
        self.view.endEditing(true)
    
    }//----------------- END Pickerdate ------------------

    
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

    //---------------- Fotos -----------------//
    


    //----------------- IBACTION EJECUTAR NORMAL --------------------//
    //---------------------------------------------------------------//
    @IBAction func guardarEjecucion(_ sender: Any) {
        
        let validacion = validarCampos()
        
        if validacion {
            ejecutarActividad(id_actividadestado: 7)
        }
        else{
            alertWithTitle(title: "¡Datos incompletos!", msg: "Debe completar los campos obligatorios ", vc: self)
        }
        
        
    }//-----------------END-----------------------

    
    //------------------ IMAGE PICKER CONTROLLER -----------------------//
    //------------------------------------------------------------------//
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageViews[count].image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (count == 0){
            self.imgLabel1.text = "\(formatearFecha(fecha: Date(), format: "YYYYMMddHHmmss"))_1"
            self.imgLabels[count].text = imgLabel1.text
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }//-----------------END-----------------------//

    
    
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
        
        let fecha = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
        let fechaPostergar = formatearFecha(fecha: postergarDatePicker.date, format: "yyyy-MM-dd")
        let datos = parsearDatos()
        let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
        
        if(id_actividadestado == 7){ // Ejecutar normal
            updateActividadLocal(id_actividad: id_actividad, act_obs_ejecutor: self.observacionTextField.text!, id_tipoobservacion: 0, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: fecha, act_datos: datos, id_postergar: id_postergar, act_tiempo: Int64(tiempomuertoTextField.text!)!, act_fec_asignada: fechaPostergar)
        }
        
        let i = 0 // Recorre las 3 imagenes si existen
            
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
        
        if(id_actividadestado == 7){ // cambiar a 7 postergar
            
            updateActividadServer(id_actividad: id_actividad, act_obs_ejecutor: self.observacionTextField.text!, id_tipoobservacion: 0, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: fecha, act_datos: datos, id_postergar: id_postergar, act_tiempo: Int64(tiempomuertoTextField.text ?? "0")!, act_fec_asignada: fechaPostergar, id_nivel: Int64(id_nivel), id_objeto: Int64(datosEjecucion.id_objeto ?? "0")!, success: { success, state, message, id_actEnproceso in
                if(success && state == 1){
                    print("Update Actividad server: ", success)
                    
                    updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                    
                    self.subirImg(i: i, name: self.imgLabels[i].text!, id_act: self.id_actividad){ (success) -> () in
                        if success {
                            //Update campo de foto subida
                            updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(self.id_actividad)")
                            print("Foto: ", i+1, "Actividad: ", self.id_actividad)
                            
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
            
        }// ActividadEstado == 7 // Postergar
        
    }// ----------------------- END FUNCTION---------------------------//
    
    
    
    func validarCampos() -> Bool {
        // validaciones
        var ok = true
        
        if(observacionTextField.text! == "" ){
            observacionTextField.borderStyle = UITextBorderStyle.roundedRect
            observacionTextField.layer.borderColor = UIColor.red.cgColor
            observacionTextField.layer.borderWidth = 1.0
            
            ok = false
        }else{
            observacionTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        if(tiempomuertoTextField.text! == "" ){
            tiempomuertoTextField.borderStyle = UITextBorderStyle.roundedRect
            tiempomuertoTextField.layer.borderColor = UIColor.red.cgColor
            tiempomuertoTextField.layer.borderWidth = 1.0
            
            ok = false
        }
        else{
            tiempomuertoTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if(postergarTextField.text! == "" ){
            postergarTextField.borderStyle = UITextBorderStyle.roundedRect
            postergarTextField.layer.borderColor = UIColor.red.cgColor
            postergarTextField.layer.borderWidth = 1.0
            
            ok = false
        }
        else{
            postergarTextField.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        if(motivoTextField.text! == "" ){
            motivoTextField.borderStyle = UITextBorderStyle.roundedRect
            motivoTextField.layer.borderColor = UIColor.red.cgColor
            motivoTextField.layer.borderWidth = 1.0
            
            ok = false
        }
        else{
            motivoTextField.layer.borderColor = UIColor.lightGray.cgColor
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
        
        return ok
    }
    
    func resetearCampos(){
        
        observacionTextField.borderStyle = UITextBorderStyle.roundedRect
        observacionTextField.layer.borderColor = UIColor.clear.cgColor
    
        tiempomuertoTextField.borderStyle = UITextBorderStyle.roundedRect
        tiempomuertoTextField.layer.borderColor = UIColor.clear.cgColor

        postergarTextField.borderStyle = UITextBorderStyle.roundedRect
        postergarTextField.layer.borderColor = UIColor.clear.cgColor
    
        motivoTextField.borderStyle = UITextBorderStyle.roundedRect
        motivoTextField.layer.borderColor = UIColor.clear.cgColor
        
        imgLabel1.borderStyle = UITextBorderStyle.roundedRect
        imgLabel1.layer.borderColor = UIColor.clear.cgColor

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
