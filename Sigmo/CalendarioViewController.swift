//
//  CollectionViewController.swift
//  Sigmo
//
//  Created by macOS User on 26/12/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

private let reuseIdentifier = "Cell"
let fecha = DateFormatter()

@available(iOS 11.0, *)
class CalendarioViewController: UICollectionViewController {
    
    @IBOutlet var calendarioView: UICollectionView!
    
    @IBOutlet weak var fechaLbl: UILabel!
    
    var fecha = Date()
    var lunes = Date()
    var domingo = Date()
    var fechaSend = Date() // FECHA ENVIADA A SGTE VIEW (LISTA NIVEL ACT)
    
    var ultimoNivel = NivelViewController.PickerValor(id_nivelvalor: 0, nva_valorcorto: "", id_nivel: 0, niveles: "", niv_ruta: "")
    let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
    let kCellHeight : CGFloat = 100// HEIGHT DE LA COLUMNA
    let kLineSpacing : CGFloat = 5 // ESPACIO LATERAL ENTRE CELDAS
    let kInset : CGFloat = 5 // ESPACIO VERTICAL ENTRE CELDAS
    
    var actSemana:[ValorActividad] = [] // Arreglo con los datos de la semana actual
    var actLun = ValorActividad(dia: "LUNES", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actMar = ValorActividad(dia: "MARTES", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actMie = ValorActividad(dia: "MIERCOLES", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actJue = ValorActividad(dia: "JUEVES", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actVie = ValorActividad(dia: "VIERNES", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actSab = ValorActividad(dia: "SABADO", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    var actDom = ValorActividad(dia: "DOMINGO", fecha: Date(), planificada: "0", backlog: "", alta: "0", media: "0", baja: "0")
    
    
//------------------- MAIN ---------------------
//----------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imgBarRight(vc: self)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NP:", style: .plain, target: self, action: #selector(noProgramadas))

        //UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(noProgramadas))

    actSemana.append(actLun);actSemana.append(actMar);actSemana.append(actMie);actSemana.append(actJue);actSemana.append(actVie);actSemana.append(actSab);actSemana.append(actDom)
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        let fechaNueva = addDays(fecha: fecha, cant: 0)
        actualizaDias(fecha: fechaNueva)
        
        let fechaFormat = formatearFecha(fecha: fechaNueva)
        print("Fecha: ", fechaFormat.uppercased())
        print("Lunes: ", formatearFecha(fecha: lunes, format: "d-MMM"))
        print("Domingo: ", domingo)
        
        setConstantes()
        actualizarCalendario()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        avanzar()
        retroceder()
        self.navigationItem.rightBarButtonItem?.title = getNP()
        self.tabBarController?.tabBar.isHidden = false // mostrar Tab Bar
        
        // Subir actividades pendientes si existen
        subirActividadesPendientes{ (success, estado) -> () in
            if success {
                print("ACTIVIDADES PENDIENTES EJECUTADA")
            }
        }
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actSemana.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarioCell
        
        print("IndexPath: ", indexPath.item)
        let fecha = formatearFecha(fecha: actSemana[indexPath.item].fecha!, format: "d/MM")
        let fechaBacklog = formatearFecha(fecha: actSemana[indexPath.item].fecha!, format: "YYYY-MM-dd")
        actSemana[indexPath.item].backlog? = getBacklog(fecha: fechaBacklog)
        
        cell.fechaDia.text? = "\(actSemana[indexPath.item].dia!) \(fecha)"
        cell.planificada.text? = actSemana[indexPath.item].planificada!
        cell.alta.text? = actSemana[indexPath.item].alta!
        cell.media.text? = actSemana[indexPath.item].media!
        cell.baja.text? = actSemana[indexPath.item].baja!
        cell.backlog.text = actSemana[indexPath.item].backlog!
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        print("Pla: ",actSemana[indexPath.item].planificada!)
        if (actSemana[indexPath.item].planificada! != "0"){
            
            cell.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.00)
            cell.isUserInteractionEnabled = true
        }
        else{
             cell.backgroundColor = UIColor(red: 92/255, green: 107/255, blue: 192/255, alpha: 1.00)
            cell.isUserInteractionEnabled = false
        }

    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        fechaSend = actSemana[indexPath.item].fecha!
        self.performSegue(withIdentifier: "verListaNivel", sender: self);
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verListaNivel" {
            if let listaNivel = segue.destination as? ListaNivelViewController {
                listaNivel.fecha = fechaSend
            }
        }
    }
    
    // ------------- HEADER  Y FOOTER DEL CALENDARIO --------------------
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader  {
           
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarioHeader", for: indexPath) as! CalendarioHeader
            
            headerView.fechaLabel.text = "\(formatearFecha(fecha: lunes, format: "d MMM"))  al  \(formatearFecha(fecha: domingo, format: "d MMM"))"

            return headerView
        }
        else {
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "calendarioFooter", for: indexPath) as! CalendarioFooter
            return footerView
        }
        //fatalError("Unexpected kind")
    }//------------------- O ------------------------------
    
    
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func avanzarFecha(_ sender: Any) {
        
        avanzar()
        
    }
    
    @IBAction func retrocederFecha(_ sender: Any) {
        
        retroceder()

    }
    func avanzar(){
        
        inicializarVariables()
        fecha = addDays(fecha: fecha, cant: 7)
        actualizaDias(fecha: fecha)
        
        actualizarCalendario()
        calendarioView?.reloadData()
        
    }
    
    func retroceder(){
        
        inicializarVariables()
        
        fecha = addDays(fecha: fecha, cant: -7)
        actualizaDias(fecha: fecha)
        actualizarCalendario() // Realizar la consulta por e rango de fechas y actualizar array
        
        calendarioView?.reloadData()
        print("\(formatearFecha(fecha: lunes, format: "d-MMM")) AL \(formatearFecha(fecha: domingo, format: "d-MMM"))")

    }
    
    

// ---------------------- FUNCIONES PARA LAS FECHAS -----------------------------------
//-------------------------------------------------------------------------------------
    
    // --------- ACTUALIZA LOS DÌAS 1 Y 7 DE LA SEMANA DE LA FECHA CONSULTADA ------------
        func actualizaDias(fecha: Date){ // Trae la fecha de now + - 7 días
            
            //var fecha = Date()
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            
            let startOfWeek = calendar.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fecha))!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            
            //let lunesFormat = formatearFecha(fecha: startOfWeek)
            //let domingoFormat = formatearFecha(fecha: endOfWeek)
            lunes = startOfWeek
            domingo = endOfWeek
            
