//
//  ImageCollectionViewDelegate.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

public enum PhotoState { case added, deleted }

public protocol ImageCollectionViewDelegate: class {
    func photoChangedState(_ photo: UIImage?, state: PhotoState)
    func photosArrayChanged(_ newArray: [UIImage?])
    func reachedMaximumPhotosAllowed()
}

protocol ImageCollectionViewCellDelegate: class {
    func removeButtonPressed(photo: UIImage?, at indexPath: IndexPath)
}
