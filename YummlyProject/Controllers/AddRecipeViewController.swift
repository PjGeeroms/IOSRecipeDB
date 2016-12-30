//
//  AddRecipeViewController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 28/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class AddRecipeViewController: UITableViewController {
    
    // Recipe variables
    var recipeName: String?
    var imageUrl: String?
    var recipeImage: UIImage = #imageLiteral(resourceName: "darkTile")
    var recipeDescription: String?
    var ingredients: [String] = []
    var instructions: [String] = []
    
    var recipeImageView: UIImageView?
    
    override func viewDidLoad() {
        
        // Testing data
        recipeName = "Recept naam"
        imageUrl = "http://images4.fanpop.com/image/photos/23400000/Cakes-delicious-recipes-23444509-1024-768.jpg"
        recipeDescription = "Recept description"
        ingredients = ["Sla", "Tomaat", "Mayonnaise"]
        instructions = ["Doe eerst dit", "Doe dan dat"]
    }
        
    func deleteCell(cell: UITableViewCell) {
        if let index = tableView.indexPath(for: cell) {
            if (cell.restorationIdentifier == "ingredient") {
                ingredients.remove(at: index.row - 1)
            } else {
                instructions.remove(at: index.row - 1)
            }
            
            tableView.deleteRows(at: [index], with: .automatic)
        }
    }
    
    @IBAction func addRecipe() {
        
//        print("Name: \(recipeName), imageUrl: \(imageUrl), Description: \(recipeDescription), Ingredients: \(ingredients), Instructions: \(instructions)")
//        print("Token: \(Service.shared.user.token)")
        
        let parameters: Parameters = [
            "recipe": [
                "title" : recipeName!,
                "body" : recipeDescription!,
                "image" : imageUrl!,
                "portions" : "2",
                "instructions" : instructions,
                "ingredients" : ingredients
            ]
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/json",
            "Authorization" : "Token \(Service.shared.user.token!)"
        ]
        
        let url = "http://recipedb.pw/api/recipes/"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            let data = JSON(response.result.value!)
            let errors = data.dictionaryValue["errors"] != nil
            print(data)
            if errors {
                print("ERROR")
                // Error handling
            } else {
                print("SUCCESS")
                self.performSegue(withIdentifier: "unwindFromAdd", sender: self)
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 0: Recipe image
        // 1: Recipe name, Recipe image url, Recipe description
        // 2: Recipe ingredient, Ingredients list
        // 3: Recipe instruction, Instruction list
        // 4: Post button
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  section {
        case 0, 4:
            return 1
        case 1:
            return 3
        case 2:
            return ingredients.count + 1
        case 3:
            return instructions.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! RecipeTableViewImageCell
            recipeImageView = cell.recipeImage
            recipeImageView?.image = recipeImage
            
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! RecipeInputCell
                cell.inputField.delegate = self
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageInputCell", for: indexPath) as! RecipeImageInputCell
                cell.inputField.delegate = self
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! RecipeDescriptionCell
                cell.inputField.delegate = self
                return cell
                
            default:
                return UITableViewCell()
            }
            
        case 2:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! RecipeInputCell
                cell.inputField.delegate = self
                cell.inputField.restorationIdentifier = "addIngredient"
                cell.inputField.placeholder = "Add ingredient"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath) as! RecipeListItem
                cell.label.text = ingredients[indexPath.row - 1]
                cell.viewController = self
                cell.restorationIdentifier = "ingredient"
                return cell
            }
            
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! RecipeInputCell
                cell.inputField.delegate = self
                cell.inputField.restorationIdentifier = "addInstruction"
                cell.inputField.placeholder = "Add instruction"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "listItem", for: indexPath) as! RecipeListItem
                cell.label.text = instructions[indexPath.row - 1]
                cell.viewController = self
                cell.restorationIdentifier = "instruction"
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            if indexPath.row == 2 {
                return 120
            }
            return 44
        case 4:
            return 60
        default:
            return 44
        }
    }
}

extension AddRecipeViewController: UITextFieldDelegate {
    func loadImage(url: String) {
        Alamofire.request(url).responseImage(completionHandler: {
            image in
            if image.result.isSuccess {
                self.recipeImage = image.result.value!
                self.recipeImageView?.image = self.recipeImage
            } else {
                print("failed")
            }
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.restorationIdentifier! == "imageInput") {
            imageUrl = textField.text!
            loadImage(url: textField.text!)
        }
        
        if textField.restorationIdentifier! == "recipeName" {
            recipeName = textField.text!
            print(recipeName!)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text!.characters.count > 0) {
            switch textField.restorationIdentifier! {
            case "recipeName":
                textField.resignFirstResponder()
            case "imageInput":
                loadImage(url: textField.text!)
                textField.resignFirstResponder()
            case "addIngredient":
                ingredients.append(textField.text!)
                textField.text! = ""
                tableView.reloadData()
                print("added ingredient")
            case "addInstruction":
                instructions.append(textField.text!)
                textField.text! = ""
                tableView.reloadData()
                print("added instruction")
            default:
                break
            }
        }
        return true
    }
}

extension AddRecipeViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let content = textView.text!
        recipeDescription = content
        
        if content.contains("\n") {
            let str = textView.text.substring(from:textView.text.index(textView.text.endIndex, offsetBy: -1))
            if str == "\n"{
                if content == "\n" {
                    textView.text = ""
                }
                textView.resignFirstResponder()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
        }
    }

}
