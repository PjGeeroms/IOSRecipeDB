//
//  RecipeListItem.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 28/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit

class RecipeListItem: UITableViewCell {
    var viewController: AddRecipeViewController?
    @IBOutlet weak var label: UILabel!
    @IBAction func DeleteHandle() {
        print("clicked")
        viewController?.deleteCell(cell: self)
    }
}
