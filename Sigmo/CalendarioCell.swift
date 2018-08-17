//
//  CalendarioCell.swift
//  Sigmo
//
//  Created by macOS User on 26/12/17.
//  Copyright © 2017 Sgonzalez. All rights reserved.
//

import UIKit

class CalendarioCell: UICollectionViewCell {
    @IBOutlet weak var fechaDia: UILabel!
    @IBOutlet weak var planificada: UILabel!
    @IBOutlet weak var backlog: UILabel!
    @IBOutlet weak var alta: UILabel!
    @IBOutlet weak var media: UILabel!
    @IBOutlet weak var baja: UILabel!
    @IBAction func selectorFecha(_ sender: UIDatePicker) {
    }
    
}
