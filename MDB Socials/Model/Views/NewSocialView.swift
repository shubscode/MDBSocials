//
//  NewSocialView.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 3/14/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import CoreLocation
import LocationPicker
import MKSpinner
import FirebaseAuth
import FirebaseDatabase


class NewSocialView: UIView, UITextViewDelegate {

    var titleLabel: UILabel!
    var eventNameTextField: UITextField!
    var dateOfEventTextField: UITextField!
    var eventDescriptionTextView: UITextView!
    
    var eventName: String!
    var eventDate: String!
    var eventDescription: String!
    var imagePicked: UIImageView!
    
    var selectLocationButton: UIButton!
    var selectedLocation: CLLocationCoordinate2D!
    
    var image = #imageLiteral(resourceName: "startingImage")
    
    var createEventButton: UIButton!
    var addPhotoButton: UIButton!
    
    var datePicker: UIDatePicker!
    let dateFormatter: DateFormatter = DateFormatter()
    
    var backgroundImage: UIImageView!

    
    var customBlue = UIColor(hue: 0.5472, saturation: 0.75, brightness: 0.94, alpha: 1.0)
    var customWhite = UIColor(hue: 0.5972, saturation: 0.24, brightness: 0.95, alpha: 1.0)
    
    var viewController: NewSocialViewController!
    
    init(frame: CGRect, controller: NewSocialViewController){
        super.init(frame: frame)
        viewController = controller
        setBackground()

        eventName = viewController.eventName
        eventDate = viewController.eventDate
        eventDescription = viewController.eventDescription
        imagePicked = viewController.imagePicked
        image = viewController.image
        selectedLocation = viewController.selectedLocation
        
        
        setup()
        
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        titleLabel = UILabel(frame: CGRect(x: 20, y: 60, width: self.frame.width - 40, height: 60))
        //titleLabel.font = UIFont.systemFont(ofSize: 34, weight: 3)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = titleLabel.font.withSize(50)
        titleLabel.textAlignment = .center
        titleLabel.text = "Event Details"
        titleLabel.textColor = customWhite
        self.addSubview(titleLabel)
        
        eventNameTextField = UITextField(frame: CGRect(x: 20, y: 120, width: self.frame.width - 40, height: 50))
        eventNameTextField.placeholder = "Event Name"
        eventNameTextField.borderStyle = .roundedRect
        eventNameTextField.clipsToBounds = true
        self.addSubview(eventNameTextField)
        
        datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 20, y: 290, width: self.frame.width - 40, height: 120)
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = customWhite
        
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        self.addSubview(datePicker)
        
        //        dateOfEventTextField = UITextField(frame: CGRect(x: 20, y: 340, width: self.frame.width - 40, height: 50))
        //        dateOfEventTextField.placeholder = "Date of Event"
        //        dateOfEventTextField.borderStyle = .roundedRect
        //        dateOfEventTextField.clipsToBounds = true
        //        self.addSubview(dateOfEventTextField)
        
        eventDescriptionTextView = UITextView(frame: CGRect(x: 20, y: 180, width: self.frame.width - 40, height: 80))
        eventDescriptionTextView.delegate = self
        eventDescriptionTextView.layer.borderColor = UIColor.gray.cgColor
        eventDescriptionTextView.layer.borderWidth = 0.5
        eventDescriptionTextView.text = "Add event description here"
        eventDescriptionTextView.textColor = UIColor.lightGray
        //eventDescriptionTextView.place = "Add event description here"
        //eventDescriptionTextView.borderStyle = .roundedRect
        eventDescriptionTextView.clipsToBounds = true
        self.addSubview(eventDescriptionTextView)
        
        imagePicked = UIImageView(frame: CGRect(x: 20, y: 420, width: 130, height: 130))
        imagePicked.image = image
        imagePicked.contentMode = .scaleAspectFill
        imagePicked.clipsToBounds = true
        imagePicked.layer.cornerRadius = 10
        self.addSubview(imagePicked)
        
