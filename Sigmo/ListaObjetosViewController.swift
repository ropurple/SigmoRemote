//
//  ListaObjetosViewController.swift
//  Sigmo
//
//  Created by macOS User on 01/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)
class ListaObjetosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!

    // Variables
    let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
    var valoresListaObjetos:[ValorListaObjetos] = []
    var listaObjetos = ListaNivelViewController.ValorListaNivel(id_nivel: "", nti_nombre: "", nva_valorcorto: "", planificada: "", alta: "", media: "", baja: "", id_nivelvalor: "", fecha: Date())
    var listaActividades = ValorListaObjetos(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", planificada: "", alta: "", media: "", baja: "", id_nivelvalor: "", fecha: Date())
    
    
// ----------- MAIN ------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        // Labels
        nivelLabel.text = "\(listaObjetos.nti_nombre!): \(listaObjetos.nva_valorcorto!)"
        fechaLabel.text = formatearFecha(fecha: listaObjetos.fecha!, format: "EEEE dd/MM")
        
        let nibName = UINib(nibName: "ListaObjetosTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ListaObjetosCell")
        
        self.tableview.tableFooterView = UIView()
        consultarDatos()
    }
    
    // Reload data de Tableview cuando vuelve a la vista
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        valoresListaObjetos.removeAll()
        consultarDatos()
        tableview.reloadData()
        self.tabBarController?.tabBar.isHidden = false // No mostrar Tab Bar
    }//--------- o ------------
    
//---- END MAIN -----
    
    
// ------------------- TABLEVIEW FUNCTIONS -----------------------
// ---------------------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  valoresListaObjetos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaObjetosCell", for: indexPath) as! ListaObjetosTableViewCell

        if (indexPath.item < valoresListaObjetos.count){
            let backlog = getBacklog(fecha: formatearFecha(fecha: listaObjetos.fecha!, format: "YYYY-MM-dd"))
            
            cell.cellInit(objeto: valoresListaObjetos[indexPath.item].obj_nombre!, planificada: valoresListaObjetos[indexPath.item].planificada!, backlog: backlog, alta: valoresListaObjetos[indexPath.item].alta!, media: valoresListaObjetos[indexPath.item].media!, baja: valoresListaObjetos[indexPath.item].baja!)
            
            
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
        listaActividades = valoresListaObjetos[indexPath.item]
        performSegue(withIdentifier: "verListaActividades", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verListaActividades" {
            if let listaAct = segue.destination as? ListaActividadesViewController{
                listaAct.listaActividades = listaActividades
            }
        }
    }
// ------------------- END TABLEVIEW -----------------------
    
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
// --------------------------- FUNCIONES ------------------------------------
// --------------------------------------------------------------------------

    func consultarDatos() {
        
        let fechaString = formatearFecha(fecha: listaObjetos.fecha!, format: "YYYY-MM-dd")
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        
        let listaObjetoSql = "SELECT " +
                            "count(*) as c, " +                     //0
                                "SUM(CASE WHEN p.id_prioridad = 1 THEN 1 ELSE 0 END) AS alta, " +    //1
                                "SUM(CASE WHEN p.id_prioridad = 2 THEN 1 ELSE 0 END) AS media, " +   //2
                                "SUM(CASE WHEN p.id_prioridad = 3 THEN 1 ELSE 0 END) AS baja, " +    //3
                                "v.nva_valor, " +                       //4
                                "v.id_nivelvalor," +                    //5
                                "t.nti_nombre," +                       //6
                                "n.niv_hijos," +                        //7
                                "obj_nombre," +                         //8
                                "a.id_objeto " +                        //9
                                "FROM usuariotipodoc u " +
                                "INNER JOIN actividad a ON a.id_nivel = u.id_nivel AND u.id_nivel IN (\(id_nivel), \(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +
                                "AND a.act_fec_asignada BETWEEN '\(fechaString) 00:00:00' AND '\(fechaString) 23:59:59'" +
                                "INNER JOIN objeto o ON a.id_objeto = o.id_objeto " +
                                "INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle " +
                                "INNER JOIN nivel n ON n.id_nivel = u.id_nivel AND n.id_nivelvalor = '\(listaObjetos.id_nivelvalor!)' " +
                                "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor " +
                                "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo " +
                                "WHERE u.id_usuario = '\(userID!)' " +
                                "GROUP BY v.id_nivelvalor, a.id_objeto " +
                            "ORDER BY v.nva_valor, obj_nombre"
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, listaObjetoSql)
                if( rows.count == 0){
                    print("No existen registros Lista Objetos")
                }
                else{
                    
                    for row in rows {
                        let listaObj = ValorListaObjetos(nti_nombre: "\(row["nti_nombre"] ?? "")", nva_valor: "\(row["nva_valor"] ?? "")", id_objeto: "\(row["id_objeto"] ?? "")", obj_nombre: "\(row["obj_nombre"] ?? "")", planificada: "\(row["c"] ?? "")", alta: "\(row["alta"] ?? "")", media: "\(row["media"] ?? "")", baja: "\(row["baja"] ?? "")", id_nivelvalor: "\(row["id_nivelvalor"] ?? "")", fecha: listaObjetos.fecha!)
                        
                        valoresListaObjetos.append(listaObj)
                    }
                    //print("LISTAOBJ count: ", valoresListaObjetos)
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
        
    }// ----------------- END CONSULTAR DATOS ------------------
    

    func getBacklog(fecha: String) -> String{
        
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        var backlog:String = "-1"
        
        let backlogSql = "SELECT COUNT(*) as c " +
                            "FROM usuariotipodoc u " +
                            "INNER JOIN actividad a ON a.id_nivel=u.id_nivel AND a.id_nivel IN (\(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +// AND a.id_tipodocumento=2
                            "AND a.act_fec_asignada < '\(fecha)' " +
                            "INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle " +
                            "WHERE u.id_usuario='\(userID!)' "
        
        do{
            try dbQueue.inTransaction{ db in
                
                let rows = try Row.fetchAll(db, backlogSql)
                if( rows.count == 0){
                    print("No existen registros de backlog")
                }
                else{
                    backlog = "\(rows[0]["c"]!)"
                }
                return .commit
            }
        }
        catch{
            print(error)
        }
        return backlog
        
    }
    //---------------- END BACKLOG -------------------------
    
// ----------------------------- END FUNCIONES ----------------------------------
    
    
    struct ValorListaObjetos {
        
        var nti_nombre: String?
        var nva_valor: String?
        var id_objeto: String?
        var obj_nombre: String?
        var planificada: String?
        var alta: String?
        var media: String?
        var baja: String?
        var id_nivelvalor: String?
        var fecha: Date?
        
        
        init(nti_nombre: String, nva_valor: String, id_objeto: String, obj_nombre: String, planificada: String, alta: String, media: String, baja: String, id_nivelvalor: String, fecha: Date) {
            self.nti_nombre = nti_nombre
            self.nva_valor = nva_valor
            self.id_objeto = id_objeto
            self.obj_nombre = obj_nombre
            self.planificada = planificada
            self.alta = alta
            self.media = media
            self.baja = baja
            self.id_nivelvalor = id_nivelvalor
            self.fecha = fecha
        }
    }
}

