//
//  ResturantsViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 29/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import  Alamofire
import NVActivityIndicatorView
class ResturantsViewController: UIViewController,NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet var resturantsCollectionView: UICollectionView!
    @IBOutlet weak var categoryL: UILabel!
    
    var categories = [Client]()
    var subcategories = [String]()
    var categoryLText = String()
    var clientName = String()
    var sub_categoryLText = String()
    var partnerCount = 0
    var clientId = String()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        categoryL.text = categoryLText.uppercased()
        categoryL.kerning = 2
        self.hidesBottomBarWhenPushed = false
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.getCategoryWiseData(category: self.categoryLText)
            }
        }else
        {        self.getCategoryWiseData(category: categoryLText)
        }
        if subcategories[0]==""{
            self.subCategoryCollectionView.isHidden=true        }
        
    }
    func reloadCollectionView(_ cData: [Client],_ count: Int){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.categories = cData
            self.partnerCount=count
            self.resturantsCollectionView.reloadData()
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueForResturantScreen") {
            //get a reference to the destination view controller
//            let storyboard = UIStoryboard(name: "Host", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "hostVC") as HostViewController
//            controller.client_id = self.clientId
//            controller.clientName = self.clientName
//            self.present(controller, animated: true, completion: nil)
            let controller = segue.destination as! HostViewController
            controller.client_id = self.clientId
            controller.clientName = self.clientName
        }
        if (segue.identifier == "subCategorySegue") {
            //get a reference to the destination view controller
            if subcategories.count != 0{
                let controller = segue.destination as! SubCategoryViewController
                controller.subCategoryLText = sub_categoryLText}
        }
    }
}
extension ResturantsViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == subCategoryCollectionView{
            return subcategories.count
        }
        else{
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == subCategoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCollectionCell
            cell.category.text = subcategories[indexPath.row]
            return cell
        }
        else{
            
            let cell = resturantsCollectionView.dequeueReusableCell(withReuseIdentifier: "resturantCell", for: indexPath) as! resturantCollectionViewCell
            
            cell.title.text = categories[indexPath.row].establishmentName
            //cell.distance.text = categories[indexPath.row].d
            cell.cuisine.text = categories[indexPath.row].category
            cell.offersNo.text = "\(String(describing: categories[indexPath.row].coupons?.count ?? 0)) OFFERS"
            
            if let rating = categories[indexPath.row].rating{
                if rating == 0 {
                    cell.unratedL.isHidden = false
                    cell.rating.isHidden = true
                } else {
                    cell.unratedL.isHidden = true
                    cell.rating.rating = Double(rating)
                }
            }
            if let bgImg = categories[indexPath.row].imgUrl {
                if bgImg.count == 0{
                    cell.imageView.image = #imageLiteral(resourceName: "logo_without_bkg")
                }else{
                    let url = URL(string: bgImg[0])
                    cell.imageView.kf.setImage(with: url)
                }
            }
            
            
            return cell
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == subCategoryCollectionView{
            if subcategories[indexPath.row] != ""{
                self.sub_categoryLText = subcategories[indexPath.row]
                self.performSegue(withIdentifier: "subCategorySegue", sender: self)}
        }else{
            self.clientId = categories[indexPath.row].id ?? ""
            self.clientName = categories[indexPath.row].establishmentName ?? ""
            self.performSegue(withIdentifier: "segueForResturantScreen", sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == subCategoryCollectionView{
            let size = subcategories[indexPath.row].size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
            return CGSize(width: size.width+24, height: collectionView.bounds.size.height)
        }else{
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2 - 10)), height: CGFloat(170))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let countCell = resturantsCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "partnerCountCell", for: indexPath) as! PartnerCountCell
        countCell.count.text = "\(partnerCount) Entertainer partners around you."
        return countCell
    }
    
    // Category Wise
    func getCategoryWiseData(category: String) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let filter = "[{ \"category\":\"" + category + "\"}]"
        let params = ["filter": filter,"access_token": authToken ?? ""] as [String:Any]
        Alamofire.request(Constant().baseURL+"clients",method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON{ response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("URL ", response.request ?? "")
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let client = Client_category(JSONString: utf8Text)
                    let code = client?.code
                    
                    if code == 200{
                        print("Got category data successfully")
                        self.reloadCollectionView((client?.clients)!,(client?.count)!)
                    }
                    else{
                        self.apiErrorHandler(code: code, msg: client?.msg, function: {
                            self.self.getCategoryWiseData(category: category)
                        })
                        
                    }
                }
                
            case .failure:
                self.errorDialog(function: {
                    self.getCategoryWiseData(category: category)
                    
                })
                
                print("Error Ocurred in getting category data!")
            }
        }
    }
}
