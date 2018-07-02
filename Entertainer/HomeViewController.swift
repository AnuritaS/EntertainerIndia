//
//  HomeViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 01/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeViewController: UIViewController, APIManagerDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var partnerL: UILabel!
    var categories = [CategoriesToSend]()
    var categoryToShow = [SubCategory]()
    var result = [[Result]]()
    var subcategories = [String]()
    var categoryL = String()
    var clientId = String()
    var clientName = String()
    var clientLogoStr = String()
    let sharedInstance = APIManager()
    var partnerCount=0
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkIsLogin()
        let preferences = UserDefaults.standard
        let uid = preferences.string(forKey: "ID")
        let authToken = preferences.string(forKey: "AUTHTOKEN")
        
        print("uid",uid!,"token",authToken ?? "")
        sharedInstance.delegate = self
        if Connectivity.isNotConnectedToInternet{
            noInternetDialog {
                self.sharedInstance.getClient(uid!,authToken!)
            }
        }
        else
       { sharedInstance.getClient(uid!,authToken!)}
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkIsLogin()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = "•"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.tabBarItem.title = " "
    }
    func errorHandler(code: Int?, msg: String?, function: @escaping () -> ()) {
        apiErrorHandler(code: code, msg: msg, function: function)
    }
    func errorHandler(function: @escaping () -> ()) {
        errorDialog {
            function()
        }
    }
    
    
}
extension HomeViewController{
    
    func checkIsLogin(){
        let preferences = UserDefaults.standard
        let IS_LOGIN = preferences.bool(forKey: "IS_LOGIN")
        print("IS_LOGIN: \(IS_LOGIN)")
        
        if(!IS_LOGIN){
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNC")
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    func reloadCollectionView(_ cData: [CategoriesToSend],_ sData: [SubCategory],_ rData: [[Result]],_ partner: Int){
        DispatchQueue.main.async{
            print("Refreshing data")

            self.categories = cData
            self.categoryToShow = sData
            self.result = rData
            
            self.partnerCount = partner
            self.collectionView.reloadData()
            self.tableView.reloadData()
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RestaurantVC") {
            //get a reference to the destination view controller
            let controller = segue.destination as! ResturantsViewController
            
            //set properties on the destination view controller
            controller.subcategories = subcategories
            controller.categoryLText = categoryL
        }
        if (segue.identifier == "segueForPopup"){
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "segueForPopup") as! PopUpViewController
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            popOverVC.clientId = self.clientId
            popOverVC.clientNameStr = self.clientName
            popOverVC.clientLogoStr = self.clientLogoStr
            tabBarController?.present(popOverVC, animated: true)
        }
    }
}
extension HomeViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCollectionCell
        cell.category.text = categories[indexPath.row].category
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pressed \(indexPath.row)")
        self.subcategories = categories[indexPath.row].subCategories!
        self.categoryL = categories[indexPath.row].category!
        performSegue(withIdentifier: "RestaurantVC", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = categories[indexPath.row].category?.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
        return CGSize(width: size!.width+24, height: collectionView.bounds.size.height)
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource,CategoryRowDelegate{
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor(rgb: 0xFAFAFA)
//
//        let headerLabel = UILabel(frame: CGRect(x: 20, y: 0, width:
//            tableView.bounds.size.width, height: tableView.bounds.size.height))
//        headerLabel.font = UIFont(name: "Poppins-Bold", size: 12)
//        headerLabel.textColor = UIColor.black
//        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
//        headerLabel.kerning = 2
//        headerLabel.sizeToFit()
//        headerView.addSubview(headerLabel)
//
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return categoryToShow[section].subCategory?.uppercased()
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return categoryToShow.count+1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        if indexPath.section==0{
          let cell = tableView.dequeueReusableCell(withIdentifier: "partnerCountCell") as! PartnerCountTableCell
            cell.partnerCount.text="\(partnerCount) Entertainer partners around you."
        return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientTableCell", for: indexPath) as! ClientTableCell
        cell.delegate = self
        cell.tag = indexPath.section-1
        cell.categoryBtn.setTitle(categoryToShow[indexPath.section-1].subCategory?.uppercased(), for: .normal)
        cell.collectionView.reloadData()
        cell.result = self.result
        cell.onCategoryTapped = {
            self.subcategories = self.categories[indexPath.row].subCategories!
            self.categoryL = self.categories[indexPath.row].category!
            self.performSegue(withIdentifier: "RestaurantVC", sender: self)
        }
        return cell
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section==0{
//            return 100
//        }
//        return 240
//    }

    func cellTapped(_ clientId: String,_ clientName: String,_ clientLogoStr: String){
        //code for navigation
        self.clientId = clientId
        self.clientName = clientName
        self.clientLogoStr = clientLogoStr
        performSegue(withIdentifier: "segueForPopup", sender: self)
    }
}

