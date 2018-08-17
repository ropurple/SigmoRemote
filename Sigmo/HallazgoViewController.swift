//
//  HallazgoViewController.swift
//  Sigmo
//
//  Created by macOS User on 24/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB
import Alamofire
import MapKit
import AVFoundation

class HallazgoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var btnSgte: UIButton!
    
    // Loading & loading view
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var nivelesView: UIView! // View de niveles dinámicos
    @IBOutlet weak var nivelesHeight: NSLayoutConstraint!
    @IBOutlet weak var observacionField: UITextField!// texto informacion
    
    // Pickers fijos
    @IBOutlet weak var nivelLabel: UILabel! // label ultimo nivel antes de objeto
    @IBOutlet weak var nivelTextfield: UITextField!
    @IBOutlet weak var objetoTextfield: UITextField!
    @IBOutlet weak var hallazgoTextfield: UITextField!
    
    // Textfields de imágenes
    @IBOutlet weak var imgLabel1: UITextField!
    @IBOutlet weak var imgLabel2: UITextField!
    @IBOutlet weak var imgLabel3: UITextField!
    
    // Switch de hallazgo resuelto
    @IBOutlet weak var hallazgoSwitch: UISwitch!
    
    // Var para images
    var imagePicker: UIImagePickerController!
    var imageViews: [UIImageView] = []
    var imgLabels: [UITextField] = []
    
    // VARIABLES PARA PICKERVIEWS
    var pickerViews:[UIPickerView] = []
    var picker1 = UIPickerView()
    var picker2 = UIPickerView()
    var picker3 = UIPickerView()
    var picker4 = UIPickerView()
    var picker5 = UIPickerView()
    var picker6 = UIPickerView()
    
    // Pickerviews fijos
    var nivelPickerview = UIPickerView()
    var objetoPickerview = UIPickerView()
    var hallazgoPickerview = UIPickerView()
    
    // VARIABLES PARA TEXTFIELDS DE LOS SELECCIONABLES
    var fields: [UITextField] = []
    var field1: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    var field2: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    var field3: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    var field4: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    var field5: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    var field6: UITextField! = UITextField(frame: CGRect(x: 0, y: 0, width: 0.00, height: 0.00));
    
    // VARIABLES PARA LABELS DE LOS SELECCIONABLES
    var labels: [UILabel] = []
    var label1: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var label2: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var label3: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var label4: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var label5: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var label6: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    public var cantPicker:Int = 0
    public var nivelesTipo:[PickerArray] = []
    public var tiponiveles:[Tiponivel] = []

    // ARRAYS PARA MOSTRAR EN PICKERVIEW
    
    var pickerArrays:[[PickerValor]] = []// ARRAY QUE CONTIENE LOS ARRAYS PARA EL PICKERVIEW
    var picker1Array:[PickerValor] = []
    var picker2Array:[PickerValor] = []
    var picker3Array:[PickerValor] = []
    var picker4Array:[PickerValor] = []
    var picker5Array:[PickerValor] = []
    var picker6Array:[PickerValor] = []
    
    var nivelPickerArray:[PickerValor] = []
    var objetoPickerArray:[ObjetoValor] = []
    var hallazgoPickerArray:[HallazgoValor] = []
    
    var ultimoNivel = PickerValor(id_nivelvalor: 0, nva_valorcorto: "", id_nivel: 0, niveles: "", nti_nombre: "", id_niveltipo: 0)
    var id_objeto: Int64 = 0
    var id_nivel: Int64 = 0
    var id_tipohallazgo: Int64 = 0
    var eje_y:Double = 0
    var eje_x:Double = 0
    
    var count = 0 // images
    var lat: String = ""
    var lon: String = ""
    var gps = Gps()
    var locationManager = CLLocationManager()
    var viewcount = 0 // Contador para manejar la preseleccion de los niveles al crear la vista
    var comingFromTab = false // Identifica si es que viene desde el tab bar o si se refresca despues de usar la camera


    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround() // Ocultar teclado al tocar afuera
        imgBarRight(vc: self)// Logo a la derecha del nav
        
        loading.frame = loadingView.bounds
        
        //------------ Get Ubicacion ---------
        if(gps.getLocation(locationManager: locationManager)){
            
            lat = UserDefaults.standard.string(forKey: "latitud")!
            lon = UserDefaults.standard.string(forKey: "longitud")!
        }
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        //Viene desde tab
        comingFromTab = true
        
    }// ---- END VIEWDIDLOAD() ----
    
    
    //-------- VIEW WILL APPEAR -----------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.tabBarController?.tabBar.isHidden = false // No mostrar Tab Bar
        
        if comingFromTab{ // Viene desde tab
           
            let foto1 = UIImageView();let foto2 = UIImageView();let foto3 = UIImageView()
            imageViews.append(foto1);imageViews.append(foto2);imageViews.append(foto3)
            imgLabels.append(imgLabel1); imgLabels.append(imgLabel2); imgLabels.append(imgLabel3)
            
            // Inhabilitar textfield de imagen
            imgLabel1.isUserInteractionEnabled = false
            imgLabel2.isUserInteractionEnabled = false
            imgLabel3.isUserInteractionEnabled = false
            
            
            // ------- LLENADO DE ARRAYS -------------
            pickerViews.removeAll()
            pickerViews.append(picker1);pickerViews.append(picker2);pickerViews.append(picker3);pickerViews.append(picker4);pickerViews.append(picker5);pickerViews.append(picker6)
            pickerArrays.removeAll()
        pickerArrays.append(picker1Array);pickerArrays.append(picker2Array);pickerArrays.append(picker3Array);pickerArrays.append(picker4Array);pickerArrays.append(picker5Array);pickerArrays.append(picker6Array)
            fields.removeAll()
            fields.append(field1);fields.append(field2);fields.append(field3);fields.append(field4);fields.append(field5);fields.append(field6)
            labels.removeAll()
            labels.append(label1);labels.append(label2);labels.append(label3);labels.append(label4);labels.append(label5);labels.append(label6)
            //----------------o------------------
            
            nivelesTipo.removeAll()
            nivelesTipo = nivelesRequeridos()// Trae los niveles requeridos del User
            cantPicker = nivelesTipo.count
            
            eje_y = 15
            eje_x = 120
            var c = 1
            
            for ntipo in nivelesTipo{ // Recorre los niveles del usuario
                if(cantPicker >= c){
                    
                    if (c == 1){ // si es el primero, entonces crea y llena el pickerview
                        
                        generaTextField( posicion: ntipo.index!, text: ntipo.tipo_nombre!, ejey: eje_y, ejex: eje_x)
                        let hijos = hijosxNivel(id_niveltipo: ntipo.id_niveltipo!, niveles: "")
                        llenarPicker(tiponivel: ntipo.id_niveltipo!, pickerview: pickerViews[0], hijos: hijos, field: nivelesTipo[0].field!)
                        
                        eje_y+=40
                        c+=1
                    }
                    else {
                        
                        generaTextField( posicion: ntipo.index!, text: ntipo.tipo_nombre!, ejey: eje_y, ejex: eje_x)
                        
                        eje_y+=40
                        c+=1
                    }
                }
            }
            
            // inicializa picker nivel
            nivelPickerview.delegate = self
            nivelPickerview.dataSource = self
            nivelPickerview.tag = 10
            nivelTextfield.inputView = nivelPickerview
            nivelTextfield.isUserInteractionEnabled = false
            
            // inicializa picker objbeto
            objetoPickerview.delegate = self
            objetoPickerview.dataSource = self
            objetoPickerview.tag = 11
            objetoTextfield.inputView = objetoPickerview
            objetoTextfield.isUserInteractionEnabled = false
            
            // Inicializa picker Hallazgo
            hallazgoPickerview.delegate = self
            hallazgoPickerview.dataSource = self
            hallazgoPickerview.tag = 12
            hallazgoTextfield.inputView = hallazgoPickerview
            let hallazgos = getHallazgo()
            llenarPickerHallazgo(pickerview: hallazgoPickerview, hijos: hallazgos, field: hallazgoTextfield)
            
            nivelesHeight.constant = CGFloat(eje_y)
            nivelesHeight.priority = UILayoutPriority(rawValue: 999)
            self.view.endEditing(true)
            
            // ---- Llena los niveles seleccionados (anclas) y los preselecciona -----
            tiponiveles.removeAll()
            let niv_ruta = UserDefaults.standard.string(forKey: "niv_ruta")
            llenarTiponivel(niv_ruta: niv_ruta!)
            
            
            var n = 0
            for ntipo in tiponiveles{ // Recorre los niveles del usuario
                
                if(ntipo.id_niveltipo == nivelesTipo[n].id_niveltipo){
                    
                    let index = pickerArrays[n].index(where: {$0.id_nivelvalor! == ntipo.id_nivelvalor!})!
                    pickerViews[n].selectRow(index, inComponent: 0, animated: true)
                    self.pickerView(self.pickerViews[n], didSelectRow: index, inComponent: 0)

                }
                // Hacer match con el nivel del hallazgo
                n += 1
            }
            comingFromTab = false
        }//----- Coming From Tab ----------
        
    }//-------- END VIEW WILL APPEAR -----------
    
    
    //--------------------- FUNCIONES NECESARIAS PARA EL PICKERVIEW ---------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //---- Tag Picker de ultimo nivel antes de objeto nivelPickerArray -----
        if(pickerView.tag == 10){
            id_objeto = 0
            nivelTextfield.text = nivelPickerArray[row].nva_valorcorto!
            id_nivel = nivelPickerArray[row].id_nivel!
            
            objetoPickerArray.removeAll()
            let objetos = getObjeto(id_nivel: nivelPickerArray[row].id_nivel!)
           
                llenarPickerObjeto(pickerview:objetoPickerview, hijos:objetos, field: objetoTextfield )
                objetoTextfield.isUserInteractionEnabled = true
                objetoPickerview.selectRow(1, inComponent: 0, animated: true)
                objetoTextfield.text = objetoPickerArray[0].obj_nombre!
        } //---- END tag nivelPickerArray -----
            
        //---- Tag Picker objetoPickerArray -----
        else if(pickerView.tag == 11){
            id_objeto = objetoPickerArray[row].id_objeto!
            objetoTextfield.text = objetoPickerArray[row].obj_nombre!
        }//---- END Tag objetoPickerArray -----
            
        //---- Tag Picker hallazgoPickerArray -----
        else if(pickerView.tag == 12){
            hallazgoTextfield.text = hallazgoPickerArray[row].tha_nombre!
            id_tipohallazgo = hallazgoPickerArray[row].id_tipohallazgo!
        }//---- END Tag hallazgoPickerArray -----
            
            
        //----- Pickers dinámicos ---------
        else{
            let i = Int(pickerView.tag)
            
            nivelesTipo[i].field?.text = pickerArrays[i][row].nva_valorcorto
            
            if(cantPicker > 0 && i < (cantPicker - 1)){
                
                limpiarPicker(cantidad: cantPicker, tag: i)
                let hijos = hijosxNivel(id_niveltipo: nivelesTipo[i+1].id_niveltipo!, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!)
                llenarPicker(tiponivel: nivelesTipo[i+1].id_niveltipo!, pickerview: pickerViews[i+1], hijos: hijos, field: nivelesTipo[i+1].field!)
                btnSgte.isEnabled = false
                
                if (hijos.count == 1){ // Para seleccion automàtica cuando es 1 --- probar
                    pickerViews[i+1].selectRow(1, inComponent: 0, animated: true)
                    nivelesTipo[i+1].field?.text = pickerArrays[i+1][0].nva_valorcorto
                    self.pickerView(self.pickerViews[i+1], didSelectRow: 0, inComponent: 0) // Llama al pickerview siguiente recursivo
                }
            }
                
            else { // Último nivel requerido
                limpiarPicker(cantidad: cantPicker, tag: i)
                
                ultimoNivel = PickerValor(id_nivelvalor: pickerArrays[i][row].id_nivelvalor!, nva_valorcorto: pickerArrays[i][row].nva_valorcorto!, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!, nti_nombre: pickerArrays[i][row].nti_nombre!, id_niveltipo: pickerArrays[i][row].id_niveltipo!)
                
                id_nivel = pickerArrays[i][row].id_nivel!
                id_objeto = 0
                // ULTIMO Nivel antes del objeto
                
                nivelTextfield.text = ""
                nivelTextfield.isUserInteractionEnabled = false
                nivelLabel.text = "Nivel"
                nivelPickerArray.removeAll()
                let hijos = hijosxNivel(id_niveltipo: 0, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!, ultimoNivel: true)
                var hijosNivel:[PickerValor] = []
                
                if hijos.count > 0 {
                    // Si el ultimo nivel es igual al ultimo requerido
                    if(hijos[0].id_niveltipo == pickerArrays[i][row].id_niveltipo!){
                        hijosNivel.removeAll()
                        hijosNivel.append(PickerValor(id_nivelvalor: 0, nva_valorcorto: "-=SELECCIONE NIVEL=-", id_nivel: 0, niveles: "", nti_nombre: "", id_niveltipo: 0))
                        hijosNivel.append(ultimoNivel)
                        llenarPickerNivel(tiponivel: ultimoNivel.id_niveltipo!, pickerview: nivelPickerview, hijos: hijosNivel, field: nivelTextfield!)
                    }
                    else{
                        llenarPickerNivel(tiponivel: nivelPickerArray[0].id_niveltipo!, pickerview: nivelPickerview, hijos: nivelPickerArray, field: nivelTextfield!)
                    }
                    if (hijos.count == 1 || hijosNivel.count == 1){
                        nivelPickerview.selectRow(1, inComponent: 0, animated: true)
                        nivelTextfield.text = nivelPickerArray[0].nva_valorcorto
                        self.pickerView(self.nivelPickerview, didSelectRow: 0, inComponent: 0)
                        id_nivel = nivelPickerArray[0].id_nivel!
                    }
                }
                else{
                    nivelPickerArray.append(PickerValor(id_nivelvalor: 0, nva_valorcorto: "-=SELECCIONE NIVEL=-", id_nivel: 0, niveles: "", nti_nombre: "", id_niveltipo: 0))
                    nivelPickerArray.append(ultimoNivel)
                    nivelTextfield.isUserInteractionEnabled = true
                }
                
                btnSgte.isEnabled = true
                
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 10){
            return nivelPickerArray[row].nva_valorcorto
        }
        else if(pickerView.tag == 11){
            return objetoPickerArray[row].obj_nombre
        }
        else if(pickerView.tag == 12){
            return hallazgoPickerArray[row].tha_nombre
        }
        else {
            return pickerArrays[pickerView.tag][row].nva_valorcorto
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if(pickerView.tag == 10){
             return nivelPickerArray.count
        }
        else if(pickerView.tag == 11){
            return objetoPickerArray.count
        }
        else if(pickerView.tag == 12){
            return hallazgoPickerArray.count
        }
        else{
             return pickerArrays[pickerView.tag].count
        }
        
    }
    //---------- END FUNCIONES PICKERVIEW --------------------
    
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
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
    
    @IBAction func guardarHallazgo(_ sender: Any) {
        
        let validacion = validarCampos()
        
        if validacion {
            let resuelto = hallazgoSwitch.isOn
            
            if resuelto{
                ejecutarActividad(id_actividadestado: 2)
            }
            else{
                ejecutarActividad(id_actividadestado: 5)
            }
        }
        else{
            alertWithTitle(title: "¡Datos incompletos!", msg: "Debe completar los campos obligatorios ", vc: self)
        }
    }
    
    // --------------- GENERA LOS TEXTFIELDS PARA CADA PICKER ---------------------------
    
    func generaTextField(posicion: Int, text: String,  ejey: Double, ejex: Double)  {

        let index = Int(posicion)
        labels[index] = UILabel(frame: CGRect(x: ejex-110, y: ejey, width: 100.00, height: 30.00))
        labels[index].text = text
        labels[index].font = fields[index].font?.withSize(15)
        labels[index].autoresizingMask = [.flexibleLeftMargin]
        nivelesView.addSubview(labels[index])
        
        fields[index] = UITextField(frame: CGRect(x: ejex, y: ejey, width: 240.00, height: 30.00));
        
        // Or you can position UITextField in the center of the view //nombreField.center = self.view.center
        // Set UITextField placeholder text
        fields[index].placeholder = "-=SELECCIONE \(text)=-"
        fields[index].textAlignment = .center
        fields[index].borderStyle = UITextBorderStyle.roundedRect
        fields[index].font = fields[index].font?.withSize(12)
        fields[index].autoresizingMask = [.flexibleWidth]
        fields[index].autoresizingMask = [.flexibleRightMargin]
        
        if(index > 0){ //Permite usar el primer picker solamente
            fields[index].isUserInteractionEnabled = false
        }
        
        // Set UITextField background colour //myTextField.backgroundColor = UIColor.white // Set UITextField text color //myTextField.textColor = UIColor.blue
        nivelesView.addSubview(fields[index])
        if(cantPicker > 1 ){
            let i = nivelesTipo.index(where: {$0.index == posicion})!
            nivelesTipo[i].field = fields[index]
            nivelesTipo[i].pickerview = pickerViews[i]
            
            pickerViews[i].delegate = self
            pickerViews[i].tag = i
            fields[index].inputView = pickerViews[i]
        }
        
        
    }//------------------------ o -------------------------------
    
    
    // -------------------- RELLENAR CADA PICKERVIEW -----------------------
    
    func llenarPicker(tiponivel: Int64, pickerview:UIPickerView, hijos:[PickerValor], field: UITextField ) {
        
        //var arrayPicker:[(id_nivelvalor: Int64, nva_nombre: String)] = []
        let i = nivelesTipo.index(where: {$0.id_niveltipo == tiponivel})!
        
        pickerArrays[Int(i)].removeAll()
        pickerArrays[Int(i)] = hijos
        pickerview.reloadAllComponents()
        
        if(field.text != nil){
            field.isUserInteractionEnabled = true
        }
        
    }// ----------------------- o --------------------------
    
    func llenarPickerNivel(tiponivel: Int64, pickerview:UIPickerView, hijos:[PickerValor], field: UITextField ) {
        
        nivelPickerArray.removeAll()
        nivelPickerArray = hijos
        pickerview.reloadAllComponents()
        
        if(field.text != nil){
            field.isUserInteractionEnabled = true
        }
        
    }// ----------------------- o --------------------------
    
    func llenarPickerObjeto(pickerview:UIPickerView, hijos:[ObjetoValor], field: UITextField ) {
        
        objetoPickerArray.removeAll()
        objetoPickerArray = hijos
        pickerview.reloadAllComponents()
        
        if(field.text != nil){
            field.isUserInteractionEnabled = true
        }
        
    }// ----------------------- o --------------------------
    
    func llenarPickerHallazgo(pickerview:UIPickerView, hijos:[HallazgoValor], field: UITextField ) {
        
        hallazgoPickerArray.removeAll()
        hallazgoPickerArray = hijos
        pickerview.reloadAllComponents()
        
        if(field.text != nil){
            field.isUserInteractionEnabled = true
        }
        
    }// ----------------------- o --------------------------

    
    // ------------------- LIMPIAR PICKER ----------------------
    
    func limpiarPicker(cantidad: Int, tag: Int){
        
        
        for i in (tag+1)..<cantidad  {
            nivelesTipo[i].field?.text = ""
            nivelesTipo[i].field?.isUserInteractionEnabled = false
        }
        
        nivelTextfield.text = ""
        nivelTextfield.isUserInteractionEnabled = false
        objetoTextfield.text = ""
        objetoTextfield.isUserInteractionEnabled = false
    }//---------------------o------------------------------


    
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
            //print("URL IMG: ", fileURL)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = UIImageJPEGRepresentation(imageViews[i].image!, 0.02),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    //print("img: \(fileName) -saved")
                } catch {
                    print("error saving file -\(i)- :", error)
                }
            }
        }
        else{
            print("No existe foto \(i)")
        }
        
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
        
        var actLocal = Actividad()// Actividad duplicada localmente
        //let fecha = formatearFecha(fecha: Date(), format: "yyyy-MM-dd HH:mm:ss")
        let datos = parsearDatos()
        var id_act:Int64 = 0
        if(id_nivel == 0){
            id_nivel = ultimoNivel.id_nivel!
        }
        // INSERTA ACTIVIDAD LOCALMENTE (HALLAZGO)
        //print("\n id_tipohallazgo: ", id_tipohallazgo)
        actLocal = insertarActividad(id_actividad: 0, id_actividadestado: id_actividadestado, act_obs_ejecutor: self.observacionField.text!, id_tipoobservacion: 0, act_datos: datos, id_nivel: id_nivel, id_objeto: id_objeto, id_tipohallazgo: id_tipohallazgo)
        id_act = actLocal.id_actividad!
        
        
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
            }//---- END if((imageViews[i].image) != nil) ----
        }// --- For -----
        
        
        if actLocal.id_actividad! > 0 { // Se inserta correctamente
            
            updateActividadServer(id_actividad: id_act, act_obs_ejecutor: actLocal.act_obs_ejecutor!, id_tipoobservacion: actLocal.id_tipoobservacion!, id_usuario: userID!, id_actividadestado: id_actividadestado, act_fec_realizada: actLocal.act_fec_realizada!, act_datos: actLocal.act_datos!, id_nivel: actLocal.id_nivel!, id_objeto: actLocal.id_objeto!, id_tipohallazgo: id_tipohallazgo, success: { success, state, message, id_act_server in
                if(success && state == 1){
                    
                    updateTable(tabla: "actividad", campo: "act_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(actLocal.id_actividad!)")
                    print("\n\n\n Update Actividad server: ", success, "Id_actividad: ", id_act_server, "\n\n")
                    
                    for i in 0...2{ // Recorre las 3 imagenes si existen e intenta subirlas
                        
                        if((self.imageViews[i].image) != nil){
                            self.subirImg(i: i, name: self.imgLabels[i].text!, id_act: id_act_server){ (success) -> () in
                                if success {
                                    //Update campo de foto subida
                                    updateTable(tabla: "foto", campo: "fot_subida", valor: "1", whereCampo: "id_actividad", whereValor: "\(actLocal.id_actividad!)")
                                    print("Foto: ", i+1, "Actividad: ", id_act_server)
                                    // --- Actualiza el id actividad que retorna del server en la tabla foto
                                    updateTable(tabla: "foto", campo: "id_actividad", valor: "\(id_act_server)", whereCampo: "id_actividad", whereValor: "\(actLocal.id_actividad!)")

                                    
                                }
                            }
                        }
                    }
                    
                    self.goBackMsgeHallazgo(vc: self, title: "INFO", msge: "Hallazgo sincronizado con éxito", loading: self.loading)
                   
                }
                else if(success && state == 2){
                    
                    self.goBackMsgeHallazgo(vc: self, title: "INFO", msge: "¡Hallazgo YA INSERTADO!", loading: self.loading)
                } // Actividad ya insertada, mostrar modal
                else if(success && state == 0){
                    
                    self.goBackMsgeHallazgo(vc: self, title: "INFO", msge: message, loading: self.loading)
                } // Actividad no encontrada, mostrar modal
                    
                else {
                    
                    self.goBackMsgeHallazgo(vc: self, title: "INFO", msge: "¡Hallazgo guardado localmente", loading: self.loading)
                }
            })
        }
    }// ----------------------- END
    
    func goBackMsgeHallazgo(vc: UIViewController, title: String, msge: String, loading: UIActivityIndicatorView){
        
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message: msge, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                //run your function here
                self.limpiarValores()
                self.comingFromTab = true
                self.tabBarController?.selectedIndex = 0
            }))
            loading.stopAnimating()
            vc.present(alertController, animated: true, completion: nil)
        })
    }
    // -------- END ALERT VC ANTERIOR -----------

    func limpiarValores(){
        
        fields[0].text = ""; fields[1].text = ""; fields[2].text = ""; fields[3].text = ""; fields[4].text = ""; fields[5].text = ""; 
        nivelTextfield.text = ""
        objetoTextfield.text = ""
        hallazgoTextfield.text = ""
        observacionField.text = ""
        imgLabel1.text = ""; imgLabel2.text = ""; imgLabel3.text = ""
        imageViews[0].image = nil; imageViews[1].image = nil; imageViews[2].image = nil
        
        for i in 0...(cantPicker - 1){
            fields[i].text = ""
            if i > 0 {
                fields[i].isUserInteractionEnabled = false
            }
        }
        
        
    }
    
    func validarCampos() -> Bool {
        // validaciones
        var ok = true
        
        if(observacionField.text! == "" ){
            observacionField.borderStyle = UITextBorderStyle.roundedRect
            observacionField.layer.borderColor = UIColor.red.cgColor
            observacionField.layer.borderWidth = 1.0
            
            ok = false
        }
        if(hallazgoTextfield.text! == "" ){
            hallazgoTextfield.borderStyle = UITextBorderStyle.roundedRect
            hallazgoTextfield.layer.borderColor = UIColor.red.cgColor
            hallazgoTextfield.layer.borderWidth = 1.0
            
            ok = false
        }
        if(imgLabel1.text! == "" ){
            imgLabel1.borderStyle = UITextBorderStyle.roundedRect
            imgLabel1.layer.borderColor = UIColor.red.cgColor
            imgLabel1.layer.borderWidth = 1.0
            
            ok = false
        }
        if(nivelTextfield.text! == "" ){
            nivelTextfield.borderStyle = UITextBorderStyle.roundedRect
            nivelTextfield.layer.borderColor = UIColor.red.cgColor
            nivelTextfield.layer.borderWidth = 1.0
            
            ok = false
        }
        
        return ok
    }
    
    func resetearCampos(){
        
        observacionField.borderStyle = UITextBorderStyle.roundedRect
        observacionField.layer.borderColor = UIColor.clear.cgColor

        
        hallazgoTextfield.borderStyle = UITextBorderStyle.roundedRect
        hallazgoTextfield.layer.borderColor = UIColor.clear.cgColor

        
        imgLabel1.borderStyle = UITextBorderStyle.roundedRect
        imgLabel1.layer.borderColor = UIColor.clear.cgColor
    
        
        nivelTextfield.borderStyle = UITextBorderStyle.roundedRect
        nivelTextfield.layer.borderColor = UIColor.clear.cgColor

        hallazgoSwitch.isOn = false
        
    }
    
    // --------------------BUSCA LOS HIJOS POR NIVEL----------------------------
    
    func hijosxNivel(id_niveltipo: Int64, id_nivel: Int64 = 0, niveles:String, ultimoNivel:Bool = false, primerPicker:Bool = false) -> [PickerValor]{
        
        var hijos: String = ""
        var pickerValores = [PickerValor]()
        var nivelSql = ""
        
        do{
            try dbQueue.inDatabase { db in
                
                // CONSULTA POR LOS HIJOS EN UN STRING POR COMAS
                if id_nivel > 0 {
                    let hijosSql = "SELECT niv_hijos, id_nivel FROM nivel WHERE id_nivel IN ( \(niveles) )"
                    
                    let rowHijos = try Row.fetchAll(db, hijosSql)
                    
                    if( rowHijos.count == 0){
                        print("No existen hijos")
                    }
                    else{
                        var count = 1
                        
                        for row in rowHijos{
                            if(row["niv_hijos"] != ""){
                                if count == 1 {
                                    hijos += row["niv_hijos"]
                                    count += 1
                                }
                                else{
                                    hijos += ", " + row["niv_hijos"]
                                }
                            }
                        }
                    }
                }//------------HIJOS---------------------
                
                if ultimoNivel {
                    nivelSql = "SELECT " +
                        "n.id_nivelvalor, " +
                        "v.nva_valorcorto, " +
                        "n.id_nivel, " +
                        "GROUP_CONCAT(" +
                        "CASE " +
                        "WHEN n.id_nivel = '' " +
                        "THEN 0 " +
                        "ELSE n.id_nivel " +
                        "END ) AS niveles, " +
                        "t.nti_nombre, " +
                        "t.id_niveltipo " +
                        "FROM usuarionivel u " +
                        "INNER JOIN nivel n ON n.id_nivel = u.id_nivel AND n.niv_hijos = '' " +
                        "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor " +
                    "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo "
                }
                else{
                    
                    nivelSql = "SELECT " +
                        "n.id_nivelvalor," +            //0
                        "v.nva_valorcorto, " +          //1
                        "GROUP_CONCAT(n.id_nivel) as niveles," +   //2
                        "n.id_nivel, " +
                        "t.id_niveltipo " +                 //3
                        "FROM nivel n " +
                        "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor AND v.id_niveltipo = '\(id_niveltipo)' " +
                    "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido = 1 "
                }
                
                if hijos != "" {
                    
                    nivelSql += "WHERE n.id_nivel IN ( \(niveles), \(hijos) ) "
                }
                else{
                    if(ultimoNivel){
                        nivelSql += "WHERE n.id_nivel IN (\(niveles)) "
                    }
                }
                nivelSql += "GROUP BY n.id_nivelvalor ORDER BY v.nva_valorcorto "
                
                let rows = try Row.fetchAll(db, nivelSql)
                
                if( rows.count == 0){
                    print("No existen registros")
                }
                else{
                    
                    if(ultimoNivel){
                        nivelPickerArray.append(PickerValor(id_nivelvalor: 0, nva_valorcorto: "-=SELECCIONE NIVEL=-", id_nivel: 0, niveles: "0", nti_nombre: "", id_niveltipo: 0))
                    }
                    
                    for row in rows{
                        
                        let id_nivelvalor: Int64 = row["id_nivelvalor"]
                        let nva_valorcorto: String = row["nva_valorcorto"]
                        let id_nivel: Int64 = row["id_nivel"]
                        let niveles: String = row["niveles"]
                        var nti_nombre: String = ""
                        let id_niveltipo: Int64 = row["id_niveltipo"]
                        if ultimoNivel {
                            nti_nombre = row["nti_nombre"]
                        }
                        
                        let valores = PickerValor(id_nivelvalor: id_nivelvalor, nva_valorcorto: nva_valorcorto, id_nivel: id_nivel, niveles: niveles, nti_nombre: nti_nombre, id_niveltipo: id_niveltipo)
                        
                        if !ultimoNivel {
                            pickerValores.append(valores)
                        }
                        else{
                            nivelPickerArray.append(valores)
                            nivelLabel.text = nti_nombre
                            nivelTextfield.text = "-=SELECCIONE NIVEL=-"
                        }
                    }
                }
            }
            
        }catch{
            print(error)
        }
        if ultimoNivel{
            return nivelPickerArray
        }
        else{
            return pickerValores
        }
        
    }//------------END FUNC HIJOSXNIVEL---------------

    
    // ---------------------- TRAE NIVELES REQUERIDOS POR USUARIO ---------------------
    
    func nivelesRequeridos() -> [PickerArray]{
        
        var niveles = [Niveltipo]()
        var pickers = [PickerArray]()
        let sql =  "SELECT t.id_niveltipo, t.nti_nombre, t.nti_orden, n.id_nivel FROM usuarionivel u INNER JOIN nivel n ON n.id_nivel = u.id_nivel INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido = 1 WHERE u.id_usuario = \(userID!) GROUP BY t.id_niveltipo ORDER BY t.nti_orden"
        do{
            try dbQueue.inDatabase { db in
                niveles = try Niveltipo.fetchAll(db, sql) // DEVUELVE UN ARRAY DE niveltipo
            }//--------O-----------
            
        }catch{
            print(error)
        }
        if(niveles.count == 0){
            print("No existen registros")
        }
        else{
            
            var i = 0
            
            for item in niveles{
                var picker:PickerArray
                
                picker = PickerArray(id_niveltipo: item.id_niveltipo!, tipo_nombre: item.nti_nombre!, pickerview: nil, field: nil, index: i, pickerArray: pickerArrays[i])
                pickers.append(picker)
                i += 1
            }
        }
        return pickers
        
    }//----------------------- o --------------------------------
    
    
    func getObjeto(id_nivel:Int64) -> [ObjetoValor]{
        
        var objetos = [ObjetoValor]()
        objetos.append(ObjetoValor(id_objeto: 0, obj_nombre: "-=SELECCIONE OBJETO=-"))
        
        let objSql = "SELECT id_objeto, obj_nombre FROM objeto WHERE id_nivel = \(id_nivel) ORDER BY obj_nombre";
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, objSql)
                if( rows.count == 0){
                    print("No existen registros de objetos")
                }
                else{
                    
                    for row in rows {

                        let id_objeto:Int64 = Int64("\(row["id_objeto"]!)")!
                        let obj_nombre = "\(row["obj_nombre"]!)"
                        
                        let objeto = ObjetoValor(id_objeto: id_objeto, obj_nombre: obj_nombre)
                        
                        objetos.append(objeto)
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
        return objetos
    }
    
    
    func getHallazgo() -> [HallazgoValor]{
        
        var hallazgos = [HallazgoValor]()
        
        let hallazgoSql = "SELECT id_tipohallazgo, tha_nombre FROM tipohallazgo ORDER BY tha_nombre";
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, hallazgoSql)
                if( rows.count == 0){
                    print("No existen registros de Hallazgos")
                }
                else{
                    for row in rows {

                        let id_tipohallazgo:Int64 = Int64("\(row["id_tipohallazgo"]!)")!
                        let tha_nombre = "\(row["tha_nombre"]!)"
                        
                        let hallazgo = HallazgoValor(id_tipohallazgo: id_tipohallazgo, tha_nombre: tha_nombre)
                        
                        hallazgos.append(hallazgo)
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
        return hallazgos
    }

    
    func llenarTiponivel(niv_ruta: String){
        
        let sql_nivel = "SELECT " +
            "n.id_nivel, " +
            "t.nti_nombre, " +
            "t.id_niveltipo, " +
            "v.id_nivelvalor, " +
            "v.nva_valorcorto " +
            "FROM nivel n " +
            "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor " +
            "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo " +
            "WHERE n.id_nivel IN (\(niv_ruta)) AND nti_requerido=1 " +
        "ORDER BY niv_posicion, nva_valor";
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, sql_nivel)
                if( rows.count == 0){
                    print("No existen Niveles")
                }
                else{
                    for row in rows {

                        let id_nivel:Int64 = Int64("\(row["id_nivel"]!)")!
                        let id_niveltipo:Int64 = Int64("\(row["id_niveltipo"]!)")!
                        let id_nivelvalor:Int64 = Int64("\(row["id_nivelvalor"]!)")!
                        let nti_nombre = "\(row["nti_nombre"]!)"
                        let nva_valorcorto = "\(row["nva_valorcorto"]!)"
                        
                        let tiponivel = Tiponivel(id_nivel: id_nivel, id_niveltipo: id_niveltipo, id_nivelvalor: id_nivelvalor, nti_nombre: nti_nombre, nva_valorcorto: nva_valorcorto)
                        
                        tiponiveles.append(tiponivel)
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
    }
    
    
    
    //--------------------------------- STRUCTS ------------------------------------//
    
    struct PickerArray {
        
        var id_niveltipo: Int64?
        var tipo_nombre: String?
        var pickerview: UIPickerView?
        var field: UITextField?
        var index: Int?
        var pickerArray:[PickerValor]
        
        init(id_niveltipo: Int64, tipo_nombre: String, pickerview:UIPickerView?, field:UITextField?, index:Int, pickerArray:[PickerValor]) {
            self.id_niveltipo = id_niveltipo
            self.tipo_nombre = tipo_nombre
            self.pickerview = pickerview
            self.field?.text = "Seleccionar"
            self.index = index
            self.pickerArray = pickerArray
            
        }
    }
    
    struct PickerValor {
        
        var id_nivelvalor: Int64?
        var nva_valorcorto: String?
        var id_nivel: Int64?
        var niveles: String?
        var nti_nombre: String?
        var id_niveltipo: Int64?
        
        init(id_nivelvalor: Int64, nva_valorcorto: String, id_nivel: Int64, niveles: String, nti_nombre: String, id_niveltipo: Int64) {
            self.id_nivelvalor = id_nivelvalor
            self.nva_valorcorto = nva_valorcorto
            self.id_nivel = id_nivel
            self.niveles = niveles
            self.nti_nombre = nti_nombre
            self.id_niveltipo = id_niveltipo
        }
    }
    
    struct ObjetoValor {
        
        var id_objeto: Int64?
        var obj_nombre: String?
        
        
        init(id_objeto: Int64, obj_nombre: String) {
            self.id_objeto = id_objeto
            self.obj_nombre = obj_nombre
            
        }
    }
    
    struct HallazgoValor {
        
        var id_tipohallazgo: Int64?
        var tha_nombre: String?
        
        
        init(id_tipohallazgo: Int64, tha_nombre: String) {
            self.id_tipohallazgo = id_tipohallazgo
            self.tha_nombre = tha_nombre
            
        }
    }
    struct Ejecucion: Codable {
        var act_latitud: String
        var act_longitud: String
        var act_radio: Double
    }
    
    struct Tiponivel {
        
        var id_nivel : Int64?
        var id_niveltipo : Int64?
        var id_nivelvalor : Int64?
        var nti_nombre : String?
        var nva_valorcorto: String?
        
        init(id_nivel: Int64, id_niveltipo: Int64, id_nivelvalor: Int64, nti_nombre : String, nva_valorcorto : String){
            
            self.id_nivel = id_nivel
            self.id_niveltipo = id_niveltipo
            self.id_nivelvalor = id_nivelvalor
            self.nti_nombre = nti_nombre
            self.nva_valorcorto = nva_valorcorto
        }
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
    //-------------------------------- END STRUCTS ---------------------------------------//

}
