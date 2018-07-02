//
//  loyaltyCardsViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 25/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class loyaltyCardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    var numbers = ["1st","2nd","3rd","4th","5th"]
    var colors = [UIColor(red:52/255,green:176/255,blue:100/255,alpha:1.00),
                  UIColor(red:255/255,green:116/255,blue:117/255,alpha:1.00),
                  UIColor(red:80/255,green:97/255,blue:128/255,alpha:1.00),
                  UIColor(red:26/255,green:32/255,blue:41/255,alpha:1.00),
                  UIColor(red:245/255,green:166/255,blue:35/255,alpha:1.00)]
    var text = ["Get a free drink or dessert of choice.","Get 20% off your bill.","Get 20% off on Sunday brunch menu.","1+1 on desserts.","Hurray, your drinks are on us."]
    
    @IBOutlet weak var loyaltyCardsCollection: UICollectionView!
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loyaltyCardsCollection.delegate = self
        loyaltyCardsCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = loyaltyCardsCollection.dequeueReusableCell(withReuseIdentifier: "loyaltyCard", for: indexPath) as! loyaltyCollectionViewCell
        cell.number.text = numbers[indexPath.row]
        cell.text.text = text[indexPath.row]
        cell.colorView.backgroundColor = colors[indexPath.row]
        cell.BGView.layer.cornerRadius = 4.7
        
        return cell
    }
    
}
