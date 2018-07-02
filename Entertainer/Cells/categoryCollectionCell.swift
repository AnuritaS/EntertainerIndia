//
//  categoryCollectionCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 20/12/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//

import UIKit

class categoryCollectionCell: UICollectionViewCell {
    

    @IBOutlet var category: UILabel!

}

protocol CategoryRowDelegate:class {
    func cellTapped(_ clientId: String,_ clientName: String,_ clientLogoStr: String)
}

