//
//  SignUpView.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 3/13/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import SwiftyBeaver

class SignUpView: UIView {
    
    var titleLabel: UILabel!
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var profileImage: UIImageView!
    
    var username: String!
    var password: String!
    var name: String!
    var email: String!
    var profilePic: UIImage!
    
    var signUpLabel: UILabel!
    var signUpButton: UIButton!
    
    var loginButton: UIButton!
    
    //var ref: DatabaseReference!
    
    var customBlue = UIColor(hue: 0.5472, saturation: 0.75, brightness: 0.94, alpha: 1.0)
    var customWhite = UIColor(hue: 0.5972, saturation: 0.24, brightness: 0.95, alpha: 1.0)
    
    var backgroundImage: UIImageView!
    

    
    var viewController: SignUpViewController!
    
    init(frame: CGRect, controller: SignUpViewController){
        super.init(frame: frame)
        viewController = controller
        
        createBackground()
        setup()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func photoSelect(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            viewController.present(imagePicker, animated: true, completion: nil)
        }

        // Your action
    }
    
    func setup() {
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 50, width: self.frame.width - 40, height: 100))
        //titleLabel.font = UIFont.systemFont(ofSize: 34, weight: 3)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = titleLabel.font.withSize(90)
        titleLabel.textColor = Constants.textColor
        titleLabel.textAlignment = .center
        titleLabel.text = "Sign Up"
        self.addSubview(titleLabel)
        
        nameTextField = UITextField(frame: CGRect(x: 20, y: 170, width: self.frame.width - 40, height: 50))
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.clipsToBounds = true
        self.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 20, y: 230, width: self.frame.width - 40, height: 50))
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.clipsToBounds = true
        self.addSubview(emailTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: 20, y: 290, width: self.frame.width - 40, height: 50))
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.clipsToBounds = true
        self.addSubview(usernameTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 20, y: 350, width: self.frame.width - 40, height: 50))
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.clipsToBounds = true
        self.addSubview(passwordTextField)
        
        profileImage = UIImageView(frame: CGRect(x: self.frame.midX - 40, y:410, width: 80, height: 80))
        profileImage.image = #imageLiteral(resourceName: "startingImage")
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.borderColor = UIColor.black.cgColor
        //profileImage.addTarge
        
        self.addSubview(profileImage)
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(photoSelect(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        
        
        
        signUpLabel = UILabel(frame: CGRect(x: 20, y: 560, width: self.frame.width - 40, height: 50))
        signUpLabel.text = "Already have an account?"
        signUpLabel.textColor = Constants.textColor
        signUpLabel.textAlignment = .center
        self.addSubview(signUpLabel)
        
        signUpButton = UIButton(frame: CGRect(x: 20, y: 610, width: self.frame.width - 40, height: 50))
        signUpButton.backgroundColor = customBlue
        signUpButton.layer.cornerRadius = 15
        signUpButton.setTitle("SIGN IN", for: .normal)
        self.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(toSignInScreen), for: .touchUpInside)
        
        loginButton = UIButton(frame: CGRect(x: 20, y: 500, width: self.frame.width - 40, height: 50))
        loginButton.backgroundColor = customBlue
        loginButton.layer.cornerRadius = 15
        loginButton.setTitle("CREATE USER", for: .normal)
        self.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(toFeedView), for: .touchUpInside)
    }
    
    func readInputs() {
        let nameResp = nameTextField.text
        let usernameResp = usernameTextField.text
        let emailResp = emailTextField.text
        let passwordResp = passwordTextField.text
        if nameResp == "" || usernameResp == "" || emailResp == "" || passwordResp == "" {
            raiseInvalidInfoAlert();
        } else {
            name = nameResp
            username = usernameResp
            email = emailResp
            password = passwordResp
        }
        
    }
    func raiseInvalidInfoAlert() {
        let alert = UIAlertController(title: "Invalid Information", message: "Please fill out all text fields", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    @objc func toSignInScreen() {
        viewController.dismiss(animated: true, completion: {})
    }
    
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        backgroundImage.backgroundColor = Constants.loginColor
        self.addSubview(backgroundImage)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
    
    
    @objc func toFeedView() {
        readInputs()
        let profileImageData = UIImageJPEGRepresentation(profileImage.image!, 0.9)
        
        UserAuthHelper.createUser(name: name, username: username, email: email, password: password, image: profileImage.image!, view: viewController, withBlock: { (user) in
            self.viewController.dismiss(animated: true, completion: {
                log.verbose("Finished creating a user!")
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.nameTextField.text = ""
                self.viewController.performSegue(withIdentifier: "toFeedView", sender: self)
                //self.performSegue(withIdentifier: "toFeedView", sender: self)
            })
        })
    }
    

}

extension SignUpView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilePic = info[UIImagePickerControllerOriginalImage] as! UIImage
        //MKFullSpinner.show("Selecting Image...", animated: true)
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = profilePic

        viewController.dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }

}

