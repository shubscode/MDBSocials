//
//  ViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    var mainView: SignInView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = SignInView(frame: view.frame, controller: self)
        view.addSubview(mainView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toFeedView", sender: self)
        }
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true;
    }

    


}

