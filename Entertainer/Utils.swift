//
//  Utils.swift
//  Entertainer
//
//  Created by WisOpt on 15/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class Utils{
    static func showAlert(title: String, message: String, presenter: UIViewController){
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithAction(title: String, message: String, presenter: UIViewController){
        // create the alert
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            action in
            if(action.style == .default){
                if let navController = presenter.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }))
        
        // show the alert
        presenter.present(alert, animated: true, completion: nil)
    }
    
    
}

