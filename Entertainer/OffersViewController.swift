//
//  OffersViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 06/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire

import NVActivityIndicatorView
class OffersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,NVActivityIndicatorViewable  {
    
    @IBOutlet weak var clientNameLbl: UILabel!
    var clientId = String()
    var couponId = String()
    var clientName = String()
    var offers = [ClientOfferResult]()
    @IBOutlet weak var offerList: UICollectionView!
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offerList.dataSource = self
        offerList.delegate = self
        clientNameLbl.text=clientName
        getOffers(clientId: self.clientId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return offers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = offerList.dequeueReusableCell(withReuseIdentifier: "offerCell", for: indexPath) as! offersCollectionViewCell
        let offer=offers[indexPath.row]
        if offer.isUsed!{
            cell.usedOfferOverlay.isHidden=false
        }else{
            cell.usedOfferOverlay.isHidden=true
        }
        if offer.imgUrl == nil {
            cell.imageView.image = #imageLiteral(resourceName: "logo_without_bkg")
        }else{
            let url = URL(string: offer.imgUrl!)
            cell.imageView.kf.setImage(with: url)
        }
//        cell.imageView.k=offer.imgUrl
        cell.textView.text=offer.descriptionField
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        let isUsed = offer.isUsed!
        if !isUsed{
        self.couponId = offer.id!
            performSegue(withIdentifier: "redeemVCSegue", sender: self)}else{
            self.showAlert(title: "Already Reedeed", msg: "Try other coupons.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="redeemVCSegue"{
            let controller = segue.destination as! OfferRedeemViewController
            controller.couponId=self.couponId
            controller.clientName = self.clientName
        }
    }
    
}
extension OffersViewController {
    func getOffers(clientId:String){
        //Add api
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                
                self.getOffers(clientId: clientId)
            }
            
        }
        else{           let preferences = UserDefaults.standard
            let authToken = preferences.string(forKey: "AUTHTOKEN")
            let uid=preferences.string(forKey: "ID")
            
            let param = ["clientId":clientId,"access_token": authToken!]
            
            Alamofire.request(Constant().baseURL+"users/"+uid!+"/coupons",method: .get, parameters: param, encoding: URLEncoding.queryString).responseJSON { response in
                print(response.request ?? "")
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let offersRes = ClientOfferResponse(JSONString: utf8Text)
                        let code = offersRes?.code
                        
                        if code == 200{
                            self.offers.removeAll()
                            self.offers=(offersRes?.result)!.sorted(by: { (a, b) -> Bool in
                                if a.isUsed! {return false}
                                if b.isUsed! {return false}else{return true}
                            })
                            self.offerList.reloadData()
                        }else{self.apiErrorHandler(code: code, msg: offersRes?.msg, function: {
                            self.self.getOffers(clientId: clientId)
                            
                            
                        })
                            print("Unable to search")
                        }
                    }
                case .failure:self.errorDialog(function: {
                    self.getOffers(clientId: clientId)
                    
                })
                print("Error Ocurred in getting profile data!")
                }
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
        }
    }
}
