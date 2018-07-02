//
//  OfferRedeemViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 12/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView


class OfferRedeemViewController: UIViewController,NVActivityIndicatorViewable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBOutlet weak var redeemB: UIButton!
    @IBOutlet weak var TandC: UIButton!
    @IBOutlet weak var estabName: UILabel!
    @IBOutlet weak var offerDesc: UILabel!
    var clientName = String()
    var offer = String()
    var couponId = String()
    
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    @IBOutlet weak var third: UITextField!
    @IBOutlet weak var fourth: UITextField!
    @IBOutlet weak var fifth: UITextField!
    
    @IBOutlet weak var offerL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        redeemB.isHidden = true
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        fifth.delegate = self
        
        self.estabName.text = self.clientName
        self.offerDesc.text = self.offer
    }
    
    @IBAction func redeemOffer(_ sender: Any) {
        let pin = first.text!+second.text!+third.text!+fourth.text!+fifth.text!
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.callredeemOffer(self.self.couponId,pin)
            }}
        else{
            self.callredeemOffer(couponId,pin)}
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        let buttonTitleStr = NSMutableAttributedString(string:"All general T&C applicable", attributes:[NSAttributedStringKey.font : UIFont(name: "Hind-SemiBold", size: 12) ?? .systemFont(ofSize: 12),
                                                                                                        NSAttributedStringKey.foregroundColor : UIColor.white,
                                                                                                        NSAttributedStringKey.underlineStyle : 1])
        
        TandC.setAttributedTitle(buttonTitleStr, for: .normal)
        
        
        redeemB.layer.cornerRadius = 20
        redeemB.layer.shadowOffset = CGSize(width: 0, height: 10)
        redeemB.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        redeemB.layer.shadowOpacity = 1
        redeemB.layer.shadowRadius = 20
        
        
        let gradient = CAGradientLayer()
        gradient.frame = redeemB.bounds
        gradient.colors = [    UIColor(red:1, green:0.45, blue:0.46, alpha:1).cgColor,    UIColor(red:0.31, green:0.38, blue:0.5, alpha:1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        gradient.cornerRadius = 20
        redeemB.layer.addSublayer(gradient)
        
    }
    
}
extension OfferRedeemViewController: UITextFieldDelegate{
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
            
            redeemB.isHidden = false
        }else{
            redeemB.isHidden = true
        }
    }
    
    // Already redeemed error bhi aaeyga so just show the error message
    func callredeemOffer(_ couponId: String,_ pin: String) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let header: HTTPHeaders = [
            "pin": pin.uppercased()
        ]
        
        let url = Constant().baseURL+"users/\(uid!)/coupons/\(couponId)/redeem?access_token=\(authToken ?? "")"

        Alamofire.request(url,method: .put, parameters: header).responseJSON{ response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("URL ", response.request ?? "")
            switch response.result {
            case .success: if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let offer = otp(JSONString: utf8Text)
                let code = offer?.code
                if code == 200{
                    //  Show it to your users
                    let alertView = UIAlertController(title: "Success", message: offer?.msg, preferredStyle: .alert)
                    
                    alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler:{
                        action in
                        if(action.style == .default){
                            print("Offer redeemed successfully")
                        }
                    }
                    ))
                    self.present(alertView, animated: true, completion: nil)
                }else{
                    self.apiErrorHandlerCancellable(code: code, msg: offer?.msg, function: {
                        self.self.callredeemOffer(couponId, pin)
                    })
                }
                }
            case .failure:self.errorDialog(function: {
                self.callredeemOffer(couponId, pin)
                
            })
            print("Error Ocurred in redeeming offer!")
            }
        }
    }
   
    
}
