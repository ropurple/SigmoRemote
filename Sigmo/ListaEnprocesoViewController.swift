//
//  EnprocesoViewController.swift
//  Sigmo
//
//  Created by macOS User on 18/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

@available(iOS 11.0, *)
class ListaEnprocesoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    // Labels cabecera
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var datosEjecucion = ListaActividadesViewController.ValorListaActividades(nti_nombre: "", nva_valor: "", id_objeto: "", obj_nombre: "", info: "", prg_nombre: "", prg_detalle: "", fecha: Date(), acc_foto: "", acc_capacitacion: "", acc_lubricante: "", id_prioridad: "", id_actividad: "", id_acciontipo: "", ep: "")
    var valoresEnproceso:[ValorEnproceso] = []
    var id_actividad:Int64 = 0
    var imageUrl:String = ""
    var imageViews:[UIImageView] = []
    var i = 0
    let urlBase = Config.config.con_url!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        id_actividad = Int64(datosEjecucion.id_actividad!)!
        print("Id_actividad: ", id_actividad)
        
        imgBarRight(vc: self)
        
        tableview.delegate = self
        tableview.dataSource = self

        
        // ------ Actualizar Labels ------
        fechaLabel.text = formatearFecha(fecha: datosEjecucion.fecha!, format: "EEEE dd/MM")
        nivelLabel.text = "\(datosEjecucion.nti_nombre!): \(datosEjecucion.nva_valor!)"
        print("NIVEL: ", nivelLabel.text!)
        objetoLabel.text = datosEjecucion.obj_nombre!
        print("OBJ: ", objetoLabel.text!)
        accionLabel.text = datosEjecucion.prg_nombre!
        infoLabel.text = datosEjecucion.info!

        let nibName = UINib(nibName: "ListaEnprocesoTableViewCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ListaEnprocesoCell")
        
        self.tableview.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        valoresEnproceso.removeAll()
        getEnproceso()
        cargarImagenes(i: 0, completion: { (success) -> () in
            if success {
                // Reload data de Tableview cuando vuelve a la vista
                self.tableview.reloadData()
                print("URL: ", self.valoresEnproceso[self.i].img_url!)
                print("THUMB: ", self.valoresEnproceso[self.i].image!)
            }
            else{
                print("ERROR EP")
            }
        })
        self.tabBarController?.tabBar.isHidden = true // No mostrar Tab Bar
    }//--------- o ------------
    
    
    // ------------------- TABLEVIEW FUNCTIONS -----------------------
    // ---------------------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  valoresEnproceso.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaEnprocesoCell", for: indexPath) as! ListaEnprocesoTableViewCell
        
        let index = indexPath.item
        i = index
        
        print("COUNT -> ", valoresEnproceso.count)
        if (indexPath.item < valoresEnproceso.count){
            print("\n Entra al cellforROW INDEX: ", index)
        
            cell.enProcesoInit(image: self.valoresEnproceso[indexPath.item].image, fecha: "\(self.valoresEnproceso[indexPath.item].act_fec_realizada ?? "")", usuario: "\(self.valoresEnproceso[indexPath.item].usu_nombre ?? "") \(self.valoresEnproceso[indexPath.item].usu_apellido ?? "")", observacion: "\(self.valoresEnproceso[indexPath.item].act_obs_ejecutor ?? "")")
            
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
        
        if(valoresEnproceso[indexPath.item].img_url! != ""){
            UIApplication.shared.open(URL(string: "\(self.urlBase)\(valoresEnproceso[indexPath.item].img_url!)")!, options: [:], completionHandler: nil)
        }
        
    }
