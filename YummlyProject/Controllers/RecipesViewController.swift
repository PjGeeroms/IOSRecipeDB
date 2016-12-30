//
//  RecipeCollectionViewController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 20/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SearchTextField

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: SearchTextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Unwind point
    @IBAction func unwindToRecipes(segue: UIStoryboardSegue){
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func unwindFromAdd(segue: UIStoryboardSegue) {
        refreshTableView()
    }
    
    fileprivate var recipes: [Recipe] = []
    private var currentTask: DataRequest?
    private var searchTask: DataRequest?
    private var selectedIndex: Int?
    
    private let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type" : "application/json",
        "Authorization" : "Token \(Service.shared.user.token)"
    ]
    
    override func viewDidLoad() {
        // Show the navigationBar
        navigationController?.isNavigationBarHidden = false
        
        // Searchbar settings
        searchBar.theme = .darkTheme()
        
        // Change current theme
        //searchBar.theme.font = UIFont.systemFontOfSize(12)
        searchBar.theme.font = UIFont(name: "Avenir", size: 14)!
        searchBar.theme.bgColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        searchBar.theme.borderColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        searchBar.theme.separatorColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        searchBar.theme.cellHeight = 50
        
        searchBar.maxNumberOfResults = 5
        
        searchBar.highlightAttributes = [NSBackgroundColorAttributeName: UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0), NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
        
        searchBar.itemSelectionHandler = {item in
            self.searchBar.text = item.title
            
            self.selectedIndex = self.recipes.index(where: {
                $0.name == item.title
            })
            
            self.searchBar.resignFirstResponder()
            self.performSegue(withIdentifier: "detailRecipeFromSelector", sender: self)
        }

        
        searchBar.userStoppedTypingHandler = {
            if let criteria = self.searchBar.text {
                if (criteria.characters.count == 0) {
                    self.searchBar.resignFirstResponder()
                    self.refreshTableView()
                }
                
                if criteria.characters.count > 1 {
                    
                    // Show the loading indicator
                    self.searchBar.showLoadingIndicator()
                    
                    self.searchTask = Alamofire.request("\(Service.shared.baseApi)/recipes/filter/\(criteria)", headers: self.headers).responseCollection { (response: DataResponse<[Recipe]>) in
                        switch response.result {
                        case .success(let recipes):
                            self.recipes = recipes
                            for (index,recipe) in self.recipes.enumerated() {
                                // Load images
                                // Filter images without imageString
                                Service.shared.sessionManager.request(recipe.imageString).responseImage(completionHandler: {
                                    imageResponse in
                                    
                                    switch imageResponse.result {
                                    case .success(let image):
                                        recipe.image = image
                                        self.collectionView.reloadData()
                                    case .failure(_):
                                        if index % 2 == 0 {
                                            recipe.image = #imageLiteral(resourceName: "darkTile")
                                        } else {
                                            recipe.image = #imageLiteral(resourceName: "lightTile")
                                        }
                                    }
                                    
                                })
                            }
                            
                            var items: [SearchTextFieldItem] = []
                            recipes.forEach({
                                items.append(SearchTextFieldItem(title: $0.name))
                            })
                            self.searchBar.filterItems(items)
                            self.collectionView.reloadData()
                            self.searchBar.stopLoadingIndicator()
                        case .failure(_):
                            self.searchBar.stopLoadingIndicator()
                        }
                    }
                }
            }
        }
        
        // Load recipes
        currentTask = Service.shared.sessionManager.request("\(Service.shared.baseApi)/recipes", headers: headers).responseCollection { (response: DataResponse<[Recipe]>) in
            switch response.result {
                case .success(let recipes):
                    self.recipes = recipes
                    for (index,recipe) in self.recipes.enumerated() {
                        // Load images
                        // Filter images without imageString
                        Service.shared.sessionManager.request(recipe.imageString).responseImage(completionHandler: {
                            imageResponse in
                            
                            switch imageResponse.result {
                            case .success(let image):
                                recipe.image = image
                                self.collectionView.reloadData()
                            case .failure(let error):
                                if index % 2 == 0 {
                                    recipe.image = #imageLiteral(resourceName: "darkTile")
                                } else {
                                    recipe.image = #imageLiteral(resourceName: "lightTile")
                                }
                                print(error)
                            }
                            
                        })
                    }
                case .failure(let error):
                    print(error)
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func refreshTableView() {
        currentTask?.cancel()
        currentTask = Service.shared.sessionManager.request("\(Service.shared.baseApi)/recipes", headers: headers).responseCollection { (response: DataResponse<[Recipe]>) in
            switch response.result {
            case .success(let recipes):
                self.recipes = recipes
                for (index,recipe) in self.recipes.enumerated() {
                    // Load images
                    // Filter images without imageString
                    Service.shared.sessionManager.request(recipe.imageString).responseImage(completionHandler: {
                        imageResponse in
                        
                        switch imageResponse.result {
                        case .success(let image):
                            recipe.image = image
                            self.collectionView.reloadData()
                            self.collectionView.refreshControl?.endRefreshing()
                        case .failure(let error):
                            if index % 2 == 0 {
                                recipe.image = #imageLiteral(resourceName: "darkTile")
                            } else {
                                recipe.image = #imageLiteral(resourceName: "lightTile")
                            }
                            
                            print(error)
                        }
                    })
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "addRecipe":
            let _ = segue.destination as! AddRecipeViewController
            
        case "detailRecipe":
            let recipeOverviewController = segue.destination as! RecipeOverviewController
            selectedIndex = collectionView.indexPathsForSelectedItems![0].row;
            recipeOverviewController.recipe = recipes[selectedIndex!]
            
        case "detailRecipeFromSelector":
            let recipeOverviewController = segue.destination as! RecipeOverviewController
            recipeOverviewController.recipe = recipes[selectedIndex!]

        default:
            break
        }
        
    }

}

extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeName.text = recipe.name
        cell.recipeSource.text = recipe.author.username
        cell.recipeImage.image = recipe.image
        
        
        //cell.recipeImage.af_setImage(withURL: URL(string: recipe.image)!)
        
        return cell
    }
}

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height / 2
        return CGSize(width: collectionView.frame.width, height: height)
    }
}