        selectLocationButton = UIButton(frame: CGRect(x: self.frame.midX, y: 420, width: 130, height: 130))
        selectLocationButton.setTitle("Select Location", for: .normal)
        selectLocationButton.layer.cornerRadius = 10
        selectLocationButton.backgroundColor = UIColor.flatSkyBlue
        selectLocationButton.setTitleColor(Constants.textColor, for: .normal)
        selectLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        self.addSubview(selectLocationButton)
        
        addPhotoButton = UIButton(frame: CGRect(x: 20, y: 570, width: self.frame.width - 40, height: 40))
        addPhotoButton.backgroundColor = customBlue
        addPhotoButton.layer.cornerRadius = 15
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.addTarget(self, action: #selector(toImagePicker), for: .touchUpInside)
        self.addSubview(addPhotoButton)
        
        
        createEventButton = UIButton(frame: CGRect(x: 20, y: 620, width: self.frame.width - 40, height: 40))
        createEventButton.backgroundColor = customBlue
        createEventButton.layer.cornerRadius = 15
        createEventButton.setTitle("CREATE EVENT", for: .normal)
        self.addSubview(createEventButton)
        createEventButton.addTarget(self, action: #selector(returnToFeed), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        nullCheck()
        self.addGestureRecognizer(tap)
    }
    func setBackground() {
        
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        backgroundImage.backgroundColor = Constants.loginColor
        self.addSubview(backgroundImage)
    }
    
    @objc func selectLocation() {
        let locationPicker = LocationPickerViewController()
        
        //        let location = CLLocation(latitude: 37.8719, longitude: 122.2585)
        //        let initialLocation = Location(name: "UC Berkeley", location: location, placemark: CLPlacemark() )
        //        locationPicker.location = initialLocation
        //
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = Constants.loginColor!
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.resultRegionDistance = 500
        locationPicker.completion = { location in
            self.selectedLocation = location?.coordinate
            self.selectLocationButton.titleLabel?.numberOfLines = 0
            self.selectLocationButton.titleLabel?.lineBreakMode = .byWordWrapping
            self.selectLocationButton.setTitle("Location\rSelected", for: .normal)
        }
        
        self.viewController.present(locationPicker, animated: true) {
            print("Selecting location")
        }
    }
    
    func nullCheck() {
        print(eventName)
        print(eventDate)
        if eventName != nil && eventDate != nil {
            eventNameTextField.text = eventName
            eventDescriptionTextView.text = eventDescription
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: eventDate)
            
            datePicker.date = date!
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add event description here"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        eventDate = dateFormatter.string(from: sender.date)
        
        print("Selected value \(eventDate)")
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
    
    func readEventInfo() {
        let event = eventNameTextField.text
        let date = eventDate
        let desc = eventDescriptionTextView.text
        if event == "" {
            raiseInvalidInfoAlert(info: "Event Name")
        }
        else if date == "" {
            raiseInvalidInfoAlert(info: "Event Date")
        }
        else {
            eventName = event
            //eventDate = date
            eventDescription = desc
        }
        
    }
    func raiseInvalidInfoAlert(info: String) {
        let alert = UIAlertController(title: "Missing \(info)", message: "You must provide an \(info)!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.viewController.present(alert, animated: true, completion: nil)
    }

    
    @objc func toImagePicker() {
        readEventInfo()
        self.viewController.performSegue(withIdentifier: "toImagePicker", sender: self)
    }
    
    @objc func returnToFeed() {
        readEventInfo()
        if imagePicked.image == nil {
            raiseInvalidInfoAlert(info: "Image")
        }
        if selectedLocation == nil {
            raiseInvalidInfoAlert(info: "Location")
        } else {
            MKFullSpinner.show("Creating Event", animated: true)
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            print(userID)
            ref.child("Users").child(userID!).child("name").observeSingleEvent(of: .value, with: {(snapshot) in
                let name = snapshot.value
                let user = name! as? String
                print("USER IS \(user)")
                
                
                FirebaseAPIClient.createPost(selectedImage: self.imagePicked.image!, posterName: user!, name: self.eventName, description: self.eventDescription, dateString: self.eventDate, location: self.selectedLocation).then { success -> Void in
                    MKFullSpinner.hide()
                    self.viewController.dismiss(animated: true, completion: {
                        print("Post Complete")
                    })
                }
            })
        }
    }

}
