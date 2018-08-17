//
//  PruebaViewController.swift
//  Sigmo
//
//  Created by macOS User on 15/01/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)

class NivelViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //let usuId = "\(userID!)"
    @IBOutlet weak var btnSync: UIButton!
    @IBOutlet weak var btnSgte: UIButton!
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectHeight: NSLayoutConstraint!
    
    // VARIABLES PARA PICKERVIEWS
    var pickerViews:[UIPickerView] = []
    var picker1 = UIPickerView()
    var picker2 = UIPickerView()
    var picker3 = UIPickerView()
    var picker4 = UIPickerView()
    var picker5 = UIPickerView()
    var picker6 = UIPickerView()
    
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
    //var selected:[(id_nivel: Int64, id_nivelvalor: Int64, nva_nombre: String)] = [] // Valores seleccionados
    
    
    // ARRAYS PARA MOSTRAR EN PICKERVIEW
    
    var pickerArrays:[[PickerValor]] = []// ARRAY QUE CONTIENE LOS ARRAYS PARA EL PICKERVIEW
    var picker1Array:[PickerValor] = []
    var picker2Array:[PickerValor] = []
    var picker3Array:[PickerValor] = []
    var picker4Array:[PickerValor] = []
    var picker5Array:[PickerValor] = []
    var picker6Array:[PickerValor] = []
    
    var ultimoNivel = PickerValor(id_nivelvalor: 0, nva_valorcorto: "", id_nivel: 0, niveles: "", niv_ruta: "")
    
    var eje_y:Double = 20
    let eje_x:Double = 120
    var id_nivel_old = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() // Ocultar teclado al tocar afuera
        imgBarRight(vc: self)
        
        loading.frame = loadingView.bounds
        if(modoOffline == true){
            showToast(message: "INGRESO MODO OFFLINE")
        }
        // Esconde los Botones submit del formulario
        btnSync.isHidden = true
        btnSgte.isHidden = true
        btnView.isHidden = true
        
        // ------- LLENADO DE ARRAYS -------------
        pickerViews.append(picker1);pickerViews.append(picker2);pickerViews.append(picker3);pickerViews.append(picker4);pickerViews.append(picker5);pickerViews.append(picker6)
    pickerArrays.append(picker1Array);pickerArrays.append(picker2Array);pickerArrays.append(picker3Array);pickerArrays.append(picker4Array);pickerArrays.append(picker5Array);pickerArrays.append(picker6Array)
        fields.append(field1);fields.append(field2);fields.append(field3);fields.append(field4);fields.append(field5);fields.append(field6)
        labels.append(label1);labels.append(label2);labels.append(label3);labels.append(label4);labels.append(label5);labels.append(label6)
        //----------------o------------------
        
        nivelesTipo = nivelesRequeridos()// Trae los niveles requeridos del User
        cantPicker = nivelesTipo.count
        
        var c = 1
        for ntipo in nivelesTipo{ // Recorre los niveles del usuario
            if(cantPicker >= c){
                
                if (c == 1){ // si es el primero, entonces crea y llena el pickerview
                    
                    generaTextField( posicion: ntipo.index!, text: ntipo.tipo_nombre!, ejey: eje_y, ejex: eje_x)
                    let hijos = hijosxNivel(id_niveltipo: ntipo.id_niveltipo!, niveles: "")
                    llenarPicker(tiponivel: ntipo.id_niveltipo!, pickerview: pickerViews[0], hijos: hijos, field: nivelesTipo[0].field!)
                    
                    eje_y+=50
                    c+=1
                }
                else {

                    generaTextField( posicion: ntipo.index!, text: ntipo.tipo_nombre!, ejey: eje_y, ejex: eje_x)

                    eje_y+=50
                    c+=1
                }
            }
        }
        selectHeight.constant = CGFloat(eje_y)
        selectHeight.priority = UILayoutPriority(rawValue: 999)
        self.view.endEditing(true)
    
    }//----------END ViewDidLoad()--------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        self.tabBarController?.tabBar.isHidden = true // No mostrar Tab Bar
        id_nivel_old = UserDefaults.standard.integer(forKey: "id_nivel")
    }
    
    
