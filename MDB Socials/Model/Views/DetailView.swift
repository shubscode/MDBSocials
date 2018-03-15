//
//  DetailView.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 3/13/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class DetailView: UIView {

    //Background Image
    var backgroundImage: UIImageView!
    
    var mapView: MKMapView!
    var getDirectionsButton: UIButton!
    
    var whosInterested: UIButton!
    
    //Post Given
    var post: Post!
    
    //Post Title
    var postTitleTextField: UILabel!
    
    //Post Body
    var postBodyTextField: UILabel!
    
    //Post Date
    var postDateTextField: UILabel!
    
    //Post Location
    var postLocationTextField: UILabel!
    
    //Event Image View
    var eventImageView : UIImageView!
    
    //Interested Button
    var interestedButton : UIButton!
    
    var lyftLogo: UIImageView!
    var lyftInfoLabel: UILabel!
    
    
    var viewController: DetailViewController!
    
    init(frame: CGRect, controller: DetailViewController){
        super.init(frame: frame)
        viewController = controller
        
        post = viewController.post!
        createBackground()
        createEventImageView()
        createPostTitle()
        createPostBody()
        createPostDate()
        createInterestedButton()
        createWhosInterested()
        createMapView()
        createGetDirectionsButton()
        createLyftLabel()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Create background
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        backgroundImage.backgroundColor = UIColor(red: 67.0/255.0, green: 130.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        self.addSubview(backgroundImage)
    }
    
    
    //Create the EventImageView
    func createEventImageView() {
        eventImageView = UIImageView(frame: CGRect(x: self.frame.width * 0.05, y: self.frame.height * 0.13, width: self.frame.width * 0.6, height: self.frame.height * 0.27))
        eventImageView.layer.cornerRadius = 8
        eventImageView.clipsToBounds = true
        eventImageView.backgroundColor = .white
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.image = post.image!
        self.addSubview(eventImageView)
    }
    
    func createMapView() {
        mapView = MKMapView(frame: CGRect(x: self.frame.width * 0.67, y: self.frame.height * 0.13, width: self.frame.width * 0.28, height: self.frame.height * 0.27))
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        self.addSubview(mapView)
    }
    
    
    func createPostTitle() {
        postTitleTextField = UILabel(frame: CGRect(x: self.frame.width * 0.05, y: self.frame.height * 0.42, width: self.frame.width * 0.45, height: self.frame.height * 0.16))
        postTitleTextField.backgroundColor = .white
        //postTitleTextField.roundCorners(corners: [.topLeft], radius: 8)
        postTitleTextField.layer.cornerRadius = 8
        postTitleTextField.numberOfLines = 0
        postTitleTextField.lineBreakMode = .byWordWrapping
        postTitleTextField.text = " \(post.eventName!)\rBy: \(post.posterName!)"
        postTitleTextField.textAlignment = .center
        
        //postTitleTextField.sizeToFit()
        
        
        self.addSubview(postTitleTextField)
        
        
    }
    
    //Create date of the event
    func createPostDate() {
        postDateTextField = UILabel(frame: CGRect(x: self.frame.width * 0.5, y: self.frame.height * 0.42, width: self.frame.width * 0.45, height: self.frame.height * 0.16))
        postDateTextField.backgroundColor = .white
        postDateTextField.layer.cornerRadius = 8
        postDateTextField.numberOfLines = 0
        postDateTextField.text = "\(post.eventDate!)\r\(post.getNumInterested()) ppl interested"
        postDateTextField.textAlignment = .center
        //postDateTextField.roundCorners(corners: [.topRight], radius: 8)
        postDateTextField.layer.cornerRadius = 8
        self.addSubview(postDateTextField)
    }
    
    
    //Create the body of the function
    func createPostBody() {
        postBodyTextField = UILabel(frame: CGRect(x: self.frame.width * 0.05, y: self.frame.height * 0.60, width: self.frame.width * 0.9, height: self.frame.height * 0.15))
        postBodyTextField.text = post.eventDescription!
        postBodyTextField.numberOfLines = 5
        //postBodyTextField.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 8)
        postBodyTextField.layer.cornerRadius = 8
        postBodyTextField.backgroundColor = .white
        postBodyTextField.textAlignment = .center
        self.addSubview(postBodyTextField)
    }
    
    //Create a button to increase the interested number
    func createInterestedButton() {
        interestedButton = UIButton(frame: CGRect(x: self.frame.width * 0.05, y: self.frame.height * 0.8, width: self.frame.width * 0.2667, height: self.frame.height * 0.12))
        interestedButton.layer.cornerRadius = 8
        interestedButton.backgroundColor = UIColor.lightGray
        interestedButton.backgroundColor = .white
        interestedButton.setTitle("Interested?", for: .normal)
        
        interestedButton.setTitleColor(Constants.loginColor, for: .normal)
        interestedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        if(post.getInterestedUserIds().contains((Auth.auth().currentUser?.uid)!)){
            interestedButton.isEnabled = false
            interestedButton.titleLabel?.numberOfLines = 0
            interestedButton.titleLabel?.lineBreakMode = .byWordWrapping
            interestedButton.setTitle("Already\rinterested", for: .normal)
            interestedButton.titleLabel?.textAlignment = .center
            interestedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            interestedButton.addTarget(self, action: #selector(increaseInterested), for: .touchUpInside)
        }
        self.addSubview(interestedButton)
    }
    
    func createGetDirectionsButton() {
        getDirectionsButton = UIButton(frame: CGRect(x: self.frame.width * 0.37, y: self.frame.height * 0.8, width: self.frame.width * 0.2667, height: self.frame.height * 0.06))
        getDirectionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        getDirectionsButton.layer.cornerRadius = 10
        getDirectionsButton.titleLabel?.numberOfLines = 0
        getDirectionsButton.titleLabel?.lineBreakMode = .byWordWrapping
        getDirectionsButton.setTitle("Get\rDirections", for: .normal)
        getDirectionsButton.titleLabel?.textAlignment = .center
        getDirectionsButton.setTitleColor(Constants.loginColor, for: .normal)
        getDirectionsButton.backgroundColor = .white
        getDirectionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(getDirectionsButton)
    }
    
    func createLyftLabel() {
//        lyftLogo = UIImageView(frame: CGRect(x: 10, y: 10, width: fourthBlockView.frame.height - 20, height: fourthBlockView.frame.height - 20))
//        lyftLogo.image = #imageLiteral(resourceName: "lyft")
//        self.addSubview(lyftLogo)
        print("WHY AINT THIS SHOWING UP")
        lyftInfoLabel = UILabel(frame: CGRect(x: self.frame.width * 0.37, y: self.frame.height * 0.861, width: self.frame.width * 0.2667, height: self.frame.height * 0.059))
        lyftInfoLabel.textColor = .white
        lyftInfoLabel.numberOfLines = 2
        self.addSubview(lyftInfoLabel)
    }
    
    func createWhosInterested() {
        whosInterested = UIButton(frame: CGRect(x: self.frame.width * 0.6833, y: self.frame.height * 0.8, width: self.frame.width * 0.2667, height: self.frame.height * 0.12))
        whosInterested.addTarget(self, action: #selector(whosInterestedSegue), for: .touchUpInside)
        whosInterested.layer.cornerRadius = 10
        whosInterested.titleLabel?.numberOfLines = 0
        whosInterested.titleLabel?.lineBreakMode = .byWordWrapping
        whosInterested.setTitle("See Who's\rInterested", for: .normal)
        whosInterested.titleLabel?.textAlignment = .center
        whosInterested.setTitleColor(Constants.loginColor, for: .normal)
        whosInterested.backgroundColor = .white
        whosInterested.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(whosInterested)
    }
    
    func queryLyft(){
        let eventLocation = CLLocationCoordinate2DMake(viewController.post.latitude!, viewController.post.longitude!)
        if viewController.currentLocation != nil {
            LyftHelper.getRideEstimate(pickup: viewController.currentLocation!, dropoff: eventLocation) { costEstimate in
                self.lyftInfoLabel.text = "A Lyft ride will cost $" + String(describing: costEstimate.estimate!.maxEstimate.amount) + " from your location."
            }
        } else {
            print("Cant get current location")
        }
    }

    
    @objc func getDirections(){
        let urlString = "http://maps.apple.com/?saddr=&daddr=\(post.latitude!),\(post.longitude!)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!)
    }
    
    
    @objc func whosInterestedSegue(){
        viewController.performSegue(withIdentifier: "toWhosInterested", sender: self)
    }
    
    
    //Function to increase the number of those interested
    @objc func increaseInterested() {
        
        FirebaseAPIClient.updateInterested(postId: post.id!, userId: (UserAuthHelper.getCurrentUser()?.uid)!).then { success -> Void in
            print("Updated interested")
            
            self.interestedButton.isEnabled = false
            self.interestedButton.titleLabel?.numberOfLines = 0
            self.interestedButton.titleLabel?.lineBreakMode = .byWordWrapping
            self.interestedButton.setTitle("You are\ralready interested", for: .normal)
            
            self.post.addInterestedUser(userID: (UserAuthHelper.getCurrentUser()?.uid)!)
            
            NotificationCenter.default.post(name: Notification.Name("incrementedInterested"), object: self)

        }
        
        
    }


}
