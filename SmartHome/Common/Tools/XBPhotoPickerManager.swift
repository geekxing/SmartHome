//
//  XBPhotoPickerManager.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/1/15.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import MobileCoreServices
import LGAlertView
import Toast_Swift

public protocol XBPhotoPickerManagerDelegate:NSObjectProtocol {
    func imagePickerDidFinishPickImage(image:UIImage)
}

class XBPhotoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LGAlertViewDelegate {

    static let shared = XBPhotoPickerManager()
    
    var sourceType:UIImagePickerControllerSourceType = .photoLibrary
    var chooser:UIViewController?
    weak var delegate:XBPhotoPickerManagerDelegate?
    
    func pickIn(vc:UIViewController) {
        chooser = vc
        let alert = LGAlertView(title: "Choose a way to select your avatar", message: nil, style: .actionSheet, buttonTitles: ["PhotoLibrary","Camera"], cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, delegate: self)
        alert.showAnimated()
    }
    
    private func open() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String]
        chooser?.present(imagePicker, animated: true, completion: nil)
    }
    
    private func cameraAuthentication() -> Bool {
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        return authStatus != .denied || authStatus != .restricted
    }
    
    private func photoLibraryAuth() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        return authStatus != .denied || authStatus != .restricted
    }
    
    private func hasAccessTo(sourceType:UIImagePickerControllerSourceType) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            return true
        } else {
            let alert = LGAlertView(title: "your device have no access to camera", message: nil, style: .alert, buttonTitles: ["DONE"], cancelButtonTitle: nil, destructiveButtonTitle: nil)
            alert.showAnimated()
            return false
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as? String
        if mediaType == kUTTypeImage as String {
            delegate?.imagePickerDidFinishPickImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - LGAlertViewDelegate
    func alertView(_ alertView: LGAlertView, buttonPressedWithTitle title: String?, index: UInt) {
        if index == 0  {
            self.sourceType = .photoLibrary
            guard self.hasAccessTo(sourceType: .photoLibrary) else {return }
            guard photoLibraryAuth() else {
                let alert = LGAlertView(title: "you have no permission to photoLibrary", message: nil, style: .alert, buttonTitles: ["DONE"], cancelButtonTitle: nil, destructiveButtonTitle: nil)
                alert.showAnimated()
                return
            }
        } else {
            self.sourceType = .camera
            guard self.hasAccessTo(sourceType: .camera) else {return }
            guard photoLibraryAuth() else {
                let alert = LGAlertView(title: "you have no permission to camera", message: nil, style: .alert, buttonTitles: ["DONE"], cancelButtonTitle: nil, destructiveButtonTitle: nil)
                alert.showAnimated()
                return
            }
        }
        self.open()
    }
}
