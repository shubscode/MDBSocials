//
//  DetailViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import Firebase
import CoreGraphics
import CoreLocation
import MapKit

class DetailViewController: UIViewController {
    
    
    var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var mainView: DetailView!
    
    var post: Post!

//
    
    
    override func viewDidLoad() {
        //self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        mainView = DetailView(frame: view.frame, controller: self)
        view.addSubview(mainView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(interestIncremented), name: Notification.Name("incrementedInterested"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainView.queryLyft()
        //mainView.addAnnotationToMap()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is InterestedUsersViewController {
            let dest = segue.destination as! InterestedUsersViewController
            dest.userIDArray = post.interestedUserIds
        }
    }
    
    @objc func interestIncremented() {
        print("MADE IT HERE AT LAST")
        var numInterested = post.getNumInterested()
        print(numInterested)
        mainView.postDateTextField.text = "\(post.eventDate!)\r\(numInterested) ppl interested"
    }


}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location")
        guard let currentLoc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("CURRENT LOCATION IS  \(currentLoc)")
        self.currentLocation = currentLoc
    }
}
