//
//  StorageManager.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/2/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class StorageManager {

    private init() {}

    static let sharedInstance = StorageManager()

    func storeUserProfileImage(withImage image: UIImage, completion: @escaping (_ success: Bool, _ error: String?, _ imageDownloadURL: String?) -> Void) {

        let fileName = UUID().uuidString

        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            completion(false, "Image cannot be converted to jpeg data", nil)
            return
        }

        let storageImageChildReference = Storage.storage().reference().child(AK_PROFILE_IMAGES).child(fileName)

        storageImageChildReference.putData(imageData, metadata: nil) { [unowned self] (metadata, error) in
            if error != nil {
                completion(false, error?.localizedDescription, nil)
                return
            }

            self.getDownloadURL(forStorageReference: storageImageChildReference, completion: { (downloadURL, error) in
                if error != nil {
                    completion(false, error, nil)
                    return
                }

                guard let downloadURL = downloadURL else {
                    return
                }

                completion(true, nil, downloadURL)
            })

        }
    }

    func getDownloadURL(forStorageReference storageReference: StorageReference, completion: @escaping (_ downloadURL: String?, _ erorr: String?) -> Void) {
        storageReference.downloadURL { (url, error) in
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }

            guard let url = url else {
                completion(nil, "Image URL cannot be casted as a URL")
                return
            }

            completion(url.absoluteString, nil)
        }
    }
}
