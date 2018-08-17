//
//  ListaActividadesTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 02/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ListaActividadesTableViewCell: UITableViewCell {

    @IBOutlet weak var accionLabel: UILabel!
    @IBOutlet weak var detalleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var epLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func actividadInit(accion: String, detalle: String, info: String, ep: String){
        
        accionLabel.text = accion
        detalleLabel.text = detalle
        infoLabel.text = info
        epLabel.text = ep
        
    }
}
