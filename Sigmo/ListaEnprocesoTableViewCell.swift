//
//  ListaEnprocesoTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 18/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ListaEnprocesoTableViewCell: UITableViewCell, UIImagePickerControllerDelegate{

    
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var usuarioLabel: UILabel!
    @IBOutlet weak var observacionLabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageview.image = UIImage(named: "ver_web.png")!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func enProcesoInit( image: UIImageView!, fecha: String, usuario: String, observacion: String){
        
        if(image != nil){
            imageview.image = image.image!
        }else{
            imageview.image = UIImage(named: "ver_web.png")!
        }
        fechaLabel.text = fecha
        usuarioLabel.text = usuario
        observacionLabel.text = observacion
        
    }
}
