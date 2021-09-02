//
//  ImageType.swift
//  ABJC
//
//  Created by Noah Kamara on 27.03.21.
//

import Foundation


extension APIModels {
    public enum ImageType: String, Decodable {
        case primary = "Primary"
        case backdrop = "Backdrop"
        case art = "Art"
        case banner = "Banner"
        case logo = "Logo"
        case thumb = "Thumb"
        case thumbnail = "Thumbnail"
    }
}
