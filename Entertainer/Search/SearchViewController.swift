//
//  SearchViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 01/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import Alamofire
import NVActivityIndicatorView

class SearchViewController: UIViewController,NVActivityIndicatorViewable{

    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    @IBOutlet weak var segmentControl: ScrollableSegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var categories = [CategoriesToSend]()
    var categoriesToSend = [CategoriesToSend]()
     var client = [Client]()
    var arrayName = ""
    var segmentCheck = -1
    var selectedCategory = String()
    var count = Int()
    var clientId = String()
    var clientName = String()
    
    let preferences = UserDefaults.standard
 
   
    override func viewDidLoad() {
      
        collectionView.dataSource = self
        collectionView.delegate = self
        super.viewDidLoad()
        self.segmentControl.isHidden = true
        self.searchBar.delegate = self
        self.tableView.isHidden = true
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
              self.getSearchClient(["recommended" : true],self.preferences.string(forKey: "AUTHTOKEN")!)
            }
        } else
            {self.getSearchClient(["recommended" : true],preferences.string(forKey: "AUTHTOKEN")!)}
        // Give some left padding between the edge of the search bar and the text the user enters
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffsetMake(10, 0)
    }
    
     //EXPLAIN
    func getSearchClient(_ filter:Dictionary<String, Any>?,_ authToken:String){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        var jsonString: String?
       if filter != nil{ do {
        var dictionary = filter!
        for key in dictionary.keys {
            if dictionary[key] as? String  == ""{
                dictionary[key]=nil
            }
        }
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON", jsonString ?? "")
        } catch let error as NSError {
            print(error)
        }}else {
        jsonString=""
        }
        var f = "[" + jsonString!
        if filter != nil && (filter!["recommended"] as? Bool) == nil
       { f+=",{\"skip\": 0, \"limit\": 10 }"}
        f+="]"
        let param = ["filter" : f,"access_token": authToken] as [String:Any]
        
       
        Alamofire.request(Constant().baseURL+"clients",method: .get, parameters: param, encoding: URLEncoding.queryString).responseJSON { response in      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print("REQ ", response.request ?? "")
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let searchTxt = search_Client(JSONString: utf8Text)
                    let code = searchTxt?.code
                    
                    if code == 200{
//                        if filter["recommended"] != nil {
//                             self.mainSearchClients = (searchTxt?.clients)!
//                        }
//
                        self.categoriesToSend=(searchTxt?.categoriesToSend)!
                        print("Got search data successfully")
                        self.client.removeAll()
                 self.reloadView((searchTxt?.categoriesToSend)!,(searchTxt?.clients)!,(searchTxt?.count)!)
                    }else{ self.apiErrorHandler(code: code, msg: searchTxt?.msg, function: {
                        self.self.getSearchClient(filter, authToken)
                    })
                        print("Unable to search")
                    }
                }
            case .failure:self.errorDialog(function: {
                self.getSearchClient(filter, authToken)
                
            })
                print("Error Ocurred in getting search data!")
            }
        }
    }
    
    func reloadView(_ cData: [CategoriesToSend],_ clData: [Client],_ count: Int){
        DispatchQueue.main.async{
            print("Refreshing data")
            self.categories = cData
            self.client = clData
           self.count = count
            
            self.collectionView.reloadData()
            self.tableView.reloadData()
            if self.segmentCheck == -1{
                self.loadHeader()
                self.segmentCheck = 0
            }
        }
    }
}
extension SearchViewController:UISearchBarDelegate{
    
    
    override func viewDidAppear(_ animated: Bool) {
        
      
          self.navigationController?.tabBarItem.title = "•"
        searchBar.showsCancelButton = false
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
         searchTextField.leftViewMode = UITextFieldViewMode.never
        
        searchTextField.font = UIFont(name: "Poppins-Bold", size: 19)
        searchTextField.textColor = UIColor(rgb: 0xD6CACA)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "S E A R C H  H E R E", attributes: [NSAttributedStringKey.foregroundColor:UIColor(rgb: 0xD6CACA),NSAttributedStringKey.font:UIFont(name: "Poppins-Bold", size: 19.0)!])
        searchTextField.rightView = UIImageView.init(image: #imageLiteral(resourceName: "search"))
        searchTextField.rightViewMode = UITextFieldViewMode.always
    }
    override func viewDidDisappear(_ animated: Bool) {
           self.navigationController?.tabBarItem.title = " "
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {  client.removeAll()
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
             self.getSearchClient([:],self.preferences.string(forKey: "AUTHTOKEN")!)
            }
        } else
        {self.getSearchClient([:],preferences.string(forKey: "AUTHTOKEN")!)}
        
