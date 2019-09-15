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

    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: "cell")

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(collectionViewRefreshCalled), for: .valueChanged)

        collectionView.refreshControl = refreshControl

        setupNavigationItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchPosts()
    }

    @objc private func collectionViewRefreshCalled() {
        fetchPosts()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HomePostCell {
            let post = posts[indexPath.row]
            cell.post = post
            cell.homePostCellDelegate = self
            cell.configureCell()
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
            self?.refreshControl.endRefreshing()
        }
    }
}

extension HomeVC: HomePostCellProtocolDelegate {
    func commentButtonTapped(post: Post) {
        let commentsVC = CommentsVC(post: post)
        navigationController?.pushViewController(commentsVC, animated: true)
    }

    func likeButtonTapped(post: Post) {
        print("like button tapped")
    }

    func sendDirectMessageButtonTapped(post: Post) {
        print("send message button tapped")
    }

    func bookMarkButtonTapped(post: Post) {
        print("bookmark button tapped")
    }
}
