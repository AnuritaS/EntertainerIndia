//
//  PhoneViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 13/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView


class PhoneViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable{
    
    @IBOutlet weak var continueB: UIButton!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameL: UILabel!
    
    var invite : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        //until phone number is entered
        continueB.isHidden = true
        phoneTF.delegate = self
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (phoneTF.text?.count)! < 10{
            continueB.isHidden = true
        }else{
            continueB.isHidden = false
        }
    }
    @IBAction func sendphone(_ sender: Any) {
        if phoneTF.text?.count != 10{
            Utils.showAlert(title: "Error!", message: "Phone number cannot be less than 10 digits", presenter: self)
        }else if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.sendphone(sender)
            }
        }else{
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
            if invite != nil{
                self.signUp(self.invite!, Int(phoneTF.text!)!)
            }else{
                self.logIn(Int(phoneTF.text!)!)
            }}
    }
    
    @IBAction func onBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "otpSegue"{
            
            let controller = segue.destination as? OTPViewController
            controller?.invite = self.invite
            controller?.phone = Int((self.phoneTF.text)!)
        }
        else  if segue.identifier == "loginSegue"{
            
            let controller = segue.destination as? OTPViewController
            
            controller?.phone = Int((self.phoneTF.text)!)
        }
    }
    
    @IBAction func unwindToPhoneVC(unwindSegue: UIStoryboardSegue){}
    func signUp(_ uid: String,_ contact: Int){
        
        let param = ["uid":uid,"contact": contact, "option": "uid"] as [String : Any]
        print(Constant().baseURL+"users/signup")
        Alamofire.request(Constant().baseURL+"users/signup", method: .post, parameters: param).responseJSON { response in
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let user_otp = otp(JSONString: utf8Text)
                    let code = user_otp?.code
                    
                    if code == 200{
                        let alertView = UIAlertController(title: "Success", message: user_otp?.msg, preferredStyle: .alert)
                        print("Sign up successfully")
                        
                        //  Show it to your users
                        alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
                            action in
                            if(action.style == .default){
                                self.performSegue(withIdentifier: "otpSegue", sender: self)
                            }
                        }))
                        
                        self.present(alertView, animated: true, completion: nil)
                    }else{
                        self.apiErrorHandler(code: code, msg: user_otp?.msg, function: {
                            self.self.signUp(uid, contact)
                        })
                        
                    }
                }
            case .failure:
                self.errorDialog(function: {
                    self.signUp(uid, contact)
                    
                })
            }
        }
    }
    func logIn(_ contact: Int){
        //        let preferences = UserDefaults.standard
        //        var option = preferences.string(forKey: "option")
        //        if (option != "no-uid") {
        //            option = "signin"
        //        }
        
        let param = ["contact": contact, "option": "signin"] as [String : Any]
        print(Constant().baseURL+"users/login")
        Alamofire.request(Constant().baseURL+"users/login", method: .post, parameters: param).responseJSON { response in
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let user_otp = otp(JSONString: utf8Text)
                    let code = user_otp?.code
                    if code == 200{
                        print("Log in successfully")
                        let alertView = UIAlertController(title: "Success", message: user_otp?.msg, preferredStyle: .alert)
                        
                        //  Show it to your users
                        alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {
                            action in
                            if(action.style == .default){
                                self.performSegue(withIdentifier: "otpSegue", sender: self)
                            }
                        }))
                        
                        self.present(alertView, animated: true, completion: nil)
                    }else{
                        self.apiErrorHandler(code: code, msg: user_otp?.msg, function: {
                            self.self.logIn(contact)
                        })
                        
                    }
                }
                
            case .failure:
                self.errorDialog(function: {
                    self.logIn(contact)
                    
                })            }
        }
    }
    func setupView(){
        
        phoneTF.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                           attributes: [NSAttributedStringKey.foregroundColor: UIColor(red:0.05, green:0.07, blue:0.09, alpha:0.4)])
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
class OTPViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var continueB: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var fifth: UITextField!
    
    var invite : String?
    var phone: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
        self.continueB.isHidden = true
        
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        
        numberLabel.text = "Please enter the verification code sent to \(phone!)"
        
    }
    
    //check if user is logged in already
    func setIsLogin(){
        let preferences = UserDefaults.standard
        preferences.set(true, forKey: "IS_LOGIN")
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
    @IBAction func goToHome(_ sender: Any) {
        
        let otpString = first.text!+second.text!+third.text!+fourth.text!+fifth.text!
        let otp = Int(otpString)
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.goToHome(sender)
            }
        }
        else if otpString.count==5 && otp != nil{
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
             if invite != nil{
                self.signUpVerify(invite!, phone!, otp!)
            }else{
                self.logInVerify(otp!, phone!)
            }}
        else{
            Utils.showAlert(title: "Error!", message: "Enter a valid otp", presenter: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "homeSegue"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.present(controller, animated: true, completion: nil)
            //controller?.invite = inviteString
        }
    }
    
    func signUpVerify(_ uid: String,_ contact: Int,_ otp: Int){
        
        let param = ["uid":uid, "contact": contact, "otp":otp] as [String : Any]
        print("param",param)
        print("type",type(of: contact),type(of: otp))
        print(Constant().baseURL+"users/signup/verify")
        Alamofire.request(Constant().baseURL+"users/signup/verify", method: .post, parameters: param).responseJSON { response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let user_details = accessToken(JSONString: utf8Text)
                    let code = user_details?.code
                    let preferences = UserDefaults.standard
                    
                    preferences.set(user_details?.userId!, forKey: "ID")
                    preferences.set(user_details?.refToken!, forKey: "refToken")
                    preferences.set(user_details?.authToken!, forKey: "AUTHTOKEN")
                    preferences.set(user_details?.contact!, forKey: "contact")
                    preferences.synchronize()
                    
                    let didSave = preferences.synchronize()
                    
                    if !didSave {
                        
                        print("Unable to save data!")
                    }else{
                        print("Data Saved!")
                    }
                    if code == 200{
                        print("Sign up verified successfully")
                        self.setIsLogin()
                        self.performSegue(withIdentifier: "homeSegue", sender: self)
                        
                    }else{
                        self.apiErrorHandlerCancellable(code: code, msg: user_details?.msg, function: {
                            self.self.signUpVerify(uid, contact, otp)
                        })
                    }
                    
                }
            case .failure:
                self.errorDialog(function: {
                    self.signUpVerify(uid, contact, otp)
                })
                print("Error Ocurred in signing up verification!")
            }
        }
    }
    func logInVerify(_ otp: Int,_ contact: Int){
        
        let param = ["otp":otp, "contact": contact] as [String : Any]
        print(Constant().baseURL+"users/login/verify")
        Alamofire.request(Constant().baseURL+"users/login/verify", method: .post, parameters: param).responseJSON { response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let user_details = accessTokenLogin(JSONString: utf8Text)
                    let code = user_details?.code
                    
                    
                    if code == 200{
                        let preferences = UserDefaults.standard
                        
                        preferences.set(user_details?.userId!, forKey: "ID")
                        preferences.set(user_details?.authToken!, forKey: "AUTHTOKEN")
                        preferences.set(user_details?.accessLevel!, forKey: "accessLevel")
                        preferences.set(user_details?.refToken!, forKey: "refToken")
                        preferences.set(user_details?.name!, forKey: "name")
                        preferences.set(user_details?.profile?.contact!, forKey: "contact")
                        preferences.set(user_details?.profile?.email!, forKey: "email")
                        preferences.set(user_details?.profile?.imgUrl!, forKey: "imgUrl")
                       
                        
                        let didSave = preferences.synchronize()
                        
                        if !didSave {
                            //  Couldn't save (I've never seen this happen in real world testing)
                            print("Unable to save data!")
                        }else{
                            print("Data Saved!")
                        }
                        print("Log In verified successfully")
                        self.setIsLogin()
                        self.performSegue(withIdentifier: "homeSegue", sender: self)
                        
                    }else{
                        self.apiErrorHandlerCancellable(code: code, msg: user_details?.msg, function: {
                            self.self.logInVerify(otp, contact)
                        })
                    }
                    
                }
            case .failure:
                self.errorDialog(function: {
                self.logInVerify(otp, contact)
                
            })
                print("Error Ocurred in logging in verification!")
            }
        }
    }
    
    func resendOTP (contact: Int) {
        let parameters = [
            "contact": contact
        ]
        
        let url = Constant().baseURL + "/users/resend";
        
        Alamofire.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print("REQ ", response.request ?? "")
                switch response.result {
                case .success:
                    
                    print("OTP Resend Successful Successfully")
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    //Add data model for resend OTP and error 
                    
                    
                case .failure:self.errorDialog(function: {
                    self.resendOTP(contact: contact)
                    
                })
                    print("FAILED to resend otp");
                }
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
