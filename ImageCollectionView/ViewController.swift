//
//  ViewController.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    open lazy var imageCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return layout
    }()
    
    lazy var imageCollectionView: ImageCollectionView = {
        let frame = CGRect(x: 0, y: 48, width: view.frame.width, height: 150)
        let imageCollectionView = ImageCollectionView(frame: frame, collectionViewLayout: imageCollectionViewLayout)
        imageCollectionView.collectionViewLayout = imageCollectionViewLayout
        imageCollectionView.imageCollectionDelegate = self
        imageCollectionView.maxPhotosAllowed = 4
        return imageCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageCollectionView)
        imageCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
}

extension ViewController: ImageCollectionViewDelegate {
    func reachedMaximumPhotosAllowed() {
        print("max photos allowed, sorry")
    }
    func photosArrayChanged(_ newArray: [UIImage?]) {
        print(newArray.count)
    }
    func photoChangedState(_ photo: UIImage?, state: PhotoState) {
        print(state)
    }
}
