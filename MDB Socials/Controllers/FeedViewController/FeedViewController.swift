//
//  FeedViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

import SwiftyBeaver

class FeedViewController: UIViewController {

    var backgroundImage: UIImageView!

    var eventCollectionView: UICollectionView!
    
    //var newEventButton: UIButton!
    var logoutButton: UIButton!
    
    var posts : [Post] = []
    
    var postToPass : Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackground()
        setupPosts()
        fetchPosts()
        changePosts()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false;
    }
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        eventCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        eventCollectionView.backgroundColor = UIColor.white
        eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "eventCell")
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        eventCollectionView.backgroundColor = Constants.loginColor
        //eventCollectionView.layer.backgroundColor = customWhite as! CGColor
        view.addSubview(eventCollectionView)
    }
    
//    @objc func createNewEvent() {
//        self.performSegue(withIdentifier: "toNewEvent", sender: self)
//    }
//    
//    @objc func logoutUser() {
//        UserAuthHelper.logOut().then {success -> Void in
//            self.performSegue(withIdentifier: "logoutSegue", sender: self)
//        }
//        
//    }
    
    func fetchPosts() {
        posts.removeAll()
        FirebaseAPIClient.fetchPosts(withBlock: { posts in
            for p in posts.reversed(){
                self.posts.insert(p, at: 0)
            }
            self.posts = self.posts.sorted(by: { $0.getPostDate().compare($1.getPostDate()) == .orderedAscending })
            
            self.eventCollectionView.reloadData()
            
            
        })
        print(posts)
    }
    
    func changePosts() {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            self.eventCollectionView.reloadData()
        })
    }
    
    func setupPosts() {
        let cvLayout = UICollectionViewFlowLayout()
        eventCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * 0.12, width: view.frame.width, height: view.frame.height * 0.88), collectionViewLayout: cvLayout)
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
        eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "eventCell")
        eventCollectionView.backgroundColor = Constants.loginColor
        view.addSubview(eventCollectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetails" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = postToPass
        }
    }
    func createBackground() {
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImage.backgroundColor = Constants.loginColor
        view.addSubview(backgroundImage)
    }

    

}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        let selectedEvent = posts[indexPath.row]

        if selectedEvent.image == nil {
            selectedEvent.getPicture().then { success -> Void in
                cell.imageView.image = selectedEvent.image
            }
        }
//        else{
//            cell.imageView.image = selectedEvent.image
//        }
        
        cell.title = selectedEvent.eventName
        cell.image = selectedEvent.image
        cell.content = selectedEvent.eventDescription
        cell.date = selectedEvent.eventDate
        
        
      
        
        var temp = ""
        if selectedEvent.posterName == nil {
            FirebaseAPIClient.getUserWithId(id: selectedEvent.posterId!).then { user in
                DispatchQueue.main.async {
                    //print(name)
                    cell.name = user.name
                    selectedEvent.posterName = user.name
                }
            }
                    
            }
        else{
            cell.name = selectedEvent.posterName!
        }
        print(selectedEvent.posterName)
        log.info("Event poster: \(selectedEvent.posterName)")
        
        //cell.name = selectedEvent.posterName
        let numInterested = selectedEvent.getNumInterested()
        cell.interested = "Interested: \(numInterested)"
        
        //cell.eventPost = selectedEvent
        cell.awakeFromNib()
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: eventCollectionView.bounds.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: UIScreen.main.bounds.width - 20, height: 200)
        return CGSize(width: view.frame.width * 0.9, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postToPass = posts[indexPath.row]
        if postToPass.image != nil{
            performSegue(withIdentifier: "toEventDetails", sender: self)
        }
    }
    
    
}
