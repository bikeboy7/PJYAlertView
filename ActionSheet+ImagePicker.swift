//
//  ActionSheet+ImagePicker.swift
//  App
//
//  Created by boy on 2017/5/4.
//  Copyright © 2017年 xys. All rights reserved.
//

import Foundation

extension PJYActionSheet {
   
    convenience init(title: String? = nil, currentVC: UIViewController, imagePicker: UIImagePickerController) {
        
        self.init(title: title)
        
        
        self.addAction(withTitle: "拍摄", font: nil, color: nil, handler: { (actionSheet) in
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            currentVC.present(imagePicker, animated: true, completion: nil)
        })
        
        self.addAction(withTitle: "照片", font: nil, color: nil, handler: { (actionSheet) in
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            currentVC.present(imagePicker, animated: true, completion: nil)
            
        })
        self.addAction(withTitle: "取消", font: nil, color: nil, handler: nil)
        
        self.show()

        
    }
    
    static func showImagePicker (title: String? = nil, objec: AnyObject? = nil, vc: UIViewController, imagePicker: UIImagePickerController) {
    
        _ = PJYActionSheet.init(title: nil, currentVC: vc, imagePicker: imagePicker)
    }
    
}
