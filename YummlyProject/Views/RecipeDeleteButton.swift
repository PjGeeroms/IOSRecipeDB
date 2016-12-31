//
//  RecipeDeleteButton.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 31/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit

class RecipeDeleteButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        
        let smallRect = CGRect(x: rect.width / 4, y: rect.width / 4, width: 25, height: 25)
        TrashCan.drawCanvas1(frame: smallRect, resizing: .aspectFit)
        
        rect.union(smallRect)
    }
}
