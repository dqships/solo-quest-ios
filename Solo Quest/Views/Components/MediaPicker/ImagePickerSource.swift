//
//  ImagePickerSource.swift
//  Solo Quest XP
//
//  Created by DaQuan Louden on 05-23-2026
//

import UIKit

enum ImagePickerSource: String, Identifiable {
    case camera
    case photoLibrary

    var id: String {
        rawValue
    }

    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .photoLibrary:
            return .photoLibrary
        }
    }
}
