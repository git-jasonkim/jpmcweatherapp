//
//  UIView+Ext.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/7/23.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeading: CGFloat, paddingBottom: CGFloat, paddingTrailing: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
                
        if let top = top {
            let topAnchorConstraint = self.topAnchor.constraint(equalTo: top, constant: paddingTop)
            topAnchorConstraint.isActive = true
        }
        
        if let bottom = bottom {
            let bottomAnchorConstraint = self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom)
            bottomAnchorConstraint.isActive = true
        }

        if width != 0 {
            let widthAnchorConstraint = widthAnchor.constraint(equalToConstant: width)
            widthAnchorConstraint.isActive = true
        }
        
        if height != 0 {
            let heightAnchorConstraint = heightAnchor.constraint(equalToConstant: height)
            heightAnchorConstraint.isActive = true
        }

        if let leading = leading {
            let leadingAnchorConstraint = self.leadingAnchor.constraint(equalTo: leading, constant: paddingLeading)
            leadingAnchorConstraint.isActive = true
        }
 
        if let trailing = trailing {
            let trailingAnchorConstraint = self.trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing)
            trailingAnchorConstraint.isActive = true
        }
    }
    
    func anchor(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeading: CGFloat, paddingBottom: CGFloat, paddingTrailing: CGFloat, width: CGFloat, height: CGFloat) {
        
        anchor(top: top, leading: leading, bottom: bottom, trailing: trailing, paddingTop: paddingTop, paddingLeading: paddingLeading, paddingBottom: paddingBottom, paddingTrailing: paddingTrailing, width: width, height: height)
        
        if let centerX = centerX {
            let centerXAnchorConstraint = self.centerXAnchor.constraint(equalTo: centerX)
            centerXAnchorConstraint.isActive = true
        }
        
        if let centerY = centerY {
            let centerYAnchorConstraint = self.centerYAnchor.constraint(equalTo: centerY)
            centerYAnchorConstraint.isActive = true
        }
    }
}
