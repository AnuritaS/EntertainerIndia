//
//  loyaltyCollectionViewCell.swift
//  Entertainer
//
//  Created by Shubhankar Singh on 25/11/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class loyaltyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBAction func button(_ sender: Any) {
        UIView.animate(withDuration: 0.3)
        {
            self.overlay.alpha = 0.45
        }
    }
}