            actSemana[0].fecha = lunes
            actSemana[1].fecha = addDays(fecha: lunes, cant: 1)
            actSemana[2].fecha = addDays(fecha: lunes, cant: 2)
            actSemana[3].fecha = addDays(fecha: lunes, cant: 3)
            actSemana[4].fecha = addDays(fecha: lunes, cant: 4)
            actSemana[5].fecha = addDays(fecha: lunes, cant: 5)
            actSemana[6].fecha = addDays(fecha: lunes, cant: 6)
            
            //print("Semana: \n", actSemana)
            
            
            
    }//------------------------ o ----------------------
    
    
        
    
    private func setConstantes(){
        
        do{
            try dbQueue.inTransaction{ db in
               let constantesSql = "SELECT " +
                                        "niv_hijos, " +         //0
                                        "id_nivel, " +          //1
                                        "niv_ruta, " +          //2
                                        "v.id_nivelvalor, " +   //3
                                        "t.id_niveltipo " +     //4
                                        "FROM " +
                                        "nivel n " +
                                        "INNER JOIN nivelvalor v ON v.id_nivelvalor=n.id_nivelvalor " +
                                        "INNER JOIN niveltipo t ON t.id_niveltipo=v.id_niveltipo " +
                                    "WHERE id_nivel= \(ultimoNivel.id_nivel!)"
                
                let rows = try Row.fetchAll(db, constantesSql)
                if( rows.count == 0){
                    print("No existen registros")
                }
                else{
                    var niv_hijos = ""
                    if(rows[0]["niv_hijos"] != ""){
                        niv_hijos = "\(rows[0]["id_nivel"]!), \(rows[0]["niv_hijos"]!)"
                    }
                    else{
                        niv_hijos = "\(rows[0]["id_nivel"]!)"
                    }
                    
                    let niv_ruta = "\(rows[0]["niv_ruta"]!)"
                    let id_nivelvalor = "\(rows[0]["id_nivelvalor"]!)"
                    let id_niveltipo = "\(rows[0]["id_niveltipo"]!)"
                    
                    /*print("hijos: ", niv_hijos)
                    print("niv_ruta: ", niv_ruta)
                    print("id_nivelvalor: ", id_nivelvalor)
                    print("id_niveltipo: ", id_niveltipo)*/
                    
                    UserDefaults.standard.set(niv_hijos, forKey: "niv_hijos")
                    UserDefaults.standard.set(niv_ruta, forKey: "niv_ruta")
                    UserDefaults.standard.set(id_nivelvalor, forKey: "id_nivelvalor")
                    UserDefaults.standard.set(id_niveltipo, forKey: "id_niveltipo")
                    
                }
                return .commit
            }
        }catch{
            print(error)
        }
    }
    
    
