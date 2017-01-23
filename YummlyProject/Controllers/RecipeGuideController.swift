//
//  RecipeGuideController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 26/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit

class RecipeGuideController: UITableViewController {
    var recipe: Recipe!
    @IBOutlet weak var loadingScreen: UIView!

    @IBAction func close(){
        performSegue(withIdentifier: "unwindToRecipes", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadingScreen.isHidden = true
    }
    
    override func viewDidLoad() {
//        tableView.addSubview(loadingScreen)
//        loadingScreen.translatesAutoresizingMaskIntoConstraints = false
//        tableView.addConstraints([
//            NSLayoutConstraint(item: loadingScreen, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: loadingScreen, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 1, constant: 0),
//            loadingScreen.widthAnchor.constraint(equalTo: tableView.widthAnchor),
//            loadingScreen.heightAnchor.constraint(equalTo: tableView.heightAnchor)
//        ])

        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.topItem?.hidesBackButton = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return recipe.ingredients.count + 1
        case 2:
            return recipe.instructions.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            if indexPath.row == 0 {
                return 60
            } else {
                return 50
            }
        case 2:
            if indexPath.row == 0 {
                return 60
            } else {
                if indexPath.section == 2 {
                    if recipe.instructions[indexPath.row - 1].characters.count > 40 {
                        return 50
                    } else if recipe.instructions[indexPath.row - 1].characters.count > 80 {
                        return 80
                    } else if recipe.instructions[indexPath.row - 1].characters.count > 120 {
                        return 110
                    }
                }
                return 50
            }
        default:
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! RecipeTableViewImageCell
            cell.recipeImage.image = recipe.image
            return cell
        case 1:
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
                cell.textLabel?.text = "INGREDIENTS"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = recipe.ingredients[indexPath.row - 1].capitalizingFirstLetter()
            cell.contentMode = .top
            return cell
        case 2:
            if (indexPath.row == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath)
                cell.textLabel?.text = "INSTRUCTIONS"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(indexPath.row). \(recipe.instructions[indexPath.row - 1].capitalizingFirstLetter())"
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
}

