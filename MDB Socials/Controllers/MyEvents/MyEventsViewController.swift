//
//  MyEventsViewController.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 3/5/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

class MyEventsViewController: UIViewController {

    var myEventsCollectionView: UICollectionView!
    var myPosts = [Post]()
    var postToPass: Post!
    var myEventsIDs: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        getMyEvents()
        setupCollectionView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //getMyEvents()
        //myEventsCollectionView.reloadData()
    }
    
    func getMyEvents() {
        let user = UserAuthHelper.getCurrentUser()
        FirebaseAPIClient.getMyEvents(userID: (user?.uid)!).then{posts -> Void in
            for p in posts {
                FirebaseAPIClient.getPostWithId(id: p).then{ post -> Void in
                    self.myPosts.append(post)
                }
            }
            }.then{
                self.myEventsCollectionView.reloadData()
            }
    }

    func setupCollectionView() {
        
        let cvLayout = UICollectionViewFlowLayout()
        myEventsCollectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height * 0.09, width: view.frame.width, height: view.frame.height * 0.88), collectionViewLayout: cvLayout)
        myEventsCollectionView.delegate = self
        myEventsCollectionView.dataSource = self
        myEventsCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "eventCell")
        myEventsCollectionView.backgroundColor = Constants.loginColor
        view.addSubview(myEventsCollectionView)
        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetails" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = postToPass
        }
    }



}
extension MyEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myEventsCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
        let selectedEvent = myPosts[indexPath.row]
        
        if selectedEvent.image == nil {
            selectedEvent.getPicture().then { success -> Void in
                cell.imageView.image = selectedEvent.image
            }
        }
        cell.title = selectedEvent.eventName
        cell.image = selectedEvent.image
        cell.content = selectedEvent.eventDescription
        cell.date = selectedEvent.eventDate
        
        
        
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
        return CGSize(width: myEventsCollectionView.bounds.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postToPass = myPosts[indexPath.row]
        if postToPass.image != nil{
            performSegue(withIdentifier: "toEventDetails", sender: self)
        }
    }
    

}



