//
//  ListaNivelTableViewCell.swift
//  Sigmo
//
//  Created by macOS User on 01/02/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ListaNivelTableViewCell: UITableViewCell {

    @IBOutlet weak var nivtipoLabel: UILabel! // Niveltipo
    @IBOutlet weak var nivvalorLabel: UILabel! // Nivelvalor
    @IBOutlet weak var plaLabel: UILabel!
    @IBOutlet weak var altaLabel: UILabel!
    @IBOutlet weak var blLabel: UILabel!
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
    
    func cellInit(niveltipo: String, nivelvalor: String, pla: String, bl: String, alta: String, media: String, baja: String){
        
        nivtipoLabel.text = niveltipo
        nivvalorLabel.text = nivelvalor
        plaLabel.text = pla
        altaLabel.text = alta
        blLabel.text = bl
        mediaLabel.text = media
        bajaLabel.text = baja
    }
    
}
