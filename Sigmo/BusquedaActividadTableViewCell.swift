//
//  BusquedaActividadTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 25/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class BusquedaActividadTableViewCell: UITableViewCell {

    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var detalleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var epLabel: UILabel!
    @IBOutlet weak var tiponivelLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nivelView: UIView!
    @IBOutlet weak var detalleView: UIView!
    @IBOutlet weak var accionView: UIView!
    @IBOutlet weak var objetoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func actividadInit(tipoNivel: String, nivel: String, objeto: String, accion: String, detalle: String, info: String, ep: String){
        
        tiponivelLabel.text = tipoNivel
        nivelLabel.text = nivel
        objetoLabel.text = objeto
        accionLabel.text = accion
        detalleLabel.text = detalle
        infoLabel.text = info
        epLabel.text = ep
        
    }
}
