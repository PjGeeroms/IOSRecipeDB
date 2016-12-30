//
//  LaunchScreenView.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 06/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit

class LaunchScreenView: UIView {
    
    
    override func draw(_ rect: CGRect) {
        let square = UIBezierPath(rect: rect)
        UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0).setFill()
        square.fill()
        
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setStroke()
        path.stroke()
        
        drawHorizontalLine()
        
        
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
