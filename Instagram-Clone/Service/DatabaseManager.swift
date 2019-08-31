//
//  DatabaseManager.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/2/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {

    private init() {}

    static let sharedInstance = DatabaseManager()

    func updateUserValuesInDatabase(withUserId userId: String, withValue value: [String: String], completion: @escaping (_ succes: Bool,_ error: String?) -> Void) {
        Database.database().reference().child(AK_USERS).child(userId).updateChildValues(value) { (error, _) in
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            
            completion(true, nil)
        }
    }

    func getUserValueFromDatabase(withUserId userId: String, completion: @escaping (User?) -> Void) {
        Database.database().reference().child(AK_USERS).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let result = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }

            let username = result[AK_USERNAME] as? String ?? "Not Available"
            let profileImageDownloadURL = result[AK_PROFILE_IMAGE_DOWNLOAD_URL] as? String ?? ""

            let user = User(username: username, userProfileImageString: profileImageDownloadURL)

            completion(user)

        }) { (error) in
            print(error.localizedDescription)
            completion(nil)
            return
        }
    }

    func savePostToDatabase(post: Post, completion: @escaping (_ success: Bool) -> ()) {
        let databaseReference = Database.database().reference().child("Posts").child(Auth.auth().currentUser!.uid).childByAutoId()
        
        let values: [String: Any] = [
            "Summary": post.summary,
            "imageDownloadURL": post.imageDownloadURL,
            "imageWidth": post.imageWidth,
            "imageHeight": post.imageHeight,
            "creationDate": post.creationDate.timeIntervalSince1970,
            "username": post.user.username,
            "userProfileImageString": post.user.userProfileImageString,
        ]

        databaseReference.updateChildValues(values) { (error, reference) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false)
                return
            }

            print("Successfully stored the post to the database")
            completion(true)
        }
    }

    func fetchPostForCurrentUser(completion: @escaping (_ posts: [Post]) -> ()) {
        let databaseReference = Database.database().reference().child("Posts").child(Auth.auth().currentUser!.uid)

        databaseReference.queryOrdered(byChild: "creationDate").observeSingleEvent(of: .value) { snapshot in
            var posts = [Post]()
            guard snapshot.exists() else {
                print("No post exist for the user")
                completion(posts)
                return
            }

            guard let allPosts = snapshot.value as? [String: Any] else {
                completion(posts)
                return
            }

            allPosts.values.forEach {
                guard let post = $0 as? [String: Any] else {
                    return
                }

                let summary = post["Summary"] as? String ?? ""
                let imageDownloadURL = post["imageDownloadURL"] as? String ?? ""
                let imageHeight = post[""] as? CGFloat ?? 0.0
                let imageWidth = post[""] as? CGFloat ?? 0.0
                let creationDate = post["creationDate"] as? Double ?? 0.0
                let userName = post["username"] as? String ?? ""
                let userProfilImageString = post["userProfileImageString"] as? String ?? ""

                let user = User(username: userName, userProfileImageString: userProfilImageString)

                let newPost = Post(user: user, summary: summary, imageDownloadURL: imageDownloadURL, imageWidth: imageWidth, imageHeight: imageHeight, creationDate: Date(timeIntervalSince1970: creationDate))

                posts.append(newPost)
            }

            completion(posts)
        }
    }
}
