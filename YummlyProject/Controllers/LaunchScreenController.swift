//
//  LaunchScreenController.swift
//  YummlyProject
//
//  Created by Pieter-Jan Geeroms on 06/12/2016.
//  Copyright © 2016 Pieter-Jan Geeroms. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class LaunchScreenController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        //Enable for production 
        //sleep(2)
        performSegue(withIdentifier: "loginScreen", sender: self)
    }
}