        // Show the cancel button
        searchBar.showsCancelButton = true
        self.segmentControl.isHidden = false
        self.collectionView.isHidden = true
        self.tableView.isHidden = false
        print("Show categories")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search \(String(describing: searchBar.text))")
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.segmentControl.isHidden = true
        self.collectionView.isHidden = false
        self.collectionView.heightAnchor.constraint(equalToConstant: 531).isActive = true
        self.tableView.isHidden = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        searchBar.resignFirstResponder()
        selectedCategory=""
        // Hide the cancel button
        searchBar.showsCancelButton = false
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
               self.getSearchClient(["recommended" : true],self.preferences.string(forKey: "AUTHTOKEN")!)
            }
        } else
        {self.getSearchClient(["recommended" : true],preferences.string(forKey: "AUTHTOKEN")!)}
      
    }
    func loadHeader(){
        
        // Style the Segmented Control
        segmentControl.segmentStyle = .textOnly
     
        //SET WIDTH
        //add categories in segment control
        segmentControl.insertSegment(withTitle: "Everything" , at: 0)
       
        for  i in (0..<categories.count){
            if let category = categories[i].category{
                segmentControl.insertSegment(withTitle: "\(category)" , at: i+1)
            }
        }
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(rgb: 0xfafafa),NSAttributedStringKey.font:UIFont(name: "Poppins-Bold", size: 15.0)!], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor(rgb: 0xfafafa),NSAttributedStringKey.font:UIFont(name: "Poppins-Bold", size: 15.0)!], for: .selected)
        segmentControl.backgroundColor = UIColor(rgb: 0x1A2029)
        segmentControl.tintColor = UIColor(rgb: 0x1A2029)
       
        
        segmentControl.addTarget(self, action: #selector(changeArray(_:)), for: .valueChanged)
    }
    
    //EXPLAIN
    @objc func changeArray(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        let choice = sender.selectedSegmentIndex
        switch(choice){
        case 0:
            client.removeAll()
            if Connectivity.isNotConnectedToInternet{
                noInternetDialogCancellable {
                   self.getSearchClient(nil,authToken ?? "")
                }
            } else

             {self.getSearchClient(nil,authToken ?? "")}
        case 1...categories.count:
            if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
                self.selectedCategory = self.categoriesToSend[choice-1].category ?? ""
                print(self.categoriesToSend[choice-1].category)
                self.getSearchClient(["category":self.selectedCategory as String],authToken ?? "") }
            } else{self.selectedCategory = self.categoriesToSend[choice-1].category ?? ""
                self.getSearchClient(["category":self.selectedCategory as String],authToken ?? "")}
            
        default:
            print("Wrong choice!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueForHostVC") {
            //get a reference to the destination view controller
            let controller = segue.destination as! HostViewController
            controller.client_id = self.clientId
             controller.clientName = self.clientName
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search ", searchText);
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        // need category here
        if Connectivity.isNotConnectedToInternet{
            noInternetDialogCancellable {
              self.getSearchClient(["establishment_name":searchText,"category":self.selectedCategory], authToken ?? "")
            }
        } else
        {self.getSearchClient(["establishment_name":searchText,"category":self.selectedCategory], authToken ?? "")}

        /*}else{
              self.getSearchClient(["establishment_name":searchText,"category":selectedCategory], authToken ?? "")
        }*/
    }
}
extension SearchViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return client.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resturantCell", for: indexPath) as! searchCellCollectionViewCell
       
        
       cell.title.text = client[indexPath.row].establishmentName
        //cell.distance.text = distance[indexPath.row]
        cell.cuisine.text = client[indexPath.row].category
        cell.offersNo.text = "\(String(describing: client[indexPath.row].coupons?.count ?? 0)) OFFERS"
        
        if let rating = client[indexPath.row].rating{
            if rating == 0 {
                cell.unratedL.isHidden = false
                cell.rating.isHidden = true
            } else {
                cell.unratedL.isHidden = true
                cell.rating.rating = Double(rating)
            }
        }
        if let bgImg = client[indexPath.row].imgUrl {
            if bgImg.count == 0{
                cell.imageView.image = #imageLiteral(resourceName: "logo_without_bkg")
            }else{
                let url = URL(string: bgImg[0])
                cell.imageView.kf.setImage(with: url)
            }
        }
        
 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let imageCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "imageCell", for: indexPath)
        
        return imageCell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return CGSize(width: CGFloat((collectionView.frame.size.width / 2 - 20)), height: CGFloat(170))
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.clientId = client[indexPath.row].id ?? ""
          self.clientName = client[indexPath.row].establishmentName ?? ""
        self.performSegue(withIdentifier: "segueForHostVC", sender: self)
        
    }
    
}
extension SearchViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return client.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTextCell
        
        let r=indexPath.row
            cell.searchName.text = self.client[r].establishmentName
            cell.searchOffer.text = "\(String(describing: self.client[r].coupons!.count))  O F F E R S"
            if let rating = self.client[r].rating{
                if rating == 0 {
                    cell.unratedL.isHidden = false
                    cell.searchRate.isHidden = true
                } else {
                    cell.unratedL.isHidden = true
                    cell.searchRate.rating = Double(rating)
                }
            }

            if self.client[r].imgUrl?.count == 0 {
                cell.searchImage.image = #imageLiteral(resourceName: "logo_without_bkg")
            } else {
                let url = URL(string: self.client[r].imgUrl![0])
                cell.searchImage.kf.setImage(with: url)
            }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.clientId = client[indexPath.row].id ?? ""
         self.clientName = client[indexPath.row].establishmentName ?? ""
        self.performSegue(withIdentifier: "segueForHostVC", sender: self)
    }
}
