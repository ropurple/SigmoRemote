//
//  ListaNoprogramadaViewController.swift
//  Sigmo
//
//  Created by macOS User on 01/06/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

class ListaNoprogramadaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    // Botones hidden para llamar al modal
    @IBOutlet weak var ejecutarBtn: UIButton!
    
    
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    var valoresListaActividades:[ListaActividadesViewController.ValorListaActividades] = []
    var is_searching = false
    var datosFiltrados:[ListaActividadesViewController.ValorListaActividades] = []
    
    // ----------- ViewDidLoad ---------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self

        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaNoprogramadaViewController.ejecutarAct(_:)), name:NSNotification.Name(rawValue: "ejecutarNp"), object: nil)
        
        // Postergar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaNoprogramadaViewController.postergarAct(_:)), name:NSNotification.Name(rawValue: "postergarNp"), object: nil)
        
        // Ver en proceso desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(ListaNoprogramadaViewController.verEnproceso(_:)), name:NSNotification.Name(rawValue: "verEnprocesoNp"), object: nil)
        
        
        let nibName = UINib(nibName: "ListaNoprogramadaTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ListaNoprogramadaCell")
        
        self.tableview.tableFooterView = UIView()
        //consultarDatos()
        
        
    }// ------- END ViewDidLoad ----------
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaNoprogramadaCell", for: indexPath) as! ListaNoprogramadaTableViewCell
        
        if (indexPath.item < valoresListaActividades.count){
            var ep = ""
            if(Int(valoresListaActividades[indexPath.item].ep!)! > 0){
                ep = "EP: \(valoresListaActividades[indexPath.item].ep!)"
            }
            
            print("INFO: ", valoresListaActividades[indexPath.item].info!)
            
            cell.actividadInit(nivel: valoresListaActividades[indexPath.item].nva_valor!, objeto: valoresListaActividades[indexPath.item].obj_nombre!, accion: valoresListaActividades[indexPath.item].prg_nombre!, fecha: "\(formatearFecha(fecha: valoresListaActividades[indexPath.item].fecha!))", info: "\(valoresListaActividades[indexPath.item].info!)", ep: ep )
            
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
    
        datosEjecucion = valoresListaActividades[indexPath.item]
        
    
        if(Int64(datosEjecucion.ep!)! > 0){
            UserDefaults.standard.set("true", forKey: "verEnprocesoNp")
        }
        else{
            UserDefaults.standard.set("false", forKey: "verEnprocesoNp")
        }
        performSegue(withIdentifier: "modalActividadNp", sender: nil)
    }
    
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func ejecutarAct(_ sender: NSNotification) {
        
       /* print("Llamando desde el modal")
        let accionTipo = datosEjecucion.id_acciontipo!
        
        if(accionTipo == "1"){ // Normal*/
            performSegue(withIdentifier: "ejecutarNormalNp", sender: sender)
        /*}
        if(accionTipo == "2"){ // Microfiltrado
            performSegue(withIdentifier: "ejecutarMicrofiltradoNp", sender: sender)
        }
        if(accionTipo == "3"){ // Vibracion
            performSegue(withIdentifier: "ejecutarVibracion2", sender: sender)
        }
        if(accionTipo == "4"){ // Molino
            performSegue(withIdentifier: "ejecutarMolino2", sender: sender)
        }*/
    }
    
    @IBAction func postergarAct(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "postergarNp", sender: sender)
    }
    
    @IBAction func verEnproceso(_ sender: NSNotification) {
        
        print("Llamando desde el modal")
        performSegue(withIdentifier: "verEnprocesoNp", sender: sender)
    }
    
    
    // --------------------- SEGUE -------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ejecutarNormalNp" {
            if let datosEjec = segue.destination as? EjecutarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        /*if segue.identifier == "ejecutarMicrofiltrado2" {
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
        }*/
        if segue.identifier == "postergarNp" {
            if let datosEjec = segue.destination as? PostergarViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
        if segue.identifier == "verEnprocesoNp" {
            if let datosEjec = segue.destination as? ListaEnprocesoViewController{
                datosEjec.datosEjecucion = datosEjecucion
            }
        }
    }
    
    // -------------------- END TABLEVIEW -------------------------
    
    
    // ------------------------- FUNCIONES ------------------------------
    // ------------------------------------------------------------------
    
    func consultarDatos() {
        
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        
        let listaActividadSql = "" +
            "SELECT " +
                "v.nva_valor," +        //0
                "o.obj_nombre," +       //1
                "a.id_actividad," +     //2
                "a.act_obs_np," +       //3
                "strftime('%d-%m-%Y',a.act_fec_asignada) as fecha, " +//4
                "t.nti_nombre," +       //5
                "COUNT(z.id_actividad) as ep, " +//6
                "o.id_objeto " +
            "FROM actividad a " +
                "INNER JOIN nivel n ON a.id_nivel = n.id_nivel " +
                "INNER JOIN nivelvalor v ON n.id_nivelvalor = v.id_nivelvalor " +
                "INNER JOIN niveltipo t ON v.id_niveltipo = t.id_niveltipo " +
                "LEFT JOIN objeto o ON a.id_objeto = o.id_objeto " +
                "LEFT JOIN actividad z ON z.id_actividadpadre = a.id_actividad " +
                "WHERE a.id_actividadestado=1 AND a.id_tipodocumento=6 AND a.id_nivel IN (\(niv_hijos)) " +
                "GROUP BY a.id_actividad " +
            "ORDER BY a.act_fec_asignada DESC"
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, listaActividadSql)
                if( rows.count == 0){
                    print("No existen registros Lista Actividades")
                }
                else{
                    
                    for row in rows {
                        let accion = "\(row["act_obs_np"] ?? "")"
                        let detalle = "\(row["fecha"] ?? "")"
                        let info = "NP, \(row["id_actividad"] ?? "")"
                        let fecha = stringToDate(fechaString: "\(row["fecha"]!)", hora: false, format: "dd-MM-yyyy" )
                        
                        let listaAct = ListaActividadesViewController.ValorListaActividades(nti_nombre: "\(row["nti_nombre"] ?? "")", nva_valor: "\(row["nva_valor"] ?? "")", id_objeto: "\(row["id_objeto"] ?? "0")", obj_nombre: "\(row["obj_nombre"] ?? "SIN OBJETO")", info: info, prg_nombre: accion, prg_detalle: detalle, fecha: fecha, acc_foto: "\(row["acc_foto"] ?? "")", acc_capacitacion: "\(row["acc_capacitacion"] ?? "")", acc_lubricante: "\(row["acc_lubricante"] ?? "")", id_prioridad: "\(row["id_prioridad"] ?? "")", id_actividad: "\(row["id_actividad"] ?? "")", id_acciontipo: "\(row["id_acciontipo"] ?? "")", ep: "\(row["ep"] ?? "")")
                        
                        
                        valoresListaActividades.append(listaAct)
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
        
    }// ----------------- END CONSULTAR DATOS ------------------
    
    
}
