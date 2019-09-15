//
//  CommentsVC.swift
//  Instagram-Clone
//
//  Created by AKIL KUMAR THOTA on 9/14/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let post: Post

    var currenUser: User?

    var comments: [PostComment] = []

    let commentsTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a comment"
        return textfield
    }()

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        let sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)

        containerView.addSubview(sendButton)
        sendButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 50, height: 0)

        containerView.addSubview(commentsTextField)
        commentsTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)

        return containerView
    }()

    init(post: Post) {
        self.post = post 
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLoggedInUserDataAndUserPosts()

        collectionView.backgroundColor = .white

        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: "cell")

        collectionView.keyboardDismissMode = .onDrag

        navigationItem.title = "Comments"

        fetchCommentsForPost()
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

            self?.currenUser = user
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CommentsCell {
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        else{
            return CommentsCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override var inputAccessoryView: UIView? {
        return containerView
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    @objc private func handleSendButton() {
        guard let commentText = commentsTextField.text, commentText.count > 0 else {
            print("comment text is empty")
            return
        }

        commentsTextField.text = ""
        view.endEditing(true)

        guard let currenUser = currenUser else {
            print("current user is nil")
            return
        }
        
        let comment = PostComment(username: currenUser.username, userUID: currenUser.uid, commentID: UUID().uuidString, userProfilePicImageURL: currenUser.userProfileImageString, comment: commentText, creationDate: Date())

        DatabaseManager.sharedInstance.addCommentForPost(post: post, comment: comment) { [weak self] (success) in
            guard success else {
                print("failed to save comment")
                return
            }

            self?.comments.append(comment)
            self?.comments.sort(by: {
                $0.creationDate < $1.creationDate
            })
            self?.collectionView.reloadData()
        }
    }

    private func fetchCommentsForPost() {
        comments.removeAll()
        DatabaseManager.sharedInstance.fetchCommentsForPost(post: post) { [weak self] (postComments) in
            self?.comments = postComments
            self?.comments.sort(by: {
                $0.creationDate < $1.creationDate
            })
            self?.collectionView.reloadData()
        }
    }
}
