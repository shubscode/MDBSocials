//
//  SignUpViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var mainView: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = SignUpView(frame: view.frame, controller: self)
        view.addSubview(mainView)
    }
    
}

