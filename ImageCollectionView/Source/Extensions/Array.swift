//
//  Array.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

extension Array where Element == String {
    func getPhotosFromPathfiles() -> [UIImage?] {
        var photoArray = [UIImage?]()
        for path in self {
            photoArray.append(FileManager.default.getImageFromTemporaryDirectory(pathComponent: path, pathExtension: ".jpg"))
        }
        return photoArray
    }
}
