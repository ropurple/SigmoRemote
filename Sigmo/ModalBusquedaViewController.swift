//
//  ModalBusquedaViewController.swift
//  Sigmo
//
//  Created by macOS User on 26/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ModalBusquedaViewController: UIViewController {

    @IBOutlet weak var postergarView: UIView!
    @IBOutlet weak var realizarView: UIView!
    @IBOutlet weak var capacitacionView: UIView!
    @IBOutlet weak var epView: UIView!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    @IBOutlet weak var postergarHeight: NSLayoutConstraint!
    @IBOutlet weak var realizarHeight: NSLayoutConstraint!
    @IBOutlet weak var capacitacionHeight: NSLayoutConstraint!
    @IBOutlet weak var epHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let acc_capacitacion = UserDefaults.standard.string(forKey: "acc_capacitacion")
        let ep = UserDefaults.standard.string(forKey: "verEnproceso")
        
        //print("ACC_CAPACITACION = ", acc_capacitaci as Anyon!)
        //print("EN PROCESO =  as Any", ep!)
        
        if(acc_capacitacion != "true"){
            
            capacitacionHeight.constant = 0
            capacitacionHeight.priority = UILayoutPriority(rawValue: 999)
            capacitacionView.isHidden = true
        }
        else{
            capacitacionView.isHidden = false
        }
        
        if(ep != "true"){
            
            epHeight.constant = 0
            epHeight.priority = UILayoutPriority(rawValue: 999)
            epView.isHidden = true
        }
        else{
            epView.isHidden = false
        }
        
        //updateViewConstraints()
        
        
    }
    
    @IBAction func postergar(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postergar2"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func realizarBtn(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ejecutar2"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    
    @IBAction func capacitacionUrl(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "capacitacion2"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func verEnproceso(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "verEnproceso2"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        
        dismiss(animated: true)
    }
}
