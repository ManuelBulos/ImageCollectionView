//
//  ImageCollectionViewCell.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

open class ImageCollectionViewCell: UICollectionViewCell {
    
    open lazy var addPhotoIcon: UIImage? = {
        return UIImage(named: "addPhotoIcon")
    }()
    
    open lazy var removePhotoIcon: UIImage? = {
        return UIImage(named: "removePhotoIcon")
    }()
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   open lazy var removeButton: UIButton = {
        let removeButton = UIButton()
        removeButton.imageView?.contentMode = .scaleAspectFit
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.addTarget(self, action: #selector(removeButtonPressed), for: .touchUpInside)
        return removeButton
    }()
    
    open var indexPath = IndexPath()
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.isUserInteractionEnabled = false
        removeButton.setImage(removePhotoIcon, for: .normal)
    }
    
    private func addViews() {
        addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        addSubview(removeButton)
        removeButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        removeButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        bringSubviewToFront(removeButton)
    }
    
    @objc private func removeButtonPressed() {
        removeButton.bounce()
        delegate?.removeButtonPressed(photo: imageView.image, at: indexPath)
    }
}
