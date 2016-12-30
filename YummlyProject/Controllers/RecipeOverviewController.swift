//
//  RecipeOverviewController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 25/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit

class RecipeOverviewController: UIViewController {
    var recipe: Recipe!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func makeRecipe() {}
    
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
    }
    
    
   
}
