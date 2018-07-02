//
//  searchCelCollectionViewCell.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 18/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit
import  Cosmos

class searchCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var offersNo: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var unratedL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
        rootView.layer.cornerRadius = 3
        rootView.layer.masksToBounds = true
        
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.15
    }
}
