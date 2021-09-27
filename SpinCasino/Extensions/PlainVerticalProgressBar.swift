//
//  PlainVerticalProgressBar.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 19.08.2021.
//

import UIKit

@IBDesignable
class PlainVerticalProgressBar: UIView {
    
    @IBInspectable var color: UIColor? = .gray

    var progress: CGFloat = 0
   
    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.25).cgPath
        layer.mask = backgroundMask
        
        progress = CGFloat(Level.shared.rateLevel / Level.maxRateLevel)
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width, height: rect.height * progress))
  
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        let progressLayer = CALayer()
        progressLayer.frame = progressRect
        
        layer.addSublayer(progressLayer)
        progressLayer.cornerRadius = 10
        progressLayer.backgroundColor = color?.cgColor
    }
}
