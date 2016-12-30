//
//  RecipeOverviewBackButton.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 26/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit

class RecipeOverviewBackButton: UIButton {
    override func draw(_ rect: CGRect) {
        // Blue background
        let path = UIBezierPath(rect: rect)
        UIColor(red:0.20, green:0.60, blue:0.86, alpha:0.8).setFill()
        path.fill()
        
        drawArrow(inside: path)
    }
    
    func drawArrow(inside box: UIBezierPath) {
        let length:CGFloat = 5
        let centerPoint: CGFloat = box.bounds.height / 2
        let center = CGPoint(x: centerPoint, y: centerPoint)
        
        let linePath = UIBezierPath()
        linePath.lineWidth = 2
        
        // Draw a cross
        linePath.move(to: center)
        linePath.addLine(to: CGPoint(x: centerPoint + length, y: centerPoint + length))
        linePath.move(to: center)
        linePath.addLine(to: CGPoint(x: centerPoint + length, y: centerPoint - length))
        linePath.move(to: center)
        linePath.addLine(to: CGPoint(x: centerPoint - length, y: centerPoint + length))
        linePath.move(to: center)
        linePath.addLine(to: CGPoint(x: centerPoint - length, y: centerPoint - length))
        
        // Set color to white & stroke
        UIColor.white.setStroke()
        linePath.stroke()
    }
}
