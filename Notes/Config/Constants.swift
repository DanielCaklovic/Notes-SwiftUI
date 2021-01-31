//
//  Constants.swift
//  Notes
//
//  Created by Daniel Caklovic on 31.01.2021..
//

import Foundation

typealias VoidBlock = () -> Void
typealias ValueBlock<Value> = (Value) -> Void

final class Constants {
    
    class Keys {
        static let authToken = "auth_token"
        static let serverId = "server_id"
        static let analyticsEnabled = "analytics_enabled"
    }
    
    class Config {
        static let networkActivityLogging = true
        static let minPasswordLength = 6
        // Width of the image before uploading. Aspect ratio is preserved.
        static let uploadImageSize: Float = 720
        // 1 - no compression, best quality,
        // 0 - highest compression, lowest quality
        static let uploadCompression: Float = 0.8
    }
    
    class DateFormats {
        static let defaultDate = "dd.MM.yyyy"
        static let defaultTime = "HH:mm"
    }
    
    static let persistentContainerName = "Notes"
    static let animationDuration = 0.3
}
