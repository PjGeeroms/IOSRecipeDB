//
//  RecipeOverviewButton.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 26/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit

class RecipeOverviewButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        let square = UIBezierPath(rect: rect)
        UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0).setFill()
        square.fill()
        
        //drawHorizontalLine()
        
        
    }
    
    func drawHorizontalLine() {
        let box = subviews[0]
        
        //let lineWidth : CGFloat = min(bounds.width, bounds.height) * 0.6
        let linePath = UIBezierPath()
        linePath.lineWidth = 1
        linePath.move(to: CGPoint(x: box.frame.minX + 20, y: box.frame.maxY + 10))
        linePath.addLine(to: CGPoint(x: box.frame.maxX - 20, y: box.frame.maxY + 10))
        
        UIColor.white.setStroke()
        linePath.stroke()
    }

    
}
