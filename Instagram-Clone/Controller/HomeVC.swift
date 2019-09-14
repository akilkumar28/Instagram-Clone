//
//  HomeVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 8/25/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "cell")

        setupNavigationItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchPosts()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HomePostCell {
            let post = posts[indexPath.row]
            cell.configureCell(post: post)
            return cell
        }
        else {
            return HomePostCell()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 50
        return CGSize(width: view.frame.width, height: height)
    }

    private func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    private func fetchPosts() {
        posts.removeAll()
        DatabaseManager.sharedInstance.getFollowersPostsForUser(userUID: Auth.auth().currentUser!.uid) { [weak self] (posts) in
            self?.posts = posts
            self?.posts.sort(by: {
                $0.creationDate > $1.creationDate
            })
            self?.collectionView.reloadData()
        }
    }
}
