//
//  BusquedaActividadViewController.swift
//  Sigmo
//
//  Created by macOS User on 24/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)
class BusquedaActividadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    

    @IBOutlet weak var tableview: UITableView!
    // Botones hidden para llamar al modal
    @IBOutlet weak var ejecutarBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectHeight: NSLayoutConstraint!
    
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    var valoresListaActividades:[ListaActividadesViewController.ValorListaActividades] = []
    var is_searching = false
    var datosFiltrados:[ListaActividadesViewController.ValorListaActividades] = []
    
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

    var eje_y:Double = 5
    let eje_x:Double = 120
    var id_nivel:String = ""
    var niv_hijos = ""
    var actCount = 0
    var willappearCount = 0
    
    // ----------- ViewDidLoad ---------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "OK"
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(BusquedaActividadViewController.ejecutarAct(_:)), name:NSNotification.Name(rawValue: "ejecutar2"), object: nil)
        
        // Postergar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(BusquedaActividadViewController.postergarAct(_:)), name:NSNotification.Name(rawValue: "postergar2"), object: nil)
        
        // Ver en proceso desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(BusquedaActividadViewController.verEnproceso(_:)), name:NSNotification.Name(rawValue: "verEnproceso2"), object: nil)
        
        // Link capacitacion desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(BusquedaActividadViewController.capacitacionUrl(_:)), name:NSNotification.Name(rawValue: "capacitacion2"), object: nil)
        
        
        let nibName = UINib(nibName: "BusquedaActividadTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "BusquedaActividadCell")
        
        self.tableview.tableFooterView = UIView()
        consultarDatos()
        actCount = valoresListaActividades.count
        
        
        
        
        
    }// ------- END ViewDidLoad ----------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        id_nivel = UserDefaults.standard.string(forKey: "id_nivel")!
        var nivelDistinto = UserDefaults.standard.integer(forKey: "nivel_distinto")
        let id_nivel_old = UserDefaults.standard.integer(forKey: "id_nivel_old")
        let id_nivel_count = UserDefaults.standard.integer(forKey: "id_nivel_count")
        
        if(Int(id_nivel) == id_nivel_old && id_nivel_count > 0){
            nivelDistinto = 0
        }
        
        if(nivelDistinto == 1 || willappearCount == 0){
            eje_y = 5
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
            selectView.subviews.forEach({ $0.removeFromSuperview() })
            
            let hijos = gethijos(id_nivel: Int(id_nivel)!)
            if(hijos != "" && actCount > 0){
                
                nivelesTipo = nivelesNoRequeridos(id_nivel: hijos)// Trae los niveles requeridos del User
                cantPicker = nivelesTipo.count
                
                var c = 1
                for ntipo in nivelesTipo{ // Recorre los niveles del usuario
                    if(cantPicker >= c){
                        
                        print("--- - - - NIVELTIPO: ", ntipo.tipo_nombre!)
                        if (c == 1){ // si es el primero, entonces crea y llena el pickerview
                            
                            generaTextField( posicion: ntipo.index!, text: ntipo.tipo_nombre!, ejey: eje_y, ejex: eje_x)
                            let hijos = hijosxNivel(id_niveltipo: ntipo.id_niveltipo!, id_nivel: Int64(id_nivel)!, niveles: id_nivel, primerPicker: true)
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
            }
            selectHeight.constant = CGFloat(eje_y)
            selectHeight.priority = UILayoutPriority(rawValue: 999)
            self.view.endEditing(true)
            
            valoresListaActividades.removeAll()
            consultarDatos()
            tableview.reloadData()
            
            willappearCount += 1
           UserDefaults.standard.set(1, forKey: "id_nivel_count")
        }
        self.tabBarController?.tabBar.isHidden = false // No mostrar Tab Bar
        
    }
    
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

    //--------------------- FUNCIONES NECESARIAS PARA EL PICKERVIEW ---------------------------
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let i = Int(pickerView.tag)
        
        nivelesTipo[i].field?.text = pickerArrays[i][row].nva_valorcorto
        
        
        if(i == 0 && row == 0){
            valoresListaActividades.removeAll()
            let hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
            
            for n in 0...cantPicker-1{
                if(cantPicker > 0 && i < (cantPicker - 1)){
                    limpiarPicker(cantidad: cantPicker, tag: n)
                }
            }

            consultarDatos(hijos: hijos)
            tableview.reloadData()
        }
        else{
            if(cantPicker > 0 && i < (cantPicker - 1)){
                
                limpiarPicker(cantidad: cantPicker, tag: i)
                let hijos = hijosxNivel(id_niveltipo: nivelesTipo[i+1].id_niveltipo!, id_nivel: pickerArrays[i][row].id_nivel!, niveles: pickerArrays[i][row].niveles!)
                if(hijos.count > 0){
                    llenarPicker(tiponivel: nivelesTipo[i+1].id_niveltipo!, pickerview: pickerViews[i+1], hijos: hijos, field: nivelesTipo[i+1].field!)
                    
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
                print("ULTIMO FILTRO")
                niv_hijos = "\(pickerArrays[i][row].id_nivel!)"
            }
            valoresListaActividades.removeAll()
            consultarDatos(hijos: niv_hijos)
            tableview.reloadData()
        }
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
    
    
    // ------------------- TABLEVIEW FUNCTIONS -----------------------
    // ---------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if is_searching{
            tituloLabel.text = "Buscador de Actividades (\(datosFiltrados.count))"
            return datosFiltrados.count
            
        }
        else{
            tituloLabel.text = "Buscador de Actividades (\(valoresListaActividades.count))"
            return valoresListaActividades.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusquedaActividadCell", for: indexPath) as! BusquedaActividadTableViewCell
        
        if (indexPath.item < valoresListaActividades.count){
            var ep = ""
            if(Int(valoresListaActividades[indexPath.item].ep!)! > 0){
                ep = "EP: \(valoresListaActividades[indexPath.item].ep!)"
            }
            
            if is_searching{
                ep = ""
                if(Int(datosFiltrados[indexPath.item].ep!)! > 0){
                    ep = "EP: \(datosFiltrados[indexPath.item].ep!)"
                }
                cell.actividadInit(tipoNivel: datosFiltrados[indexPath.item].nti_nombre!, nivel: datosFiltrados[indexPath.item].nva_valor!, objeto: datosFiltrados[indexPath.item].obj_nombre!, accion: datosFiltrados[indexPath.item].prg_nombre!, detalle: datosFiltrados[indexPath.item].prg_detalle!, info: "\(datosFiltrados[indexPath.item].info!), \(formatearFecha(fecha: datosFiltrados[indexPath.item].fecha!))", ep: ep )
            }
            else{
                cell.actividadInit(tipoNivel: valoresListaActividades[indexPath.item].nti_nombre!, nivel: valoresListaActividades[indexPath.item].nva_valor!, objeto: valoresListaActividades[indexPath.item].obj_nombre!, accion: valoresListaActividades[indexPath.item].prg_nombre!, detalle: valoresListaActividades[indexPath.item].prg_detalle!, info: "\(valoresListaActividades[indexPath.item].info!), \(formatearFecha(fecha: valoresListaActividades[indexPath.item].fecha!))", ep: ep )
            }
            
            //print("ID_ACCIONTIPO: ",valoresListaActividades[indexPath.item].id_acciontipo!)
            
            // Para mantener el width centrado del separador
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if is_searching {
            datosEjecucion = datosFiltrados[indexPath.item]
        }
        else{
            datosEjecucion = valoresListaActividades[indexPath.item]
        }
        
        if(datosEjecucion.acc_capacitacion! != ""){
            
            UserDefaults.standard.set("true", forKey: "acc_capacitacion")
            
        }
        else{
            UserDefaults.standard.set("false", forKey: "acc_capacitacion")
        }
        if(Int64(datosEjecucion.ep!)! > 0){
            UserDefaults.standard.set("true", forKey: "verEnproceso")
        }
        else{
            UserDefaults.standard.set("false", forKey: "verEnproceso")
        }
        performSegue(withIdentifier: "modalActividad2", sender: nil)
    }
    
    // ------------------ SEARCHBAR --------------------------
    //--------------------------------------------------------
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("SERACHBAR TEXT: ",searchBar.text!)
        //searchBar.showsCancelButton = true
        if searchBar.text == nil || searchBar.text == "" {
            
            is_searching = false
            view.endEditing(true)
            tableview.reloadData()
        }
        else{
            is_searching = true
            datosFiltrados = valoresListaActividades.filter({(
                ($0.prg_nombre?.uppercased().contains(searchBar.text!.uppercased()))! ||
                    ($0.id_actividad?.uppercased().contains(searchBar.text!.uppercased()))! ||
                    ($0.nva_valor?.uppercased().contains(searchBar.text!.uppercased()))! ||
                    ($0.obj_nombre?.uppercased().contains(searchBar.text!.uppercased()))! ||
                    ($0.info?.uppercased().contains(searchBar.text!.uppercased()))! ||
                    ($0.prg_detalle?.uppercased().contains(searchBar.text!.uppercased()))!
                
                )})
            tableview.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        if(datosFiltrados.count == 0){
            searchBar.text = ""
            self.searchBar(searchBar, textDidChange: "")
        }
        // Hide the cancel button
        //searchBar.showsCancelButton = false
        /*if(datosFiltrados.count == 0){
            self.searchBar(searchBar, textDidChange: "")
        }*/
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }// --------- END SEARCHBAR --------------
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func ejecutarAct(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        let accionTipo = datosEjecucion.id_acciontipo!
        
        if(accionTipo == "1"){ // Normal
            performSegue(withIdentifier: "ejecutarNormal2", sender: sender)
        }
        if(accionTipo == "2"){ // Microfiltrado
            performSegue(withIdentifier: "ejecutarMicrofiltrado2", sender: sender)
        }
        if(accionTipo == "3"){ // Vibracion
            performSegue(withIdentifier: "ejecutarVibracion2", sender: sender)
        }
        if(accionTipo == "4"){ // Molino
            performSegue(withIdentifier: "ejecutarMolino2", sender: sender)
        }
        if(accionTipo == "5"){ // Inventario
            performSegue(withIdentifier: "ejecutarInventario2", sender: sender)
        }
    }
    
    @IBAction func postergarAct(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "postergar2", sender: sender)
    }
    
    @IBAction func verEnproceso(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "verEnproceso2", sender: sender)
    }
    
    @IBAction func capacitacionUrl(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        print("URL: ", datosEjecucion.acc_capacitacion!)
        UIApplication.shared.open(URL(string: "\(datosEjecucion.acc_capacitacion!)")!, options: [:], completionHandler: nil)
    }
    
   // --------------------- SEGUE -------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ejecutarNormal2" {
            if let datosEjec = segue.destination as? EjecutarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarMicrofiltrado2" {
            if let datosEjec = segue.destination as? MicrofiltradoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarVibracion2" {
            if let datosEjec = segue.destination as? VibracionViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarMolino2" {
            if let datosEjec = segue.destination as? MolinoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarInventario2" {
            if let datosEjec = segue.destination as? InventarioViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "postergar2" {
            if let datosEjec = segue.destination as? PostergarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "verEnproceso2" {
            if let datosEjec = segue.destination as? ListaEnprocesoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
    }
    
    // -------------------- END TABLEVIEW -------------------------
    
    
    // ------------------------- FUNCIONES ------------------------------
    // ------------------------------------------------------------------
    
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


    
    func consultarDatos(hijos:String = "") {
        
        var niv_hijos = hijos
        
        if(niv_hijos == ""){
            niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        }
        
        print("NIv_HIJOS: ", niv_hijos)
        
        let listaActividadSql = "" +
            "SELECT " +
            "v.nva_valorcorto," +   //0
            "o.obj_nombre," +       //1
            "r.prg_nombre," +       //2
            "r.prg_detalle," +      //3
            "i.tdo_nombrecorto," +  //4
            "a.id_actividad," +     //5
            "p.pri_nombre," +       //6
            "c.id_acciontipo," +    //7
            "p.id_prioridad," +     //8
            "COUNT(z.id_actividad) as ep," + //9
            "strftime('%d-%m-%Y', datetime(a.act_fec_asignada)) as fecha," + //10
            "c.acc_nombre," +         //11
            "c.acc_riesgo," +         //12
            "c.acc_control," +        //13
            "c.acc_capacitacion," +   //14
            "c.acc_lubricante," +     //15
            "c.acc_foto, " +            //16
            "t.nti_nombre, " +           //17
            "o.id_objeto " +
            "FROM usuariotipodoc u " +
            "INNER JOIN actividad a ON u.id_nivel = a.id_nivel AND a.id_nivel IN (\(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +
            "INNER JOIN programadadetalle d ON a.id_programadadetalle = d.id_programadadetalle " +
            "INNER JOIN prioridad p ON d.id_prioridad = p.id_prioridad " +
            "INNER JOIN nivel n ON a.id_nivel = n.id_nivel " +
            "INNER JOIN nivelvalor v ON n.id_nivelvalor = v.id_nivelvalor " +
            "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo " +
            "INNER JOIN objeto o ON a.id_objeto = o.id_objeto " +
            "INNER JOIN programada r ON d.id_programada = r.id_programada " +
            "INNER JOIN accion c ON c.id_accion = r.id_accion " +
            "INNER JOIN tipodocumento i ON i.id_tipodocumento = d.id_tipodocumento " +
            "LEFT JOIN actividad z ON z.id_actividadpadre = a.id_actividad " +
            "WHERE u.id_usuario = \(userID!) " +
            "GROUP BY a.id_actividad " +
            "ORDER BY r.prg_orden"
        
        print("BuscadorSQL: ", listaActividadSql)
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, listaActividadSql)
                if( rows.count == 0){
                    print("No existen registros Lista Actividades")
                }
                else{
                    
                    for row in rows {
                        let accion = "\(row["prg_nombre"] ?? "")"
                        let detalle = "\(row["prg_detalle"] ?? "")"
                        let info = "\(row["tdo_nombrecorto"] ?? "") \(row["id_actividad"] ?? ""), \(row["pri_nombre"] ?? "")"
                        let fecha = stringToDate(fechaString: "\(row["fecha"]!)", hora: false, format: "dd-MM-yyyy" )
                       
                        let listaAct = ListaActividadesViewController.ValorListaActividades(nti_nombre: "\(row["nti_nombre"] ?? "")", nva_valor: "\(row["nva_valorcorto"] ?? "")", id_objeto: "\(row["id_objeto"] ?? "")", obj_nombre: "\(row["obj_nombre"] ?? "")", info: info, prg_nombre: accion, prg_detalle: detalle, fecha: fecha, acc_foto: "\(row["acc_foto"] ?? "")", acc_capacitacion: "\(row["acc_capacitacion"] ?? "")", acc_lubricante: "\(row["acc_lubricante"] ?? "")", id_prioridad: "\(row["id_prioridad"] ?? "")", id_actividad: "\(row["id_actividad"] ?? "")", id_acciontipo: "\(row["id_acciontipo"] ?? "")", ep: "\(row["ep"] ?? "")")
                        
                        
                        valoresListaActividades.append(listaAct)
                    }
                }
                return .commit
            }
            
        }catch{
            print("Busqueda Act ERROR: ", error)
        }
        
    }// ----------------- END CONSULTAR DATOS ------------------
    
    func nivelesNoRequeridos(id_nivel:String = "") -> [PickerArray]{
        
        var niveles = [Niveltipo]()
        var pickers = [PickerArray]()
        let sql =  "SELECT t.id_niveltipo, t.nti_nombre, t.nti_orden, n.id_nivel " +
                   "FROM usuarionivel u " +
                   "INNER JOIN nivel n ON n.id_nivel = u.id_nivel " +
                   "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor " +
                   "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido = 0 " +
                   "WHERE u.id_usuario = \(userID!) AND n.id_nivel IN (\(id_nivel)) GROUP BY t.id_niveltipo ORDER BY t.nti_orden"
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
                print("ITEM: ", item)
                var picker:PickerArray
                
                picker = PickerArray(id_niveltipo: item.id_niveltipo!, tipo_nombre: item.nti_nombre!, pickerview: nil, field: nil, index: i, pickerArray: pickerArrays[i])
                pickers.append(picker)
                i += 1
                //print("ID_ntipo: \(item.id_niveltipo!) nti_nombre: \(item.nti_nombre!) \n")
            }
        }
        return pickers
        
    }//----------------------- o --------------------------------
    
    func gethijos(id_nivel:Int) -> String{
        
        var hijos: String = ""
        
        do{
            try dbQueue.inDatabase { db in
                
                // CONSULTA POR LOS HIJOS EN UN STRING POR COMAS
                if id_nivel > 0 {
                    let hijosSql = "SELECT niv_hijos, id_nivel FROM nivel WHERE id_nivel IN ( \(id_nivel) )"
                    print("hijosSQL: ", hijosSql)
                    
                    let rowHijos = try Row.fetchAll(db, hijosSql)
                    
                    print("RowHijos: ", rowHijos)
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
                
            }
        }catch{
        print(error)
        }
        
        return hijos
        
    }//------------END FUNC HIJOSXNIVEL---------------
    // --------------------BUSCA LOS HIJOS POR NIVEL----------------------------
    
    func hijosxNivel(id_niveltipo: Int64, id_nivel: Int64 = 0, niveles:String, primerPicker:Bool = false) -> [PickerValor]{
        
        
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
                    
                    niv_hijos = hijos
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
                    "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo AND nti_requerido=0 " +
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
                    
                    if(primerPicker){
                        let seleccionar = PickerValor(id_nivelvalor: 0, nva_valorcorto: "-=TODOS=-", id_nivel: 0, niveles: "", niv_ruta: "")
                        pickerValores.append(seleccionar)
                    }
                    
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
    
}//----CLASS------