//--------------------- FUNCIONES NECESARIAS PARA EL PICKERVIEW ---------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let i = Int(pickerView.tag)
        
        nivelesTipo[i].field?.text = pickerArrays[i][row].nva_valorcorto
        
        if(cantPicker > 0 && i < (cantPicker - 1)){
            
            limpiarPicker(cantidad: cantPicker, tag: i)
            let hijos = hijosxNivel(id_niveltipo: nivelesTipo[i+1].id_niveltipo!, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!)
            if(hijos.count > 0){
                llenarPicker(tiponivel: nivelesTipo[i+1].id_niveltipo!, pickerview: pickerViews[i+1], hijos: hijos, field: nivelesTipo[i+1].field!)
                btnSgte.isHidden = true
                btnSync.isHidden = true
                btnView.isHidden = true
                
                if (hijos.count == 1){ // Para seleccion automàtica cuando es 1 --- probar
                    pickerViews[i+1].selectRow(1, inComponent: 0, animated: true)
                    nivelesTipo[i+1].field?.text = pickerArrays[i+1][0].nva_valorcorto
                    //nivelesTipo[i+2].field?.isUserInteractionEnabled = true
                    self.pickerView(self.pickerViews[i+1], didSelectRow: 0, inComponent: 0) // Llama al pickerview siguiente recursivo
                    //print("Tiene 1 sola opciòn")
                }
            }
        }
            
        else{
            // MOstrar botones
            ultimoNivel = PickerValor(id_nivelvalor: pickerArrays[i][row].id_nivelvalor!, nva_valorcorto: pickerArrays[i][row].nva_valorcorto!, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!, niv_ruta: pickerArrays[i][row].niv_ruta!)
            
        // Reconoce si hay un cambio de niveles con el mismo usuario
            
            print("\n id_nivel_old: ", id_nivel_old)
            print("id_nivel now: ", pickerArrays[i][row].id_nivel!, "\n")
            
            if (id_nivel_old > 0 && id_nivel_old != pickerArrays[i][row].id_nivel!){
                UserDefaults.standard.set(1, forKey: "nivel_distinto")
            }
            else{
                UserDefaults.standard.set(0, forKey: "nivel_distinto")
            }
            UserDefaults.standard.set(pickerArrays[i][row].id_nivel!, forKey: "id_nivel_old")
            UserDefaults.standard.set(0, forKey: "id_nivel_count")
            //------ 0 -----------
            
            UserDefaults.standard.set(pickerArrays[i][row].id_nivel!, forKey: "id_nivel") // variable global
            UserDefaults.standard.set(pickerArrays[i][row].niv_ruta!, forKey: "niv_ruta")
            btnSgte.isHidden = false
            btnSync.isHidden = false
            btnView.isHidden = false
        }

        //self.view.endEditing(true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerArrays[pickerView.tag][row].nva_valorcorto
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{        
    
        return pickerArrays[pickerView.tag].count
        
    }
//---------- END FUNCIONES PICKERVIEW --------------------
    
    
// --------------- GENERA LOS TEXTFIELDS PARA CADA PICKER ---------------------------
    
    func generaTextField(posicion: Int, text: String,  ejey: Double, ejex: Double)  {
        
        let index = Int(posicion)
        labels[index] = UILabel(frame: CGRect(x: ejex-110, y: ejey, width: 110.00, height: 30.00))
        labels[index].text = text
        labels[index].font = UIFont.boldSystemFont(ofSize: 12.0)
        labels[index].autoresizingMask = [.flexibleLeftMargin]
        selectView.addSubview(labels[index])
        
        fields[index] = UITextField(frame: CGRect(x: ejex, y: ejey, width: 240.00, height: 30.00));
        
        // Or you can position UITextField in the center of the view //nombreField.center = self.view.center
        // Set UITextField placeholder text
        fields[index].placeholder = "-=SELECCIONE \(text)=-"
        // Set text to UItextField
        // Set UITextField border style
        fields[index].borderStyle = UITextBorderStyle.roundedRect
        fields[index].font = fields[index].font?.withSize(12)
        fields[index].autoresizingMask = [.flexibleWidth]
        fields[index].autoresizingMask = [.flexibleRightMargin]

        if(index > 0){ //Permite usar el primer picker solamente
            fields[index].isUserInteractionEnabled = false
        }
        
        // Set UITextField background colour //myTextField.backgroundColor = UIColor.white // Set UITextField text color //myTextField.textColor = UIColor.blue
        selectView.addSubview(fields[index])
        if(cantPicker > 1 ){
            let i = nivelesTipo.index(where: {$0.index == posicion})!
            //print("entra al field 1 Del: \(i)")
            nivelesTipo[i].field = fields[index]
            nivelesTipo[i].pickerview = pickerViews[i]
            
            pickerViews[i].delegate = self
            pickerViews[i].tag = i
            fields[index].inputView = pickerViews[i]
        }
        
    }//------------------------ o -------------------------------
    
    
