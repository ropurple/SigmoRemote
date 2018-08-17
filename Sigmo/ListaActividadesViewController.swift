//
//  ListaActividadesViewController.swift
//  Sigmo
//
//  Created by macOS User on 02/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)

class ListaActividadesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    // Botones hidden para llamar al modal
    @IBOutlet weak var ejecutarBtn: UIButton!
    
    // Variables
    var datosEjecucion = ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    var valoresListaActividades:[ValorListaActividades] = []
    var listaActividades = ListaObjetosViewController.ValorListaObjetos(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", planificada: "", alta: "", media: "", baja: "", id_nivelvalor: "", fecha: Date())
    
    //--------- Main -----------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaActividadesViewController.ejecutarAct(_:)), name:NSNotification.Name(rawValue: "ejecutar"), object: nil)
        
        // Postergar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaActividadesViewController.postergarAct(_:)), name:NSNotification.Name(rawValue: "postergar"), object: nil)
        
        // Ver en proceso desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaActividadesViewController.verEnproceso(_:)), name:NSNotification.Name(rawValue: "verEnproceso"), object: nil)
        
        // Link capacitacion desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaActividadesViewController.capacitacionUrl(_:)), name:NSNotification.Name(rawValue: "capacitacion"), object: nil)
        
        
        fechaLabel.text = formatearFecha(fecha: listaActividades.fecha!, format: "EEEE dd/MM")
        nivelLabel.text = "\(listaActividades.nti_nombre!): \(listaActividades.nva_valor!)"
        objetoLabel.text = listaActividades.obj_nombre!
        
        
        let nibName = UINib(nibName: "ListaActividadesTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ListaActividadCell")
        
        self.tableview.tableFooterView = UIView()
        //consultarDatos()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        valoresListaActividades.removeAll()
        consultarDatos()
        tableview.reloadData()
        self.tabBarController?.tabBar.isHidden = false // No mostrar Tab Bar
    }
    
    // ------------------- TABLEVIEW FUNCTIONS -----------------------
    // ---------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  valoresListaActividades.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaActividadCell", for: indexPath) as! ListaActividadesTableViewCell
        
        if (indexPath.item < valoresListaActividades.count){
            var ep = ""
            if(Int(valoresListaActividades[indexPath.item].ep!)! > 0){
                ep = "EP: \(valoresListaActividades[indexPath.item].ep!)"
            }
            cell.actividadInit(accion: valoresListaActividades[indexPath.item].prg_nombre!, detalle: valoresListaActividades[indexPath.item].prg_detalle!, info: valoresListaActividades[indexPath.item].info!, ep: ep )
            
            print("ID_ACCIONTIPO: ",valoresListaActividades[indexPath.item].id_acciontipo!)
            // Para mantener el width centrado del separador
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        datosEjecucion = valoresListaActividades[indexPath.item]
        
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
        performSegue(withIdentifier: "modalActividad", sender: nil)
    }
    
    
    @IBAction func ejecutarAct(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        let accionTipo = datosEjecucion.id_acciontipo!

        if(accionTipo == "1"){ // Normal
            performSegue(withIdentifier: "ejecutarNormal", sender: sender)
        }
        if(accionTipo == "2"){ // Microfiltrado
            performSegue(withIdentifier: "ejecutarMicrofiltrado", sender: sender)
        }
        if(accionTipo == "3"){ // Vibracion
            performSegue(withIdentifier: "ejecutarVibracion", sender: sender)
        }
        if(accionTipo == "4"){ // Molino
            performSegue(withIdentifier: "ejecutarMolino", sender: sender)
        }
        if(accionTipo == "5"){ // Inventario
            performSegue(withIdentifier: "ejecutarInventario", sender: sender)
        }
    }
    
    @IBAction func postergarAct(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "postergar", sender: sender)
    }
    
    @IBAction func verEnproceso(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "verEnproceso", sender: sender)
    }
    
    @IBAction func capacitacionUrl(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        print("URL: ", datosEjecucion.acc_capacitacion!)
        UIApplication.shared.open(URL(string: "\(datosEjecucion.acc_capacitacion!)")!, options: [:], completionHandler: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ejecutarNormal" {

            if let datosEjec = segue.destination as? EjecutarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarMicrofiltrado" {
            if let datosEjec = segue.destination as? MicrofiltradoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarVibracion" {
            if let datosEjec = segue.destination as? VibracionViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarMolino" {
            if let datosEjec = segue.destination as? MolinoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "ejecutarInventario" {
            if let datosEjec = segue.destination as? InventarioViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "postergar" {
            if let datosEjec = segue.destination as? PostergarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "verEnproceso" {
            if let datosEjec = segue.destination as? ListaEnprocesoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
    }
    
    // -------------------- END TABLEVIEW -------------------------
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // ------------------------- FUNCIONES ------------------------------
    // ------------------------------------------------------------------
    
    func consultarDatos() {
        
        let fechaString = formatearFecha(fecha: listaActividades.fecha!, format: "YYYY-MM-dd")
        
        let listaActividadSql = "" +
            "SELECT " +
            "v.nva_valor," +        //0
            "o.obj_nombre," +
            "o.id_objeto," + //1
            "r.prg_nombre," +       //2
            "r.prg_detalle," +      //3
            "i.tdo_nombrecorto," +  //4
            "a.id_actividad," +     //5
            "p.pri_nombre," +       //6
            "c.id_acciontipo," +    //7
            "p.id_prioridad," +     //8
            "COUNT(z.id_actividad) as ep," +//9
            "c.acc_nombre," +         //10
            "c.acc_riesgo," +         //11
            "c.acc_control," +        //12
            "c.acc_capacitacion," +   //13
            "c.acc_lubricante," +     //14
            "c.acc_foto " +           //15
            "FROM usuariotipodoc u " + //AND a.id_nivel IN ("+niv_hijos+")
            "INNER JOIN actividad a ON u.id_nivel = a.id_nivel AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +
            "AND a.act_fec_asignada BETWEEN '\(fechaString) 00:00:00' AND '\(fechaString) 23:59:59' AND a.id_objeto='\(listaActividades.id_objeto!)' " +
            "INNER JOIN programadadetalle d ON a.id_programadadetalle = d.id_programadadetalle " +
            "INNER JOIN prioridad p ON d.id_prioridad = p.id_prioridad " +
            "INNER JOIN nivel n ON a.id_nivel = n.id_nivel " +
            "INNER JOIN nivelvalor v ON n.id_nivelvalor = v.id_nivelvalor AND v.id_nivelvalor='\(listaActividades.id_nivelvalor!)' " +
            "INNER JOIN objeto o ON a.id_objeto = o.id_objeto " +
            "INNER JOIN programada r ON d.id_programada = r.id_programada " +
            "INNER JOIN accion c ON c.id_accion = r.id_accion " +
            "INNER JOIN tipodocumento i ON i.id_tipodocumento = d.id_tipodocumento " +
            "LEFT JOIN actividad z ON z.id_actividadpadre = a.id_actividad " +
            "WHERE u.id_usuario='\(userID!)' " +
            "GROUP BY a.id_actividad " +
        "ORDER BY r.prg_orden"
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
                        let nti_nombre = listaActividades.nti_nombre ?? ""
                        let nva_valor = row["nva_valor"] ?? ""
                        let id_objeto = row["id_objeto"] ?? ""
                        let obj_nombre = row["obj_nombre"] ?? ""
                        let acc_foto = row["acc_foto"] ?? ""
                        let acc_capacitacion = row["acc_capacitacion"] ?? ""
                        let acc_lubricante = row["acc_lubricante"] ?? ""
                        let id_prioridad = row["id_prioridad"] ?? ""
                        let id_actividad = row["id_actividad"] ?? ""
                        let id_acciontipo = row["id_acciontipo"] ?? ""
                        let ep = row["ep"] ?? ""
                        
                        let listaAct = ValorListaActividades(nti_nombre: nti_nombre, nva_valor: "\(nva_valor)", id_objeto: "\(id_objeto)", obj_nombre: "\(obj_nombre)", info: info, prg_nombre: accion, prg_detalle: detalle, fecha: listaActividades.fecha!, acc_foto: "\(acc_foto)", acc_capacitacion: "\(acc_capacitacion)", acc_lubricante: "\(acc_lubricante)", id_prioridad: "\(id_prioridad)", id_actividad: "\(id_actividad)", id_acciontipo: "\(id_acciontipo)", ep: "\(ep)")
                        
                        valoresListaActividades.append(listaAct)
                    }
                }
                return .commit
            }
        }catch{
            print(error)
        }
    }// ----------------- END CONSULTAR DATOS ------------------
    
    // ------------------------ END FUNCIONES --------------------------------------
    
    
    struct ValorListaActividades {
        
        var nti_nombre: String?
        var nva_valor: String?
        var id_objeto: String?
        var obj_nombre: String?
        var info: String?
        var prg_nombre: String?
        var prg_detalle: String?
        var fecha: Date?
        var acc_foto: String?
        var acc_capacitacion: String?
        var acc_lubricante: String?
        var id_prioridad: String?
        var id_actividad: String?
        var id_acciontipo: String?
        var ep: String?
        
        
        init(nti_nombre: String, nva_valor: String, id_objeto: String, obj_nombre: String, info: String, prg_nombre: String, prg_detalle: String, fecha: Date, acc_foto: String, acc_capacitacion: String, acc_lubricante: String, id_prioridad: String, id_actividad: String, id_acciontipo: String, ep: String) {
            
            self.nti_nombre = nti_nombre
            self.nva_valor = nva_valor
            self.id_objeto = id_objeto
            self.obj_nombre = obj_nombre
            self.info = info
            self.prg_nombre = prg_nombre
            self.prg_detalle = prg_detalle
            self.fecha = fecha
            self.acc_foto = acc_foto
            self.acc_capacitacion = acc_capacitacion
            self.acc_lubricante = acc_lubricante
            self.id_prioridad = id_prioridad
            self.id_actividad = id_actividad
            self.id_acciontipo = id_acciontipo
            self.ep = ep
            
            
        }
    }
    
}

