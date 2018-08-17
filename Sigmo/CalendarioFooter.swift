//
//  CalendarioFooter.swift
//  Sigmo
//
//  Created by macOS User on 03/01/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class CalendarioFooter: UICollectionReusableView {
        
    @IBAction func buscar(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Buscar actividad", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }

    @IBAction func hallazgo(_ sender: Any) {
        
        let alert = UIAlertController(title: "Alert", message: "Ingreso de hallazgo", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }

}
