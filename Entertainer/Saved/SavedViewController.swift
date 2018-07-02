//
//  BlogViewController.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 01/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var savedCollectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedCollectionView.dataSource = self
        savedCollectionView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarItem.title = "•"
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarItem.title = " "
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = savedCollectionView.dequeueReusableCell(withReuseIdentifier: "savedCell", for: indexPath) as! savedCollectionViewCell
        
        cell.baseView.layer.cornerRadius = 4.7
        cell.baseView.layer.shadowRadius = 14
        cell.baseView.layer.shadowOffset = CGSize(width:0, height:6)
        cell.baseView.layer.shadowOpacity = 0.20

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let suplView = savedCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "savedHeader", for: indexPath)
        
        return suplView
    }
}
