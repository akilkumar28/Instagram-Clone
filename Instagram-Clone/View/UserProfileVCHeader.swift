//
//  UserProfileVCHeader.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/21/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class UserProfileVCHeader: UICollectionReusableView {

    var user: User?

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()

    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()

    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.5)
        return button
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let postLabel: UILabel = {
        let label = UILabel()

        let attributedString = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let followersLabel: UILabel = {
        let label = UILabel()

        let attributedString = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let followingLabel: UILabel = {
        let label = UILabel()

        let attributedString = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray , NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))

        label.attributedText = attributedString
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    lazy var editProfileOrFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(editProfileFollowButtonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        profileImageView.clipsToBounds = true

        setupBottomToolBar()

        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        setupPersonalStats()

        addSubview(editProfileOrFollowButton)
        editProfileOrFollowButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPersonalStats() {
        let personalStatsStackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        personalStatsStackView.distribution = .fillEqually

        addSubview(personalStatsStackView)

        personalStatsStackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }

    private func setupBottomToolBar() {
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray

        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray

        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])

        addSubview(stackView)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

        topDivider.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDivider.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }

    func configureCell() {
        guard let user = user else {
            return
        }

        if user.uid == Auth.auth().currentUser?.uid  {
            currentUserSetup()
        }
        else {
            randomUserSetup()
        }
        
        let url = URL(string: user.userProfileImageString)
        profileImageView.sd_setImage(with: url, completed: nil)

        userNameLabel.text = user.username
    }

    private func currentUserSetup() {
        editProfileButtonSetup()
    }

    private func randomUserSetup() {
        guard let user = user else {
            return
        }

        DatabaseManager.sharedInstance.isFollowingUser(currentUserUID: Auth.auth().currentUser!.uid, followingUserToCheck: user.uid) { [weak self] (success) in
            if success {
                self?.unFollowButtonSetup()
            }
            else {
                self?.followButtonSetup()
            }
        }
    }

    private func followButtonSetup() {
        editProfileOrFollowButton.setTitle("Follow", for: .normal)
        editProfileOrFollowButton.setTitleColor(.white, for: .normal)
        editProfileOrFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        editProfileOrFollowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editProfileOrFollowButton.layer.borderColor = UIColor.init(white: 0, alpha: 0.2).cgColor
        editProfileOrFollowButton.layer.borderWidth = 1.0
        editProfileOrFollowButton.layer.cornerRadius = 5.0
    }

    private func unFollowButtonSetup() {
        editProfileOrFollowButton.setTitle("Unfollow", for: .normal)
        editProfileOrFollowButton.setTitleColor(.black, for: .normal)
        editProfileOrFollowButton.backgroundColor = UIColor.white
        editProfileOrFollowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
        editProfileOrFollowButton.layer.borderWidth = 1.0
        editProfileOrFollowButton.layer.cornerRadius = 5.0
    }

    private func editProfileButtonSetup() {
        editProfileOrFollowButton.setTitle("Edit Profile", for: .normal)
        editProfileOrFollowButton.setTitleColor(.black, for: .normal)
        editProfileOrFollowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        editProfileOrFollowButton.layer.borderColor = UIColor.lightGray.cgColor
        editProfileOrFollowButton.layer.borderWidth = 1.0
        editProfileOrFollowButton.layer.cornerRadius = 5.0
    }

    @objc private func editProfileFollowButtonTapped() {
        if Auth.auth().currentUser?.uid == user?.uid {
            print("edit button tapped")
        }
        else {
            // follow unfollow scenario

            if editProfileOrFollowButton.titleLabel?.text == "Follow" {
                // follow
                DatabaseManager.sharedInstance.followUser(currentUserUID: Auth.auth().currentUser!.uid, userToFollowUID: user!.uid) { [weak self] (success) in
                    guard success else {
                        return
                    }

                    self?.unFollowButtonSetup()
                }
            }
            else {
                // unfollow
                DatabaseManager.sharedInstance.unFollowUser(currentUserUID: Auth.auth().currentUser!.uid, userToFollowUID: user!.uid) { [weak self] (success) in
                    guard success else {
                        return
                    }

                    self?.followButtonSetup()
                }
            }
        }
    }
}
