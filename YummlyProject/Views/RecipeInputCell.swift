//
//  RecipeInputCell.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 28/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit

class RecipeInputCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var inputField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
