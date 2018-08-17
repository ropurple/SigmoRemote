//
//  ListaActividadesTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 02/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ListaObjetosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var objetoLabel: UILabel!
    @IBOutlet weak var plaLabel: UILabel!
    @IBOutlet weak var blLabel: UILabel!
    @IBOutlet weak var altaLabel: UILabel!
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var bajaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func cellInit(objeto: String, planificada: String, backlog: String, alta: String, media: String, baja: String){
        
        objetoLabel.text = objeto
        plaLabel.text = planificada
        blLabel.text = backlog
        altaLabel.text = alta
        mediaLabel.text = media
        bajaLabel.text = baja
        
    }
}

