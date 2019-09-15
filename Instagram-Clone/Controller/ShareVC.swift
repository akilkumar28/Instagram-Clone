//
//  ShareVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/26/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class ShareVC: UIViewController {

    var selectedImage: UIImage?

    let pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5.0
        return iv
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))

        setupContainerView()

        pictureImageView.image = selectedImage

        textView.delegate = self
        textView.text = "Share your thoughts here..."
        textView.textColor = UIColor.lightGray
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupContainerView() {
        let containerView = UIView()
        containerView.backgroundColor = .white

        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)

        containerView.addSubview(pictureImageView)
        pictureImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)

        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: pictureImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }

    private func fetchUserData(completion: @escaping (User?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User id is not present")
            completion(nil)
            return
        }

        DatabaseManager.sharedInstance.getUserValueFromDatabase(withUserId: userId) { (user) in
            guard let user = user else {
                print("User not present while fetching from database")
                completion(nil)
                return
            }
            completion(user)
        }
    }

    @objc private func shareButtonTapped() {
        let fileName = UUID().uuidString 
        let storageReference = Storage.storage().reference().child(AK_POST_IMAGES).child(fileName)

        guard let image = selectedImage else {
            print("Image not present")
            return
        }

        view.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false

        StorageManager.sharedInstance.storeImageToFirebase(withImage: image, storageReference: storageReference) { [weak self] (success, error, downloadUrl) in
            if error != nil {
                self?.navigationItem.rightBarButtonItem?.isEnabled = true
                print(error!)
                return
            }

            let summary = (self?.textView.textColor == .lightGray ? "" : self?.textView.text) ?? ""
            let downloadURL = downloadUrl ?? ""

            self?.fetchUserData(completion: { user in
                guard let user = user else {
                    print("No user present while fetching in Share VC")
                    return
                }

                let postId = UUID().uuidString

                let post = Post(postId: postId, user: user, summary: summary, imageDownloadURL: downloadURL, imageWidth: image.size.width, imageHeight: image.size.height, creationDate: Date())

                DatabaseManager.sharedInstance.savePostToDatabase(post: post, completion: { (success) in
                    if !success {
                        print("failed to store post in database")
                        self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    }

                    self?.dismiss(animated: true, completion: nil)
                })
            })
        }
    }
}

extension ShareVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your thoughts here..."
            textView.textColor = UIColor.lightGray
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
