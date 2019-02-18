//
//  ImageCollectionView.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

open class ImageCollectionView: UICollectionView {
    
    // Identifier for ImageCollectionViewCell
    fileprivate let reuseIdentifier: String = "ImageCollectionViewCell"
    
    // Stores the file path for each photo directory
    open var photoPathsArray = [String]()
    
    // Sets the maximum number of photos the user is able to take
    open var maxPhotosAllowed: Int?
    
    // ImageCollectionViewDelegate
    open weak var imageCollectionDelegate: ImageCollectionViewDelegate?
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func addPhoto(_ photo: UIImage) {
        imageCollectionDelegate?.photoChangedState(photo, state: .added)
        let timeInterval = Date().timeIntervalSince1970.description
        FileManager.default.saveInTemporaryDirectory(image: photo, pathComponent: timeInterval, pathExtension: ".jpg")
        photoPathsArray.append(timeInterval)
        imageCollectionDelegate?.photosArrayChanged(photoPathsArray.getPhotosFromPathfiles())
        insertItems(at: [IndexPath(item: photoPathsArray.count - 1, section: 0)])
        scrollToItem(at: IndexPath(item: photoPathsArray.count, section: 0), at: .right, animated: true)
    }
    
    private func removePhoto(photo: UIImage, at indexPath: IndexPath) {
        imageCollectionDelegate?.photoChangedState(photo, state: .deleted)
        FileManager.default.removeImageFromTemporaryDirectory(pathComponent: photoPathsArray[indexPath.item], pathExtension: ".jpg")
        photoPathsArray.remove(at: indexPath.item)
        imageCollectionDelegate?.photosArrayChanged(photoPathsArray.getPhotosFromPathfiles())
        deleteItems(at: [indexPath])
        reloadItems(at: [indexPath])
    }
    
    func openActionSheet() {
        let actionSheet = UIAlertController(title: "Selecciona", message: "fuente de foto", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (_) in
            UIApplication.shared.openPickerControllerFor(source: .camera, delegate: self)
        }))
        actionSheet.addAction(UIAlertAction(title: "Galería", style: .default, handler: { (_) in
            UIApplication.shared.openPickerControllerFor(source: .photoLibrary, delegate: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cacnelar", style: .cancel))
        
        UIApplication.shared.topMostViewController()?.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension ImageCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Returns nomber of file paths plus the addPhotoIcon
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoPathsArray.count + 1
    }
    
    // If user clicks on the last row (addPhoto) it opens action sheet to select the photo source
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == photoPathsArray.count {
            if maxPhotosAllowed == photoPathsArray.count {
                imageCollectionDelegate?.reachedMaximumPhotosAllowed()
            } else {
                openActionSheet()
            }
            cellForItem(at: indexPath)?.bounce()
        }
    }
    
    // ImageCollectionViewCell configuration
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell {
            return getCell(initialCell: cell, indexPath: indexPath)
        } else { return ImageCollectionViewCell() }
    }
    
    private func getCell(initialCell: ImageCollectionViewCell, indexPath: IndexPath) -> UICollectionViewCell {
        initialCell.delegate = self
        initialCell.indexPath = indexPath
        
        let isLastItem = indexPath.item == photoPathsArray.count
        initialCell.removeButton.isHidden = isLastItem
        
        let image = isLastItem ?  initialCell.addPhotoIcon : FileManager.default.getImageFromTemporaryDirectory(pathComponent: photoPathsArray[indexPath.item], pathExtension: ".jpg")
        initialCell.imageView.image = image

        return initialCell
    }
    
}

extension ImageCollectionView: ImageCollectionViewCellDelegate {
    func removeButtonPressed(photo: UIImage?, at indexPath: IndexPath) {
        guard let photo = photo else { return }
        removePhoto(photo: photo, at: indexPath)
    }
}

extension ImageCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.addPhoto(photo)
            }
        }
    }
}

extension UIView {
    func bounce() {
        transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