// --------------------BUSCA LOS HIJOS POR NIVEL----------------------------
    
    func hijosxNivel(id_niveltipo: Int64, id_nivel: Int64 = 0, niveles:String) -> [PickerValor]{
        
        
        var pickerValores = [PickerValor]()
        
        var hijos: String = ""
        
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
                    
                    
                    print("\n\nHIJOS: \(hijos)")
                        
                }//------------HIJOS---------------------
                
                var nivelSql = "SELECT " +
                                    "n.id_nivelvalor," +            //0
                                    "v.nva_valorcorto, " +          //1
                                    "GROUP_CONCAT(n.id_nivel) as niveles, " +   //2
                                    "n.id_nivel, " +
                                    "n.niv_ruta " +
                                "FROM usuarionivel u " +
                                "INNER JOIN nivel n ON n.id_nivel = u.id_nivel  " +
                                "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor AND v.id_niveltipo = \(id_niveltipo) " +
                                "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido=1 " +
                                "WHERE u.id_usuario = \(userID!) "
                
                if hijos != "" {
                    nivelSql += "AND n.id_nivel IN ( \(hijos) ) "
                }
                nivelSql += "GROUP BY n.id_nivelvalor ORDER BY v.nva_valorcorto "
                print("\n\nCONSULTA NIVEL ( \(id_nivel) ): ", nivelSql)
                
                let rows = try Row.fetchAll(db, nivelSql)
                
                if( rows.count == 0){
                    print("No existen registros")
                }
                else{
                    
                    for row in rows{
                        //print("NIVELVALOR: \(row["id_nivelvalor"]!)")
                        
                        let id_nivelvalor: Int64 = row["id_nivelvalor"]
                        let nva_valorcorto: String = row["nva_valorcorto"]
                        let id_nivel: Int64 = row["id_nivel"]
                        let niveles: String = row["niveles"]
                        let niv_ruta: String = row["niv_ruta"]
                        
                        let valores = PickerValor(id_nivelvalor: id_nivelvalor, nva_valorcorto: nva_valorcorto, id_nivel: id_nivel, niveles: niveles, niv_ruta: niv_ruta)
                        pickerValores.append(valores)
                        
                        //print("id_nivel: \(id_nivel) id_valor: \(id_nivelvalor) nva_valor: \(nva_valorcorto) \n")
                        
                    }
                }
            }
            
        }catch{
            print(error)
        }
        
        return pickerValores
        
    }//------------END FUNC HIJOSXNIVEL---------------
    
    
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
    
    
// ------------------- LIMPIAR PICKER ----------------------
    
    func limpiarPicker(cantidad: Int, tag: Int){
        
        
        for i in (tag+1)..<cantidad  {
            nivelesTipo[i].field?.text = ""
            nivelesTipo[i].field?.isUserInteractionEnabled = false
            //print("i: \(i) - Picker: \(tag)  - Total: \(cantidad)")
        }
    }//---------------------o------------------------------
    
    
// ---------------------- TRAE NIVELES REQUERIDOS POR USUARIO ---------------------
    
    func nivelesRequeridos() -> [PickerArray]{
        
        var niveles = [Niveltipo]()
        var pickers = [PickerArray]()
        let sql =  "SELECT t.id_niveltipo, t.nti_nombre, t.nti_orden, n.id_nivel FROM usuarionivel u INNER JOIN nivel n ON n.id_nivel = u.id_nivel INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido = 1 WHERE u.id_usuario = \(userID!) GROUP BY t.id_niveltipo ORDER BY t.nti_orden"
        do{
            try dbQueue.inDatabase { db in
                niveles = try Niveltipo.fetchAll(db, sql) // DEVUELVE UN ARRAY DE niveltipo
            }//--------O-----------
            print(sql)
            
        }catch{
            print(error)
        }
        if(niveles.count == 0){
            print("No existen registros")
        }
        else{
            //let field0 = UITextField(frame: CGRect(x: 0, y: 0, width: 230.00, height: 30.00));
            //let picker0 = UIPickerView()
            var i = 0
            for item in niveles{
                var picker:PickerArray
            
                picker = PickerArray(id_niveltipo: item.id_niveltipo!, tipo_nombre: item.nti_nombre!, pickerview: nil, field: nil, index: i, pickerArray: pickerArrays[i])
                pickers.append(picker)
                i += 1
                //print("ID_ntipo: \(item.id_niveltipo!) nti_nombre: \(item.nti_nombre!) \n")
            }
        }
        return pickers
        
    }//----------------------- o --------------------------------
    
    
