//
//  ProfileViewSettingsController.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 11/01/18.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController
    //,UICollectionViewDataSource
{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    let titleL = ["User Details","Contact Details","Logout","Terms of Use","Privacy Policy","Blog"]
    var color = ["506180"]
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        screenSize = UIScreen.main.bounds
        //        screenWidth = screenSize.width
        //        screenHeight = screenSize.height
        //
        //        let myNib = UINib(nibName: "(1.1)HeaderCell",bundle: nil)
        //        collectionView.register(myNib, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headerCell")
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    //        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    ////        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
    //        layout.minimumInteritemSpacing = 0
    //        layout.minimumLineSpacing = 10
    //        collectionView!.collectionViewLayout = layout
    //    }
    //
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onLogoutPressed(_ sender: Any) {
        signOut()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="webViewVCTOU"{
            prepareForSegue(type: 0, segue: segue)
        }
        else if segue.identifier=="webViewVCPP"{
            prepareForSegue(type: 1, segue: segue)
        }
        else if segue.identifier=="webViewVCBlog"{
            prepareForSegue(type: 2, segue: segue)
        }
        
    }
    func prepareForSegue(type:Int, segue: UIStoryboardSegue) {
        let controller = segue.destination as! WebViewVC
        switch type {
        case 0:
            controller.frameName="TERMS OF USE"
            controller.url="https://entertainerindia.com/terms-of-use"
        case 1:
            controller.frameName="PRIVACY POCILY"
            controller.url="https://entertainerindia.com/privacy-policy"
        case 2:
            controller.frameName="BLOG"
            controller.url="https://blog.entertainerindia.com"
        default:
            controller.frameName="PROFILE"
            controller.url="https://entertainerindia.com"
        }
    }
}
//extension ProfileSettingsViewController:UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return titleL.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCell
////        cell.contentView.layer.cornerRadius = 5
////        cell.contentView.layer.masksToBounds = false
////
////        cell.layer.shadowColor = UIColor.gray.cgColor
////        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
////        cell.layer.shadowRadius = 2.0
////        cell.layer.shadowOpacity = 1.0
////        cell.layer.masksToBounds = false
////
////        cell.frame.size.width = screenWidth / 2
////        cell.frame.size.height = screenWidth / 2
//
//
//        cell.Label?.text = titleL[indexPath.row]
//        return cell
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: CGFloat((collectionView.frame.size.width / 2) - 20), height: CGFloat(72))
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0{
//            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "editUD") as! EditUserViewController
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//        if indexPath.row == 1{
//            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "editCD") as! EditContactViewController
//            self.navigationController?.pushViewController(controller, animated: true)
//        }
//}
//}

