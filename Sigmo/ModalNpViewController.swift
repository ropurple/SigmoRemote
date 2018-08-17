//
//  ModalBusquedaViewController.swift
//  Sigmo
//
//  Created by macOS User on 26/04/18.
//  Copyright © 2018 Sgonzalez. All rights reserved.
//

import UIKit

class ModalNpViewController: UIViewController {
    
    @IBOutlet weak var postergarView: UIView!
    @IBOutlet weak var realizarView: UIView!
    @IBOutlet weak var epView: UIView!
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var modalHeight: NSLayoutConstraint!
    @IBOutlet weak var postergarHeight: NSLayoutConstraint!
    @IBOutlet weak var realizarHeight: NSLayoutConstraint!
    @IBOutlet weak var epHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ep = UserDefaults.standard.string(forKey: "verEnprocesoNp")
        
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postergarNp"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    @IBAction func realizarBtn(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ejecutarNp"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    
    @IBAction func verEnproceso(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "verEnprocesoNp"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true)
    }
    
    
    
    @IBAction func dismissBtn(_ sender: Any) {
        
        dismiss(animated: true)
    }
}
