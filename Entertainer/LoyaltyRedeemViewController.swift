//
//  LoyaltyRedeemViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 28/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class LoyaltyRedeemViewController: UIViewController {

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first.delegate = self as? UITextFieldDelegate
        second.delegate = self as? UITextFieldDelegate
        third.delegate = self as? UITextFieldDelegate
        fourth.delegate = self as? UITextFieldDelegate
        
        first.addTarget(self, action: Selector(("textFieldDidChange")), for: UIControlEvents.editingChanged)
        second.addTarget(self, action: Selector(("textFieldDidChange")), for: UIControlEvents.editingChanged)
        third.addTarget(self, action: Selector(("textFieldDidChange")), for: UIControlEvents.editingChanged)
        fourth.addTarget(self, action: Selector(("textFieldDidChange")), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
       /* if text?.characters.count > 1{
            switch textField{
            case first:
                second.becomeFirstResponder()
            case second:
                third.becomeFirstResponder()
            case third:
                fourth.becomeFirstResponder()
            case fourth:
                fourth.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }*/
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}

