//
//  UIView+Ext.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

extension UIView {
        
    func addShadowsOnly(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
        
}
