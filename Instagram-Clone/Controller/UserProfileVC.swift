//
//  UserProfileVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/13/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController {
    // properties

    var user: User?

    // life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()

        navigationItem.title = "User Profile"

    }

    // functions

    private func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User id is not present")
            return
        }

        DatabaseManager.sharedInstance.getUserValueFromDatabase(withUserId: userId) { [weak self] (user) in
            guard let user = user else {
                print("User not present while fetching from database")
                return
            }

            self?.user = user
        }
    }

}
