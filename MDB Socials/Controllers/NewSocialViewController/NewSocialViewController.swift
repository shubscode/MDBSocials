//
//  NewSocialViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation
import LocationPicker
import MKSpinner

class NewSocialViewController: UIViewController, UITextViewDelegate {

    var eventName: String!
    var eventDate: String!
    var eventDescription: String!
    var imagePicked: UIImageView!
    var selectedLocation: CLLocationCoordinate2D!
    
    var image = #imageLiteral(resourceName: "startingImage")

    
    var mainView: NewSocialView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set date format
        

        mainView = NewSocialView(frame: view.frame, controller: self)
        view.addSubview(mainView)
        
        let b = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CancelClicked))
        self.navigationItem.setLeftBarButtonItems([b], animated: true)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func CancelClicked(sender: UIBarButtonItem) {
       self.dismiss(animated: true, completion: {})
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImagePicker" {
            if let destinationVC = segue.destination as? ImagePickerViewController {
                destinationVC.eventName = self.mainView.eventName
                destinationVC.eventDate = self.mainView.eventDate
                destinationVC.eventDescription = self.mainView.eventDescription
                destinationVC.selectedLocation = self.mainView.selectedLocation
            }
        }
    }
        

    }



