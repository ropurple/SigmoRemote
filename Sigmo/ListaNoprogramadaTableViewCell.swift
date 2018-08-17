//
//  ListaNoprogramadaTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 01/06/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ListaNoprogramadaTableViewCell: UITableViewCell {

    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var epLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var nivelView: UIView!
    @IBOutlet weak var fechaView: UIView!
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
    
    func actividadInit(nivel: String, objeto: String, accion: String, fecha: String, info: String, ep: String){
        
        nivelLabel.text = nivel
        objetoLabel.text = objeto
        accionLabel.text = accion
        fechaLabel.text = fecha
        infoLabel.text = info
        epLabel.text = ep
        
    }
}
