//
//  HistoryCollectionCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 13/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit
import Cosmos

class HistoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var couponL: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var card: CardView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
        imageV.layer.cornerRadius = imageV.frame.height/2
    }
}

class reviewsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var starR: CosmosView!
    @IBAction func performReview(_ sender: Any) {
        if let onTickTapped = self.onTickTapped {
            onTickTapped()
        }
    }
    @IBOutlet weak var reviewButtonView: UIView!
    @IBOutlet weak var cancelReview: UIButton!
    var onRatingTapped : (() -> Void)? = nil
    var onTickTapped : (() -> Void)? = nil
    var onCrossTapped : (() -> Void)? = nil
    @IBAction func cancelReviewPressed(_ sender: Any) { 
        if let onCrossTapped = self.onCrossTapped {
        onCrossTapped()
        }
    }
    @IBOutlet weak var ratingView: CosmosView!
}
