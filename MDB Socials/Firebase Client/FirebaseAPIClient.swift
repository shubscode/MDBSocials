//
//  FirebaseAPIClient.swift
//  MDB Socials
//
//  Created by Shubham Gupta on 2/19/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase
import PromiseKit
import MKSpinner
import ObjectMapper
import SwiftyJSON
import CoreLocation


import SwiftyBeaver

class FirebaseAPIClient {
    
    
    static func fetchPosts(withBlock: @escaping ([Post]) -> ()) {

        let postsRef = Database.database().reference()
        postsRef.child("Posts").observe(.childAdded, with: { (snapshot) in
            let json = JSON(snapshot.value)
            if let result = json.dictionaryObject {
                if let post = Post(JSON: result){
                    withBlock([post])
                }
            }
        })
    }
    

    
    static func createNewPost(postDict: [String: Any]?) {
        let postsRef = Database.database().reference().child("Posts")
//        let newPost = ["text": postText, "poster": poster, "imageUrl": imageUrl, "posterId": posterId] as [String : Any]
        let key = postsRef.childByAutoId().key
        let childUpdates = ["/\(key)/": postDict]
        postsRef.updateChildValues(childUpdates)
    }
    
//    static func createNewUser(id: String, name: String, email: String) {
//
//        let usersRef = Database.database().reference().child("Users")
//        let newUser = ["name": name, "email": email]
//        let childUpdates = ["/\(id)/": newUser]
//        usersRef.updateChildValues(childUpdates)
//    }
    
    static func createNewUser(name: String, username: String, email: String, image: UIImage) -> Promise<Bool> {
        return Promise { fulfill, reject in
            let usersRef = Database.database().reference().child("Users")
            let imageRef = Storage.storage().reference().child("profileImages/" + username.trimmingCharacters(in: .whitespaces) + ".png")
            let data = UIImagePNGRepresentation(image)!
            MKFullSpinner.show("Creating User...")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    log.error("ERROR: \(error)")
                    MKFullSpinner.hide()
                    return
                }
                
                let downloadURL = String(describing: metadata.downloadURL()!)
                let userID = String(describing: UserAuthHelper.getCurrentUser()!.uid)
                let newUser = ["name": name, "username": username, "email": email, "profilePictureURL": downloadURL, "userID": userID, "myEvents": [String]()] as [String : Any]
                let childUpdates = ["/\(userID)/": newUser]
                print("FIREBASE PLEASE WORK")
                print(newUser)
                print(childUpdates)
                usersRef.updateChildValues(childUpdates)
                MKFullSpinner.hide()
                fulfill(true)
            }
        }
    }
    
    static func createPost(selectedImage: UIImage, posterName: String, name: String, description: String, dateString: String, location: CLLocationCoordinate2D) -> Promise<Bool>{
        let postsRef = Database.database().reference()
        return Promise { fulfill, error in
            let data = UIImagePNGRepresentation(selectedImage)!
            let imageRef = Storage.storage().reference().child("postImages/" + name.trimmingCharacters(in: .whitespaces) + ".png")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                   log.error("ERROR UPLOADING")
                    MKFullSpinner.hide()
                    return
                }
                let downloadURL = String(describing: metadata.downloadURL()!)
                //print(downloadURL)
                let posterId = UserAuthHelper.getCurrentUser()?.uid
                
                
    
                let postsRef = Database.database().reference().child("Posts")
                let key = postsRef.childByAutoId().key
                let newPost = ["postId": key, "posterName": posterName, "name": name, "pictureURL": downloadURL, "posterId": posterId!, "description": description, "date": dateString, "latitude": location.latitude, "longitude": location.longitude] as [String : Any]
                let childUpdates = ["/\(key)/": newPost]
                postsRef.updateChildValues(childUpdates)
                //print("Post created!")
                let userRef = Database.database().reference().child("Users").child(posterId!).child("myEvents")
                userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    var arr = snapshot.value
                    if arr is NSNull {
                        arr = [key]
                        userRef.setValue(arr)
                    } else {
                        log.verbose("Adding to Array")
                        var myeventsArray =  arr as! [String]
                        myeventsArray.append(key)
                        userRef.setValue(myeventsArray)
                    }
                })
                fulfill(true)
            }
        }
    }
    
    
    static func getUserWithId(id: String) -> Promise<Users> {
        return Promise { fulfill, error in
            let usersRef = Database.database().reference().child("Users")
            
            //usersRef.setValue(["value": 5])
            usersRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                //let name = snapshot.value
                //let user = name! as? String
                
                let json = JSON(snapshot.value)
                if let result = json.dictionaryObject {
                    if let user = Users(JSON: result){
                        fulfill(user)
                    }
                }
        
            })
        }
    }
    static func getPostWithId(id: String) -> Promise<Post> {
        return Promise { fulfill, error in
            let postsRef = Database.database().reference().child("Posts")
            
            postsRef.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let json = JSON(snapshot.value)
                if let result = json.dictionaryObject {
                    if let post = Post(JSON: result){
                        fulfill(post)
                    }
                }
                
            })
        }
    }
    
    
    static func updateInterested(postId: String, userId: String) -> Promise<Bool> {
        return Promise { fulfill, _ in
            let postRef = Database.database().reference().child("Posts").child(postId).child("Interested")
            let newInterestedUser = [postRef.childByAutoId().key: userId] as [String : Any]
            postRef.updateChildValues(newInterestedUser)
            fulfill(true)
        }
    }
    
    static func getInterestedUsers(postId: String) -> Promise<[String]>{
        return Promise { fulfill, _ in
            let ref = Database.database().reference()
            ref.child("Posts").child(postId).child("Interested").observeSingleEvent(of: .value, with: { (snapshot) in
                var users: [String] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let value = snap.value as! String
                    users.append(value)
                }
                fulfill(users)
            })
        }
    }
    
    static func getMyEvents(userID: String) -> Promise<[String]>{
        return Promise { fulfill, _ in
            let ref = Database.database().reference()
            ref.child("Users").child(userID).child("myEvents").observeSingleEvent(of: .value, with: { (snapshot) in
                print("TRYING TO GET EVENTS")
                var events: [String] = []
                for child in snapshot.children {
                    print("THESE ARE MY CHILDREN")
                    let snap = child as! DataSnapshot
                    let value = snap.value as! String
                    print(value)
                    events.append(value)
                }
                fulfill(events)
            })
        }
    }
    
}


