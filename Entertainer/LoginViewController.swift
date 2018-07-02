//
//  LoginViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 13/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    @IBOutlet weak var yesB: UIButton!
    @IBOutlet weak var noB: UIButton!
    @IBOutlet weak var logInB: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(yesB != nil && noB != nil && logInB != nil){
          self.checkIsLogin()
        }
        setupView()
    }
    //check if user is logged in already
 
    func checkIsLogin(){
        let preferences = UserDefaults.standard
        let IS_LOGIN = preferences.bool(forKey: "IS_LOGIN")
        print("IS_LOGIN: \(IS_LOGIN)")
        
        if(IS_LOGIN){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.present(controller, animated: true, completion: nil)
            //            performSegue(withIdentifier: "tabController", sender: self)
        }
    }
    
    func setupView(){
        yesB.layer.cornerRadius = 20
        yesB.layer.shadowOffset = CGSize(width: 0, height: 10)
        yesB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        yesB.layer.shadowOpacity = 1
        yesB.layer.shadowRadius = 20
        
        noB.layer.cornerRadius = 20
        noB.layer.shadowOffset = CGSize(width: 0, height: 10)
        noB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        noB.layer.shadowOpacity = 1
        noB.layer.shadowRadius = 20
        
        let gradient = CAGradientLayer()
        gradient.frame = yesB.bounds
        gradient.colors = [    UIColor(red:1, green:0.45, blue:0.46, alpha:1).cgColor,    UIColor(red:0.31, green:0.38, blue:0.5, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.cornerRadius = 20
        yesB.layer.addSublayer(gradient)
        }
    @IBAction func unwindToLoginVC(unwindSegue: UIStoryboardSegue){}
}

class EmailViewController: UIViewController,NVActivityIndicatorViewable {
    
    @IBOutlet weak var continueB: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    func setupView(){
        let preferences = UserDefaults.standard
        preferences.set("no-uid", forKey: "option")
        // change this to contact
        emailTF.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:0.05, green:0.07, blue:0.09, alpha:0.4)])
        continueB.layer.cornerRadius = 20
        continueB.layer.shadowOffset = CGSize(width: 0, height: 10)
        continueB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        continueB.layer.shadowOpacity = 1
        continueB.layer.shadowRadius = 20
        
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 140, height: 38.62)
        gradient.colors = [    UIColor(red:1, green:0.45, blue:0.46, alpha:1).cgColor,    UIColor(red:0.31, green:0.38, blue:0.5, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.cornerRadius = 20
        continueB.layer.addSublayer(gradient)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "homeSegue"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.present(controller, animated: true, completion: nil)
            //controller?.invite = inviteString
        }
        
    }
    //check if user is logged in already
    func setIsLogin(){
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "IS_LOGIN")
    }
   
    func logIn(_ contact: Int){
        let param = ["contact": contact, "option": "no-uid"] as [String : Any]
        print(Constant().baseURL+"users/login")
        Alamofire.request(Constant().baseURL+"users/login", method: .post, parameters: param).responseJSON { response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let user_details = accessTokenLogin(JSONString: utf8Text)
                    let code = user_details?.code
                    
                  
                    if code == 200{
                        print("Browse Log In successfull")
                        let preferences = UserDefaults.standard
                        
                        preferences.set(user_details?.userId!, forKey: "ID")
                        preferences.set(user_details?.authToken!, forKey: "AUTHTOKEN")
                        preferences.set(user_details?.accessLevel!, forKey: "accessLevel")
                        preferences.set(user_details?.profile?.contact!, forKey: "contact")
                        preferences.set(true, forKey: "isBrowseOnly")
                        
                        let didSave = preferences.synchronize()
                        
                        if !didSave {
                            //  Couldn't save (I've never seen this happen in real world testing)
                            print("Unable to save data!")
                        }else{
                            print("Data Saved!")
                        }
                        self.setIsLogin()
                        self.performSegue(withIdentifier: "homeSegue", sender: self)
                        
                    }else {
                        self.apiErrorHandlerCancellable(code: code, msg: user_details?.msg, function: {
                            self.self.logIn(contact)
                        })
                    }
                }
            case .failure:
                self.errorDialog(function: {
                    self.logIn(contact)
                })
            }
        }
    }
    @IBAction func onContinuePressed(_ sender: Any) {
        if emailTF.text?.count != 10{
            Utils.showAlert(title: "Error!", message: "Phone number cannot be less than 10 digits.", presenter: self)
        }else if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.onContinuePressed(sender)
            }
        }
        else if let phone = Int(emailTF.text!) {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
            logIn(phone)
        }else {
            Utils.showAlert(title: "Error!", message: "Enter a valid phone number.", presenter: self)
        }
    }
    
    
}
class InviteViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var fifth: UITextField!
    @IBOutlet weak var continueB: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.

        //otp is empty
      self.continueB.isHidden = true
        
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
      
    }
    //OTP textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        // On inputing value to textfield
        if ((text?.count)! < 1  && string.count > 0){
            let nextTag = textField.tag + 1;
            
            // get next responder
            let nextResponder = textField.superview?.viewWithTag(nextTag);
            textField.text = string;
            
            if (nextResponder == nil){
                textField.resignFirstResponder()
            }
            nextResponder?.becomeFirstResponder();
            return false;
        }
        else if ((text?.count)! >= 1  && string.count == 0){
            // on deleting value from Textfield
            let previousTag = textField.tag - 1;
            
            // get next responder
            var previousResponder = textField.superview?.viewWithTag(previousTag)
            
            if (previousResponder == nil){
                previousResponder = textField.superview?.viewWithTag(1)
            }
            textField.text = ""
            previousResponder?.becomeFirstResponder()
    
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    //otp is filled
    func textFieldDidEndEditing(_ textField: UITextField) {
        if first.hasText && second.hasText && third.hasText && fourth.hasText && fifth.hasText{
            
            continueB.isHidden = false
        }else{
            continueB.isHidden = true
        }
    }
    @IBAction func sendOtp(_ sender: Any) {
    
        self.performSegue(withIdentifier: "phoneSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "phoneSegue"{
            let inviteString = first.text!+second.text!+third.text!+fourth.text!+fifth.text!
           
        let controller = segue.destination as? PhoneViewController
            controller?.invite = inviteString
        }
    }
    func setupView(){
     
        continueB.layer.cornerRadius = 20
        continueB.layer.shadowOffset = CGSize(width: 0, height: 10)
        continueB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        continueB.layer.shadowOpacity = 1
        continueB.layer.shadowRadius = 20
      

        let gradient = CAGradientLayer()
        gradient.frame = continueB.bounds
        gradient.colors = [    UIColor(red:1, green:0.45, blue:0.46, alpha:1).cgColor,    UIColor(red:0.31, green:0.38, blue:0.5, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.cornerRadius = 20
        continueB.layer.addSublayer(gradient)
        
    }
}
