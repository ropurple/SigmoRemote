//
//  ListaNivelViewController.swift
//  Sigmo
//
//  Created by macOS User on 01/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)
class ListaNivelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var buscarBtn: UITabBarItem!
    
    var fecha = Date()
    let id_nivel = UserDefaults.standard.integer(forKey: "id_nivel")
    var valoresListaNivel:[ValorListaNivel] = []
    var listaObjetos = ValorListaNivel(id_nivel: "", nti_nombre: "", nva_valorcorto: "", planificada: "", alta: "", media: "", baja: "", id_nivelvalor: "", fecha: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // Ejecutar desde modal
        NotificationCenter.default.addObserver(self, selector: #selector(CalendarioViewController.mostrarTab(_:)), name:NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        
        //label.text = fechaSend
        let nibName = UINib(nibName: "ListaNivelTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ListaNivelCell")

        self.tableview.tableFooterView = UIView()
        fechaLabel.text! = formatearFecha(fecha: fecha, format: "EEEE dd/MM")
        consultarDatos()
    }

    // Reload data de Tableview cuando vuelve a la vista
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        valoresListaNivel.removeAll()
        consultarDatos()
        tableview.reloadData()
        self.tabBarController?.tabBar.isHidden = false // No mostrar Tab Bar
    }//--------- o ------------
    
    // ----------------- FUNC TABLEVIEW NUMBERSofROW ------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  valoresListaNivel.count
        
    }//----------------- FUNC TABLEVIEW NUMBERSofROW -----------------
    
    //-------------------------- FUNC TABLEVIEW INDEXPATH ------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaNivelCell", for: indexPath) as! ListaNivelTableViewCell
        //print("CANTIDAD: \(niveltipoArray.count)")
        
        if (indexPath.item < valoresListaNivel.count){
            let backlog = getBacklog(fecha: formatearFecha(fecha: fecha, format: "YYYY-MM-dd"))
            
            cell.cellInit(niveltipo: "\(valoresListaNivel[indexPath.item].nti_nombre!): ",
                          nivelvalor: valoresListaNivel[indexPath.item].nva_valorcorto!,
                          pla: valoresListaNivel[indexPath.item].planificada!,
                          bl: backlog,
                          alta: valoresListaNivel[indexPath.item].alta!,
                          media: valoresListaNivel[indexPath.item].media!,
                          baja: valoresListaNivel[indexPath.item].baja!)
            
            // Para mantener el width centrado del separador
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        
        return cell
    }
    
    // ----------------- FUNC TABLEVIEW height ------------------------
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }// -------------- END FUNC TABLEVIEW height ------------------


    // ----------------- FUNC TABLEVIEW SELECTED ------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listaObjetos = valoresListaNivel[indexPath.item]
        performSegue(withIdentifier: "verListaObjetos", sender: nil)
            
    }// ------------ end FUNC TABLEVIEW SELECTED ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verListaObjetos" {
            if let listaObj = segue.destination as? ListaObjetosViewController {
                listaObj.listaObjetos = listaObjetos
            }
        }
    }
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func mostrarTab(_ sender: NSNotification) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
//--------------------- FUNC CONSULTAR DATOS ----------------------
    
    func consultarDatos(){
        
        let fechaString = formatearFecha(fecha: fecha, format: "YYYY-MM-dd")
        let niv_hijos = UserDefaults.standard.string(forKey: "niv_hijos")!
        
        let listaNivelSql = "SELECT " +
                            "COUNT(*) as c, " +                                                      //0
                                "n.id_nivel, " +                                                    //1
                                "n.niv_hijos, " +                                                   //2
                                "t.nti_nombre, " +                                                  //3
                                "v.nva_valorcorto, " +                                              //4
                                "SUM(CASE WHEN p.id_prioridad = 1 THEN 1 ELSE 0 END) AS alta, " +   //5
                                "SUM(CASE WHEN p.id_prioridad = 2 THEN 1 ELSE 0 END) AS media, " +  //6
                                "SUM(CASE WHEN p.id_prioridad = 3 THEN 1 ELSE 0 END) AS baja," +    //7
                                "n.id_nivelvalor " +                                                //8
                                "FROM usuariotipodoc u " +
                                "INNER JOIN actividad a ON u.id_nivel = a.id_nivel AND u.id_nivel IN (\(id_nivel), \(niv_hijos)) AND a.id_actividadestado=1 AND u.id_tipodocumento=a.id_tipodocumento " +
                                "AND a.act_fec_asignada BETWEEN '\(fechaString) 00:00:00' AND '\(fechaString) 23:59:59'" +
                                "INNER JOIN programadadetalle p ON p.id_programadadetalle = a.id_programadadetalle " +
                                "INNER JOIN nivel n ON n.id_nivel = u.id_nivel " +
                                "INNER JOIN nivelvalor v ON v.id_nivelvalor = n.id_nivelvalor " +
                                "INNER JOIN niveltipo t ON t.id_niveltipo = v.id_niveltipo " +
                                "WHERE u.id_usuario='\(userID!)'" +
                                "GROUP BY v.id_nivelvalor " +
                                "ORDER BY nti_nombre, nva_valorcorto"
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, listaNivelSql)
                if( rows.count == 0){
                    print("No existen registros")
                }
                else{
                    
                    for row in rows {
                        let actDia = ValorListaNivel(id_nivel: "\(row["id_nivel"] ?? "")", nti_nombre: "\(row["nti_nombre"] ?? "")", nva_valorcorto: "\(row["nva_valorcorto"] ?? "")", planificada: "\(row["c"] ?? "")", alta: "\(row["alta"] ?? "")", media: "\(row["media"] ?? "")", baja: "\(row["baja"] ?? "")", id_nivelvalor: "\(row["id_nivelvalor"] ?? "")", fecha: fecha)
                        
                            valoresListaNivel.append(actDia)
                    }
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
                            "WHERE u.id_usuario='\(userID!)'"

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
    
    
    struct ValorListaNivel {
        
        var id_nivel: String?
        var nti_nombre: String?
        var nva_valorcorto: String?
        var planificada: String?
        var alta: String?
        var media: String?
        var baja: String?
        var id_nivelvalor: String?
        var fecha: Date?
        
        
        init(id_nivel: String, nti_nombre: String, nva_valorcorto: String, planificada: String, alta: String, media: String, baja: String, id_nivelvalor: String, fecha: Date) {
            self.id_nivel = id_nivel
            self.nti_nombre = nti_nombre
            self.nva_valorcorto = nva_valorcorto
            self.planificada = planificada
            self.alta = alta
            self.media = media
            self.baja = baja
            self.id_nivelvalor = id_nivelvalor
            self.fecha = fecha
        }
    }
}
