//
//  Author.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 22/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation

struct Author: ResponseObjectSerializable {
    let email: String
    let username: String
    let id: String
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String:Any],
            let id = representation["_id"] as? String,
            let email = representation["email"] as? String,
            let username = representation["username"] as? String
        else { return nil }
        self.id = id
        self.username = username
        self.email = email
    }
}

