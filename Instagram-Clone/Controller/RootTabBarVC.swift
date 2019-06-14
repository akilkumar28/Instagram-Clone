//
//  RootTabBarVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 6/13/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

class RootTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .black

        viewControllers = [userProfileVC()]
    }

    // list of all the view controllers attached to the root tab bar
    private func userProfileVC() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout()))
        navigationController.tabBarItem.image = UIImage(named: "profile_unselected")
        navigationController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        return navigationController
    }
}
