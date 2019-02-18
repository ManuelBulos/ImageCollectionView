//
//  UIApplication.swift
//  ImageCollectionView
//
//  Created by Jose Manuel Solis Bulos on 2/15/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController
    }
    
    func openPickerControllerFor(source: UIImagePickerController.SourceType, delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = delegate
            pickerController.sourceType = source
            topMostViewController()?.present(pickerController, animated: true, completion: nil)
        } else {
            showSourceTypeUnavailableAlert()
        }
    }
    
    func showSourceTypeUnavailableAlert() {
        let alertController = UIAlertController(title: "Lo sentimos", message: "Controlador de fotos no disponible", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        topMostViewController()?.present(alertController, animated: true, completion: nil)
    }
    
}