// ------ END TABLEVIEW FUNCTIONS -------
    
    @IBAction func bloquearTab(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
    }

    
    func getEnproceso(){
        
        let enprocesoSql = "SELECT " +
                            "a.id_actividad," +     //0
                                "a.id_usuario," +       //1
                                "u.usu_nombre," +       //2
                                "u.usu_apellido," +     //3
                                "a.act_obs_ejecutor," + //4
                                "a.act_fec_realizada " + //5
                            "FROM " +
                                "actividad a " +
                                "INNER JOIN usuario u ON u.id_usuario = a.id_usuario " +
                                "WHERE id_actividadpadre = \(id_actividad) " +
                            "ORDER BY a.act_fec_realizada DESC"
        
        do{
            try dbQueue.inTransaction{ db in
                let rows = try Row.fetchAll(db, enprocesoSql)
                if( rows.count == 0){
                    print("No existen registros Lista en Proceso")
                }
                else{
                    print("Consulta En Proceso: ", enprocesoSql)
                    for row in rows {
                        print("ROW: ", row)
                        let id_actividad = "\(row["id_actividad"]!)"
                        let usu_nombre = "\(row["usu_nombre"]!)"
                        let usu_apellido = "\(row["usu_apellido"]!)"
                        let act_obs_ejecutor = "\(row["act_obs_ejecutor"]!)"
                        let act_fec_realizada = "\(row["act_fec_realizada"]!)"
                        let img_thumb = UIImageView()
                        
                        let listaEnpro = ValorEnproceso(id_actividad: "\(id_actividad)", usu_nombre: usu_nombre, usu_apellido: usu_apellido, act_obs_ejecutor: act_obs_ejecutor, act_fec_realizada: act_fec_realizada, img_url: "", image: img_thumb)
                        self.valoresEnproceso.append(listaEnpro)
                       // print("GUARDA: ", listaEnpro)
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
    }
    
    
    // ---- Revisa si hay img en el servidor en la act en proceso y las carga en el array -----
    func cargarImagenes(i: Int, completion: @escaping (Bool) -> Void){
        
        let count = valoresEnproceso.count
        print("COUNT EP: ", valoresEnproceso.count)
            
        let img_thumb = UIImageView()
        
        if count > 0 && i < valoresEnproceso.count{ // Existen valores en proceso
            
            getImgUrlServer(id_actividad: Int64(valoresEnproceso[i].id_actividad!)!, success: { success, url in
                if(success){
                    DispatchQueue.main.async{
                        UIImage.downloadFromRemoteURL(URL(string: "\(self.urlBase)\(url)")!, completion: { image, error in
                                guard let image = image, error == nil else { print("ERROR 1: ",error!);return }
                                img_thumb.image = image
                            
                                self.valoresEnproceso[i].img_url = url
                                self.valoresEnproceso[i].image = img_thumb
                                print("Img Descargada OK")
                                if((i+1) < count){
                                    print("entra al img recursiva")
                                    self.cargarImagenes(i: i+1, completion: completion)
                                }
                                else{
                                    completion(true)
                                }
                            }
                        )
                    }
                }
                else {
                    if(i < count){
                        DispatchQueue.main.async{
                            self.cargarImagenes(i: i+1, completion: completion)
                        }
                    }
                    else{
                        completion(true)
                    }
                
                }
            })
        }
    }// ------- END Cargar Imágenes --------
    
    struct ValorEnproceso {
        
        var id_actividad: String?
        var usu_nombre: String?
        var usu_apellido: String?
        var act_obs_ejecutor: String?
        var act_fec_realizada: String?
        var img_url: String?
        var image: UIImageView?
        
        init(id_actividad: String, usu_nombre: String, usu_apellido: String, act_obs_ejecutor: String, act_fec_realizada: String, img_url: String, image: UIImageView) {
            
            self.id_actividad = id_actividad
            self.usu_nombre = usu_nombre
            self.usu_apellido = usu_apellido
            self.act_obs_ejecutor = act_obs_ejecutor
            self.act_fec_realizada = act_fec_realizada
            self.img_url = img_url
            self.image?.image = image.image
            
        }
    }// ---- Struct ----
            
}// ---- Class ------

extension UIImage {
    
    static func downloadFromRemoteURL(_ url: URL, completion: @escaping (UIImage?,Error?)->()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async{
                    completion(nil,error)
                }
                return
            }
            DispatchQueue.main.async() {
                completion(image,nil)
            }
        }.resume()
    }
}
