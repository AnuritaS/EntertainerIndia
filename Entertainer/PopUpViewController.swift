//
//  PopUpViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 12/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire

import NVActivityIndicatorView
class PopUpViewController: UIViewController,NVActivityIndicatorViewable{
    
    @IBOutlet var popupCollection: UICollectionView!
    @IBOutlet weak var clientLogo: UIImageView!
    @IBOutlet weak var clientName: UILabel!
    var clientDetails = [ResultPopup]()
    var clientNameStr = String()
    var clientLogoStr = String()
    var clientId = String()
    var offerDesc = String()
    var couponId = String()
    
    @IBOutlet weak var pageCntrl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupCollection.delegate = self
        popupCollection.dataSource = self
        
        self.clientName.text = self.clientNameStr
        
        print("logo",self.clientLogoStr)
        let url = URL(string: self.clientLogoStr)
        self.clientLogo.kf.setImage(with: url)
        
        self.setupView()
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.getCouponsDataByClientId(self.clientId)
            }
        }else
        {self.getCouponsDataByClientId(clientId)}
    }
    
}

extension PopUpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(clientDetails.count)
        return clientDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let popupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "popup_cell", for: indexPath) as! PopUpCollectionViewCell
        
        popupCell.layer.cornerRadius = 6
        popupCell.offerL.text = clientDetails[indexPath.row].descriptionField
        popupCell.offerDL.text = clientDetails[indexPath.row].details
        
//        self.pageCntrl.currentPage = Int((popupCollection.contentOffset.x + popupCollection.frame.width / 2) / popupCollection.frame.width)
        
        let exp_date = clientDetails[indexPath.row].expiry ?? ""
        
        //\(daySuffix(from:  exp_date.toDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")!))
        
        let date = exp_date.toDateString(inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", outputFormat: "dd MMMM yyyy") ?? ""
        
        popupCell.expiryL.text =  "EXPIRES ON \(date)"
        
        let url = URL(string: clientDetails[indexPath.row].imgUrl ?? "")
        popupCell.img.kf.setImage(with: url)
        
        self.offerDesc = clientDetails[indexPath.row].details ?? ""
        self.couponId=clientDetails[indexPath.row].id!
        
        popupCell.onButtonTapped = {
            //Do whatever you want to do when the button is tapped here
            if !self.isBrowseUser(){
                self.performSegue(withIdentifier: "offerSegue", sender: self)}
        }
        return popupCell
    }
   
    func isBrowseUser()->Bool{
        let preferences = UserDefaults.standard
        if preferences.bool(forKey: "isBrowseOnly"){
            let alert = UIAlertController(style: .alert)
            alert.set(title:"Hey! Looks like you have discovered a premium feature.", font: .systemFont(ofSize: 20), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 1))
            alert.set(message: "Upgrade to premium.", font: .systemFont(ofSize: 16), color: #colorLiteral(red: 0.1019607843, green: 0.1254901961, blue: 0.1607843137, alpha: 0.8329676798))
            alert.addAction(image: nil, title: "Upgrade", color: #colorLiteral(red: 0.3923987448, green: 0.4124389887, blue: 0.4334673882, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in
                self.openBrowser(url: "https://entertainerindia.com/buy")
            });
            alert.addAction(image: nil, title: "Cancel", color: #colorLiteral(red: 1, green: 0.4549019608, blue: 0.4588235294, alpha: 1), style: .default, isEnabled: true, handler: {(alert: UIAlertAction!) in });
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
    func openBrowser(url:String?){
        let mUrl=URL(string:url!)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(mUrl!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(mUrl!)
        }
    }
    
}
extension PopUpViewController{
    
    func reloadCollectionView(_ clientDetails: [ResultPopup]){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.clientDetails = clientDetails
            self.pageCntrl.numberOfPages = clientDetails.count
            self.popupCollection.reloadData()
        }
    }
    
    func getCouponsDataByClientId(_ clientId: String) {
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        //        let filter = "[\"clientId\":" + clientId + "}]"
        let params = ["clientId": clientId,"access_token": authToken ?? ""] as [String:Any]
        Alamofire.request(Constant().baseURL+"users/\(uid ?? " ")/coupons/available",method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON{ response in
            print("URL ", response.request ?? "")
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let pop = PopUp(JSONString: utf8Text)
                    let code = pop?.code
                    
                    if code == 200{
                        print("Got popupdata successfully")
                        self.reloadCollectionView((pop?.result)!)
                    }else{self.apiErrorHandler(code: code, msg: pop?.msg, function: {
                        self.self.getCouponsDataByClientId(clientId)
                    })
                        print("Unable to search")
                    }
                }
            case .failure:self.errorDialog(function: {
                self.getCouponsDataByClientId(clientId)
                
            })
            print("Error Ocurred in getting popup data!")
            }
            
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "offerSegue"{
            let controller = segue.destination as! OfferRedeemViewController
            controller.clientName = self.clientNameStr
            controller.offer = self.offerDesc
            controller.couponId = self.couponId
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        
        clientLogo.layer.cornerRadius = clientLogo.frame.size.width/2
        clientLogo.clipsToBounds = true
    }
}