//--------------------------------- STRUCTS ------------------------------------//
    
    struct PickerArray {
        
        var id_niveltipo: Int64?
        var tipo_nombre: String?
        //var id_nivel: Int64?
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
        var niv_ruta: String?
        
        init(id_nivelvalor: Int64, nva_valorcorto: String, id_nivel: Int64, niveles: String, niv_ruta: String) {
            self.id_nivelvalor = id_nivelvalor
            self.nva_valorcorto = nva_valorcorto
            self.id_nivel = id_nivel
            self.niveles = niveles
            self.niv_ruta = niv_ruta
        }
    }
    //-------------------------------- END STRUCTS ---------------------------------------//
    
    @IBAction func sincronizar(_ sender: Any) {
        sync{ (success) -> () in
            if success {
                print("Sincronizado por btn")
            }
            else{
                print("No sincronizado por btn")
            }
        }
    }
        
    @IBAction func irSgte(_ sender: Any) {
    
    //print("Apriete de Btn")
        
        let alert = UIAlertController(title: "Permisos de Usuario", message: "¿Desea sincronizar permisos de usuario antes de ingresar?", preferredStyle: .alert)
        for i in ["INGRESAR OFFLINE", "SYNC E INGRESAR"] {
            alert.addAction(UIAlertAction(title: i, style: .default, handler: self.ingresar))
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: self.ingresar))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verCalendario" {
            if let calendario = segue.destination as? CalendarioViewController {
                calendario.ultimoNivel = ultimoNivel
            }
        }
    }
    
    func ingresar(alert: UIAlertAction){
        print("ENTRA A lA FUNCION")
        if(alert.title == "INGRESAR OFFLINE"){
            performSegue(withIdentifier: "verCalendario", sender: nil)
        }
        else if(alert.title == "SYNC E INGRESAR"){
            
            sync{ (success) -> () in
                if success {
                    
                    DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "verCalendario", sender: nil)
                    })
                }
            }
        }
    
    }//----------------------- END Ingresar -------------------------------//
    
    func sync(completion: @escaping (Bool) -> Void){
        
        if(Internet.isConnectedToNetwork()){
            
            // Subir actividades pendientes si existen
            subirActividadesPendientes{ (success, estado) -> () in
                if success {
                    print("ACTIVIDADES PENDIENTES EJECUTADA")
                }
            }
            bloquearCampos()
            
            loading.startAnimating()
            self.syncLabel!.text = "SINCRONIZANDO ACTIVIDADES..."
            //try! crearTablas(num: 3) // Elimina tablas sync 3
            Request<Actividad>.postRequest(id_nivel: ultimoNivel.id_nivel!, fecha: true, item: { item in
            }, success: { success, message in
                print("Sync Actividad", success)
                
                // Aqui realizar la sync con inventario con la fecha guardada en user defaults
                //-------------------------0--------------------------------
                
                let actFecha = UserDefaults.standard.string(forKey: "actFechaSync")
                
                getInventario(fec_app: actFecha!, id_nivel: "\(self.ultimoNivel.id_nivel!)", success: { success, state, msge in
                    if success{
                        print("Success: \(success) State: \(state)")
                    }
                    else{
                        print("ERROR: ", msge)
                    }
                
                    Request<Objeto>.postRequest(id_nivel: self.ultimoNivel.id_nivel!, fecha: true, item: { item in
                    }, success: { success, message in
                        print("SYNC Objeto ", success)
                        
                        Request<Programada>.postRequest(id_nivel: self.ultimoNivel.id_nivel!, fecha: true, item: { item in
                        }, success: { success, message in
                            print("SYNC Programada ", success)
                            
                            Request<Programadadetalle>.postRequest(id_nivel: self.ultimoNivel.id_nivel!, fecha: true, item: { item in
                            }, success: { success, message in
                                print("SYNC Programadadetalle ", success)
                                
                                Request<Programadaproducto>.postRequest(id_nivel:self.ultimoNivel.id_nivel!, fecha: true, item: { item in
                                }, success: { success, message in
                                    print("SYNC Programadaproducto ", success)
                                    
                                    Request<Nivelvalorobs>.postRequest(id_nivel:self.ultimoNivel.id_nivel!, fecha: true, item: { item in
                                    }, success: { success, message in
                                        print("SYNC Nivelvalorobs ", success)
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.desbloquearCampos()
                                            self.loading.stopAnimating()
                                            self.syncLabel!.text = "SYNC "+traerFechaSync(tabla: "actividad")
                                            completion(true)
                                        })
                                        //self.syncLabel!.text = "SYNC Nivel OK!..."
                                    })
                                })
                            })
                        })
                    })
                })
            })
        }
        else{ // sin internet
            showToast(message: "CONECTAR A INTERNET PARA SINCRONIZAR", bottom: 175)
            completion(false)
        }
    }
    func bloquearCampos(){

        self.btnSgte.isUserInteractionEnabled = false
        self.btnSync.isUserInteractionEnabled = false
        self.btnSgte.alpha = CGFloat(0.5)
        self.btnSync.alpha = CGFloat(0.5)
    }
    
    func desbloquearCampos(){
        
        self.btnSgte.isUserInteractionEnabled = true
        self.btnSync.isUserInteractionEnabled = true
        self.btnSgte.alpha = CGFloat(1)
        self.btnSync.alpha = CGFloat(1)
    }

    
}// ---- END CLASS ------