//------------------------ ACTUALIZAR DATOS CALENDARIO -------------------------
    
    func actualizarCalendario(){
        
        let fecha_desde = formatearFecha(fecha: lunes, format: "YYYY-MM-dd")
        let fecha_hasta = formatearFecha(fecha: domingo, format: "YYYY-MM-dd")
        print("Fecha hasta: ", fecha_hasta)
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        
        let actividadSql = "SELECT " +
                                "strftime('%Y-%m-%d',a.act_fec_asignada) as fecha, strftime('%w', a.act_fec_asignada) as weekday, " +
                                "count(*) as c,  " +
                                "SUM(CASE WHEN p.id_prioridad = 1 THEN 1 ELSE 0 END) AS alta, " +
                                "SUM(CASE WHEN p.id_prioridad = 2 THEN 1 ELSE 0 END) AS media, " +
                                "SUM(CASE WHEN p.id_prioridad = 3 THEN 1 ELSE 0 END) AS baja " +
                            "FROM usuariotipodoc u " +
        "INNER JOIN actividad a ON a.id_nivel = u.id_nivel AND a.id_nivel IN (\(id_nivel), \(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento AND a.act_fec_asignada BETWEEN '\(fecha_desde) 00:00:00' AND '\(fecha_hasta) 23:59:59' INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle WHERE u.id_usuario = '\(String(describing: userID!))' GROUP BY strftime('%Y-%m-%d',a.act_fec_asignada) ORDER BY a.act_fec_asignada ASC"
        print("\n\n", actividadSql, "\n\n")
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, actividadSql)
                if( rows.count == 0){
                    print("No existen registros")
                }
                else{
                    var index = -1
                    
                    for row in rows {
                        
                        if(Int(row["weekday"])! == 0){
                            index = 6
                        }
                        else{
                            index = Int(row["weekday"])! - 1
                        }
                       /* print("plani: \(row["c"]!)")
                        print("alta: \(row["alta"]!)")
                        print("media: \(row["media"]!)")
                        print("baja: \(row["baja"]!)")
                        print("Backlog: \(backlog)")*/
                        
                        actSemana[index].planificada = "\(row["c"]!)"
                        actSemana[index].alta = "\(row["alta"]!)"
                        actSemana[index].media = "\(row["media"]!)"
                        actSemana[index].baja = "\(row["baja"]!)"
                        
                    }
                }
                return .commit
            }
            
        }catch{
                print(error)
            }
    }// ------------END DATOS CALENDARIO -----------
    
    
    //------------------------ TRAER BACKLOG -------------------------
    
    func getBacklog(fecha: String) -> String{
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        var backlog:String = "-1"
        let backlogSql = "SELECT COUNT(*) as c " +
                            "FROM usuariotipodoc u " +
                            "INNER JOIN actividad a ON a.id_nivel=u.id_nivel AND a.id_nivel IN (\(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +// AND a.id_tipodocumento=2
                                "AND a.act_fec_asignada < '\(fecha)' " +
                            "INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle " +
                            "WHERE u.id_usuario='\(userID!)'"
        //print(backlogSql)
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, backlogSql)
                if( rows.count == 0){
                    print("No existen registros de backlog")
                }
                else{
                    backlog = "\(rows[0]["c"]!)"
                    print("BACKLOG: ", backlog)
                }
                return .commit
            }
        }
        catch{
            print(error)
        }
    
        
        return backlog
        
    }//---------------- END BACKLOG -------------------------
    
    
    // ------------------- GET NO PROGRAMADAS -------------------------//
    
    func getNP() -> String{
        
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        var np = ""
        let npSql = "SELECT id_actividad " +
                    "FROM actividad " +
                    "WHERE id_actividadestado=1 AND id_tipodocumento=6 AND id_nivel IN (\(niv_hijos)) "
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, npSql)
                if( rows.count == 0){
                    print("No existen registros de NP")
                }
                np = "NP: \(rows.count)"
                return .commit
            }
        }
        catch{
            print(error)
        }
        return np
        
    }//---------------- END NO PROGRAMADAS -------------------------

    
    @objc func noProgramadas(sender: AnyObject) {
        print("NO PROGRAMADA PRESSED")
        performSegue(withIdentifier: "verNoprogramadas", sender: nil)
        // Realizar segue
    }
    
    func inicializarVariables(){
        
        for i in 0...6{
            actSemana[i].planificada! = "0"
            actSemana[i].backlog! = "0"
            actSemana[i].alta! = "0"
            actSemana[i].media! = "0"
            actSemana[i].baja! = "0"
        }
    }
    
    struct ValorActividad {
        
        var dia: String?
        var fecha: Date?
        var planificada: String?
        var backlog: String?
        var alta: String?
        var media: String?
        var baja: String?
        
        init(dia: String, fecha: Date, planificada: String, backlog: String, alta: String, media: String, baja: String) {
            self.dia = dia
            self.fecha = fecha
            self.planificada = planificada
            self.backlog = backlog
            self.alta = alta
            self.media = media
            self.baja = baja
        }
    }
    
}// ------------------ END OF CLASS ----------------------



@available(iOS 11.0, *)
extension CalendarioViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
    
        return CGSize(width: (UIScreen.main.bounds.width - 2*kInset - kLineSpacing)/2, height: (UIScreen.main.bounds.height - 2*kInset - kLineSpacing)/6)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
{
    return kLineSpacing
    }
    
}
