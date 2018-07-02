//
//  CollectionCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 09/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import QuartzCore

class CollectionCell: UITableViewCell{
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var collectionL: UILabel!
    @IBOutlet weak var collectionDesc: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
        
        bgView.layer.cornerRadius = 7
        bgView.layer.masksToBounds = true
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1
    }
  
}
