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
import ReactiveKit
import Bond


class AddRecipeViewController: UITableViewController {
    
    // Recipe variables
    var recipeName: String?
    var imageUrl: String?
    var recipeImage: UIImage = #imageLiteral(resourceName: "darkTile")
    var recipeDescription: String?
    var ingredients: [String] = []
    var instructions: [String] = []
    var errors: [String] = []
    var recipeImageView: UIImageView?
    
    override func viewDidLoad() {
        
        //Testing data
        //recipeName = "Recept naam"
//        imageUrl = "http://graphics8.nytimes.com/images/2014/04/02/multimedia/falco-pizzadough/falco-pizzadough-superJumbo.jpg"
//        recipeDescription = "This is a very tasty pizza dough recipe for making your very own pizza!"
//        ingredients = ["200g Flour", "100ml Olive oil", "100ml water", "50g fresh yeast", "pinch of sugar", "1tsp salt"]
//        instructions = ["Pour the flour on the surface and make a small hole in the middle of the flour", "Pour the olive oil in the hole", "add the sugar and the salt", "mix the olive oil, sugar and salt carefully.", "Add the yeast to the water and pour it in the hole", "Mix until you get your pizza dough"]
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
    
    override func viewWillDisappear(_ animated: Bool) {
//        if let name = recipeName {
//            UserDefaults.standard.setValue(name, forKey: "name")
//        }
//        
//        if let image = imageUrl {
//            UserDefaults.standard.setValue(image, forKey: "image")
//        }
//        
//        if let description = recipeDescription {
//            UserDefaults.standard.setValue(description, forKey: "description")
//        }
//        
//        UserDefaults.standard.setValue(ingredients, forKey: "ingredients")
//        UserDefaults.standard.setValue(instructions, forKey: "instructions")
//        UserDefaults.standard.setValue(errors, forKey: "errors")
    }
    
    @IBAction func addRecipe() {
        
        // Clear previous errors
        self.errors = []
        var valid = true
        
        // Make sure Name & Description are initialized
        if self.recipeName == nil {
            self.recipeName = ""
        }
        
        if self.recipeDescription == nil {
            self.recipeDescription = ""
        }
        
        // Input check

        if (self.recipeName!.characters.count) < 3 {
            self.errors.append("The recipe name should contain at least 3 characters")
            valid = false
        }
        if (self.recipeDescription!.characters.count) < 5 {
            self.errors.append("The description should contain at least 5 characters")
            valid = false
        }
        if self.ingredients.count == 0 {
            self.errors.append("At least one ingredient is required")
            valid = false
        }
        if self.instructions.count == 0 {
            self.errors.append("At least one instruction is required")
            valid = false
        }
        
        // Input check valid?
        if valid {
            
            // Set parameters
            let parameters: Parameters = [
                "recipe": [
                    "title" : recipeName ?? "",
                    "body" : recipeDescription ?? "",
                    "image" : imageUrl  ?? "",
                    "portions" : "2",
                    "instructions" : instructions,
                    "ingredients" : ingredients
                ]
            ]
            
            // Set the headers
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type" : "application/json",
                "Authorization" : "Token \(Service.shared.user.token!)"
            ]
            
            // Send request
            Alamofire.request("\(Service.shared.baseApi)/recipes", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
                
                let data = JSON(response.result.value!)
                let errors = data.dictionaryValue["errors"] != nil
                
                // Network errors
                if errors {
                    let error = data.dictionaryValue["errors"]!.dictionaryValue
                    var key = error.first!.key
                    if (key == "slug") {
                        key = "name"
                    }
                    
                    let message = "\(key) \(error.first!.value.stringValue)"
                    self.errors.append(message)
                }
                
                // No errors
                if self.errors.count == 0 {
//                    if self.recipeName != nil {
//                        UserDefaults.standard.setValue("", forKey: "name")
//                    }
//                    
//                    if self.imageUrl != nil {
//                        UserDefaults.standard.setValue("", forKey: "image")
//                    }
//                    
//                    if self.recipeDescription != nil {
//                        UserDefaults.standard.setValue("", forKey: "description")
//                    }
//                    
//                    UserDefaults.standard.setValue([String](), forKey: "ingredients")
//                    UserDefaults.standard.setValue([String](), forKey: "instructions")
//                    UserDefaults.standard.setValue([String](), forKey: "errors")
                    
                    self.performSegue(withIdentifier: "unwindFromAdd", sender: self)
                    
                } else {
                    self.tableView.reloadData()
                }
                
            })
        } else {
            // not valid, show errors
            self.tableView.reloadData()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 0: Recipe image
        // 1: Recipe name, Recipe image url, Recipe description
        // 2: Recipe ingredient, Ingredients list
        // 3: Recipe instruction, Instruction list
        // 4: Errors
        // 5: Post button
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  section {
        case 0, 5:
            return 1
        case 1:
            return 3
        case 2:
            return ingredients.count + 1
        case 3:
            return instructions.count + 1
        case 4:
            return errors.count
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
                cell.label.text = ingredients[indexPath.row - 1].capitalizingFirstLetter()
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
                cell.label.text = instructions[indexPath.row - 1].capitalizingFirstLetter()
                cell.viewController = self
                cell.restorationIdentifier = "instruction"
                return cell
            }
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = errors[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        case 5:
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
        case 5:
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
                self.errors.append("Unable to load the image")
                self.tableView.reloadData()
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
