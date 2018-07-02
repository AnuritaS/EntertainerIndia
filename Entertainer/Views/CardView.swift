//
//  CardView.swift
//  Entertainer
//
//  Created by Nikhil Bansal on 28/02/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    
    override func layoutSubviews() {
        var radius:CGFloat=0.0
        if(cornerRadius==0){
            radius=5
        }else{
            radius=cornerRadius
        }
        layer.cornerRadius = radius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        
        layer.masksToBounds = maskToBounds
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowPath = shadowPath.cgPath
    }
    
}
