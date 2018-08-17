//
//  ModalNivelesViewController.swift
//  Sigmo
//
//  Created by macOS User on 29/05/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit
import GRDB

class ModalNivelesViewController: UIViewController {

    @IBOutlet weak var nivelesView: UIView!
    
    @IBOutlet weak var nivelesHeight: NSLayoutConstraint!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    // VARIABLES PARA LABELS DE LOS SELECCIONABLES
    var labelsIzq: [UILabel] = []
    var labelIzq1: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelIzq2: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelIzq3: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelIzq4: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelIzq5: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelIzq6: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var labelsDer: [UILabel] = []
    var labelDer1: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelDer2: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelDer3: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelDer4: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelDer5: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var labelDer6: UILabel! = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

    var eje_y:Double = 10
    let eje_x:Double = 120
    
    var tiponiveles:[Tiponivel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        //let calendar = CalendarioViewController()
        //calendar.tabBarController?.tabBar.isHidden = true
    labelsIzq.append(labelIzq1);labelsIzq.append(labelIzq2);labelsIzq.append(labelIzq3);labelsIzq.append(labelIzq4);labelsIzq.append(labelIzq5);labelsIzq.append(labelIzq6)
    labelsDer.append(labelDer1);labelsDer.append(labelDer2);labelsDer.append(labelDer3);labelsDer.append(labelDer4);labelsDer.append(labelDer5);labelsDer.append(labelDer6)
        let niv_ruta = UserDefaults.standard.string(forKey: "niv_ruta")
        llenarTiponivel(niv_ruta: niv_ruta!)
        
        print("TiponivelCount: ", tiponiveles.count)
        var c = 0
        for ntipo in tiponiveles{ // Recorre los niveles del usuario
            
                
            generaTextField( posicion: c, textIzq: ntipo.nti_nombre!, textDer: ntipo.nva_valorcorto!, ejey: eje_y, ejex: eje_x)
            
            eje_y+=30
            c+=1
        }
        nivelesHeight.constant = CGFloat(eje_y + 10)
        nivelesHeight.priority = UILayoutPriority(rawValue: 999)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
        self.tabBarController?.tabBar.isHidden = true // No mostrar Tab Bar
        
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mostrarTab"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    func generaTextField(posicion: Int, textIzq: String, textDer: String, ejey: Double, ejex: Double)  {
        
        let index = Int(posicion)
        labelsIzq[index] = UILabel(frame: CGRect(x: ejex-100, y: ejey, width: 70.00, height: 30.00))
        labelsIzq[index].text = textIzq
        labelsIzq[index].autoresizingMask = [.flexibleLeftMargin]
        labelsIzq[index].lineBreakMode = .byWordWrapping
        labelsIzq[index].numberOfLines = 2
        labelsIzq[index].font = labelsIzq[index].font?.withSize(11)
        nivelesView.addSubview(labelsIzq[index])
        
        let label2puntos = UILabel(frame: CGRect(x: ejex-5, y: ejey, width: 2, height: 30.00))
        label2puntos.text = ":"
        label2puntos.font = label2puntos.font?.withSize(11)
        nivelesView.addSubview(label2puntos)
        
        labelsDer[index] = UILabel(frame: CGRect(x: ejex, y: ejey, width: 220.00, height: 30.00))
        labelsDer[index].text = "\(textDer)"
        labelsDer[index].autoresizingMask = [.flexibleLeftMargin]
        labelsDer[index].lineBreakMode = .byWordWrapping
        labelsDer[index].numberOfLines = 2
        labelsDer[index].font = labelsDer[index].font?.withSize(11)
        nivelesView.addSubview(labelsDer[index])
        
    }
    
    
    func llenarTiponivel(niv_ruta: String){
        
        let sql_nivel = "SELECT " +
            "t.nti_nombre, " +
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
                        //print("ROW: ", row)
                        let nti_nombre = "\(row["nti_nombre"]!)"
                        let nva_valorcorto = "\(row["nva_valorcorto"]!)"
                
                        let tiponivel = Tiponivel(nti_nombre: nti_nombre, nva_valorcorto: nva_valorcorto)
                        
                        tiponiveles.append(tiponivel)
                        
                    }
                }
                return .commit
            }
            
        }catch{
            print(error)
        }
    }
    
    struct Tiponivel {
        
        var nti_nombre : String?
        var nva_valorcorto: String?
        
        init(nti_nombre : String, nva_valorcorto : String){
            
            self.nti_nombre = nti_nombre
            self.nva_valorcorto = nva_valorcorto
        }
    }

}
