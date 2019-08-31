//
//  PictureVC.swift
//  Instagram-Clone
//
//  Created by Akil Kumar Thota on 7/25/19.
//  Copyright © 2019 Akil Kumar Thota. All rights reserved.
//

import UIKit
import Photos

class PictureVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PictureCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        setupNavigationButtons()

        fetchPhotos()
    }

    private func fetchPhotos() {
        let options = PHFetchOptions()
        options.fetchLimit = 10
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]

        let allPhotos = PHAsset.fetchAssets(with: .image, options: options)
        allPhotos.enumerateObjects { (asset, count, stop) in

            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 350, height: 350)

            let imageOptions = PHImageRequestOptions()
            imageOptions.isSynchronous = true

            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: imageOptions, resultHandler: { [weak self] (image, info) in
                guard let image = image else {
                    return
                }

                self?.images.append(image)

                if count == allPhotos.count - 1 {
                    self?.collectionView.reloadData()
                }
            })
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PictureCell {
            let image = images[indexPath.row]
            cell.configureCell(image: image)
            return cell
        }
        else {
            return PictureCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 3) / 4
        return CGSize(width: width , height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? PictureCell else {
            return PictureCell()
        }
        if let image = images.first {
            header.configureCell(image: image)
        }
        else {
            header.imageView.image = #imageLiteral(resourceName: "like_selected")
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]

        let headerIndexPath = IndexPath(row: 0, section: 0)

        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath) as? PictureCell else {
            return
        }

        header.imageView.image = image

        collectionView.scrollToItem(at: headerIndexPath, at: .bottom, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        let headerIndexPath = IndexPath(row: 0, section: 0)

        guard let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath) as? PictureCell else {
            print("Unable to get collection view header")
            return
        }

        let shareVC = ShareVC()
        shareVC.selectedImage = header.imageView.image
        navigationController?.pushViewController(shareVC, animated: true)
    }
}
