//
//  experienceCollectionViewCell.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 07/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class experienceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var main_label: UILabel!
    @IBOutlet var host_name: UILabel!
    @IBOutlet var image_view: UIImageView!
    @IBOutlet var estd_image_view: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var roundView: CardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
//        estd_image_view.layer.cornerRadius = estd_image_view.frame.size.width/2
//        estd_image_view.clipsToBounds = true
//        image_view.clipsToBounds = true
//        roundView.clipsToBounds = true
//        roundView.maskToBounds=true
//        roundView.layer.cornerRadius = 5
//
//        mainView.backgroundColor = UIColor.clear
//        mainView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        mainView.layer.shadowColor = UIColor.gray.cgColor
//       mainView.layer.shadowRadius = 2
//      mainView.layer.shadowOpacity = 0.2
        
    }
}
