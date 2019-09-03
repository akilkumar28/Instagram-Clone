//
//  SearchVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 8/31/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var allUsers = [User]()
    var filteredUsers = [User]()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for user"
        sb.barTintColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        sb.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return sb
    }()

    fileprivate func addSearchBarToNavBar() {
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag

        // Register cell classes
        self.collectionView!.register(UserSearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        addSearchBarToNavBar()

        fetchUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.isHidden = true
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return filteredUsers.count
        }
        return allUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UserSearchCell {
            let user: User
            if searchBar.text != "" {
                user = filteredUsers[indexPath.row]
            }
            else {
                user = allUsers[indexPath.row]
            }
            cell.configureCell(user: user)
            return cell
        }
        else {
            return UserSearchCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        
        let user: User
        if searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        }
        else {
            user = allUsers[indexPath.row]
        }

        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.user = user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }

    private func fetchUsers() {
        DatabaseManager.sharedInstance.fetchAllUsersFromDatabase { [weak self] (users) in
            guard let users = users else {
                return
            }

            self?.allUsers = users
            self?.collectionView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = allUsers.filter {
            $0.username.lowercased().contains(searchText.lowercased())
        }

        collectionView.reloadData()
    }
}
