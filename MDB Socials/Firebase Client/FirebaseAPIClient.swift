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

class FirebaseAPIClient {
    
    
    static func fetchPosts(withBlock: @escaping ([Post]) -> ()) {
//        //TODO: Implement a method to fetch posts with Firebase!
//        let ref = Database.database().reference()
//        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
//            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
//            withBlock([post])
//        })
        let postsRef = Database.database().reference()
        print("Fetching Posts")
        postsRef.child("Posts").observe(.childAdded, with: { (snapshot) in
            let json = JSON(snapshot.value)
            if let result = json.dictionaryObject {
                if let post = Post(JSON: result){
                    withBlock([post])
                }
            }
        })
    }
    
//    static func fetchUser(id: String, withBlock: @escaping (User) -> ()) {
//        let ref = Database.database().reference()
//        ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//            let user = User(id: snapshot.key, userDict: snapshot.value as! [String : Any]?)
//            withBlock(user)
//
//        })
//    }
    
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
                    print(error)
                    MKFullSpinner.hide()
                    return
                }
                let downloadURL = String(describing: metadata.downloadURL()!)
                let userID = String(describing: UserAuthHelper.getCurrentUser()!.uid)
                let newUser = ["name": name, "username": username, "email": email, "profilePictureURL": downloadURL, "userID": userID] as [String : Any]
                let childUpdates = ["/\(userID)/": newUser]
                usersRef.updateChildValues(childUpdates)
                MKFullSpinner.hide()
                fulfill(true)
            }
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
}

