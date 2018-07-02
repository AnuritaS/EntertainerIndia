//
//  EditContactViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 11/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import JVFloatLabeledTextField
import NVActivityIndicatorView

class EditContactViewController: UIViewController,NVActivityIndicatorViewable {
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    @IBOutlet weak var phNumber: JVFloatLabeledTextField!
    @IBOutlet weak var email: JVFloatLabeledTextField!
    @IBOutlet weak var saveB: UIButton!
    let preferences = UserDefaults.standard
    var  mPhone :String?=nil
    var  mEmail :String?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        mPhone = self.preferences.string(forKey: "contact") ?? ""
        mEmail = self.preferences.string(forKey: "email") ?? ""
        if mPhone != nil {
            phNumber.insertText(mPhone!)
        }
        if mEmail != nil {
            email.insertText(mEmail!)
        }
        if preferences.bool(forKey: "isBrowseOnly"){
            phNumber.isEnabled=false
        }
        saveB.layer.cornerRadius = 20
        saveB.layer.shadowOffset = CGSize(width: 0, height: 10)
        saveB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        saveB.layer.shadowOpacity = 1
        saveB.layer.shadowRadius = 20
    }
    @IBAction func onSavePressed(_ sender: Any) {
        let nPhoneInt=Int(self.phNumber.text!)
        if (self.mPhone != phNumber.text && phNumber.text != "") || (self.mEmail != email.text && email.text != "")  {
            if  nPhoneInt == nil {
                
                let alertView = UIAlertController(title: "Error", message: "Enter valid mobile number.", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler:{
                    action in
                    if(action.style == .default){
                    }
                }
                ))
                self.present(alertView, animated: true, completion: nil)
                return
            }
            if !(isValidEmail(testStr: self.email.text!)){
                
                let alertView = UIAlertController(title: "Error", message: "Enter valid email.", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler:{
                    action in
                    if(action.style == .default){
                    }
                }
                ))
                self.present(alertView, animated: true, completion: nil)
                return
            }
            self.saveDetailsApi(oldContact: Int(self.mPhone!)!, newContact: nPhoneInt!, email: self.email.text!)}
        
        
        
    }
    func isValidEmail(testStr:String) -> Bool {
        if testStr == ""{
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
extension EditContactViewController{
    func sendContactUpdateRequest(oldContact: Int, newContact: Int, email: String) {
        if (oldContact == newContact) {
            // return contact same
            return;
        }
        
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        let url = Constant().baseURL+"users/\(uid ?? "")/update?access_token=\(authToken ?? "" )"
        let parameters: Parameters = [
            "oldContact": oldContact,
            "newOldContact": newContact,
            "email": email
        ]
        
        Alamofire.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("REQ ", response.request ?? "")
                switch response.result {
                case .success:
                    
                    print("OTP SENT or EMAIL Updated");
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    
                    // if only email, successfully updated otherwise
                    // OTP sent succesfully redirect to OTP input screen
                    
                    // save new email || save newContact for verify request
                    
                case .failure:
                    print("FAILED to submit request");
                }
        }
    }
    
    func sendContactUpdateVerifyRequest(oldContact: Int, newContact: Int, otp: Int, email: String) {
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        let url = Constant().baseURL+"users/"+uid!+"/update/verify?access_token=" + authToken!;
        let parameters: Parameters = [
            "oldContact": oldContact,
            "newOldContact": newContact,
            "email": email,
            "otp": otp
        ]
        
        Alamofire.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("REQ ", response.request ?? "")
                switch response.result {
                case .success:
                    
                    print("Updated Successfully")
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    
                    // save to local storage in contact field
                    
                case .failure:
                    print("FAILED to submit request");
                }
        }
    }
    
    func sendProfileUpdateRequest(name: String, dob: String, gender: String) {
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        let url = Constant().baseURL+"users/"+uid!+"?access_token=" + authToken!;
        let parameters: Parameters = [
            "name": name,
            "dob": dob,
            "gender": gender
        ]
        
        Alamofire.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("REQ ", response.request ?? "")
                switch response.result {
                case .success:
                    
                    print("Profile Updated Successfully")
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    
                case .failure:
                    print("FAILED to update profile");
                }
        }
    }
    
    func sendProfileUpdateRequestForBrowseUser(name: String, dob: String, gender: String, email: String) {
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        let url = Constant().baseURL+"users/"+uid!+"/browse?access_token=" + authToken!;
        let parameters: Parameters = [
            "name": name,
            "dob": dob,
            "gender": gender,
            "email": email
        ]
        
        Alamofire.request(url,method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print("REQ ", response.request ?? "")
                switch response.result {
                case .success:
                    
                    print("Profile Updated for Browse User Successfully")
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                    }
                    
                case .failure:
                    print("FAILED to update profile");
                }
        }
    }
    func profileUpdating(){
        //        self.saveB.alpha=1
        self.saveB.isEnabled=true
        
    }
    func profileNotUpdating(){
        //        self.saveB.alpha = 0.5
        self.saveB.isEnabled=false
        
    }
    func didDataChange() {
        if (self.mPhone != phNumber.text && phNumber.text != "") || (self.mEmail != email.text && email.text != "")  {
            
            self.profileUpdating()
        }else{
            self.profileNotUpdating()
        }
    }
    func saveDetailsApi(oldContact: Int, newContact: Int, email: String){
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.saveDetailsApi(oldContact: oldContact, newContact: newContact, email: email)
            }}else
        {NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        var parameters: Parameters = [
            "email": email
        ]
        
        var url = Constant().baseURL+"users/\(uid!)"
        if preferences.bool(forKey: "isBrowseOnly"){
            url += "/browse"
        }else{
            parameters["oldContact"] = oldContact
            parameters["newContact"] = newContact
        }
        url += "?access_token=\(authToken ?? "")"
        
        Alamofire.request(url,method: .put, parameters: parameters ).responseJSON{ response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("URL ", response.request ?? "")
            switch response.result {
            case .success: if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let offer = UploadReviewResponse(JSONString: utf8Text)
                let code = offer?.code
                if code == 200{
                    //  Show it to your users
                    let preferences = UserDefaults.standard
                    preferences.set(self.phNumber.text, forKey: "contact")
                    preferences.set(self.email.text, forKey: "email")
                    let didSave = preferences.synchronize()
                    if !didSave {
                        print("Unable to save data!")
                    }else{
                        print("Data Saved!")
                    }
                    let alertView = UIAlertController(title: "Success", message: "Profile saved", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler:{
                        action in
                        if(action.style == .default){
                            print("Offer redeemed successfully")
                        }
                    }
                    ))
                    self.present(alertView, animated: true, completion: nil)
                }else{
                    self.apiErrorHandlerCancellable(code: code, msg: offer?.msg, function: {
                        self.self.saveDetailsApi(oldContact: oldContact, newContact: newContact,  email: email)
                    })
                }
                }
            case .failure:self.errorDialog(function: {
                self.saveDetailsApi(oldContact: oldContact, newContact: newContact,  email: email)
                
            })
            print("Error Ocurred in redeeming offer!")
            }
        }
}    }
}
