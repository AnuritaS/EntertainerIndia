//
//  ProfileCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 11/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {


    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    func setupView(){
    
        
        imageView.layer.cornerRadius = imageView.frame.size.width/2
    }
}

class ProfileHeader:UICollectionReusableView{
    @IBOutlet weak var headerLabel: UILabel!
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                             withReuseIdentifier:"headerCell", for: indexPath)
            headerView.backgroundColor = .black
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
}
