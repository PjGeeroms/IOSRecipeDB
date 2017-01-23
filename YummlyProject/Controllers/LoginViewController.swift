//
//  LoginViewController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 27/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var error: UILabel!
    
    override func viewDidLoad() {
        error.isHidden = true
        
        
    }
    
    @IBAction func login() {
        let email = self.email.text!
        let password = self.password.text!
        
        let parameters: Parameters = [
            "user": [
                "email" : email,
                "password" : password
            ],
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/json"
        ]
        
        let url = "http://recipedb.pw/api/users/login"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { response in
            
            if response.result.isSuccess {
                let data = JSON(response.result.value!)
                
                if !data["errors"].dictionaryValue.isEmpty {
                    self.error.text = "Username or password is invalid"
                    self.error.isHidden = false
                }
                
                if !data["user"].dictionaryValue.isEmpty {
                    self.error.isHidden = true
                    let userData = data["user"].dictionaryValue
                    let user = Service.shared.user
                    user.email = userData["email"]!.string!
                    user.username = userData["username"]!.string!
                    user.token = userData["token"]!.string!
                    
                    self.performSegue(withIdentifier: "startScreen", sender: self)
                }
            }
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
