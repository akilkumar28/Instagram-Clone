//
//  CommentsCell.swift
//  Instagram-Clone
//
//  Created by AKIL KUMAR THOTA on 9/14/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {

    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImage.layer.cornerRadius = 20.0
        profileImage.clipsToBounds = true

        addSubview(usernameLabel)
        usernameLabel.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)


        addSubview(separatorLineView)
        separatorLineView.anchor(top: nil, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)

        addSubview(commentLabel)
        commentLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: separatorLineView.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(comment: PostComment) {
        guard let url = URL(string: comment.userProfilePicImageURL) else {
            print("userprofile string cannot be found")
            return
        }

        profileImage.sd_setImage(with: url, completed: nil)

        usernameLabel.text = comment.username

        commentLabel.text = comment.comment
    }
}
