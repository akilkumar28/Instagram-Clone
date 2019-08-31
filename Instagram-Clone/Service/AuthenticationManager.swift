//
//  AuthenticationManager.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/2/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import Foundation
import Firebase

class AuthenticationManager {

    private init() {}

    static let sharedInstance = AuthenticationManager()

    func createUser(withEmail email: String, withPassword password: String, completion: @escaping (_ success: Bool, _ result: AuthDataResult?, _ error: String?) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false, nil, error?.localizedDescription)
                return
            }

            completion(true, result, nil)
        }
    }

    func signInUser(withEmail email: String, withPassword password: String, completion: @escaping (_ success: Bool) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                completion(false)
                return
            }

            guard let _ = result else {
                print("result not available during sign in")
                completion(false)
                return
            }

            print("Successfully signed in")
            completion(true)
        }
    }
}
