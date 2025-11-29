//
//  ImagePickerCoordinator.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-02-2026
//

import UIKit

final class ImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let uiImage = info[.originalImage] as? UIImage {
            let croppedImage = ImagePickerMediaProcessor.cropToRequiredAspectRatio(uiImage)
            parent.image = croppedImage
            picker.dismiss(animated: true)
        } else if let mediaURL = info[.mediaURL] as? URL {
            ImagePickerMediaProcessor.processVideo(url: mediaURL) { [weak self] processedURL in
                DispatchQueue.main.async {
                    self?.parent.videoURL = processedURL
                    picker.dismiss(animated: true)
                }
            }
        } else {
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
