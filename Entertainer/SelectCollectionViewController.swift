//
//  SelectCollectionViewController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 11/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class SelectCollectionViewController: UIViewController,NVActivityIndicatorViewable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    @IBOutlet weak var resturantsCollectionView: UICollectionView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionImg: UIImageView!
    var cImg = UIImage()
    var cName = String()
    var collectionIndex = Int()
    var categories = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionImg.image = cImg
        self.collectionName.text = cName
        // Do any additional setup after loading the view.
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.getCollections(self.collectionIndex)
            }
        } else
        {self.getCollections(collectionIndex)}
    }
    
}
extension SelectCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueForResturantScreen", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2 - 10)), height: CGFloat(170))
    }
}

extension SelectCollectionViewController{
    
    func reloadCollectionView(_ cData: [Client]){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.categories = cData
            
            self.resturantsCollectionView.reloadData()
        }
    }
    
    func getCollections(_ collection: Int) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        let preferences = UserDefaults.standard
        
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let filter = "[{ \"in_collection\":\(collection-1)}]"
        let params = ["filter": filter,"access_token": authToken ?? ""] as [String:Any]
        Alamofire.request(Constant().baseURL+"clients",method: .get, parameters: params, encoding: URLEncoding.queryString).responseJSON{ response in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("URL ", response.request ?? "")
            print(collection)
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let client = Client_category(JSONString: utf8Text)
                    let code = client?.code
                    
                    if code == 200{
                        print("Got collection data successfully")
                        self.reloadCollectionView((client?.clients)!)
                    }else{self.apiErrorHandler(code: code, msg: client?.msg, function: {
                        self.self.getCollections(collection)
                    })
                        
                        print("Unable to get collection data")
                    }
                }
            case .failure:self.errorDialog(function: {
                self.getCollections(collection)
                
            })
            print("Error Ocurred in getting collection data!")
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
