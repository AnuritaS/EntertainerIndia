//
//  PopUpCollectionViewCell.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 15/10/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class PopUpCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var dealButtonOutlet: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var offerL: UILabel!
    @IBOutlet weak var offerDL: UITextView!
    @IBOutlet weak var expiryL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
    
        dealButtonOutlet.layer.cornerRadius = 4.6
        dealButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 6)
        dealButtonOutlet.layer.shadowRadius = 14
        dealButtonOutlet.layer.shadowOpacity = 0.25
    }
    
    @IBAction func dealButton(_ sender: UIButton) {
        print(sender.tag)
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
     var onButtonTapped : (() -> Void)? = nil
}
