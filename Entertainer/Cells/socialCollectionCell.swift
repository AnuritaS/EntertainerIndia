//
//  socialCollectionCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 10/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class socialCollectionCell: UICollectionViewCell {

    @IBOutlet weak var socialName: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
        
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        logo.layer.cornerRadius = logo.frame.size.width/2
    }
    
}
