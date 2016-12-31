//
//  RecipeOverviewController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 25/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit
import Alamofire

class RecipeOverviewController: UIViewController {
    var recipe: Recipe!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func makeRecipe() {}
    
    @IBAction func delete() {
        let confirm = UIAlertController(title: "Delete recipe", message: "Are you sure you want to delete the recipe?", preferredStyle: .alert)
        
        confirm.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let headers: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type" : "application/json",
                "Authorization" : "Token \(Service.shared.user.token!)"
            ]
            Alamofire.request("\(Service.shared.baseApi)/recipes/\(self.recipe.slug)", method: .delete, headers: headers).responseJSON(completionHandler: {
                response in
                if response.result.isSuccess {
                    self.image.isHidden = true
                    self.performSegue(withIdentifier: "unwindFromAdd", sender: self)
                }
            })
        }))
        
        confirm.addAction(UIAlertAction(title: "Hell no", style: .cancel, handler: { (action: UIAlertAction!) in
            // Do nothing
        }))
        
        present(confirm, animated: true, completion: nil)
    }
    
    @IBAction func back() {
        image.isHidden = true
        performSegue(withIdentifier: "unwindToRecipes", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
            case "recipeGuide":
                let recipeGuideController = segue.destination as! RecipeGuideController
                recipeGuideController.recipe = self.recipe
            default: break
        }
    }
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        recipeTitle.text = recipe.name
        recipeDescription.text = recipe.body
        image.image = recipe.image
        recipeTitle.adjustsFontSizeToFitWidth = true
        
        if recipe.author.username != Service.shared.user.username {
            deleteButton.isHidden = true
        }
    }
    
    
   
}
