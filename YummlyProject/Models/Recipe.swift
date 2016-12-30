//
//  Recipe.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 06/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

final class Recipe: ResponseObjectSerializable, ResponseCollectionSerializable {
    let id: String
    let slug: String
    let name: String
    let portions: String
    let ingredients: [String]
    let instructions: [String]
    let imageString: String
    var image: UIImage?
    let body: String
    let author: Author
    
    
//    init(id: String, name: String, portions: String, ingredients: [String], instructions: [String], image: String, body: String, slug: String, author: Author ) {
//        self.id = id
//        self.name = name
//        self.slug = slug
//        self.portions = portions
//        self.ingredients = ingredients
//        self.instructions = instructions
//        self.image = image
//        self.body = body
//        self.author = author
//    }    
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["_id"] as? String,
            let slug = representation["slug"] as? String,
            let body = representation["body"] as? String,
            let imageString = representation["image"] as? String,
            let portions = representation["portions"] as? String,
            let name = representation["title"] as? String,
            let ingredients = representation["ingredients"] as? [String],
            let instructions = representation["instructions"] as? [String],
            let author = representation["author"] as? [String: Any]
        else { return nil }
        
        
        self.id = id
        self.name = name
        self.slug = slug
        self.portions = portions
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageString = imageString
        self.body = body
        self.author = Author(response: response, representation: author)!
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


