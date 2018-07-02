//
//  SubCategoryViewController.swift
//  Entertainer
//
//  Created by WisOpt on 27/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import  Alamofire
import NVActivityIndicatorView


class SubCategoryViewController: UIViewController,NVActivityIndicatorViewable{
    
    @IBOutlet var resturantsCollectionView: UICollectionView!
    var sub_categories = [Client]()
    var subcategories = [String]()
    var subCategoryLText = String()
    var partnerCount=0
    var clientId = String()
    var clientName = String()
    @IBOutlet weak var subCategoryL: UILabel!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        subCategoryL.text = subCategoryLText.uppercased()
        subCategoryL.kerning = 2
        self.hidesBottomBarWhenPushed = false
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.self.getSubCategoryWiseData(self.subCategoryLText)
            }
        }
        else
        {self.getSubCategoryWiseData(subCategoryLText)}
        
    }
    func reloadCollectionView(_ sData: [Client],_ count: Int){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.sub_categories = sData
            self.partnerCount=count
            //            self.partnerL.text = "\(count) Entertainer partners around you."
            self.resturantsCollectionView.reloadData()
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueForResturantScreen") {
            //get a reference to the destination view controller
            
            let controller = segue.destination as! HostViewController
            controller.client_id = self.clientId
            controller.clientName = self.clientName
        }
    }
}
extension SubCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sub_categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = resturantsCollectionView.dequeueReusableCell(withReuseIdentifier: "resturantCell", for: indexPath) as! resturantCollectionViewCell
        
        cell.title.text = sub_categories[indexPath.row].establishmentName
        cell.cuisine.text = sub_categories[indexPath.row].category
        cell.offersNo.text = "\(String(describing: sub_categories[indexPath.row].coupons?.count ?? 0)) OFFERS"
        
        if let rating = sub_categories[indexPath.row].rating{
            if rating == 0 {
                cell.unratedL.isHidden = false
                cell.rating.isHidden = true
            } else {
                cell.unratedL.isHidden = true
                cell.rating.rating = Double(rating)
            }
        }
        if let bgImg = sub_categories[indexPath.row].imgUrl {
            if bgImg.count == 0{
                cell.imageView.image = #imageLiteral(resourceName: "logo_without_bkg")
            }else{
                let url = URL(string: bgImg[0])
                cell.imageView.kf.setImage(with: url)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clientId = sub_categories[indexPath.row].id!
        self.clientName = sub_categories[indexPath.row].establishmentName!
        self.performSegue(withIdentifier: "segueForResturantScreen", sender: self)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2 - 10)), height: CGFloat(170))
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let countCell = resturantsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "partnerCountCell", for: indexPath) as! PartnerCountCell
        countCell.count.text = "\(partnerCount) Entertainer partners around you."
        return countCell
    }
    
    // SUB Category wise
    func getSubCategoryWiseData(_ sub_category: String) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let filter = "[{ \"sub_categories\":\"" + sub_category + "\"}]"
        let params = ["filter": filter,"access_token": authToken ?? ""] as [String:Any]
        
        Alamofire.request(Constant().baseURL+"clients",method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON{ response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("URL ", response.request ?? "")
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let sub_client = Client_category(JSONString: utf8Text)
                    let code = sub_client?.code
                    
                    if code == 200{
                        print("Got sub_category data successfully")
                        self.reloadCollectionView((sub_client?.clients)!,(sub_client?.count)!)
                    }else{self.apiErrorHandler(code: code, msg: sub_client?.msg, function: {
                        self.self.getSubCategoryWiseData(sub_category)
                    })
                        print("Unable to get sub_category data")
                    }
                }
            case .failure:self.errorDialog(function: {
                self.getSubCategoryWiseData(sub_category)
                
            })
            print("Error Ocurred in getting sub_category data!")
            }
        }
    }
}

