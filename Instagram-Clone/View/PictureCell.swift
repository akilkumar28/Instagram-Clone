//
//  PictureCell.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/25/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(image: UIImage) {
        imageView.image = image
    }
}
