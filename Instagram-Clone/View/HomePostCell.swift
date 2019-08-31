//
//  HomePostCell.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 8/25/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import SDWebImage

class HomePostCell: UICollectionViewCell {

    let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    let thripleDotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        return button
    }()

    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        return button
    }()

    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        return button
    }()

    let ribbonButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        return button
    }()

    let summaryText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userImageView)
        addSubview(userNameLabel)
        addSubview(postImageView)
        addSubview(thripleDotButton)

        userImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userImageView.layer.cornerRadius = 40 / 2

        userNameLabel.anchor(top: nil, left: userImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true

        thripleDotButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 44, height: 0)

        postImageView.anchor(top: userImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        setupActionableButtons()

        setupSummarySection()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(post: Post) {
        userNameLabel.text = post.user.username

        let newlineText = NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)])
        let timeAgoText = NSAttributedString(string: post.creationDate.timeAgoDisplay(), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.gray])
        let summaryDescription = NSAttributedString(string: post.summary, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])

        let summaryFullText = NSMutableAttributedString(string: post.user.username + " ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13)])
        summaryFullText.append(summaryDescription)
        summaryFullText.append(newlineText)
        summaryFullText.append(timeAgoText)

        summaryText.attributedText = summaryFullText

        guard let postImageurl = URL(string: post.imageDownloadURL) else {
            return
        }
        postImageView.sd_setImage(with: postImageurl, completed: nil)

        guard let userImageURL = URL(string: post.user.userProfileImageString) else {
            return
        }

        userImageView.sd_setImage(with: userImageURL, completed: nil)
    }

    private func setupActionableButtons() {
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(sendButton)
        addSubview(ribbonButton)

        likeButton.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        commentButton.anchor(top: postImageView.bottomAnchor, left: likeButton.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        sendButton.anchor(top: postImageView.bottomAnchor, left: commentButton.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        ribbonButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 40, height: 40)
    }

    private func setupSummarySection() {
        addSubview(summaryText)
        summaryText.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
    }
}
