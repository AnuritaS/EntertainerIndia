//
//  SearchTextCell.swift
//  Entertainer
//
//
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Cosmos

class SearchTextCell: UITableViewCell {

    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchName: UILabel!
    @IBOutlet weak var searchRate: CosmosView!
    @IBOutlet weak var searchOffer: UILabel!
    @IBOutlet weak var greenLabel: UIView!
    @IBOutlet weak var whiteCircle: UIView!
    @IBOutlet weak var unratedL: UILabel!
    
    override func awakeFromNib() {
    super.awakeFromNib()
// Initialization code
setupView()
}
func setupView(){
    searchImage.clipsToBounds = true
    
    greenLabel.layer.cornerRadius = 3
    searchImage.layer.cornerRadius = 4
    whiteCircle.layer.cornerRadius = whiteCircle.frame.size.height/2
    unratedL.isHidden = true
}
}
