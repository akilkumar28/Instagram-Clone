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

        viewControllers = [homeVC(), searchVC(), pictureVC(), favoritesVC(), userProfileVC()]

        delegate = self
    }

    // list of all the view controllers attached to the root tab bar
    private func userProfileVC() -> UIViewController {
        let userProfilVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        return templateNavigationController(viewController: userProfilVC, tabBarSelectedImage: #imageLiteral(resourceName: "profile_unselected"), tabBarUnselectedImage: #imageLiteral(resourceName: "profile_selected"))
    }

    private func homeVC() -> UIViewController {
        let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
        return templateNavigationController(viewController: homeVC, tabBarSelectedImage: #imageLiteral(resourceName: "home_unselected"), tabBarUnselectedImage: #imageLiteral(resourceName: "home_selected"))
    }

    private func searchVC() -> UIViewController {
        let searchVC = UIViewController()
        return templateNavigationController(viewController: searchVC, tabBarSelectedImage: #imageLiteral(resourceName: "search_unselected"), tabBarUnselectedImage: #imageLiteral(resourceName: "search_selected"))
    }

    private func pictureVC() -> UIViewController {
        let pictureVC = PictureVC(collectionViewLayout: UICollectionViewFlowLayout())
        return templateNavigationController(viewController: pictureVC, tabBarSelectedImage: #imageLiteral(resourceName: "plus_unselected"), tabBarUnselectedImage: #imageLiteral(resourceName: "plus_unselected"))
    }

    private func favoritesVC() -> UIViewController {
        let favoritesVC = UIViewController()
        return templateNavigationController(viewController: favoritesVC, tabBarSelectedImage: #imageLiteral(resourceName: "like_unselected"), tabBarUnselectedImage: #imageLiteral(resourceName: "like_selected"))
    }

    private func templateNavigationController(viewController: UIViewController, tabBarSelectedImage: UIImage?, tabBarUnselectedImage: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = tabBarUnselectedImage
        navigationController.tabBarItem.selectedImage = tabBarUnselectedImage
        return navigationController
    }
}

extension RootTabBarVC: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)

        if index == 2 {
            let pictureVC = PictureVC(collectionViewLayout: UICollectionViewFlowLayout())
            let navigationController = UINavigationController(rootViewController: pictureVC)
            present(navigationController, animated: true, completion: nil)
            return false
        }

        return true
    }
}
