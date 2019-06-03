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

    func updateUserValues(forUserWithUserId userId: String,withValue value: [String: String], completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        Database.database().reference().child(AK_USERS).child(userId).updateChildValues(value) { (error, _) in
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }

            completion(true, nil)
        }
    }

    func createNewUserInDatabase(withUserId userId: String, withValue value: [String: String], completion: @escaping (_ succes: Bool,_ error: String?) -> Void) {
        Database.database().reference().child(AK_USERS).child(userId).updateChildValues(value) { (error, _) in
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            
            completion(true, nil)
        }
    }
}
