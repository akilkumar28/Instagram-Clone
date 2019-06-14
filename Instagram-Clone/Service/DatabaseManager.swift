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
        Database.database().reference().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
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
}
