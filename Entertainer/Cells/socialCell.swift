//
//  socialCell.swift
//  Entertainer
//
//  Created by WisOpt on 10/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class socialCell: UITableViewCell,
UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    var social = ["Blog","Website","Instagram","Facebook"]
    let imageList:[UIImage] = [#imageLiteral(resourceName: "article"),#imageLiteral(resourceName: "logo_without_bkg"),#imageLiteral(resourceName: "instagram_logo"),#imageLiteral(resourceName: "facebook_logo")]
    let linkList=["https://blog.entertainerindia.com","https://entertainerindia.com",
                  "https://www.instagram.com/theentertainerindia","https://www.facebook.com/theentertainerindia"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return social.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "socialCollectionCell", for: indexPath) as! socialCollectionCell
        cell.backgroundColor = UIColor.clear
        cell.socialName.text = social[indexPath.row]
        cell.logo.image=imageList[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat((collectionView.frame.size.width / 2 - 20)), height: CGFloat(50))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openBrowser(url:self.linkList[indexPath.row])
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
