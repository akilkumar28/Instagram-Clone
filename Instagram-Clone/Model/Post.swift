//
//  Post.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/26/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

struct Post {
    let user: User
    let summary: String
    let imageDownloadURL: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let creationDate: Date
}
