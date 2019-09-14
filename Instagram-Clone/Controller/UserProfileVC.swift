//
//  UserProfileVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/13/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    // properties
    var user: User?

    var posts: [Post] = []

    // life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = user?.username
        collectionView.backgroundColor = .white

        if user == nil {
            fetchLoggedInUserDataAndUserPosts()
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(gearIconSelected))

        collectionView.register(UserProfileVCHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user != nil {
            fetchPost()
        }
    }

    // functions

    private func fetchPost() {
        DatabaseManager.sharedInstance.fetchPosts(userUID: user!.uid) { [weak self] (posts) in
            self?.posts = posts
            self?.posts.sort(by: {
                $0.creationDate > $1.creationDate
            })
            self?.collectionView.reloadData()
        }
    }

    @objc private func gearIconSelected() {
        let actionSheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { action in
            do {
                try Auth.auth().signOut()

                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.topViewController()?.dismiss(animated: true, completion: nil)
            }
            catch {
                print(error.localizedDescription)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheetVC.addAction(logOutAction)
        actionSheetVC.addAction(cancelAction)

        present(actionSheetVC, animated: true, completion: nil)
    }

    private func fetchLoggedInUserDataAndUserPosts() {
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
            self?.navigationItem.title = user.username
            self?.fetchPost()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? UserProfileVCHeader else {
            return UserProfileVCHeader()
        }

        header.user = user
        header.configureCell()

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PictureCell {
            let post = posts[indexPath.row]
            let url = URL(string: post.imageDownloadURL)!
            cell.imageView.sd_setImage(with: url, completed: nil)
            return cell
        }
        else {
            return PictureCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 2) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
