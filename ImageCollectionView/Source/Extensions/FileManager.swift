//
//  FileManager.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

extension FileManager {
    
    func documentDirectoryPath() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    func clearTemporaryDirectory() {
        do {
            let temporaryDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try temporaryDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveInTemporaryDirectory(image: UIImage, pathComponent: String, pathExtension: String) {
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(pathComponent)
            .appendingPathExtension(pathExtension)
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: temporaryURL)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func removeImageFromTemporaryDirectory(pathComponent: String, pathExtension: String) {
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(pathComponent)
            .appendingPathExtension(pathExtension)
        do {
            try removeItem(at: temporaryURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImageFromTemporaryDirectory(pathComponent: String, pathExtension: String) -> UIImage? {
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(pathComponent)
            .appendingPathExtension(pathExtension)
        let image = UIImage(contentsOfFile: temporaryURL.path)
        return image
    }
    
}
