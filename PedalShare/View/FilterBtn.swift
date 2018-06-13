//
//  FilterBtn.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

class FilterBtn: UIButton {

    public var roundRectCornerRadius: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    public var roundRectColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    private var roundRectLayer: CAShapeLayer?
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).cgPath
        shapeLayer.fillColor = roundRectColor.cgColor
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundRectLayer = shapeLayer
    }

}
