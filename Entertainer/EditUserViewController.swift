//
//  EditUserViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 18/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import Alamofire
import NVActivityIndicatorView

class EditUserViewController: UIViewController,UITextFieldDelegate,NVActivityIndicatorViewable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    @IBOutlet weak var genderTF: JVFloatLabeledTextField!
    @IBOutlet weak var dobTF: JVFloatLabeledTextField!
    @IBOutlet weak var nameTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var saveB: UIButton!
    let preferences = UserDefaults.standard
    var  gender :String?=nil
    var  dob :String?=nil
    var  name :String?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        genderTF.delegate=self
        dobTF.delegate=self
        //        nameTF.delegate=self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.placeholder=="Date of Birth"{
            showDatePicker()
        }else if textField.placeholder=="Gender"{
            genderAlert()
        }
        return false
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showDatePicker(){
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = 0
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: minDate, maximumDate: maxDate) { date in
            self.dobTF.text=self.convertDateFormater(date)
        }
        alert.addAction(title: "OK", style: .cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    func convertDateFormater(_ date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return  dateFormatter.string(from: date)
        
    }
    
    @IBAction func onGenderPressed(_ sender: Any) {
        genderAlert()
    }
    func genderAlert(){
        let alert = UIAlertController(style: .alert)
        alert.set(title:"Please select you gender", font: .systemFont(ofSize: 20), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 1))
        alert.addAction(image: nil, title: "Male", color: #colorLiteral(red: 0.3923987448, green: 0.4124389887, blue: 0.4334673882, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in self.genderTF.text="Male"});
        alert.addAction(image: nil, title: "Female", color: #colorLiteral(red: 0.3923987448, green: 0.4124389887, blue: 0.4334673882, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in self.genderTF.text="Female"});
        alert.addAction(image: nil, title: "Other", color: #colorLiteral(red: 0.3923987448, green: 0.4124389887, blue: 0.4334673882, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in
            self.genderTF.text="Other"
        });
        self.present(alert, animated: true, completion: nil)
    }
    
    //    @IBAction func genderPressed(_ sender: Any) {
    ////        self.didDataChange()
    ////        print("data changed")
    //    }
    //    @IBAction func dobPressed(_ sender: Any) {
    ////        self.didDataChange()
    ////        print("data changed")
    //    }
    //    @IBAction func namePressed(_ sender: Any) {
    ////        self.didDataChange()
    ////        print("data changed")
    //    }
    func setupView(){
        gender = self.preferences.string(forKey: "gender") ?? ""
        
        dob = self.preferences.string(forKey: "dob") ?? ""
        name = self.preferences.string(forKey: "name") ?? ""
        saveB.layer.cornerRadius = 20
        saveB.layer.shadowOffset = CGSize(width: 0, height: 10)
        saveB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        saveB.layer.shadowOpacity = 1
        saveB.layer.shadowRadius = 20
        if name != ""
        {self.nameLbl.text=name}
        
        if self.gender != nil {
            genderTF.insertText(self.gender!)
        }
        if self.dob != nil {
            dobTF.insertText(self.dob!)
        }
        if self.name != nil {
            nameTF.insertText(self.name!)
        }
    }
    @IBAction func onSavePressed(_ sender: Any) {
        if (self.gender != genderTF.text && genderTF.text != "") || (self.dob != dobTF.text && dobTF.text != "") || (self.name != nameTF.text && nameTF.text != "") {
            
            self.saveDetailsApi()
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
        if (self.gender != genderTF.text && genderTF.text != "") || (self.dob != dobTF.text && dobTF.text != "") || (self.name != nameTF.text && nameTF.text != "") {
            
            self.profileUpdating()
        }else{
            self.profileNotUpdating()
        }
    }
    func saveDetailsApi(){
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.saveDetailsApi()
            }}else{
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
            let preferences = UserDefaults.standard
            let uid = preferences.string(forKey: "ID")
            
            let authToken = preferences.string(forKey: "AUTHTOKEN")
            
            let params = [
                "name":nameTF.text!,
                "dob":dobTF.text!,
                "gender":genderTF.text!
                ] as [String : String]
            
            var url = Constant().baseURL+"users/\(uid!)"
            if preferences.bool(forKey: "isBrowseOnly"){
                url += "/browse"
            }
            url += "?access_token=\(authToken ?? "")"
            
            Alamofire.request(url,method: .put, parameters: params ).responseJSON{ response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                print("URL ", response.request ?? "")
                switch response.result {
                case .success: if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let offer = UploadReviewResponse(JSONString: utf8Text)
                    let code = offer?.code
                    if code == 200{
                        //  Show it to your users
                        let preferences = UserDefaults.standard
                        preferences.set(self.genderTF.text, forKey: "gender")
                        preferences.set(self.dobTF.text, forKey: "dob")
                        preferences.set(self.nameTF.text, forKey: "name")
                        
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
                            self.self.saveDetailsApi()
                        })
                    }
                    }
                case .failure:self.errorDialog(function: {
                    self.saveDetailsApi()
                    
                })
                print("Error Ocurred in redeeming offer!")
                }
            }}
    }
    
}


